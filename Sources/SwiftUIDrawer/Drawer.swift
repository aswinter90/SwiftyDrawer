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
    @Binding var minHeight: DrawerMinHeight
    @Binding var maxHeight: DrawerMaxHeight
    @Binding var mediumHeight: DrawerMediumHeight?

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
    @State var shouldElevateStickyHeader = false

    // MARK: - Properties: Private

    private let stickyHeader: HeaderContent?
    private let content: Content

    private var isAlignedToTabBar: Bool { minHeight.isAlignedToTabBar }
    
    /// Property that controls the drawer's position on the screen.
    /// Updating the drawer's visible portion this way is less error-prone than changing its frame as in previous implementations
    private var drawerPaddingTop: CGFloat {
        UIScreen.main.bounds.height - state.currentHeight
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
        let heightModifier = UIScreen.main.scale > 2 ? 200.0 : 100
        let heightThreshold = mediumHeight?.value ?? minHeight.value
        return (heightThreshold + heightModifier - state.currentHeight) / 100.0
    }

    // MARK: - Initializer

    public init(
        state: Binding<DrawerState>,
        minHeight: Binding<DrawerMinHeight> = .constant(DrawerMinHeight(case: .relativeToSafeAreaBottom(offset: 0))),
        mediumHeight: Binding<DrawerMediumHeight?>? = .constant(DrawerConstants.drawerDefaultMediumHeightCase),
        maxHeight: Binding<DrawerMaxHeight> = .constant(.init(case: .relativeToSafeAreaTop(offset: 0))),
        stickyHeader: HeaderContent? = nil,
        content: Content
    ) {
        _state = state
        _minHeight = minHeight
        _mediumHeight = mediumHeight ?? .constant(nil)
        _maxHeight = maxHeight
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
            // Instead of the default `offset` modifier, we add our own to observe value changes, which can be published to the outside world
            OffsetEffect(
                value: drawerPaddingTop,
                onValueDidChange: onVerticalPositionDidChange
            )
        )
        .animation(
            isDragging || isAnimationDisabled ? .none : animation,
            value: state.currentHeight
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
            DragHandle()

            ZStack {
                stickyHeader
            }
            .id(stickyHeaderId)
            .onChange(of: minHeight) {
                // The `readSize` closure below is not always called when using SwiftUI previews after updating the sticky header content and changing the drawer's `minHeight` on the outside.
                // By changing the view's id we trigger a redraw and can make sure we always re-read its size.
                redrawHeaderIfNeeded(using: $0)
            }
            .readSize {
                if minHeight.shouldMatchStickyHeaderHeight {
                    minHeight.updateAssociatedValueOfCurrentCase($0.height)
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
    }
    
    private func redrawHeaderIfNeeded(using newMinHeight: DrawerMinHeight) {
        stickyHeaderId = newMinHeight.shouldMatchStickyHeaderHeight ? UUID() : stickyHeaderId
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

                let newHeight = state.currentHeight - (value.translation.height - lastTranslationYValue)
                
                state.currentHeight = max(
                    minHeight.value,
                    min(maxHeight.value, newHeight)
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
            state.case = mediumHeight != nil ? .partiallyOpened : .fullyOpened
        case (.partiallyOpened, .down):
            state.case = .closed
        case (.partiallyOpened, .up):
            state.case = .fullyOpened
        case (.fullyOpened, .down):
            state.case = mediumHeight != nil ? .partiallyOpened : .closed
        case (.fullyOpened, .up):
            state.case = .fullyOpened
        case (_, .undefined):
            // Gesture was too slow or the translation was too small. Find the nearest fixed drawer position
            let offsetToMinHeight = abs(state.currentHeight - minHeight.value)

            let offsetToMediumHeight = if let mediumHeight = mediumHeight?.value {
                abs(max(state.currentHeight, mediumHeight) - min(state.currentHeight, mediumHeight))
            } else {
                CGFloat.infinity // Eliminates `offsetToMediumHeight` from the following switch
            }

            let offsetToMaxHeight = abs(maxHeight.value - state.currentHeight)

            switch min(offsetToMinHeight, offsetToMediumHeight, offsetToMaxHeight) {
            case offsetToMinHeight:
                state.case = .closed
            case offsetToMediumHeight:
                state.case = .partiallyOpened
            case offsetToMaxHeight:
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
            state.currentHeight = minHeight.value
        case .partiallyOpened:
            if let mediumHeight = mediumHeight?.value {
                state.currentHeight = mediumHeight
            } else {
                assertionFailure("Cannot set drawer state to `partiallyOpened` when no medium height was defined")
            }
        case .fullyOpened:
            state.currentHeight = maxHeight.value
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
