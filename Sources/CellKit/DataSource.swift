import UIKit

public protocol DataSource {
    associatedtype Section

    var sections: [Section] { get }
    var delegate: CellModelDataSourceDelegate? { get }

    subscript(index: Int) -> Section { get }
}

open class AbstractDataSource: NSObject {

    public weak var delegate: CellModelDataSourceDelegate?

    public var registersCellsLazily: Bool = true
    private var registeredCellReuseIdentifiers: Set<String> = []
    private var registeredSupplementaryViewIdentifiers: Set<String> = []

    open func numberOfSections() -> Int {
        fatalError("Needs to be overridden")
    }

    open func cellModels(in section: Int) -> [CellModel] {
        fatalError("Needs to be overridden")
    }

    open func header(in section: Int) -> SupplementaryViewModel? {
        fatalError("Needs to be overridden")
    }

    open func footer(in section: Int) -> SupplementaryViewModel? {
        fatalError("Needs to be overridden")
    }

    open func cellModel(at indexPath: IndexPath) -> CellModel {
        fatalError("Needs to be overridden")
    }

    private func registerLazily(cellModel: CellModel, to tableView: UITableView) {
        guard registersCellsLazily, cellModel.registersLazily, !registeredCellReuseIdentifiers.contains(cellModel.reuseIdentifier) else {
            return
        }

        if cellModel.usesNib, let nib = cellModel.nib {
            tableView.register(nib, forCellReuseIdentifier: cellModel.reuseIdentifier)
        } else {
            tableView.register(cellModel.cellClass, forCellReuseIdentifier: cellModel.reuseIdentifier)
        }
        registeredCellReuseIdentifiers.insert(cellModel.reuseIdentifier)
    }

    private func registerLazily(cellModel: CellModel, to collectionView: UICollectionView) {
        guard registersCellsLazily, cellModel.registersLazily, !registeredCellReuseIdentifiers.contains(cellModel.reuseIdentifier) else {
            return
        }

        if cellModel.usesNib, let nib = cellModel.nib {
            collectionView.register(nib, forCellWithReuseIdentifier: cellModel.reuseIdentifier)
        } else {
            collectionView.register(cellModel.cellClass, forCellWithReuseIdentifier: cellModel.reuseIdentifier)
        }
        registeredCellReuseIdentifiers.insert(cellModel.reuseIdentifier)
    }

    private func registerLazily(headerFooter: SupplementaryViewModel, to tableView: UITableView) {
        guard registersCellsLazily, headerFooter.registersLazily, !registeredSupplementaryViewIdentifiers.contains(headerFooter.reuseIdentifier) else {
            return
        }

        if headerFooter.usesNib, let nib = headerFooter.nib {
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
        } else {
            tableView.register(headerFooter.cellClass, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
        }
        registeredSupplementaryViewIdentifiers.insert(headerFooter.reuseIdentifier)
    }

    private func registerLazily(supplementaryView: SupplementaryViewModel, kind: String, to collectionView: UICollectionView) {
        guard registersCellsLazily, supplementaryView.registersLazily, !registeredSupplementaryViewIdentifiers.contains(supplementaryView.reuseIdentifier) else {
            return
        }

        let joinedReuseIdentifier = kind + supplementaryView.reuseIdentifier

        if supplementaryView.usesNib, let nib = supplementaryView.nib {
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: joinedReuseIdentifier)
        } else {
            collectionView.register(supplementaryView.cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: joinedReuseIdentifier)
        }
        registeredSupplementaryViewIdentifiers.insert(joinedReuseIdentifier)
    }

    private func supplementaryViewModel(indexPath: IndexPath, kind: String) -> SupplementaryViewModel? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return header(in: indexPath.section)
        case UICollectionView.elementKindSectionFooter:
            return footer(in: indexPath.section)
        default:
            return nil
        }
    }

    private func view(for headerFooter: SupplementaryViewModel?, in tableView: UITableView) -> UIView? {
        guard let headerFooter = headerFooter else {
            return nil
        }
        registerLazily(headerFooter: headerFooter, to: tableView)
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooter.reuseIdentifier) else {
            return nil
        }
        return header
    }

    private func view(for supplementaryViewModel: SupplementaryViewModel?, kind: String, at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionReusableView? {
        guard let supplementaryViewModel = supplementaryViewModel else {
            return nil
        }
        registerLazily(supplementaryView: supplementaryViewModel, kind: kind, to: collectionView)
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind + supplementaryViewModel.reuseIdentifier, for: indexPath)
    }
}

extension AbstractDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels(in: section).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cellModel(at: indexPath)
        registerLazily(cellModel: item, to: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        cellModel(at: indexPath).highlighting
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = header(in: section)
        let headerView = view(for: model, in: tableView)
        headerView.flatMap { model?.configure(cell: $0) }
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = header(in: section)?.height
        return height.flatMap { CGFloat($0) }  ?? CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = footer(in: section)
        let footerView = view(for: model, in: tableView)
        footerView.flatMap { model?.configure(cell: $0) }
        return footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = footer(in: section)?.height
        return height.flatMap { CGFloat($0) }  ?? CGFloat.leastNonzeroMagnitude
    }
}

extension AbstractDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModels(in: section).count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cellModel(at: indexPath)
        registerLazily(cellModel: item, to: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewModel = supplementaryViewModel(indexPath: indexPath, kind: kind)
        guard let reusableView = view(for: viewModel, kind: kind, at: indexPath, in: collectionView) ?? view(for: CollectionReusableViewModel(), kind: kind, at: indexPath, in: collectionView) else {
            fatalError("No supplementary view can be reused")
        }
        viewModel?.configure(cell: reusableView)
        return reusableView
    }
}

extension AbstractDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(cellModel(at: indexPath).cellHeight)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = cellModel(at: indexPath) as? CellModelSelectable {
            cellModel.didSelect()
        }

        delegate?.didSelectCellModel(cellModel(at: indexPath), at: indexPath)
    }
}

extension AbstractDataSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCellModel(cellModel(at: indexPath), at: indexPath)
    }
}
