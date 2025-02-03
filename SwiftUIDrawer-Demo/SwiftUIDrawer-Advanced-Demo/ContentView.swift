import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    private enum Alignment: Int {
        case safeArea
        case tabBar
    }
    
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var drawerBottomPosition = DrawerBottomPosition.relativeToSafeAreaBottom(offset: 0)
    
    @State private var isTabBarShown = false
    @State private var isStickyHeaderShown = false
    @State private var isCustomDragHandleShown = false
    
    @State private var selectedAlignment = Alignment.safeArea.rawValue
    
    private let floatingButtonsConfig = DrawerFloatingButtonsConfiguration(
        trailingButtons: [
            .init(
                icon: Image(systemName: "map"),
                action: {}
            )
        ]
    )
    
    var body: some View {
        tabViewIfNeeded {
            configList
                .drawerOverlay(
                    state: $drawerState,
                    bottomPosition: $drawerBottomPosition,
                    isDimmingBackground: true,
                    stickyHeader: { isStickyHeaderShown ? stickyDrawerHeader : nil },
                    content: { drawerContent }
                )
                .drawerFloatingButtonsConfiguration(floatingButtonsConfig)
        }
        .onChange(of: isStickyHeaderShown) { newValue in
            updateDrawerBottomPosition(
                isStickyHeaderShown: newValue,
                isTabBarShown: isTabBarShown
            )
        }
        .onChange(of: isTabBarShown) { newValue in
            updateDrawerBottomPosition(
                isStickyHeaderShown: isStickyHeaderShown,
                isTabBarShown: newValue
            )
        }
        .onChange(of: selectedAlignment) { newValue in
            isTabBarShown = newValue == Alignment.tabBar.rawValue
        }
        .drawerStyle(
            isCustomDragHandleShown ? customDragHandleDrawerStyle() : .init()
        )
    }
    
    @ViewBuilder
    func tabViewIfNeeded<Content: View>(content: () -> Content) -> some View {
        if isTabBarShown {
            TabView {
                content()
                    .tabItem { Label("Demo", systemImage: "wrench.and.screwdriver") }
                    .opaqueTabBarStyle()
            }
        } else {
            ZStack { content() }
        }
    }
    
    var configList: some View {
        List {
            Picker(
                "Align to",
                selection: $selectedAlignment,
                content: {
                    Text("Safe area")
                        .tag(Alignment.safeArea.rawValue)
                    Text("Tab bar")
                        .tag(Alignment.tabBar.rawValue)
                }
            )
            
            Toggle("Show sticky header", isOn: $isStickyHeaderShown)
            
            Toggle("Show custom drag handle", isOn: $isCustomDragHandleShown)
            
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                Text("Set state to:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                actionButton("closed") {
                    drawerState.case = .closed
                }
                
                Spacer()
                
                actionButton("partiallyOpened") {
                    drawerState.case = .partiallyOpened
                }
                
                Spacer()
                
                actionButton("fullyOpened") {
                    drawerState.case = .fullyOpened
                }
            }
        }
    }
    
    func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(width: 140)
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var stickyDrawerHeader: some View {
        VStack(spacing: 0) {
            Text("Sticky header")
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal)
            
            Color.black.opacity(0.3)
                .frame(height: 1)
        }
        .background { Color.teal }
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
                
                Divider()
            }
            .padding(.vertical)
        }
    }

    func customDragHandleDrawerStyle() -> DrawerStyle {
        DrawerStyle(
            dragHandle: AnyView(
                VStack(spacing: 2) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 50, height: 6)
                    }
                }
                .padding(8)
            )
        )
    }
    
    func updateDrawerBottomPosition(isStickyHeaderShown: Bool, isTabBarShown: Bool) {
        switch (isStickyHeaderShown, isTabBarShown) {
        case (true, true):
            drawerBottomPosition = .matchesStickyHeaderContentHeightAlignedToTabBar()
        case (true, false):
            drawerBottomPosition = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom()
        case (false, true):
            drawerBottomPosition = .relativeToTabBar(offset: 0)
        case (false, false):
            drawerBottomPosition = .relativeToSafeAreaBottom(offset: 0)
        }
    }
}

extension View {
    @ViewBuilder func opaqueTabBarStyle() -> some View {
        if #available(iOS 16.0, *) {
            self
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color(.secondarySystemFill), for: .tabBar)
        } else {
            self
        }
    }
}

#Preview {
    ContentView()
}
