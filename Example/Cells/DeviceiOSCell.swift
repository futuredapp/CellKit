//
//  DeviceiOSCell.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

class DeviceiOSCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension DeviceiOSCell: CellConfigurable {
    func configure(with model: DeviceiOSCellModel) {
        self.nameLabel.text = model.name
    }
}
