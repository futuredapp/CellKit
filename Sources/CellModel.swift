//
//  CellModel.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import struct UIKit.CGFloat

public protocol CellModel {
    var cellClass: AnyClass { get }
    var reuseIdentifier: String { get }

    var cellHeight: CGFloat { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }
    var hashableElement: AnyHashable? { get }

    func configure(cell: AnyObject)
}

public protocol EquatableCellModel: CellModel {
    func asEquatable() -> AnyEquatableCellModel
    func isEqualTo(_ other: CellModel) -> Bool
}

extension EquatableCellModel where Self: Equatable {
    public func asEquatable() -> AnyEquatableCellModel {
        return AnyEquatableCellModel(self)
    }

    public func isEqualTo(_ other: CellModel) -> Bool {
        guard let otherCellModel = other as? Self else { return false }
        return self == otherCellModel
    }
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

    var hashableElement: AnyHashable? {
        return nil
    }
}

public protocol SupplementaryViewModel: CellModel {
    var height: CGFloat { get }
}

public struct AnyEquatableCellModel {
    public var cellModel: EquatableCellModel

    init(_ cellModel: EquatableCellModel) {
        self.cellModel = cellModel
    }
}

extension AnyEquatableCellModel: Equatable {
    public static func ==(lhs: AnyEquatableCellModel, rhs: AnyEquatableCellModel) -> Bool {
        return lhs.cellModel.isEqualTo(rhs.cellModel)
    }
}
