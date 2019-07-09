//
//  CellModel.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

public protocol CellModel: ReusableView {
    var cellHeight: Double { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }

    func configure(cell: AnyObject)
}

public extension CellModel {
    var cellHeight: Double {
        return 44.0
    }

    var highlighting: Bool {
        return true
    }

    var separatorIsHidden: Bool {
        return false
    }
}

public protocol SupplementaryViewModel: ReusableView {
    var height: Double { get }

    func configure(cell: AnyObject)
}

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
