import struct Foundation.IndexPath

public protocol CellModelDataSourceDelegate: AnyObject {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath)
}

open class CellModelDataSource: AbstractDataSource, DataSource {

    public var sections: [CellModelSection]

    override public init() {
        self.sections = []
        super.init()
    }

    public init(_ sections: [CellModelSection]) {
        self.sections = sections
    }

    public subscript(index: Int) -> CellModelSection {
        sections[index]
    }

    override open func numberOfSections() -> Int {
        sections.count
    }

    override open func cellModels(in section: Int) -> [CellModel] {
        sections[section].cells
    }

    override open func header(in section: Int) -> SupplementaryViewModel? {
        sections[section].headerView
    }

    override open func footer(in section: Int) -> SupplementaryViewModel? {
        sections[section].footerView
    }

    override open func cellModel(at indexPath: IndexPath) -> CellModel {
        sections[indexPath.section].cells[indexPath.row]
    }
}
