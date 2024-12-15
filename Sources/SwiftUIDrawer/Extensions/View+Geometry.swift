import SwiftUI

public extension View {
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
}

public struct SizePreferenceKey: PreferenceKey {
    public static let defaultValue: CGSize = .zero
    public static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

public struct FramePreferenceKey: PreferenceKey {
    public static let defaultValue: CGRect = .zero
    public static func reduce(value _: inout CGRect, nextValue _: () -> CGRect) {}
}
