import SwiftUI

public struct RoundFloatingButton: View {
    @Environment(\.drawerStyle) private var drawerStyle: DrawerStyle
    
    public static let height = 40.0
    public static let padding = 16.0

    private var icon: Image
    private var action: () -> Void

    public init(icon: Image, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(
            action: action,
            label: {
                icon
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .background(Color.background)
                    .frame(width: Self.height)
                    .clipShape(Circle())
                    .prerenderedShadow(
                        layerCornerRadius: 20,
                        color: UIColor(drawerStyle.floatingButtonShadowStyle.color),
                        opacity: Float(drawerStyle.floatingButtonShadowStyle.opacity),
                        radius: drawerStyle.floatingButtonShadowStyle.radius,
                        offset: drawerStyle.floatingButtonShadowStyle.offset
                    )
            }
        )
        .tint(.primary)
    }
}
