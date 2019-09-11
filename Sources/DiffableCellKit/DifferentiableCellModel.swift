//
//  DifferentiableCellModel.swift
//
//
//  Created by Matěj Kašpar Jirásek on 10/07/2019.
//

import DifferenceKit
#if SWIFT_PACKAGE
import CellKit
#endif

public protocol DifferentiableCellModel: CellModel {
    var domainIndentifier: Int { get }

    func hasEqualContent(with other: CellModel) -> Bool
}

extension DifferentiableCellModel {
    func asDifferentaibleBox() -> DifferentiableCellModelWrapper {
        return DifferentiableCellModelWrapper(self)
    }
}

extension DifferentiableCellModel where Self: Equatable {
    public func hasEqualContent(with other: CellModel) -> Bool {
        guard let otherCellModel = other as? Self else {
            return false
        }
        return self == otherCellModel
    }
}

struct DifferentiableCellModelWrapper {
    let cellModel: DifferentiableCellModel

    init(_ cellModel: DifferentiableCellModel) {
        self.cellModel = cellModel
    }
}

extension DifferentiableCellModelWrapper: Equatable, Differentiable {
    static func == (lhs: DifferentiableCellModelWrapper, rhs: DifferentiableCellModelWrapper) -> Bool {
        return lhs.cellModel.hasEqualContent(with: rhs.cellModel)
    }

    var differenceIdentifier: String {
        return "\(cellModel.reuseIdentifier)<.>\(cellModel.domainIndentifier)"
    }
}
