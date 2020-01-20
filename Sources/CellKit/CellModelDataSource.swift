import struct Foundation.IndexPath

public protocol CellModelDataSourceDelegate: class {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath)
}

open class CellModelDataSource: AbstractDataSource, DataSource {

    public var sections: [CellModelSection]

    public override init() {
        self.sections = []
        super.init()
    }

    public init(_ sections: [CellModelSection]) {
        self.sections = sections
    }

    public subscript(index: Int) -> CellModelSection {
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
