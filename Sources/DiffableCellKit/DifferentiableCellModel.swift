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

/// Support for determining whether cell model belongs to a certain cell, whether cell should be inserted, removed, updated or moved.
public protocol DifferentiableCellModel: CellModel {

    /// Identifier of a cell model inside it's own domain determined by reusable identifier. Assuming model is already presented inside a view, changing of this value will result in it's removal and insertion into the view.
    var domainIndentifier: Int { get }

    /// This method return true, whenever content of a view model is equal to content of other view model within it's domain. However, argument may contain view model from different domain. If cell model conforms to protocol Equatable, default implementation is provided.
    /// - Parameter other: other cell model to compare with - DO NOT FORGET to cast this argument to your view model's type
    func hasEqualContent(with other: CellModel) -> Bool
}

extension DifferentiableCellModel {
    func asDifferentaibleWrapper() -> DifferentiableCellModelWrapper {
        return DifferentiableCellModelWrapper(cellModel: self)
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
}

extension DifferentiableCellModelWrapper: Equatable, Differentiable {
    static func == (lhs: DifferentiableCellModelWrapper, rhs: DifferentiableCellModelWrapper) -> Bool {
        return lhs.cellModel.hasEqualContent(with: rhs.cellModel)
    }

    var differenceIdentifier: String {
        return "\(cellModel.reuseIdentifier)<.>\(cellModel.domainIndentifier)"
    }
}
