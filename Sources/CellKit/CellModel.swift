public protocol CellModel: ReusableView {
    var cellHeight: Double { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }

    func configure(cell: AnyObject)
}

public extension CellModel {
    var cellHeight: Double {
        return 44.0
    }

    var highlighting: Bool {
        return true
    }

    var separatorIsHidden: Bool {
        return false
    }
}

public protocol SupplementaryViewModel: ReusableView {
    var height: Double { get }

    func configure(cell: AnyObject)
}
