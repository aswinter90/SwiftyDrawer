import Foundation
import SwiftUI

public struct DrawerStyle {
    public struct ShadowStyle {
        let color: Color
        let opacity: CGFloat
        let radius: CGFloat
        let offset: CGSize
        
        public init(
            color: Color = .black,
            opacity: CGFloat = 0.15,
            radius: CGFloat = 3.0,
            offset: CGSize
        ) {
            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }
    }
    
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowStyle: ShadowStyle
    let dragHandle: AnyView
    let stickyHeaderShadowStyle: ShadowStyle
    let floatingButtonShadowStyle: ShadowStyle
    
    public init(
        backgroundColor: Color = Color.background,
        cornerRadius: CGFloat = DrawerConstants.drawerCornerRadius,
        shadowStyle: ShadowStyle = .init(offset: .init(width: 0, height: -3)),
        dragHandle: @autoclosure (() -> AnyView) = { AnyView(DragHandle()) }(),
        stickyHeaderShadowStyle: ShadowStyle = .init(offset: .init(width: 0, height: 3)),
        floatingButtonShadowStyle: ShadowStyle = .init(offset: .init(width: 0, height: 3))
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowStyle = shadowStyle
        self.dragHandle = dragHandle()
        self.stickyHeaderShadowStyle = stickyHeaderShadowStyle
        self.floatingButtonShadowStyle = floatingButtonShadowStyle
    }
}
