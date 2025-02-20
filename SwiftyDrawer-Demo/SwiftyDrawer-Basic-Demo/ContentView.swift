import SwiftUI
import SwiftyDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState.init(case: .partiallyOpened)

    var body: some View {
        AppleLogo()
            .offset(y: -(UIScreen.main.bounds.height / 4))
            .drawerOverlay(
                state: $drawerState,
                content: {
                    VStack(spacing: 16) {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                        }
                    }
                    .padding(.top, 8)
                }
            )
    }
}

#Preview {
    ContentView()
}

private struct AppleLogo: View {
    var body: some View {
        Image(systemName: "apple.logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 128, height: 128)
    }
}
