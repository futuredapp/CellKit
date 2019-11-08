//
//  TableViewHeaderViewModel.swift
//  SmallAlarmClient
//
//  Created by Adam Leitgeb on 23/04/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation
import UIKit.UIView
import CellKit

struct PhonesHeaderModel {
    let title: String
}

extension PhonesHeaderModel: SupplementaryViewModel, CellConvertible {
    typealias Cell = PhonesHeader

    var height: Double {
        return 50
    }
}
