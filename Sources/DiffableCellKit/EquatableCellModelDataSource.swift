//
//  CellModelManager.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import DifferenceKit
#if SWIFT_PACKAGE
import CellKit
#endif

public typealias DifferentiableCellModelSection = GenericCellModelSection<DifferentiableCellModel>

private typealias DiffSection = ArraySection<String, DifferentiableCellModelWrapper>
private extension DifferentiableCellModelSection {
    var arraySection: DiffSection {
        return DiffSection(model: identifier, elements: cells.map(DifferentiableCellModelWrapper.init))
    }
}

extension String: Differentiable { }

open class EquatableCellModelDataSource: AbstractDataSource, DataSource {

    private enum Container {
        case table(UITableView)
        case collection(UICollectionView)

        func reload<C>( using stagedChangeset: StagedChangeset<C>, setData: (C) -> Void) {
            switch self {
            case .table(let table):
                table.reload(using: stagedChangeset, with: .automatic, setData: setData)
            case .collection(let collection):
                collection.reload(using: stagedChangeset, setData: setData)
            }
        }
    }


    private let container: Container

    private var _sections: [DifferentiableCellModelSection]
    public var sections: [DifferentiableCellModelSection] {
        get {
            return _sections
        }
        set {
            let oldSection = _sections.map { $0.arraySection }
            let newSection = newValue.map { $0.arraySection }
            let stagedSet = StagedChangeset(source: oldSection, target: newSection)
            container.reload(using: stagedSet) { _ in
                _sections = newValue
            }
        }
    }


    public init(_ tableView: UITableView, sections: [DifferentiableCellModelSection]) {
        container = .table(tableView)
        _sections = []
        super.init()

        self.sections = sections
    }

    public init(_ collectionView: UICollectionView, sections: [DifferentiableCellModelSection]) {
        container = .collection(collectionView)
        _sections = []
        super.init()

        self.sections = sections
    }

    public subscript(index: Int) -> DifferentiableCellModelSection {
        return sections[index]
    }
}
