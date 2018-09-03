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
    var cellWidth: CGFloat? { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }

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

    var cellWidth: CGFloat {
        return nil
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

public struct AnyEquatableCellModel: EquatableCellModel {
    public var cellModel: EquatableCellModel

    // MARK: - Reusable view properties

    public var registersLazily: Bool {
        return cellModel.registersLazily
    }

    public var usesNib: Bool {
        return cellModel.usesNib
    }

    public var bundle: Bundle {
        return cellModel.bundle
    }

    public var nib: UINib? {
        return cellModel.nib
    }

    public var cellClass: AnyClass {
        return cellModel.cellClass
    }

    public var reuseIdentifier: String {
        return cellModel.reuseIdentifier
    }

    // MARK: - Cell model properties

    public var cellHeight: CGFloat {
        return cellModel.cellHeight
    }

    public var highlighting: Bool {
        return cellModel.highlighting
    }

    public var separatorIsHidden: Bool {
        return cellModel.separatorIsHidden
    }

    init(_ cellModel: EquatableCellModel) {
        self.cellModel = cellModel
    }

    public func configure(cell: AnyObject) {
        cellModel.configure(cell: cell)
    }
}

extension AnyEquatableCellModel: Equatable {
    public static func ==(lhs: AnyEquatableCellModel, rhs: AnyEquatableCellModel) -> Bool {
        return lhs.cellModel.isEqualTo(rhs.cellModel)
    }
}
