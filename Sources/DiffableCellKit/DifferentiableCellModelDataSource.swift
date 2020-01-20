import UIKit
import DifferenceKit
#if SWIFT_PACKAGE
import CellKit
#endif

open class DifferentiableCellModelDataSource: AbstractDataSource, DataSource {

    private enum Container {
        case table(UITableView)
        case collection(UICollectionView)

        func reload<C>( using stagedChangeset: StagedChangeset<C>, setData: (C) -> Void) {
            switch self {
            case .table(let table):
                table.reload(using: stagedChangeset, with: .automatic, setData: setData)
            case .collection(let collection):
                collection.reload(using: stagedChangeset, setData: setData)
            }
        }
    }

    private let container: Container

    private var _sections: [DifferentiableCellModelSection]
    public var sections: [DifferentiableCellModelSection] {
        get {
            return _sections
        }
        set {
            let oldSection = _sections.map { $0.arraySection }
            let newSection = newValue.map { $0.arraySection }
            let stagedSet = StagedChangeset(source: oldSection, target: newSection)
            container.reload(using: stagedSet) { data in
                let sections = data.map { DifferentiableCellModelSection(cells: $0.elements.map { $0.cellModel }, headerView: $0.model.headerView, footerView: $0.model.footerView, identifier: $0.model.identifier) }
                _sections = sections
            }
        }
    }

    public init(_ tableView: UITableView, sections: [DifferentiableCellModelSection]) {
        container = .table(tableView)
        _sections = []
        super.init()

        self.sections = sections
    }

    public init(_ collectionView: UICollectionView, sections: [DifferentiableCellModelSection]) {
        container = .collection(collectionView)
        _sections = []
        super.init()

        self.sections = sections
    }

    public subscript(index: Int) -> DifferentiableCellModelSection {
        return sections[index]
    }

    override open func numberOfSections() -> Int {
        return sections.count
    }

    override open func cellModels(in section: Int) -> [CellModel] {
        return sections[section].cells
    }

    override open func header(in section: Int) -> SupplementaryViewModel? {
        return sections[section].headerView
    }

    override open func footer(in section: Int) -> SupplementaryViewModel? {
        return sections[section].footerView
    }

    override open func cellModel(at indexPath: IndexPath) -> CellModel {
        return sections[indexPath.section].cells[indexPath.row]
    }
}
