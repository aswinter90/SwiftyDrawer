import Foundation
import SwiftUI

extension Drawer {
    @ViewBuilder
    func contentContainer(content: some View) -> some View {
        switch layoutStrategy {
        case .classic:
            LegacyDrawerContentCollectionView(
                content: content.readSize {
                    contentHeight = $0.height
                },
                contentHeight: contentHeight,
                shouldBeginDragging: shouldContentBeginDragging,
                onDraggingEnded: onContentDraggingEnded,
                onDecelaratingEnded: onContentDecelaratingEnded,
                onDidScroll: onContentDidScroll,
                onDidResetContentOffset: onDidResetContentOffset,
                drawerContentOffsetController: contentOffsetController
            )
            .swiftUIView()

        case .modern:
            DrawerContentCollectionView(
                content: content,
                shouldBeginDragging: shouldContentBeginDragging,
                onDraggingEnded: onContentDraggingEnded,
                onDecelaratingEnded: onContentDecelaratingEnded,
                onDidScroll: onContentDidScroll,
                onDidResetContentOffset: onDidResetContentOffset,
                drawerContentOffsetController: contentOffsetController
            )
            .swiftUIView()
        }
    }

    /// The value returned by this function controls if the `UICollectionView`, which is embedded in the `Drawer`, should accept drag gestures based on its content offset, the current drag gesture and the `DrawerState`.
    /// If the drawer is closed or partially opened, the gesture is never consumed by the `UICollectionView, as scrolling its content should only be possible when the drawer is fully opened.
    private func shouldContentBeginDragging(verticalContentOffset: CGFloat, verticalTranslation: CGFloat) -> Bool {
        // Content scrolling is only available on a fully opened drawer
        if state.case != .fullyOpened {
            isDragGestureEnabled = true
            return false
        }

        // User moves content up
        if verticalTranslation < 0 {
            isDragGestureEnabled = false
            return true
        }
        // User moves content down
        else {
            // ScrollView fully scrolled up, return false to redirect the gesture to the drawer
            if verticalContentOffset <= 0 {
                isDragGestureEnabled = true
                return false
            } else {
                isDragGestureEnabled = false
                return true
            }
        }
    }

    private func onContentDraggingEnded(willDecelerate: Bool) {
        if !willDecelerate {
            isDragGestureEnabled = true
        }
    }

    private func onContentDecelaratingEnded() {
        isDragGestureEnabled = true
    }

    private func onContentDidScroll(verticalContentOffset: CGFloat) {
        DispatchQueue.main.async {
            shouldElevateStickyHeader = verticalContentOffset > 0 && stickyHeaderHeight > 0
        }
    }

    private func onDidResetContentOffset() {
        DispatchQueue.main.async {
            shouldElevateStickyHeader = false
        }
    }
}
