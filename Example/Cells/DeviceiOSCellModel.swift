//
//  BlueCellModel.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

struct DeviceiOSCellModel: Equatable {
    let name: String
}

extension DeviceiOSCellModel: EquatableCellModel {
    func cellType() -> UIView.Type {
        return DeviceiOSCell.self
    }

    var cellHeight: CGFloat {
        return 60.0
    }
}

extension DeviceiOSCellModel: CellModelSelectable {
    func didSelect() {
        print("Did select \(self.name)")
    }
}
