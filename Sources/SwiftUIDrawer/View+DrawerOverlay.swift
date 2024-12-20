import SwiftUI

public extension View {
    @ViewBuilder
    func drawerOverlay<StickyHeaderContent: View>(
        layoutingStrategy: Binding<DrawerContentLayoutingStrategy> = .constant(.classic),
        state: Binding<DrawerState>,
        minHeight: Binding<DrawerMinHeight> = .constant(.relativeToSafeAreaBottom(0)),
        mediumHeight: Binding<DrawerMediumHeight>? = .constant(DrawerConstants.drawerDefaultMediumHeight),
        maxHeight: DrawerMaxHeight = .relativeToSafeAreaTop(0),
        isTabBarShown: Bool = true,
        isDimmingBackground: Bool = false,
        @ViewBuilder stickyHeader: () -> StickyHeaderContent? = { nil },
        animation: Animation = .smooth(duration: DrawerConstants.defaultAnimationDuration),
        @ViewBuilder content: () -> some View,
        contentViewEventHandler: DrawerContentCollectionViewEventHandler? = nil,
        originObservable: DrawerOriginObservable? = nil
    ) -> some View {
        dimmedDrawerBackground(
            isShown: isDimmingBackground,
            drawerState: state,
            drawerMinHeight: minHeight,
            drawerMediumHeight: mediumHeight,
            drawerMaxHeight: maxHeight
        )
        .overlay(alignment: .bottom, content: {
            Drawer(
                layoutingStrategy: layoutingStrategy,
                state: state,
                minHeight: minHeight,
                mediumHeight: mediumHeight,
                maxHeight: maxHeight,
                isTabBarShown: isTabBarShown,
                stickyHeader: stickyHeader(),
                animation: animation,
                content: content(),
                contentViewEventHandler: contentViewEventHandler,
                originObservable: originObservable
            )
        })
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct Wot: View {
  let model: String?

  var body: Optional<some View> {
    guard let model else {
      return Body.none
    }

    return Text(model)
  }
}
