import Combine
import SwiftUI

public struct Drawer<Content: View, HeaderContent: View>: View {
    // MARK: - Environment

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

    /// Additional safety measure to prevent the drawer from moving slightly when scrolling its content
    @State var isDrawerDragGestureEnabled = true

    /// Only needed when using `DrawerContentLayoutingStrategy.classic`
    @State var contentHeight: CGFloat = 0.0
    
    @State private var stickyHeaderHeight: CGFloat = 0.0
    @State var shouldElevateStickyHeader = false
    @State private var isAnimationDisabled = true

    // MARK: - Properties: Private

    private var isAlignedToTabBar: Bool { minHeight.isAlignedToTabBar }
    private let stickyHeader: HeaderContent?
    private let content: Content

    // MARK: - Computed

    /// Property that controls the drawer's position on the screen.
    /// Updating the visible portion of the drawer this way is less error-prone than changing its height as in previous implementations, which delivered unexpected results when it contains a sticky header with a fixed intrinsic content size (e.g. a `Text`).
    private var drawerPaddingTop: CGFloat {
        UIScreen.main.bounds.height - state.currentHeight
    }

    /// This makes sure that the scrollable content does not touch the safe area or is covered by the tab bar when the drawer is open
    private var contentBottomPadding: CGFloat {
        switch state.case {
        case .fullyOpened:
            drawerPaddingTop
                + UIApplication.shared.safeAreaInsets.bottom
                + (isAlignedToTabBar ? TabBarHeightProvider.sharedInstance.height : 0)
        default:
            0
        }
    }

    private var floatingButtonsOpacity: CGFloat {
        let heightModifier = UIScreen.main.scale > 2 ? 200.0 : 100
        let heightThreshold = mediumHeight?.absoluteValue ?? minHeight.absoluteValue
        return (heightThreshold + heightModifier - state.currentHeight) / 100.0
    }

    // MARK: - Initializer

    public init(
        state: Binding<DrawerState>,
        minHeight: Binding<DrawerMinHeight> = .constant(.relativeToSafeAreaBottom(0)),
        mediumHeight: Binding<DrawerMediumHeight?>? = .constant(DrawerConstants.drawerDefaultMediumHeight),
        maxHeight: Binding<DrawerMaxHeight> = .constant(.relativeToSafeAreaTop(0)),
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

    public var body: some View {
        VStack(spacing: 0) {
            floatingButtons()
                .padding(.bottom, DrawerConstants.floatingButtonsPadding)

            VStack(spacing: 0) {
                headerContainer
                    .zIndex(1) // For casting shadows on the scrollable content below

                contentContainer(
                    content: content
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.background)
                )
                .padding(.bottom, contentBottomPadding)
                .zIndex(0)
            }
            .frame(height: UIScreen.main.bounds.height)
            .background(Color.background)
            .roundedCorners(DrawerConstants.drawerCornerRadius, corners: [.topLeft, .topRight])
            .background { shadowView(yOffset: -3) }
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
                onValueDidChange: onDrawerVerticalPositionDidChange
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
    }

    // MARK: - Header

    @ViewBuilder
    private var headerContainer: some View {
        VStack(spacing: 0) {
            DragHandle()

            ZStack {
                stickyHeader
            }
            .readSize {
                if minHeight.isSameAsStickyHeaderHeight {
                    minHeight.updateAssociatedValue($0.height)
                }
                if stickyHeaderHeight != $0.height {
                    updateCurrentHeight(with: state.case)
                }
                
                stickyHeaderHeight = $0.height
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.background)
        .drawingGroup()
        .background {
            shadowView(yOffset: 3)
                .opacity(shouldElevateStickyHeader && stickyHeaderHeight > 0 ? 1 : 0)
                .padding(.horizontal, -8)
        }
    }

    private func shadowView(yOffset: CGFloat) -> some View {
        PrerenderedShadowView(
            configuration: .init(
                layerCornerRadius: DrawerConstants.drawerCornerRadius,
                shadowColor: .black,
                shadowOpacity: 0.15,
                shadowRadius: 3.0,
                shadowOffset: .init(width: 0, height: yOffset)
            )
        )
        .swiftUIView
    }

    // MARK: - Floating buttons

    @ViewBuilder
    private func floatingButtons() -> some View {
        if floatingButtonsConfiguration.isEmpty {
            EmptyView()
        } else {
            HStack(alignment: .bottom) {
                VStack(spacing: DrawerConstants.floatingButtonsPadding) {
                    ForEach(floatingButtonsConfiguration.leadingButtons) { buttonProperties in
                        RoundFloatingButton(icon: buttonProperties.icon, action: {
                            buttonProperties.action()
                        })
                    }
                }
                .animation(.smooth, value: !floatingButtonsConfiguration.leadingButtons.isEmpty)
                
                Spacer()
                
                VStack(spacing: DrawerConstants.floatingButtonsPadding) {
                    ForEach(floatingButtonsConfiguration.trailingButtons) { buttonProperties in
                        RoundFloatingButton(icon: buttonProperties.icon, action: {
                            buttonProperties.action()
                        })
                    }
                }
                .animation(.smooth, value: !floatingButtonsConfiguration.trailingButtons.isEmpty)
            }
            .padding(.horizontal, DrawerConstants.floatingButtonsPadding)
            .opacity(floatingButtonsOpacity)
        }
    }

    // MARK: - Drag Gesture

    private var drawerDragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                guard isDrawerDragGestureEnabled else { return }

                isDragging = true

                state.currentHeight = max(
                    minHeight.absoluteValue,
                    min(maxHeight.absoluteValue, state.currentHeight - (value.translation.height - lastTranslationYValue))
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
            let offsetToMinHeight = abs(state.currentHeight - minHeight.absoluteValue)

            let offsetToMediumHeight = if let mediumHeight = mediumHeight?.absoluteValue {
                abs(max(state.currentHeight, mediumHeight) - min(state.currentHeight, mediumHeight))
            } else {
                CGFloat.infinity // Eliminates `offsetToMediumHeight` from the following switch
            }

            let offsetToMaxHeight = abs(maxHeight.absoluteValue - state.currentHeight)

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

    private func updateCurrentHeight(with newStateCase: DrawerState.Cases) {
        switch newStateCase {
        case .closed:
            state.currentHeight = minHeight.absoluteValue
        case .partiallyOpened:
            if let mediumHeight = mediumHeight?.absoluteValue {
                state.currentHeight = mediumHeight
            } else {
                assertionFailure("Cannot set drawer state to `partiallyOpened` when no medium height was defined")
            }
        case .fullyOpened:
            state.currentHeight = maxHeight.absoluteValue
        }
    }

    // MARK: - Origin observing

    private func onDrawerVerticalPositionDidChange(_ verticalPosition: CGFloat) {
        guard let originObservable else { return }

        let origin = CGPoint(
            x: 0,
            y: verticalPosition - DrawerConstants.appleMapAttributionLabelPadding
        )

        if originObservable.origin != origin {
            originObservable.update(origin: origin)
        }
    }
}
