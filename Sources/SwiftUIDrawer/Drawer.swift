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
    
    // MARK: - Bindings & Arguments

    @Binding var state: DrawerState
    @Binding var bottomPosition: DrawerBottomPosition
    private let midPosition: DrawerMidPosition?
    private let topPosition: DrawerTopPosition
    private let positionCalculator: DrawerPositionCalculator
    private let stickyHeader: HeaderContent?
    private let content: Content

    // MARK: - Reducer
    
    private let stateReducer: DrawerStateReducer
    
    // MARK: - State

    @GestureState private var lastYTranslation = 0.0
    @State private var isAnimationDisabled = true
    
    /// Additional safety measure to prevent the drawer from moving slightly when its content is being scrolled
    @State var isDragGestureEnabled = true

    /// Only needed when using `DrawerContentLayoutingStrategy.classic`
    @State var contentHeight: CGFloat = 0.0
    
    @State var stickyHeaderHeight: CGFloat = 0.0
    @State private var stickyHeaderId = UUID()
    @State private var dragHandleId = UUID()
    @State var shouldElevateStickyHeader = false
    
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
        self.stateReducer = .init(
            bottomPosition: bottomPosition.wrappedValue,
            topPosition: topPosition,
            midPosition: midPosition,
            positionCalculator: positionCalculator
        )
    }

    // MARK: - Body
    
    public var body: some View {
        // Outer transparent container
        VStack(spacing: 0) {
            floatingButtons()
                .padding(.bottom, DrawerConstants.floatingButtonsPadding)

            // Header and content
            VStack(spacing: 0) {
                headerContainer
                    .zIndex(1) // For casting shadows on the scrollable content below

                contentContainer(
                    content: content
                        .fixedSize(horizontal: false, vertical: true)
                        .background(style.backgroundColor)
                )
                .padding(
                    .bottom,
                    positionCalculator.contentBottomPadding(
                        for: state,
                        bottomPosition: bottomPosition
                    )
                )
                .zIndex(0)
            }
            .frame(height: positionCalculator.screenHeight)
            .background(Color.background)
            .roundedCorners(style.cornerRadius, corners: [.topLeft, .topRight])
            .prerenderedShadow(style.shadowStyle, cornerRadius: style.cornerRadius)
            .gesture(dragGesture)
            .onAppear { stateReducer.syncCaseAndCurrentPosition(of: &state) }
            .onChange(of: state.case) { [oldCase = state.case] newCase in
                guard oldCase != newCase else { return }

                DispatchQueue.main.async {
                    stateReducer.syncCaseAndCurrentPosition(of: &state)
                }
            }
        }
        .padding(.top, positionCalculator.paddingTop(for: state))
        .modifier(
            // Visually the drawer does not move from just adding a top-padding. An offset effect is also required:
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-adjust-the-position-of-a-view-using-its-offset
            // Instead of the default `offset` modifier, we add our own to observe value changes, which can also be published to the outside world
            OffsetEffect(
                value: positionCalculator.paddingTop(for: state),
                onValueDidChange: onVerticalPositionDidChange
            )
        )
        .animation(
            state.isDragging || isAnimationDisabled ? .none : animation,
            value: state.currentPosition
        )
        .onFirstAppear {
            // The initial change of `state.currentPosition` should not be animated
            DispatchQueue.main.async {
                isAnimationDisabled = false
            }
        }
        .accessibilityIdentifier("SwiftUIDrawer")
        .storeSafeAreaInsetsAsAccessibilityLabel(positionCalculator.safeAreaInsets)
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
                    stateReducer.syncCaseAndCurrentPosition(of: &state)
                }

            ZStack {
                stickyHeader
            }
            .id(stickyHeaderId)
            .readSize {
                stickyHeaderHeight = $0.height

                if bottomPosition.shouldMatchStickyHeaderHeight {
                    bottomPosition.updateAssociatedValueOfCurrentCase($0.height)
                }

                stateReducer.syncCaseAndCurrentPosition(of: &state)
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
            .opacity(
                positionCalculator
                    .floatingButtonsOpacity(
                        currentDrawerPosition: state.currentPosition,
                        drawerBottomPosition: bottomPosition,
                        drawerMidPosition: midPosition
                    )
            )
        }
    }
}

extension Drawer {
    
    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                guard isDragGestureEnabled else { return }

                stateReducer.onDrag(
                    &state,
                    yTranslation: value.translation.height,
                    lastYTranslation: lastYTranslation
                )
            }
            .updating($lastYTranslation, body: { value, lastTranslationYValue, _ in
                lastTranslationYValue = value.translation.height
            })
            .onEnded { value in
                DispatchQueue.main.async {
                    stateReducer.onDraggingEnded(
                        &state,
                        startLocation: value.startLocation,
                        endLocation: value.location,
                        velocity: value.velocity
                    )
                }
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
