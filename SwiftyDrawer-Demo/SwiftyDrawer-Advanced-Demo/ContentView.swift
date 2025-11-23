import SwiftUI
import SwiftyDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var drawerBottomPosition = DrawerBottomPosition.relativeToSafeAreaBottom(offset: 0)

    @State private var isTabBarShown = false
    @State private var isStickyHeaderShown = true
    @State private var isCustomDragHandleShown = false
    @State private var isDrawerTransparent = false
    @State private var isStickyHeaderScrollable = false

    private let floatingButtonsConfig = DrawerFloatingButtonsConfiguration(
        trailingButtons: [
            .init(
                icon: Image(systemName: "map"),
                action: {}
            )
        ]
    )

    var body: some View {
        tabView(isTabBarShown: isTabBarShown) {
            configList
                .drawerOverlay(
                    state: $drawerState,
                    bottomPosition: $drawerBottomPosition,
                    isDimmingBackground: true,
                    stickyHeader: { isStickyHeaderShown ? stickyDrawerHeader : nil },
                    content: { drawerContent }
                )
                .drawerStyle(
                    isDrawerTransparent ? .init(backgroundColor: .red.opacity(0.3)) : .init()
                )
                .drawerLayoutStrategy(.classic)
                .drawerFloatingButtonsConfiguration(floatingButtonsConfig)
                .isDrawerHapticFeedbackEnabled(true)
                .isApplyingRenderingOptimizationToDrawerHeader(!isStickyHeaderScrollable)
        }
        .onChange(of: isStickyHeaderShown) { newValue in
            updateDrawerBottomPosition(isStickyHeaderShown: newValue)
        }
        .drawerStyle(
            isCustomDragHandleShown ? customDragHandleDrawerStyle() : .init()
        )
    }

    @ViewBuilder
    func tabView<Content: View>(isTabBarShown: Bool, content: () -> Content) -> some View {
        TabView {
            content()
                .tabItem { Label("Demo", systemImage: "wrench.and.screwdriver") }
                .opaqueTabBarStyle(isTabBarShown: isTabBarShown)
        }
    }

    var configList: some View {
        List {
            Toggle("Show tab bar", isOn: $isTabBarShown)
            Toggle("Show sticky header", isOn: $isStickyHeaderShown)
            Toggle("Sticky header is scrollable", isOn: $isStickyHeaderScrollable)
            Toggle("Show custom drag handle", isOn: $isCustomDragHandleShown)
            Toggle("Make drawer transparent", isOn: $isDrawerTransparent)

            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                Text("Set state to:")
                    .frame(maxWidth: .infinity, alignment: .leading)

                button("closed") {
                    drawerState.case = .closed
                }

                Spacer()

                button("partiallyOpened") {
                    drawerState.case = .partiallyOpened
                }

                Spacer()

                button("fullyOpened") {
                    drawerState.case = .fullyOpened
                }
            }
        }
    }

    func button(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(width: 140)
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    @ViewBuilder
    var stickyDrawerHeader: some View {
        if isStickyHeaderScrollable {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        stickyHeaderText(title: "Sticky header item \(index)")
                    }
                }
            }
            .background { Color.teal }
        } else {
            VStack(spacing: 0) {
                stickyHeaderText(
                    title: "Sticky header",
                    isShowingDivider: true
                )
            }
            .background { Color.teal }
        }
    }

    @ViewBuilder
    func stickyHeaderText(title: String, isShowingDivider: Bool = false) -> some View {
        Text(title)
            .font(.title)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.horizontal)

        if isShowingDivider {
            Color.black.opacity(0.3)
                .frame(height: 1)
        }
    }

    var drawerContent: some View {
        VStack(spacing: 8) {
            Text("Scrollable content")
                .font(.title2)
                .padding()

            ForEach(0..<30) { index in
                Text("Item \(index)")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical)

                Divider()
            }
        }
    }

    func customDragHandleDrawerStyle() -> DrawerStyle {
        DrawerStyle(
            dragHandleStyle: .custom({
                AnyView(
                    VStack(spacing: 2) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 50, height: 6)
                        }
                    }
                    .padding(8)
                )
            })
        )
    }

    func updateDrawerBottomPosition(isStickyHeaderShown: Bool) {
        if isStickyHeaderShown {
            drawerBottomPosition = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom()
        } else {
            drawerBottomPosition = .relativeToSafeAreaBottom(offset: 0)
        }
    }
}

extension View {
    @ViewBuilder
    func opaqueTabBarStyle(isTabBarShown: Bool) -> some View {
        if #available(iOS 16.0, *) {
            self
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color(.secondarySystemFill), for: .tabBar)
                .toolbar(isTabBarShown ? .visible : .hidden, for: .tabBar)
        } else {
            self
                .background(TabBarRepresentable(isHidden: !isTabBarShown))
        }
    }
}

#Preview {
    ContentView()
}
