//
//  CellConvertible.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

public protocol CellConvertible: CellModel {
    associatedtype Cell: CellConfigurable
}

extension CellConvertible {
    static var cellType: AnyClass {
        return Cell.self
    }

    static var reuseIdentifier: String {
        return String(describing: Cell.self)
    }
}

extension CellConvertible where Self == Cell.Model {
    func configure(cell: AnyObject) {
        if let cell = cell as? Cell {
            cell.configure(with: self)
        } else {
            assertionFailure("Wrong cell type \(type(of: cell)) provided for configuration to \(type(of: self))'!")
        }
    }
}
