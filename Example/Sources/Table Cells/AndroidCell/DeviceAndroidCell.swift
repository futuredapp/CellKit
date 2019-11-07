//
//  DeviceAndroidCell.swift
//  Example
//
//  Created by Petr Zvoníček on 22.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

final class DeviceAndroidCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension DeviceAndroidCell: CellConfigurable {
    func configure(with model: DeviceAndroidCellModel) {
        self.nameLabel.text = model.name + " tapped: \(model.numberOfTaps)"
    }
}
