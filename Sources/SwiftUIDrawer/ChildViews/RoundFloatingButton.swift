import SwiftUI

public struct RoundFloatingButton: View {
    @Environment(\.drawerFloatingButtonShadowStyle) private var shadowStyle: DrawerStyle.ShadowStyle
    
    private static let height = 40.0
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
                    .background(
                        Color.background
                            .frame(width: Self.height, height: Self.height)
                            .clipShape(Circle())
                            .prerenderedShadow(
                                layerCornerRadius: 20,
                                color: UIColor(shadowStyle.color),
                                opacity: Float(shadowStyle.opacity),
                                radius: shadowStyle.radius,
                                offset: shadowStyle.offset
                            )
                    )
            }
        )
        .tint(properties.tintColor)
    }
}
