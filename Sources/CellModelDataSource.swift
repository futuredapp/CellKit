//
//  CellModelDataSource.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import struct Foundation.IndexPath

public protocol CellModelDataSourceDelegate: class {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath)
}

open class CellModelDataSource: AbstractDataSource, DataSource {

    public var sections: [CellModelSection]

    public override init() {
        self.sections = []
    }

    public init(_ sections: [CellModelSection]) {
        self.sections = sections
    }

    public subscript(index: Int) -> CellModelSection {
        return sections[index]
    }

    override func numberOfSections() -> Int {
        return sections.count
    }

    override func cellModels(in section: Int) -> [CellModel] {
        return sections[section].cells
    }

    override func header(in section: Int) -> SupplementaryViewModel? {
        return sections[section].headerView
    }

    override func footer(in section: Int) -> SupplementaryViewModel? {
        return sections[section].footerView
    }

    override func cellModel(at indexPath: IndexPath) -> CellModel {
        return sections[indexPath.section].cells[indexPath.row]
    }
}
