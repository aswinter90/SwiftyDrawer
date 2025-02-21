import Foundation
import SwiftUI
import UIKit

/// The `PrerenderedShadowView` replaces the default SwiftUI shadow modifier. It has a smaller performance impact due to its shadow path, which must not be redrawn if the layout changes.
public class PrerenderedShadowView: UIView {
    public struct ShadowConfiguration: Equatable {
        let layerCornerRadius: Double
        let shadowColor: UIColor
        let shadowOpacity: Double
        let shadowRadius: Double
        let shadowOffset: CGSize

        init(style: DrawerStyle.ShadowStyle, cornerRadius: Double) {
            self.init(
                layerCornerRadius: cornerRadius,
                shadowColor: UIColor(style.color),
                shadowOpacity: style.opacity,
                shadowRadius: style.radius,
                shadowOffset: style.offset
            )
        }

        init(
            layerCornerRadius: Double,
            shadowColor: UIColor,
            shadowOpacity: Double,
            shadowRadius: Double,
            shadowOffset: CGSize
        ) {
            self.layerCornerRadius = layerCornerRadius
            self.shadowColor = shadowColor
            self.shadowOpacity = shadowOpacity
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
        }
    }

    private var shadowLayer = CALayer()
    private var previousBounds: CGRect?

    var configuration: ShadowConfiguration

    public init(configuration: ShadowConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        backgroundColor = .init(.background)
        layer.shouldRasterize = true

        layer.cornerRadius = configuration.layerCornerRadius

        setupShadowLayer(with: configuration)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != .zero, bounds != previousBounds {
            drawShadowPath(of: shadowLayer)
        }

        previousBounds = bounds
    }

    private func setupShadowLayer(with configuration: ShadowConfiguration) {
        shadowLayer.removeFromSuperlayer()
        shadowLayer.shadowPath = nil

        shadowLayer.shadowColor = configuration.shadowColor.cgColor
        shadowLayer.shadowOpacity = Float(configuration.shadowOpacity)
        shadowLayer.shadowRadius = configuration.shadowRadius
        shadowLayer.shadowOffset = configuration.shadowOffset

        layer.addSublayer(shadowLayer)
    }

    private func drawShadowPath(of shadowLayer: CALayer) {
        shadowLayer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: configuration.layerCornerRadius
        ).cgPath
    }

    func updateShadowLayerIfNeeded(with newConfiguration: ShadowConfiguration) {
        guard newConfiguration != configuration else { return }

        setupShadowLayer(with: newConfiguration)
        drawShadowPath(of: shadowLayer)

        configuration = newConfiguration
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public struct PrerenderedShadowViewRepresenter: UIViewRepresentable {
    public let component: PrerenderedShadowView

    public func makeUIView(context _: Context) -> PrerenderedShadowView { component }
    public func updateUIView(_ uiView: PrerenderedShadowView, context _: Context) {
        uiView.updateShadowLayerIfNeeded(with: component.configuration)
    }
}

public extension PrerenderedShadowView {
    var swiftUIView: PrerenderedShadowViewRepresenter { .init(component: self) }
}

public extension View {
    func prerenderedShadow(
        layerCornerRadius: Double,
        color: UIColor,
        opacity: Float,
        radius: Double,
        offset: CGSize
    ) -> some View {
        background {
            PrerenderedShadowView(
                configuration: .init(
                    layerCornerRadius: layerCornerRadius,
                    shadowColor: color,
                    shadowOpacity: Double(opacity),
                    shadowRadius: radius,
                    shadowOffset: offset
                )
            )
            .swiftUIView
        }
    }

    func prerenderedShadow(_ style: DrawerStyle.ShadowStyle, cornerRadius: Double) -> some View {
        prerenderedShadow(
            layerCornerRadius: cornerRadius,
            color: UIColor(style.color),
            opacity: Float(style.opacity),
            radius: style.radius,
            offset: style.offset
        )
    }
}
