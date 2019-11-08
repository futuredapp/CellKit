//
//  PhonesHeader.swift
//  SmallAlarmClient
//
//  Created by Adam Leitgeb on 23/04/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import UIKit
import CellKit

class PhonesHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleLabel: UILabel!
}

extension PhonesHeader: CellConfigurable {
    func configure(with model: PhonesHeaderModel) {
        titleLabel.text = model.title
    }
}
