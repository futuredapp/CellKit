//
//  BlueCellModel.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

struct DeviceiOSCellModel: CellConvertible, EquatableCellModel, Equatable {
    typealias Cell = DeviceiOSCell

    let name: String
    let cellHeight: CGFloat = 60.0
    let registersLazily: Bool = false
}

extension DeviceiOSCellModel: CellModelSelectable {
    func didSelect() {
        print("Did select \(self.name)")
    }
}
