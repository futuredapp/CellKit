//
//  NibTableViewCell.swift
//  Example
//
//  Created by Matěj Jirásek on 21/06/2018.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

struct NibTableViewCellModel: CellConvertible, EquatableCellModel, Equatable {
    typealias Cell = NibTableViewCell

    let text: String
    let cellHeight: CGFloat  = 170.0
}

final class NibTableViewCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var headerLabel: UILabel!

    func configure(with model: NibTableViewCellModel) {
        headerLabel.text = model.text
    }
}
