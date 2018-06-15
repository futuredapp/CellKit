//
//  CellModel.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit

public protocol CellModel: CellConvertible {
    var cellHeight: CGFloat { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }
    var hashableElement: AnyHashable? { get }
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
        guard let otherFruit = other as? Self else { return false }
        return self == otherFruit
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

public protocol SupplementaryViewModel: CellConvertible {
    var height: CGFloat { get }
}

public struct AnyEquatableCellModel: EquatableCellModel {
    var cellModel: CellModel

    public var cellHeight: CGFloat {
        return cellModel.cellHeight
    }
    public var highlighting: Bool {
        return cellModel.highlighting
    }
    public var separatorIsHidden: Bool {
        return cellModel.separatorIsHidden
    }
    public var hashableElement: AnyHashable? {
        return cellModel.hashableElement
    }

    init(_ cellModel: CellModel) {
        self.cellModel = cellModel
    }

    public func cellType() -> UIView.Type {
        return cellModel.cellType()
    }
}

extension AnyEquatableCellModel: Equatable {
    public static func ==(lhs: AnyEquatableCellModel, rhs: AnyEquatableCellModel) -> Bool {
        return lhs.isEqualTo(rhs)
    }
}
