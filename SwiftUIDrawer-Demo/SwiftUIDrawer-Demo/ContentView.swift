import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    @State private var drawerMinHeight = DrawerMinHeight.sameAsStickyHeaderContentHeightRelativeToTabBar(0)
    
    var body: some View {
        TabView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Text("Hello, world!")
            }
            .offset(.init(width: 0, height: -100))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabItem { Label("Demo", systemImage: "wrench.and.screwdriver") }
            .opaqueTabBarStyle()
            .drawerOverlay(
                state: $drawerState,
                minHeight: $drawerMinHeight,
                isTabBarShown: true,
                stickyHeader: {
                    Text("Sticky header")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .border(Color.black.opacity(0.8))
                        .padding()
                },
                content: {
                    VStack(spacing: 16) {
                        ForEach(0..<100) { index in
                            Text("Content \(index)")
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            )
        }
    }
}

extension View {
    @ViewBuilder func opaqueTabBarStyle() -> some View {
        if #available(iOS 16.0, *) {
            self
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color.white, for: .tabBar)
        } else {
            self
        }
    }
}


#Preview {
    ContentView()
}
