import SwiftUI

public struct RoundFloatingButton: View {
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
                    .background(Color.init(uiColor: .systemBackground))
                    .frame(width: Self.height)
                    .clipShape(Circle())
                    .prerenderedShadow(
                        layerCornerRadius: 20,
                        color: .black,
                        opacity: 0.15,
                        radius: 3,
                        offset: .init(width: 0, height: 3)
                    )
            }
        )
        .tint(.primary)
    }
}
