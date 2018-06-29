//
//  DeviceAndroidCellModel.swift
//  Example
//
//  Created by Petr Zvoníček on 22.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

struct DeviceAndroidCellModel: Equatable {
    let name: String
}

extension DeviceAndroidCellModel: CellConvertible, EquatableCellModel {
    typealias Cell = DeviceAndroidCell

    var cellHeight: CGFloat {
        return 60.0
    }
}

extension DeviceAndroidCellModel: CellModelSelectable {
    func didSelect() {
        print("Did select \(self.name)")
    }
}
