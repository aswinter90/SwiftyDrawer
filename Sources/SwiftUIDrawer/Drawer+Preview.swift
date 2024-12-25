import SwiftUI

#Preview("Drawer with header") {
    DrawerDemoView(isShowingStickyHeader: true)
}

#Preview("Drawer without header") {
    DrawerDemoView(isShowingStickyHeader: false)
}

struct DrawerDemoView: View {
    private let mediumHeight: CGFloat = 450
    @State private var drawerState = DrawerState(case: .fullyOpened)
    @State private var minHeight1: DrawerMinHeight = DrawerMinHeight.sameAsStickyHeaderContentHeightAlignedToTabBar(0)
    @State private var minHeight2 = DrawerMinHeight.relativeToTabBar(0)
    
    let isShowingStickyHeader: Bool

    var body: some View {
        Color.blue.opacity(0.5)
            .drawerOverlay(
                state: $drawerState,
                minHeight: isShowingStickyHeader ? $minHeight1 : $minHeight2,
                mediumHeight: .constant(.absolute(mediumHeight)),
                isDimmingBackground: true,
                stickyHeader: isShowingStickyHeader ? {
                    VStack {
                        VStack {
                            Text("Drawer Component Demo")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Sticky Header")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .red],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                        .cornerRadius(14)
                        .padding(.horizontal, 8)

                        Color.border
                            .frame(height: 1)
                    }
                } : { nil },
                content: {
                    VStack(spacing: 16) {
                        Text("Content")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(
                                LinearGradient(
                                    colors: [.yellow, .black],
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                )
                            )
                            .cornerRadius(14)
                            .padding([.horizontal, .top], 8)

                        ForEach(0 ..< 25) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            )
            .drawerAnimation(.snappy(duration: 0.3))
            .drawerFloatingButtonsConfiguration(
                .init(
                    leadingButtons: [
                        .init(icon: .init(systemName: "map"), action: {}),
                        .init(icon: .init(systemName: "pencil"), action: {}),
                    ],
                    trailingButtons: [
                        .init(icon: .init(systemName: "mappin.circle"), action: {})
                    ]
                )
            )
            .fakeTransparentTabBar
    }
}

private extension View {
    @ViewBuilder
    var fakeTransparentTabBar: some View {
        overlay(
            alignment: .bottom,
            content: {
                Text("Fake Tab bar")
                    .foregroundStyle(Color.white)
                    .font(.callout)
                    .shadow(radius: 2)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: TabBarHeightProvider.sharedInstance.height
                            + UIApplication.shared.safeAreaInsets.bottom
                    )
                    .background(Color.gray.opacity(0.8))
            }
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
