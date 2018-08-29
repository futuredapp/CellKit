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

    subscript(index: Int) -> Section { get }
}

open class AbstractDataSource: NSObject {

    internal override init() { }

    public weak var delegate: CellModelDataSourceDelegate?

    public var registersCellsLazily: Bool = true
    private var registeredCellReuseIdentifiers: Set<String> = []
    private var registeredHeaderFooterReuseIdentifiers: Set<String> = []

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

    private func registerLazily(cellModel: CellModel, to tableView: UITableView) {
        guard registersCellsLazily, cellModel.registersLazily, !registeredCellReuseIdentifiers.contains(cellModel.reuseIdentifier) else {
            return
        }

        if let nib = cellModel.nib {
            tableView.register(nib, forCellReuseIdentifier: cellModel.reuseIdentifier)
        } else {
            tableView.register(cellModel.cellClass, forCellReuseIdentifier: cellModel.reuseIdentifier)
        }
        registeredCellReuseIdentifiers.insert(cellModel.reuseIdentifier)
    }

    private func registerLazily(cellModel: CellModel, to collectionView: UICollectionView) {
        guard registersCellsLazily, cellModel.registersLazily, !registeredCellReuseIdentifiers.contains(cellModel.reuseIdentifier) else {
            return
        }

        if let nib = cellModel.nib {
            collectionView.register(nib, forCellWithReuseIdentifier: cellModel.reuseIdentifier)
        } else {
            collectionView.register(cellModel.cellClass, forCellWithReuseIdentifier: cellModel.reuseIdentifier)
        }
        collectionView.register(cellModel.cellClass, forCellWithReuseIdentifier: cellModel.reuseIdentifier)
        registeredCellReuseIdentifiers.insert(cellModel.reuseIdentifier)
    }

    private func registerLazily(headerFooter: SupplementaryViewModel, to tableView: UITableView) {
        guard registersCellsLazily, headerFooter.registersLazily, !registeredHeaderFooterReuseIdentifiers.contains(headerFooter.reuseIdentifier) else {
            return
        }

        if let nib = headerFooter.nib {
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
        } else {
            tableView.register(headerFooter.cellClass, forHeaderFooterViewReuseIdentifier: headerFooter.reuseIdentifier)
        }
        registeredHeaderFooterReuseIdentifiers.insert(headerFooter.reuseIdentifier)
    }

    private func view(for headerFooter: SupplementaryViewModel?, in tableView: UITableView) -> UIView? {
        guard let headerFooter = headerFooter else {
            return nil
        }
        registerLazily(headerFooter: headerFooter, to: tableView)
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooter.reuseIdentifier) else {
            return nil
        }
        return header
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
        registerLazily(cellModel: item, to: tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell: cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cellModel(at: indexPath).highlighting
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = header(in: section)
        let headerView = view(for: model, in: tableView)
        headerView.flatMap { model?.configure(cell: $0) }
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return header(in: section)?.height ?? CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = footer(in: section)
        let footerView = view(for: model, in: tableView)
        footerView.flatMap { model?.configure(cell: $0) }
        return footerView
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
        registerLazily(cellModel: item, to: collectionView)
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

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let theCellModel = cellModel(at: indexPath) as? CellModelPresentationHandling {
            theCellModel.prepareForPresentation()
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let theCellModel = cellModel(at: indexPath) as? CellModelPresentationHandling {
            theCellModel.tidyAfterPresentation()
        }
    }
}

extension AbstractDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let theCellModel = cellModel(at: indexPath) as? CellModelPresentationHandling {
            theCellModel.prepareForPresentation()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let theCellModel = cellModel(at: indexPath) as? CellModelPresentationHandling {
            theCellModel.tidyAfterPresentation()
        }
    }
}

extension AbstractDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCellModel(cellModel(at: indexPath), at: indexPath)
    }
}
