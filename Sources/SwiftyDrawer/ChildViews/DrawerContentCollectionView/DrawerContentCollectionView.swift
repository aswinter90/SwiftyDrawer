import SwiftUI

typealias VerticalContentOffset = Double
typealias VerticalDragTranslation = Double

/// To orchestrate drag gestures between the drawer and its scrollable content, a UICollectionView was found as the best solution,
/// compared to a UIScrollView which leads to UI freezes or a UITableView which crashes the app.
/// Hopefully SwiftUI will soon offer tools to quickly make this Frankenstein setup obsolete.
class DrawerContentCollectionView<Content: View>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Properties: Internal

    var content: Content {
        didSet {
            if let contentOffset = drawerContentOffsetController?.consumeLatestContentOffset() {
                self.contentOffset = contentOffset

                if contentOffset == .zero {
                    onDidResetContentOffset()
                }
            }
        }
    }

    var safeAreaBottom: Double
    var shouldBeginDragging: (VerticalContentOffset, VerticalDragTranslation) -> Bool
    var onDraggingEnded: (_ willDecelerate: Bool) -> Void
    var onDecelaratingEnded: () -> Void
    var onDidScroll: (_ verticalContentOffset: Double) -> Void
    var onDidResetContentOffset: () -> Void

    // MARK: - Properties: Private

    private let drawerContentOffsetController: DrawerContentOffsetController?

    private let configuration: UICollectionLayoutListConfiguration = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .init(.background)
        return configuration
    }()

    private let swiftUICellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Content> { collectionViewCell, _, content in
        if #available(iOS 16.0, *) {
            let hostingConfiguration = UIHostingConfiguration { content }.margins(.horizontal, 0)
            collectionViewCell.contentConfiguration = hostingConfiguration
            collectionViewCell.contentView.backgroundColor = .init(.background)
        } else {
            fatalError("DrawerContentCollectionView is only available on iOS 16+")
        }
    }

    // MARK: - Initializer

    init(
        content: Content,
        safeAreaBottom: Double,
        shouldBeginDragging: @escaping (VerticalContentOffset, VerticalDragTranslation) -> Bool,
        onDraggingEnded: @escaping (_ willDecelerate: Bool) -> Void,
        onDecelaratingEnded: @escaping () -> Void,
        onDidScroll: @escaping (_ verticalContentOffset: Double) -> Void,
        onDidResetContentOffset: @escaping () -> Void,
        drawerContentOffsetController: DrawerContentOffsetController?
    ) {
        self.content = content
        self.safeAreaBottom = safeAreaBottom
        self.shouldBeginDragging = shouldBeginDragging
        self.onDraggingEnded = onDraggingEnded
        self.onDecelaratingEnded = onDecelaratingEnded
        self.onDidScroll = onDidScroll
        self.onDidResetContentOffset = onDidResetContentOffset
        self.drawerContentOffsetController = drawerContentOffsetController

        super.init(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration)
        )

        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        dataSource = self
        delegate = self
    }

    // MARK: - Helper

    /// Touch events in empty space outside of cells should not be registered and passed to the Drawer instead
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let cell = visibleCells.first else { return false }

        return cell.point(inside: convert(point, to: cell), with: event)
    }

    // MARK: - Gesture recognizer

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }

        let verticalPanTranslation = panGestureRecognizer.translation(in: self).y
        return shouldBeginDragging(contentOffset.y, verticalPanTranslation)
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        onDraggingEnded(decelerate)
    }

    func scrollViewDidEndDecelerating(_: UIScrollView) {
        onDecelaratingEnded()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onDidScroll(scrollView.contentOffset.y)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueConfiguredReusableCell(using: swiftUICellRegistration, for: indexPath, item: content)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_: UICollectionView, shouldHighlightItemAt _: IndexPath) -> Bool { false }
}

// MARK: - SwiftUI

extension DrawerContentCollectionView {
    func swiftUIView() -> some View {
        DrawerContentCollectionViewRepresentable<Content>(component: self)
    }
}

struct DrawerContentCollectionViewRepresentable<Content: View>: UIViewRepresentable {
    let component: DrawerContentCollectionView<Content>

    func makeUIView(context _: Context) -> DrawerContentCollectionView<Content> { component }

    func updateUIView(_ uiView: DrawerContentCollectionView<Content>, context _: Context) {
        uiView.content = component.content
        uiView.shouldBeginDragging = component.shouldBeginDragging
        uiView.onDraggingEnded = component.onDraggingEnded
        uiView.onDecelaratingEnded = component.onDecelaratingEnded
        uiView.onDidScroll = component.onDidScroll
        uiView.onDidResetContentOffset = component.onDidResetContentOffset

        if component.safeAreaBottom != uiView.safeAreaBottom {
            uiView.safeAreaBottom = component.safeAreaBottom
            uiView.reloadData()
        }
    }
}
