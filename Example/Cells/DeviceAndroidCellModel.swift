//
//  DeviceAndroidCellModel.swift
//  Example
//
//  Created by Petr Zvoníček on 22.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

struct DeviceAndroidCellModel: CellConvertible, EquatableCellModel, Equatable {
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
