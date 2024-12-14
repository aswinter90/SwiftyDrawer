import UIKit

@MainActor
public protocol InsetsConstraining {
    @discardableResult func constrain(subview: UIView) -> UIView
    @discardableResult func constrain(subview: UIView, insets: ViewInsets) -> UIView
}

public struct ViewInsets {
    let top: CGFloat?
    let left: CGFloat?
    let bottom: CGFloat?
    let right: CGFloat?

    public init(top: CGFloat?, left: CGFloat?, bottom: CGFloat?, right: CGFloat?) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    public static var zero: ViewInsets { ViewInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0) }
}

extension UIView: InsetsConstraining {
    @discardableResult public func constrain(subview: UIView) -> UIView {
        constrain(subview: subview, insets: .zero)
    }

    @discardableResult public func constrain(subview: UIView, insets: ViewInsets) -> UIView {
        constrainHorizontally(subview: subview, insets: insets)
        constrainVertically(subview: subview, insets: insets)
        return self
    }

    @discardableResult public func constrainHorizontally(subview: UIView, insets: ViewInsets = .zero) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = constraintIfValue(first: subview.leadingAnchor, second: leadingAnchor, value: insets.left)
        let rightConstraint = constraintIfValue(first: trailingAnchor, second: subview.trailingAnchor, value: insets.right)
        addConstraints([leftConstraint, rightConstraint].compactMap { $0 })
        return self
    }

    @discardableResult public func constrainVertically(subview: UIView, insets: ViewInsets = .zero) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = constraintIfValue(first: subview.topAnchor, second: topAnchor, value: insets.top)
        let bottomConstraint = constraintIfValue(first: bottomAnchor, second: subview.bottomAnchor, value: insets.bottom)
        addConstraints([topConstraint, bottomConstraint].compactMap { $0 })
        return self
    }

    private func constraintIfValue<T>(first: NSLayoutAnchor<T>, second: NSLayoutAnchor<T>, value: CGFloat?) -> NSLayoutConstraint? {
        if let unwrapped = value {
            return first.constraint(equalTo: second, constant: unwrapped)
        } else {
            return nil
        }
    }

    @discardableResult public func constrainToCenter(subview: UIView, offset: CGPoint = .zero) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraint = centerYAnchor.constraint(equalTo: subview.centerYAnchor, constant: offset.y)
        let horizontalConstraint = centerXAnchor.constraint(equalTo: subview.centerXAnchor, constant: offset.x)
        addConstraints([verticalConstraint, horizontalConstraint])
        return self
    }

    @discardableResult public func constrainToCenterVertically(subview: UIView, offset: CGPoint = .zero) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraint = centerYAnchor.constraint(equalTo: subview.centerYAnchor, constant: offset.y)
        addConstraints([verticalConstraint])
        return self
    }

    @discardableResult public func constrainToTop(subview: UIView, insets: ViewInsets = .zero) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = constraintIfValue(first: subview.topAnchor, second: topAnchor, value: insets.top)
        topConstraint.map { addConstraint($0) }
        constrainHorizontally(subview: subview, insets: insets)
        return self
    }

    @discardableResult public func constrainToBottom(subview: UIView, insets: ViewInsets = .zero) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = constraintIfValue(first: bottomAnchor, second: subview.bottomAnchor, value: insets.bottom)
        bottomConstraint.map { addConstraint($0) }
        constrainHorizontally(subview: subview, insets: insets)
        return self
    }

    @discardableResult public func constrainToLeading(subview: UIView, leadingSpacing: CGFloat = 0) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = constraintIfValue(first: leadingAnchor, second: subview.leadingAnchor, value: -leadingSpacing)
        let verticalConstraint = centerYAnchor.constraint(equalTo: subview.centerYAnchor, constant: 0)
        addConstraints([leadingConstraint, verticalConstraint].compactMap { $0 })
        return self
    }

    @discardableResult public func constrainToTrailing(subview: UIView, trailingSpacing: CGFloat = 0) -> UIView {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = constraintIfValue(first: trailingAnchor, second: subview.trailingAnchor, value: -trailingSpacing)
        let verticalConstraint = centerYAnchor.constraint(equalTo: subview.centerYAnchor, constant: 0)
        addConstraints([trailingConstraint, verticalConstraint].compactMap { $0 })
        return self
    }

    @discardableResult public func constrainBounds(height: CGFloat? = nil, width: CGFloat? = nil) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let height {
            let constraint = heightAnchor.constraint(equalToConstant: height)
            constraints.append(constraint)
        }
        if let width {
            let constraint = widthAnchor.constraint(equalToConstant: width)
            constraints.append(constraint)
        }
        addConstraints(constraints)
        return self
    }

    @discardableResult public func constrainBounds(size: CGSize) -> UIView {
        constrainBounds(height: size.height, width: size.width)
    }

    @discardableResult public func constrainHeight(_ height: CGFloat) -> UIView {
        constrainBounds(height: height, width: nil)
    }

    @discardableResult public func constrainWidth(_ width: CGFloat) -> UIView {
        constrainBounds(height: nil, width: width)
    }

    @discardableResult public func constrainHeight(relativeWith view: UIView,
                                                   multiplier: CGFloat = 1.0,
                                                   constant: CGFloat = 0) -> UIView
    {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        addConstraint(constraint)
        return self
    }

    @discardableResult public func constrainWidth(relativeWith view: UIView,
                                                  multiplier: CGFloat = 1.0,
                                                  constant: CGFloat = 0) -> UIView
    {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        addConstraint(constraint)
        return self
    }

    @discardableResult public func constrainRatio(heightWidthRatio: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: heightWidthRatio)
        constraint.isActive = true
        addConstraint(constraint)
        return self
    }

    @discardableResult public func constrainSquare() -> UIView {
        constrainRatio(heightWidthRatio: 1.0)
    }

    @discardableResult public func constrainMaxBounds(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let width {
            let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: width)
            constraints.append(constraint)
        }
        if let height {
            let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: height)
            constraints.append(constraint)
        }
        addConstraints(constraints)
        return self
    }

    @discardableResult public func constrainMaxBounds(size: CGSize? = nil) -> UIView {
        constrainMaxBounds(width: size?.width, height: size?.height)
    }

    @discardableResult public func constrainMinBounds(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        if let width {
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            constraints.append(constraint)
        }
        if let height {
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            constraints.append(constraint)
        }
        addConstraints(constraints)
        return self
    }

    @discardableResult public func constrainMinBounds(size: CGSize? = nil) -> UIView {
        constrainMinBounds(width: size?.width, height: size?.height)
    }
}
