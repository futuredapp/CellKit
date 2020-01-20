import Foundation

public typealias CellModelSection = GenericCellModelSection<CellModel>

public struct GenericCellModelSection<Cell>: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Cell

    public var cells: [Cell]
    public var headerView: SupplementaryViewModel?
    public var footerView: SupplementaryViewModel?
    public let identifier: String

    public init(cells: [Cell] = [], headerView: SupplementaryViewModel? = nil, footerView: SupplementaryViewModel? = nil, identifier: String = "") {
        self.cells = cells
        self.headerView = headerView
        self.footerView = footerView
        self.identifier = identifier
    }

    public init(arrayLiteral elements: Cell...) {
        self.init(cells: elements)
    }

    public var isEmpty: Bool {
        return cells.isEmpty
    }
}

extension GenericCellModelSection: Equatable {
    public static func == (lhs: GenericCellModelSection<Cell>, rhs: GenericCellModelSection<Cell>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
