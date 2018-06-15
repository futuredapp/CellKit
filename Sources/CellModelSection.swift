//
//  CellModelSection.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import Foundation

public class CellModelSection: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = EquatableCellModel

    let cells: [EquatableCellModel]
    let headerView: SupplementaryViewModel?
    let footerView: SupplementaryViewModel?
    let identifier: String

    init(cells: [EquatableCellModel] = [], headerView: SupplementaryViewModel? = nil, footerView: SupplementaryViewModel? = nil, identifier: String = "") {
        self.cells = cells
        self.headerView = headerView
        self.footerView = footerView
        self.identifier = identifier
    }

    public convenience required init(arrayLiteral elements: EquatableCellModel...) {
        self.init(cells: elements)
    }

    var isEmpty: Bool {
        return cells.isEmpty
    }
}

