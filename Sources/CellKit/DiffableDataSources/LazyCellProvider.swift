import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public final class LazyCellProvider {
    private var registeredIdentifiers: Set<String>

    public init() {
        registeredIdentifiers = []
    }

    public func provide<Item: CellModel>(collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        if !registeredIdentifiers.contains(item.reuseIdentifier) {
            register(model: item, to: collectionView)
            registeredIdentifiers.insert(item.reuseIdentifier)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    public func provide<Item: CellModel>(tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? {
        if !registeredIdentifiers.contains(item.reuseIdentifier) {
            register(model: item, to: tableView)
            registeredIdentifiers.insert(item.reuseIdentifier)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    func register(model: CellModel, to collectionView: UICollectionView) {
        if model.usesNib, let nib = model.nib {
            collectionView.register(nib, forCellWithReuseIdentifier: model.reuseIdentifier)
        } else {
            collectionView.register(model.cellClass, forCellWithReuseIdentifier: model.reuseIdentifier)
        }
    }

    func register(model: CellModel, to tableView: UITableView) {
        if model.usesNib, let nib = model.nib {
            tableView.register(nib, forCellReuseIdentifier: model.reuseIdentifier)
        } else {
            tableView.register(model.cellClass, forCellReuseIdentifier: model.reuseIdentifier)
        }
    }
}
