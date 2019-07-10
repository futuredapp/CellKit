//
//  CellModelManager.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit
import Dwifft

public typealias EquatableCellModelSection = GenericCellModelSection<EquatableCellModel>

open class EquatableCellModelDataSource: AbstractDataSource, DataSource {

    public var sections: [EquatableCellModelSection] {
        get {
            return diffCalculator.sectionedValues.sectionsAndValues.map { $0.0 }
        }
        set {
            diffCalculator.sectionedValues = SectionedValues(newValue.map { ($0, $0.cells.map { $0.asEquatable() }) })
        }
    }

    let diffCalculator: AbstractDiffCalculator<EquatableCellModelSection, EquatableCellModelWrapper>

    public init(_ tableView: UITableView, sections: [EquatableCellModelSection]) {
        self.diffCalculator = TableViewDiffCalculator(tableView: tableView)
        super.init()

        self.sections = sections
    }

    public init(_ collectionView: UICollectionView, sections: [EquatableCellModelSection]) {
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView)
        super.init()

        self.sections = sections
    }

    public subscript(index: Int) -> EquatableCellModelSection {
        return diffCalculator.value(forSection: index)
    }

    override open func numberOfSections() -> Int {
        return self.diffCalculator.numberOfSections()
    }

    override open func cellModels(in section: Int) -> [CellModel] {
        return self.diffCalculator.value(forSection: section).cells
    }

    override open func header(in section: Int) -> SupplementaryViewModel? {
        return self.diffCalculator.value(forSection: section).headerView
    }

    override open func footer(in section: Int) -> SupplementaryViewModel? {
        return self.diffCalculator.value(forSection: section).footerView
    }

    override open func cellModel(at indexPath: IndexPath) -> CellModel {
        return self.diffCalculator.value(atIndexPath: indexPath).cellModel
    }
}
