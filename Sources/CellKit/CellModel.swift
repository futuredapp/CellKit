public protocol CellModel: ReusableView {
    var cellHeight: Double { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }

    func configure(cell: AnyObject)
}

public extension CellModel {
    var cellHeight: Double {
        44.0
    }

    var highlighting: Bool {
        true
    }

    var separatorIsHidden: Bool {
        false
    }
}

public protocol SupplementaryViewModel: ReusableView {
    var height: Double { get }

    func configure(cell: AnyObject)
}
