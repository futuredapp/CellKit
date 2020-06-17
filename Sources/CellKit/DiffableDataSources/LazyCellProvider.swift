import UIKit

public final class LazyCellProvider {
    private var registeredIdentifiers: Set<String>

    public init() {
        registeredIdentifiers = []
    }

    public func provide<Item: CellModel>(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        if !registeredIdentifiers.contains(item.reuseIdentifier) {
            collectionView.register(item.cellClass, forCellWithReuseIdentifier: item.reuseIdentifier)
            registeredIdentifiers.insert(item.reuseIdentifier)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
}
