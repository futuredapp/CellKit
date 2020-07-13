//
//  CellConvertible.swift
public typealias ReusableCellConvertible = CellConvertible & ReusableView

public protocol CellConvertible {
    associatedtype Cell: CellConfigurable
}

public extension CellConvertible {
    var cellClass: AnyClass {
        Cell.self
    }
    var reuseIdentifier: String {
        String(describing: Cell.self)
    }
}

public extension CellConvertible where Self == Cell.Model {
    func configure(cell: AnyObject) {
        if let cell = cell as? Cell {
            cell.configure(with: self)
        } else {
            assertionFailure("Wrong cell type \(type(of: cell)) provided for configuration to \(type(of: self))'!")
        }
    }
}
