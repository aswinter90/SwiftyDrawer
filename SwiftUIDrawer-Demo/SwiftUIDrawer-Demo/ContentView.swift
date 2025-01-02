import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    private enum Alignment: Int {
        case safeArea
        case tabBar
    }
    
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var drawerMinHeight = DrawerMinHeight.relativeToSafeAreaBottom(offset: 0)
    
    @State private var isTabBarShown = false
    @State private var isStickyHeaderShown = false
    
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
                    minHeight: $drawerMinHeight,
                    isDimmingBackground: true,
                    stickyHeader: { isStickyHeaderShown ? stickyDrawerHeader : nil },
                    content: { drawerContent }
                )
                .drawerFloatingButtonsConfiguration(floatingButtonsConfig)
        }
        .onChange(of: isStickyHeaderShown) { newValue in
            updateDrawerMinHeight(
                isStickyHeaderShown: newValue,
                isTabBarShown: isTabBarShown
            )
        }
        .onChange(of: isTabBarShown) { newValue in
            updateDrawerMinHeight(
                isStickyHeaderShown: isStickyHeaderShown,
                isTabBarShown: newValue
            )
        }
        .onChange(of: selectedAlignment) { newValue in
            isTabBarShown = newValue == Alignment.tabBar.rawValue
        }
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
            
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                Text("Actions:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                actionButton("Close") {
                    drawerState.case = .closed
                }
                
                Spacer()
                
                actionButton("Open half") {
                    drawerState.case = .partiallyOpened
                }
                
                Spacer()
                
                actionButton("Open fully") {
                    drawerState.case = .fullyOpened
                }
            }
        }
    }
    
    func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(width: 80)
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
        VStack(spacing: 16) {
            Text("Scrollable content")
                .font(.title2)
                .padding(.top)
            
            ForEach(0..<30) { index in
                Text("Item \(index)")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
            }
            .padding(.vertical)
        }
    }
    
    func updateDrawerMinHeight(isStickyHeaderShown: Bool, isTabBarShown: Bool) {
        switch (isStickyHeaderShown, isTabBarShown) {
        case (true, true):
            drawerMinHeight = .matchesStickyHeaderContentHeightAlignedToTabBar()
        case (true, false):
            drawerMinHeight = .matchesStickyHeaderContentHeightAlignedToSafeAreaBottom()
        case (false, true):
            drawerMinHeight = .relativeToTabBar(offset: 0)
        case (false, false):
            drawerMinHeight = .relativeToSafeAreaBottom(offset: 0)
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
