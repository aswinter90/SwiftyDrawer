import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var drawerMinHeight = DrawerMinHeight.sameAsStickyHeaderContentHeightRelativeToTabBar(0)
    
    @State private var isTabBarShown = true
    @State private var isStickyHeaderShown = true
    
    var body: some View {
        ZStack {
            tabViewIfNeeded {
                backgroundView
                    .drawerOverlay(
                        state: $drawerState,
                        minHeight: $drawerMinHeight,
                        isTabBarShown: isTabBarShown,
                        stickyHeader: isStickyHeaderShown ? { stickyDrawerHeader } : nil,
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
    }
    
    @ViewBuilder
    func tabViewIfNeeded<Content: View>(content: () -> Content) -> some View {
        if isTabBarShown {
            TabView { content() }
        } else {
            ZStack { content() }
        }
    }
    
    var backgroundView: some View {
        Color(.systemBackground)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) { configButtons }
            .tabItem { Label("Demo", systemImage: "wrench.and.screwdriver") }
            .opaqueTabBarStyle()
    }
    
    var configButtons: some View {
        VStack {
            Text("Align to:")
            
            HStack(spacing: 16) {
                Button("Safe area") { isTabBarShown = false }
                    .disabled(!isTabBarShown)
                
                Button("Tab bar") { isTabBarShown = true }
                    .disabled(isTabBarShown)
            }
            
            Text("Show sticky header")
                .padding(.top)
            Toggle("", isOn: $isStickyHeaderShown)
                .frame(maxWidth: 51)
        }
        .padding()
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
