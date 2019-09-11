//
//  File.swift
//  
//
//  Created by Matěj Kašpar Jirásek on 10/07/2019.
//

import DifferenceKit
#if SWIFT_PACKAGE
import CellKit
#endif

public protocol DifferentiableCellModel: CellModel {
    func isEqual(to other: CellModel) -> Bool
    func hash() -> Int
}

extension DifferentiableCellModel {
    func asEquatable() -> DifferentiableCellModelWrapper {
        return DifferentiableCellModelWrapper(self)
    }
}

extension DifferentiableCellModel where Self: Hashable {
    public func isEqual(to other: CellModel) -> Bool {
        guard let otherCellModel = other as? Self else {
            return false
        }
        return self == otherCellModel
    }

    public func hash() -> Int {
        return self.hashValue
    }
}

struct DifferentiableCellModelWrapper {
    let cellModel: DifferentiableCellModel

    init(_ cellModel: DifferentiableCellModel) {
        self.cellModel = cellModel
    }
}

extension DifferentiableCellModelWrapper: Hashable, Differentiable {
    static func == (lhs: DifferentiableCellModelWrapper, rhs: DifferentiableCellModelWrapper) -> Bool {
        return lhs.cellModel.isEqual(to: rhs.cellModel)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cellModel.hash())
    }
}
