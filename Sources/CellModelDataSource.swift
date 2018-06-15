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

public class CellModelDataSource: NSObject {

    public var sections: [CellModelSection]
    private(set) var configure: (Any, Any) -> Void

    public weak var delegate: CellModelDataSourceDelegate?

    public var first: CellModelSection? {
        return sections.first
    }

    public init(_ sections: [CellModelSection], configure: @escaping (Any, Any) -> Void) {
        self.sections = sections
        self.configure = configure
    }

    subscript(index: Int) -> CellModelSection {
        return sections[index]
    }
}

extension CellModelDataSource: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        configure(cell, item.model())
        return cell
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].cells[indexPath.row].highlighting
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let item = sections[section].headerView, let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: item.reuseIdentifier) {
            configure(header, item.model())
            return header
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerView?.height ?? CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let item = sections[section].footerView, let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: item.reuseIdentifier) {
            configure(footer, item.model())
            return footer
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerView?.height ?? CGFloat.leastNonzeroMagnitude
    }
}

extension CellModelDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].cellHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = sections[indexPath.section].cells[indexPath.row] as? CellModelSelectable {
            cellModel.didSelect()
        } else {
            delegate?.didSelectCellModel(sections[indexPath.section].cells[indexPath.row], at: indexPath)
        }
    }
}

extension CellModelDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)

        configure(cell, item.model())
        return cell
    }
}

extension CellModelDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCellModel(sections[indexPath.section].cells[indexPath.row], at: indexPath)
    }
}
