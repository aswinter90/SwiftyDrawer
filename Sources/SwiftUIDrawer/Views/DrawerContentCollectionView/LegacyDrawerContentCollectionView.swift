import SwiftUI
import UIKit

class LegacyDrawerContentCollectionView<Content: View>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Properties: Internal

    var content: Content {
        didSet {
            if let contentOffset = contentViewEventHandler?.consumeLatestContentOffset() {
                self.contentOffset = contentOffset

                if contentOffset == .zero {
                    onDidResetContentOffset()
                }
            }

            flowLayout.invalidateLayout()
            reloadData()
        }
    }

    var shouldBeginDragging: (VerticalContentOffset, VerticalDragTranslation) -> Bool
    var contentHeight: CGFloat
    var onDraggingEnded: (_ willDecelerate: Bool) -> Void
    var onDecelaratingEnded: () -> Void
    var onDidScroll: (_ verticalContentOffset: CGFloat) -> Void
    var onDidResetContentOffset: () -> Void

    // MARK: - Properties: Private

    private let flowLayout = UICollectionViewFlowLayout()
    private let contentViewEventHandler: DrawerContentCollectionViewEventHandler?

    // MARK: - Initializer

    init(
        content: Content,
        contentHeight: CGFloat,
        shouldBeginDragging: @escaping (VerticalContentOffset, VerticalDragTranslation) -> Bool,
        onDraggingEnded: @escaping (_ willDecelerate: Bool) -> Void,
        onDecelaratingEnded: @escaping () -> Void,
        onDidScroll: @escaping (_ verticalContentOffset: CGFloat) -> Void,
        onDidResetContentOffset: @escaping () -> Void,
        contentViewEventHandler: DrawerContentCollectionViewEventHandler?
    ) {
        self.content = content
        self.contentHeight = contentHeight
        self.shouldBeginDragging = shouldBeginDragging
        self.onDraggingEnded = onDraggingEnded
        self.onDecelaratingEnded = onDecelaratingEnded
        self.onDidScroll = onDidScroll
        self.onDidResetContentOffset = onDidResetContentOffset
        self.contentViewEventHandler = contentViewEventHandler

        super.init(frame: .zero, collectionViewLayout: flowLayout)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self)
        )
        dataSource = self
        backgroundColor = .init(.background)
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: UICollectionViewCell.self),
            for: indexPath
        )
        
        let contentView = cell.contentView
        
        if !contentView.subviews.isEmpty {
            return cell
        }

        guard let hostingView = UIHostingController(rootView: content).view else { return .init() }

        contentView.backgroundColor = .init(.background)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: cell.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
        ])
        
        contentView.addSubview(hostingView)
        
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let widthConstraint = contentView.widthAnchor.constraint(
            equalToConstant: UIScreen.main.bounds.width
        )
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true

        cell.layoutIfNeeded()

        return cell
    }
}

// MARK: - SwiftUI

extension LegacyDrawerContentCollectionView {
    func swiftUIView() -> some View {
        LegacyDrawerContentCollectionViewRepresentable<Content>(component: self)
    }
}

struct LegacyDrawerContentCollectionViewRepresentable<Content: View>: UIViewRepresentable {
    let component: LegacyDrawerContentCollectionView<Content>

    func makeUIView(context _: Context) -> LegacyDrawerContentCollectionView<Content> { component }

    func updateUIView(_ uiView: LegacyDrawerContentCollectionView<Content>, context _: Context) {
        uiView.content = component.content
        uiView.shouldBeginDragging = component.shouldBeginDragging
        uiView.onDraggingEnded = component.onDraggingEnded
        uiView.onDecelaratingEnded = component.onDecelaratingEnded
        uiView.onDidScroll = component.onDidScroll
        uiView.onDidResetContentOffset = component.onDidResetContentOffset

        if uiView.contentHeight != component.contentHeight {
            uiView.contentHeight = component.contentHeight
            uiView.collectionViewLayout.invalidateLayout()
        }
    }
}
