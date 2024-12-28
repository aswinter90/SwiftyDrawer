public enum DrawerContentLayoutStrategy {
    /// Robust option which is based on an `UICollectionViewFlowLayout`, but animated content size-changes can look choppy.
    case classic

    /// Better adapts to animated size-changes by leveraging a `UICollectionViewCompositionalLayout`, but can show glitchy or jumpy behavior when swapping out content, e.g. in a typical transition from a list to a detail view.
    case modern
}
