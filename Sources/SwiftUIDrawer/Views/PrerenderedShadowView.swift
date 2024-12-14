import Foundation
import SwiftUI
import UIKit

public class PrerenderedShadowView: UIView {
    public struct ShadowConfiguration: Equatable {
        let layerCornerRadius: CGFloat
        let shadowColor: UIColor
        let shadowOpacity: Float
        let shadowRadius: CGFloat
        let shadowOffset: CGSize
    }

    private var shadowLayer = CALayer()
    private var previousBounds: CGRect?

    var configuration: ShadowConfiguration

    public init(configuration: ShadowConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        backgroundColor = .systemBackground
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
        shadowLayer.shadowOpacity = configuration.shadowOpacity
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
        layerCornerRadius: CGFloat,
        color: UIColor,
        opacity: Float,
        radius: CGFloat,
        offset: CGSize
    ) -> some View {
        background {
            PrerenderedShadowView(
                configuration: .init(
                    layerCornerRadius: layerCornerRadius,
                    shadowColor: color,
                    shadowOpacity: opacity,
                    shadowRadius: radius,
                    shadowOffset: offset
                )
            )
            .swiftUIView
        }
    }
}
