//
//  File.swift
//  
//
//  Created by Matěj Kašpar Jirásek on 10/07/2019.
//

import CellKit

public protocol EquatableCellModel: CellModel {
    func isEqual(to other: CellModel) -> Bool
}

extension EquatableCellModel {
    func asEquatable() -> EquatableCellModelWrapper {
        return EquatableCellModelWrapper(self)
    }
}

extension EquatableCellModel where Self: Equatable {
    public func isEqual(to other: CellModel) -> Bool {
        guard let otherCellModel = other as? Self else { return false }
        return self == otherCellModel
    }
}

struct EquatableCellModelWrapper {
    let cellModel: EquatableCellModel

    init(_ cellModel: EquatableCellModel) {
        self.cellModel = cellModel
    }
}

extension EquatableCellModelWrapper: Equatable {
    static func ==(lhs: EquatableCellModelWrapper, rhs: EquatableCellModelWrapper) -> Bool {
        return lhs.cellModel.isEqual(to: rhs.cellModel)
    }
}
