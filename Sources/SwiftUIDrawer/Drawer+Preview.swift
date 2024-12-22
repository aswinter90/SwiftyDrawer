import SwiftUI

struct Drawer_PreviewProvider: PreviewProvider {
    @State private static var previewDrawerMinHeight1 = DrawerMinHeight.sameAsStickyHeaderContentHeightRelativeToTabBar(0)
    
    @State private static var previewDrawerMinHeight2 = DrawerMinHeight.relativeToSafeAreaBottomAndTabBar(0)
    
    static var previews: some View {
        Group {
            DrawerDemoView(isShowingStickyHeader: true)
                .previewDisplayName("Drawer with header")

            DrawerDemoView(isShowingStickyHeader: false)
                .previewDisplayName("Drawer without header")
        }
    }
}

struct DrawerDemoView: View {
    private let mediumHeight: CGFloat = 450
    @State private var drawerState = DrawerState(case: .fullyOpened)
    @State private var minHeight1: DrawerMinHeight = DrawerMinHeight.sameAsStickyHeaderContentHeightRelativeToTabBar(0)
    @State private var minHeight2 = DrawerMinHeight.relativeToSafeAreaBottomAndTabBar(0)
    
    let isShowingStickyHeader: Bool

    var body: some View {
        Color.blue.opacity(0.2)
            .frame(maxHeight: .infinity)
            .ignoresSafeArea()
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
                animation: .snappy(duration: 0.3),
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
            .drawerFloatingButtonsConfiguration(.init(
                firstButtonProperties: .init(icon: .init(systemName: "map"), action: {}),
                secondButtonProperties: .init(icon: .init(systemName: "mappin.circle"), action: {})
            ))
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
