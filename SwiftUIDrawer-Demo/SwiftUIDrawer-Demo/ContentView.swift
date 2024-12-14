import SwiftUI
import SwiftUIDrawer

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
                .drawerOverlay(state: .constant(.init(case: .partiallyOpened))) {
                    Color.gray
                }
        }
    }
}

#Preview {
    ContentView()
}
