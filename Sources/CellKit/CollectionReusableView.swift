import UIKit

public final class CollectionReusableView: UICollectionReusableView, CellConfigurable {
    public func configure(with model: CollectionReusableViewModel) {
    }
}

public struct CollectionReusableViewModel: SupplementaryViewModel, CellConvertible {
    public typealias Cell = CollectionReusableView

    public var height: Double {
        0.0
    }

    public var usesNib: Bool {
        false
    }
}
