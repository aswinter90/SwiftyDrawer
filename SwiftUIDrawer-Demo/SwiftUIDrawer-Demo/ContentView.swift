import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState(case: .partiallyOpened)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
        }
        .offset(.init(width: 0, height: -100))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .drawerOverlay(
            state: $drawerState,
            isTabBarShown: false,
            stickyHeader: {
                Text("Header")
            },
            content: {
                Text("Content")
                    .padding()
            }
        )
    }
}

#Preview {
    ContentView()
}
