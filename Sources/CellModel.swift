//
//  CellModel.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import struct UIKit.CGFloat
import class Foundation.Bundle
import class UIKit.UINib

public protocol CellModel: ReusableView {
    var cellHeight: CGFloat { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }

    func configure(cell: AnyObject)
}

public extension CellModel {
    var cellHeight: CGFloat {
        return 44
    }

    var highlighting: Bool {
        return true
    }

    var separatorIsHidden: Bool {
        return false
    }
}

public protocol SupplementaryViewModel: ReusableView {
    var height: CGFloat { get }

    func configure(cell: AnyObject)
}

public protocol EquatableCellModel: CellModel {
    func isEqualTo(_ other: CellModel) -> Bool
}

extension EquatableCellModel {
    func asEquatable() -> AnyEquatableCellModel {
        return AnyEquatableCellModel(self)
    }
}

extension EquatableCellModel where Self: Equatable {
    public func isEqualTo(_ other: CellModel) -> Bool {
        guard let otherCellModel = other as? Self else { return false }
        return self == otherCellModel
    }
}

struct AnyEquatableCellModel {
    let cellModel: EquatableCellModel

    init(_ cellModel: EquatableCellModel) {
        self.cellModel = cellModel
    }
}

extension AnyEquatableCellModel: Equatable {
    static func ==(lhs: AnyEquatableCellModel, rhs: AnyEquatableCellModel) -> Bool {
        return lhs.cellModel.isEqualTo(rhs.cellModel)
    }
}
