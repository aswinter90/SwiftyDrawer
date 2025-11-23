import Foundation
import SwiftUI

public struct DrawerStyle {
    public enum DragHandleStyle {
        case standard
        // swiftlint:disable:next discouraged_none_name
        case none
        case custom(@MainActor () -> AnyView)

        @MainActor var view: AnyView? {
            switch self {
            case .standard:
                AnyView(DragHandle())
            case .none:
                nil
            case .custom(let view):
                AnyView(view())
            }
        }
    }

    public struct ShadowStyle {
        let color: Color
        let opacity: Double
        let radius: Double
        let offset: CGSize

        public init(
            color: Color = .black,
            opacity: Double = 0.15,
            radius: Double = 3.0,
            offset: CGSize
        ) {
            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }

        public static var none: Self {
            Self.init(color: .clear, offset: .init(width: 0, height: 0))
        }
    }

    let backgroundColor: Color
    let cornerRadius: Double
    let shadowStyle: ShadowStyle
    let dragHandleStyle: DragHandleStyle
    let stickyHeaderShadowStyle: ShadowStyle

    var hasOpaqueBackgroundColor: Bool {
        let color = UIColor(backgroundColor)
        return color.cgColor.alpha == 1 && color != .clear
    }

    public init(
        backgroundColor: Color = Color.background,
        cornerRadius: Double = DrawerConstants.drawerCornerRadius,
        shadowStyle: ShadowStyle = .init(offset: .init(width: 0, height: -3)),
        dragHandleStyle: DragHandleStyle = .standard,
        stickyHeaderShadowStyle: ShadowStyle = .init(offset: .init(width: 0, height: 3))
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowStyle = shadowStyle
        self.dragHandleStyle = dragHandleStyle
        self.stickyHeaderShadowStyle = stickyHeaderShadowStyle
    }
}
