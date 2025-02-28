import SwiftUI
import SwiftyDrawer

struct ContentView: View {
    @State private var drawerState = DrawerState.init(case: .partiallyOpened)

    var body: some View {
        MyAppleLogo()
            .drawerOverlay(
                state: $drawerState,
                content: {
                    VStack {
                        ForEach(0..<30) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()

                            Divider()
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

private struct MyAppleLogo: View {
    var body: some View {
        GeometryReader { proxy in
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128, height: 128)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: -(proxy.size.height / 4))
                .background(Color.gray.opacity(0.5))
        }
    }
}
