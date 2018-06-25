//
//  CellModelDataSource.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit

public protocol CellModelDataSourceDelegate: class {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath)
}

public class CellModelDataSource: AbstractDataSource, DataSource {

    public var sections: [CellModelSection]

    public var first: CellModelSection? {
        return sections.first
    }

    public init(_ sections: [CellModelSection]) {
        self.sections = sections
    }

    public subscript(index: Int) -> CellModelSection {
        return sections[index]
    }

    public override func numberOfSections() -> Int {
        return sections.count
    }

    public override func cellModels(in section: Int) -> [CellModel] {
        return sections[section].cells
    }

    public override func header(in section: Int) -> SupplementaryViewModel? {
        return sections[section].headerView
    }

    public override func footer(in section: Int) -> SupplementaryViewModel? {
        return sections[section].footerView
    }

    public override func cellModel(at indexPath: IndexPath) -> CellModel {
        return sections[indexPath.section].cells[indexPath.row]
    }
}
