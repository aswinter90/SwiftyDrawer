import SwiftUI

public extension View {
    @inlinable func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }

    func readFrame(in coordinateSpace: CoordinateSpace, onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: geometryProxy.frame(in: coordinateSpace))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }

    func readScrollOffset(in coordinateSpace: CoordinateSpace, onChange: @escaping (CGPoint) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: coordinateSpace).origin)
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onChange)
    }

    @discardableResult func print(_ vars: Any...) -> some View {
        for v in vars {
            Swift.print(v)
        }
        return EmptyView()
    }

    /// Workaround to hide keyboard from a SwiftUI view supporting iOS 14.
    /// Source: https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }

    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

    @inlinable func padding(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> some View {
        padding(.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }

    func forceRedraw() -> some View {
        id(UUID())
    }
}

public struct SizePreferenceKey: PreferenceKey {
    public static let defaultValue: CGSize = .zero
    public static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

public struct FramePreferenceKey: PreferenceKey {
    public static let defaultValue: CGRect = .zero
    public static func reduce(value _: inout CGRect, nextValue _: () -> CGRect) {}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGPoint = .zero
    static func reduce(value _: inout CGPoint, nextValue _: () -> CGPoint) {}
}
