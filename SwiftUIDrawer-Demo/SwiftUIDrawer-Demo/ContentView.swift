import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    private enum Alignment: Int {
        case safeArea
        case tabBar
    }
    
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var drawerMinHeight = DrawerMinHeight.relativeToSafeAreaBottom(0)
    
    @State private var isTabBarShown = false
    @State private var isStickyHeaderShown = false
    
    @State private var selectedAlignment = Alignment.safeArea.rawValue
    
    var body: some View {
        ZStack {
            tabViewIfNeeded {
                backgroundView
                    .drawerOverlay(
                        state: $drawerState,
                        minHeight: $drawerMinHeight,
                        stickyHeader: { isStickyHeaderShown ? stickyDrawerHeader : nil },
                        content: { drawerContent }
                    )
            }
        }
        .onChange(of: isStickyHeaderShown) { newValue in
            updateDrawerState(
                isStickyHeaderShown: newValue,
                isTabBarShown: isTabBarShown
            )
        }
        .onChange(of: isTabBarShown) { newValue in
            updateDrawerState(
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
    
    var backgroundView: some View {
        Color(.systemBackground)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) { configButtons }
    }
    
    var configButtons: some View {
        VStack {
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
                .pickerStyle(.segmented)
                
                Toggle("Show sticky header", isOn: $isStickyHeaderShown)
            }
                
        }
    }
    
    var stickyDrawerHeader: some View {
        VStack {
            Text("Sticky header")
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal)
            
            Color.black.opacity(0.3)
                .frame(height: 1)
        }
        .background {
            Color.teal
        }
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
    
    func updateDrawerState(isStickyHeaderShown: Bool, isTabBarShown: Bool) {
        switch (isStickyHeaderShown, isTabBarShown) {
        case (true, true):
            drawerMinHeight = .sameAsStickyHeaderContentHeightRelativeToTabBar(0)
        case (true, false):
            drawerMinHeight = .sameAsStickyHeaderContentHeightRelativeToSafeAreaBottom(0)
        case (false, true):
            drawerMinHeight = .relativeToSafeAreaBottomAndTabBar(0)
        case (false, false):
            drawerMinHeight = .relativeToSafeAreaBottom(0)
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
