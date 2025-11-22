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
                safeAreaBottom: positionCalculator.safeAreaInsets.bottom,
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
                safeAreaBottom: positionCalculator.safeAreaInsets.bottom,
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

    /// The value returned by this function controls if the `UICollectionView`, which is embedded in the `Drawer`,
    /// should accept drag gestures based on its content offset, the current drag gesture and the `DrawerState`.
    /// If the drawer is closed or partially opened, the gesture is never consumed by the `UICollectionView, as scrolling its content should only be possible when the drawer is fully opened.
    private func shouldContentBeginDragging(verticalContentOffset: Double, verticalTranslation: Double) -> Bool {
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
        // swiftlint:disable superfluous_else
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
        // swiftlint:enable superfluous_else
    }

    private func onContentDraggingEnded(willDecelerate: Bool) {
        if !willDecelerate {
            isDragGestureEnabled = true
        }
    }

    private func onContentDecelaratingEnded() {
        isDragGestureEnabled = true
    }

    private func onContentDidScroll(verticalContentOffset: Double) {
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
