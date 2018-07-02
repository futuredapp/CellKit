//
//  CellKitDataSource.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 22.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit

public protocol DataSource {
    associatedtype Section

    var sections: [Section] { get }
    var delegate: CellModelDataSourceDelegate? { get }
    var firstSection: Section? { get }

    subscript(index: Int) -> Section { get }
}

open class AbstractDataSource: NSObject {

    internal override init() { }

    public weak var delegate: CellModelDataSourceDelegate?

    func numberOfSections() -> Int {
        fatalError("Needs to be overriden")
    }

    func cellModels(in section: Int) -> [CellModel] {
        fatalError("Needs to be overriden")
    }

    func header(in section: Int) -> SupplementaryViewModel? {
        fatalError("Needs to be overriden")
    }

    func footer(in section: Int) -> SupplementaryViewModel? {
        fatalError("Needs to be overriden")
    }

    func cellModel(at indexPath: IndexPath) -> CellModel {
        fatalError("Needs to be overriden")
    }
}

extension AbstractDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels(in: section).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cellModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cellModel(at: indexPath).highlighting
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let item = header(in: section), let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: item.reuseIdentifier) {
            item.configure(cell: header)
            return header
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return header(in: section)?.height ?? CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let item = footer(in: section), let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: item.reuseIdentifier) {
            item.configure(cell: footer)
            return footer
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footer(in: section)?.height ?? CGFloat.leastNonzeroMagnitude
    }
}


extension AbstractDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels(in: section).count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cellModel(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
}

extension AbstractDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellModel(at: indexPath).cellHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = cellModel(at: indexPath) as? CellModelSelectable {
            cellModel.didSelect()
        }

        delegate?.didSelectCellModel(cellModel(at: indexPath), at: indexPath)
    }
}

extension AbstractDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCellModel(cellModel(at: indexPath), at: indexPath)
    }
}
