//
//  DeviceAndroidCellModel.swift
//  Example
//
//  Created by Petr Zvoníček on 22.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit
import DiffableCellKit

struct DeviceAndroidCellModel: CellConvertible, DifferentiableCellModel {
    var domainIndentifier: Int {
        return name.hashValue
    }

    func hasEqualContent(with other: CellModel) -> Bool {
        guard let other = other as? DeviceAndroidCellModel else {
            return false
        }
        return other.name == self.name
    }

    typealias Cell = DeviceAndroidCell

    let name: String
    let cellHeight: CGFloat = 60.0
    let registersLazily: Bool = false
}

extension DeviceAndroidCellModel: CellModelSelectable {
    func didSelect() {
        print("Did select \(self.name)")
    }
}
