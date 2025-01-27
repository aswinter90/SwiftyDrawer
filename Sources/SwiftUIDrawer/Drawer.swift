import Combine
import SwiftUI

public struct Drawer<Content: View, HeaderContent: View>: View {
    // MARK: - Environment

    @Environment(\.drawerStyle) var style: DrawerStyle
    @Environment(\.drawerLayoutStrategy) var layoutStrategy: DrawerContentLayoutStrategy
    @Environment(\.drawerAnimation) private var animation: Animation
    @Environment(\.drawerFloatingButtonsConfiguration) private var floatingButtonsConfiguration: DrawerFloatingButtonsConfiguration
    @Environment(\.drawerContentOffsetController) var contentOffsetController: DrawerContentOffsetController?
    @Environment(\.drawerOriginObservable) private var originObservable: DrawerOriginObservable?
    
    // MARK: - Bindings

    @Binding var state: DrawerState
    @Binding var bottomPosition: DrawerBottomPosition
    private let topPosition: DrawerTopPosition
    private let midPosition: DrawerMidPosition?

    // MARK: - State

    @State private var isDragging = false
    @GestureState private var lastTranslationYValue = 0.0
    @State private var isAnimationDisabled = true
    
    /// Additional safety measure to prevent the drawer from moving slightly when scrolling its content
    @State var isDrawerDragGestureEnabled = true

    /// Only needed when using `DrawerContentLayoutingStrategy.classic`
    @State var contentHeight: CGFloat = 0.0
    
    @State var stickyHeaderHeight: CGFloat = 0.0
    @State private var stickyHeaderId = UUID()
    @State private var dragHandleId = UUID()
    @State var shouldElevateStickyHeader = false

    // MARK: - Properties: Private

    private let positionCalculator: DrawerPositionCalculator
    private let stickyHeader: HeaderContent?
    private let content: Content

    private var isAlignedToTabBar: Bool { bottomPosition.isAlignedToTabBar }
    
    /// Property that controls the drawer's position on the screen.
    /// Updating the drawer's visible portion this way is less error-prone than changing its frame as in previous implementations
    private var drawerPaddingTop: CGFloat {
        UIScreen.main.bounds.height - state.currentPosition
    }

    /// This makes sure that the scrollable content is not covered by the tab bar or the lower safe area when the drawer is open
    private var contentBottomPadding: CGFloat {
        switch state.case {
        case .fullyOpened:
            drawerPaddingTop
                + UIApplication.shared.insets.bottom
                + (isAlignedToTabBar ? TabBarFrameProvider.sharedInstance.frame.height : 0)
        default:
            0
        }
    }

    private var floatingButtonsOpacity: CGFloat {
        let positionModifier = UIScreen.main.scale > 2 ? 200.0 : 100
        let positionThreshold = if let midPosition {
            positionCalculator.absoluteValue(for: midPosition)
        } else {
            positionCalculator.absoluteValue(for: bottomPosition)
        }
        
        return (positionThreshold + positionModifier - state.currentPosition) / 100.0
    }

    // MARK: - Initializer

    public init(
        state: Binding<DrawerState>,
        bottomPosition: Binding<DrawerBottomPosition> = .constant(.relativeToSafeAreaBottom(offset: 0)),
        midPosition: DrawerMidPosition? = DrawerConstants.drawerDefaultMidPosition,
        topPosition: DrawerTopPosition = .relativeToSafeAreaTop(offset: 0),
        positionCalculator: DrawerPositionCalculator = .init(),
        stickyHeader: HeaderContent? = nil,
        content: Content
    ) {
        _state = state
        _bottomPosition = bottomPosition
        self.midPosition = midPosition
        self.topPosition = topPosition
        self.positionCalculator = positionCalculator
        self.stickyHeader = stickyHeader
        self.content = content
    }

    // MARK: - Body
    
    public var body: some View {
        // Outer transparent container
        VStack(spacing: 0) {
            floatingButtons()
                .padding(.bottom, DrawerConstants.floatingButtonsPadding)

            // Header and content container
            VStack(spacing: 0) {
                headerContainer
                    .zIndex(1) // For casting shadows on the scrollable content below

                contentContainer(
                    content: content
                        .fixedSize(horizontal: false, vertical: true)
                        .background(style.backgroundColor)
                )
                .padding(.bottom, contentBottomPadding)
                .zIndex(0)
            }
            .frame(height: UIScreen.main.bounds.height)
            .background(Color.background)
            .roundedCorners(style.cornerRadius, corners: [.topLeft, .topRight])
            .prerenderedShadow(style.shadowStyle, cornerRadius: style.cornerRadius)
            .gesture(drawerDragGesture)
            .onAppear { updateCurrentHeight(with: state.case) }
            .onChange(of: state.case) { [oldCase = state.case] newCase in
                guard oldCase != newCase else { return }

                DispatchQueue.main.async {
                    updateCurrentHeight(with: newCase)
                }
            }
        }
        .padding(.top, drawerPaddingTop)
        .modifier(
            // Visually the drawer does not move from just adding a top-padding. An offset effect is also required:
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-adjust-the-position-of-a-view-using-its-offset
            // Instead of the default `offset` modifier, we add our own to observe value changes, which can also be published to the outside world
            OffsetEffect(
                value: drawerPaddingTop,
                onValueDidChange: onVerticalPositionDidChange
            )
        )
        .animation(
            isDragging || isAnimationDisabled ? .none : animation,
            value: state.currentPosition
        )
        .onFirstAppear {
            // The initial change of `state.currentHeight` should not be animated
            DispatchQueue.main.async {
                isAnimationDisabled = false
            }
        }
        .accessibilityIdentifier("SwiftUIDrawer")
        .storeSafeAreaInsetsAsAccessibilityLabel()
    }
}

// MARK: - Views

extension Drawer {
    private var headerContainer: some View {
        VStack(spacing: 0) {
            style.dragHandle
                .id(dragHandleId)
                .readSize {
                    positionCalculator.dragHandleHeight = $0.height
                    updateCurrentHeight(with: state.case)
                }

            ZStack {
                stickyHeader
            }
            .id(stickyHeaderId)
            .readSize {
                if bottomPosition.shouldMatchStickyHeaderHeight {
                    bottomPosition.updateAssociatedValueOfCurrentCase($0.height)
                }

                updateCurrentHeight(with: state.case)
                stickyHeaderHeight = $0.height
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(style.backgroundColor)
        .drawingGroup()
        .background {
            PrerenderedShadowView(
                configuration: .init(
                    style: style.stickyHeaderShadowStyle,
                    cornerRadius: 0
                )
            )
            .swiftUIView
            .opacity(shouldElevateStickyHeader ? 1 : 0)
            .padding(.horizontal, -8)
        }
        // The `readSize`-closures above are not always called when using SwiftUI previews after updating the sticky header content or changing one of the drawer's fixed positions on the outside.
        // By changing the view ids in `redrawHeader` we trigger a redraw and can make sure we always re-read their sizes.
        .onChange(of: bottomPosition) { _ in
            redrawHeader()
        }
        .onChange(of: midPosition) { _ in
            redrawHeader()
        }
        .onChange(of: topPosition) { _ in
            redrawHeader()
        }
    }
    
    private func redrawHeader() {
        stickyHeaderId = UUID()
        dragHandleId = UUID()
    }
    
    @ViewBuilder
    private func floatingButtons() -> some View {
        if floatingButtonsConfiguration.isEmpty {
            EmptyView()
        } else {
            HStack(alignment: .bottom) {
                VStack(spacing: DrawerConstants.floatingButtonsPadding) {
                    ForEach(floatingButtonsConfiguration.leadingButtons) { buttonProperties in
                        RoundFloatingButton(properties: buttonProperties)
                    }
                }
                .animation(.smooth, value: !floatingButtonsConfiguration.leadingButtons.isEmpty)
                
                Spacer()
                
                VStack(spacing: DrawerConstants.floatingButtonsPadding) {
                    ForEach(floatingButtonsConfiguration.trailingButtons) { buttonProperties in
                        RoundFloatingButton(properties: buttonProperties)
                    }
                }
                .animation(.smooth, value: !floatingButtonsConfiguration.trailingButtons.isEmpty)
            }
            .padding(.horizontal, DrawerConstants.floatingButtonsPadding)
            .opacity(floatingButtonsOpacity)
        }
    }
}

extension Drawer {
    
    // MARK: - Drag Gesture

    private var drawerDragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                guard isDrawerDragGestureEnabled else { return }

                isDragging = true

                let newPosition = state.currentPosition - (value.translation.height - lastTranslationYValue)
                
                state.currentPosition = max(
                    positionCalculator.absoluteValue(for: bottomPosition),
                    min(positionCalculator.absoluteValue(for: topPosition), newPosition)
                )
            }
            .updating($lastTranslationYValue, body: { value, lastTranslationYValue, _ in
                lastTranslationYValue = value.translation.height
            })
            .onEnded { value in
                isDragging = false

                DispatchQueue.main.async {
                    updateState(withDragGestureValue: value)
                }
            }
    }

    // MARK: - State updates
    
    private func updateState(withDragGestureValue value: _ChangedGesture<DragGesture>.Value) {
        let startLocation = value.startLocation.y.roundToDecimal(3)
        let endlocation = value.location.y.roundToDecimal(3)

        let targetDirection = DragTargetDirection(
            startLocationY: startLocation,
            endLocationY: endlocation,
            velocity: value.velocity.height
        )

        switch (state.case, targetDirection) {
        case (.closed, .down):
            state.case = .closed
        case (.closed, .up):
            state.case = midPosition != nil ? .partiallyOpened : .fullyOpened
        case (.partiallyOpened, .down):
            state.case = .closed
        case (.partiallyOpened, .up):
            state.case = .fullyOpened
        case (.fullyOpened, .down):
            state.case = midPosition != nil ? .partiallyOpened : .closed
        case (.fullyOpened, .up):
            state.case = .fullyOpened
        case (_, .undefined):
            // Gesture was too slow or the translation was too small. Find the nearest fixed drawer position
            let offsetToBottomPosition = abs(
                state.currentPosition - positionCalculator.absoluteValue(for: bottomPosition)
            )

            var offsetToMidPosition: CGFloat
            
            if let midPosition = midPosition {
                let midPositionValue = positionCalculator.absoluteValue(for: midPosition)
                
                offsetToMidPosition = abs(max(state.currentPosition, midPositionValue) - min(state.currentPosition, midPositionValue))
            } else {
                offsetToMidPosition = CGFloat.infinity // Eliminates `offsetToMidPosition` from the following switch
            }

            let offsetToTopPosition = abs(positionCalculator.absoluteValue(for: topPosition) - state.currentPosition)

            switch min(offsetToBottomPosition, offsetToMidPosition, offsetToTopPosition) {
            case offsetToBottomPosition:
                state.case = .closed
            case offsetToMidPosition:
                state.case = .partiallyOpened
            case offsetToTopPosition:
                state.case = .fullyOpened
            default:
                // Unexpected case
                break
            }
        }

        updateCurrentHeight(with: state.case)
    }

    private func updateCurrentHeight(with newStateCase: DrawerState.Case) {
        switch newStateCase {
        case .closed:
            state.currentPosition = positionCalculator.absoluteValue(for: bottomPosition)
        case .partiallyOpened:
            if let midPosition = midPosition {
                state.currentPosition = positionCalculator.absoluteValue(for: midPosition)
            } else {
                assertionFailure("Cannot set drawer state to `partiallyOpened` when no midPosition was defined")
            }
        case .fullyOpened:
            state.currentPosition = positionCalculator.absoluteValue(for: topPosition)
        }
    }

    // MARK: - Origin observing

    private func onVerticalPositionDidChange(_ verticalPosition: CGFloat) {
        guard let originObservable else { return }

        originObservable.updateIfNeeded(
            origin: CGPoint(x: 0, y: verticalPosition - DrawerConstants.appleMapAttributionLabelPadding)
        )
    }
}
