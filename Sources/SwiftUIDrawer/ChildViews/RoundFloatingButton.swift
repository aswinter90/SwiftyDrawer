import SwiftUI

public struct RoundFloatingButton: View {
    @Environment(\.drawerStyle) private var drawerStyle: DrawerStyle
    
    public static let height = 40.0
    public static let padding = 16.0

    private let properties: DrawerFloatingButtonsConfiguration.ButtonProperties

    public init(properties: DrawerFloatingButtonsConfiguration.ButtonProperties) {
        self.properties = properties
    }
    
    public var body: some View {
        Button(
            action: properties.action,
            label: {
                properties
                    .icon
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
