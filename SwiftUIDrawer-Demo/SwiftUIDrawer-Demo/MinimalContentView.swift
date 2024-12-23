import SwiftUI
import SwiftUIDrawer

struct MinimalContentView: View {
    @State private var drawerState = DrawerState.init(case: .partiallyOpened)
    
    var body: some View {
        AppleLogo()
            .padding(.top, 8)
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
    MinimalContentView()
}

private struct AppleLogo: View {
    var body: some View {
        Image(systemName: "apple.logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 64, height: 64)
            .frame(maxHeight: .infinity, alignment: .top)
    }
}
