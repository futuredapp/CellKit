//
//  ViewController.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit

class ViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private var dataSource: EquatableCellModelDataSource!

    private var iPhones = ["iPhone", "iPhone 3G", "iPhone 3GS", "iPhone 4", "iPhone 4S", "iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone SE", "iPhone 7", "iPhone 8", "iPhone X"]
    private var androids = ["Samsung Galaxy Note", "OnePlus 2", "Nexus 6", "Huawei P9", "Kindle Fire", "Samsung Galaxy S6", "Nexus 5"]

    private var phonesSection: EquatableCellModelSection {
        var cellModels = [EquatableCellModel]()
        cellModels.append(contentsOf: iPhones.prefix(5).map { DeviceiOSCellModel(name: $0) })
        cellModels.append(contentsOf: androids.prefix(5).map { DeviceAndroidCellModel(name: $0) })
        return EquatableCellModelSection(cells: cellModels, identifier: "Section 1")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = EquatableCellModelDataSource(tableView, sections: [phonesSection])
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }

    @IBAction func didTapReset() {
        dataSource?.sections = [phonesSection]
    }

    @IBAction func didTapAddIPhone() {
        let visibleItems = dataSource?.sections.last?.cells
            .compactMap { $0 as? DeviceiOSCellModel }
            .compactMap { $0.name } ?? []

        let available = Set(iPhones).subtracting(Set(visibleItems))
        if let item = available.first, let section = dataSource?.firstSection {
            var section = section
            section.cells.insert(DeviceiOSCellModel(name: item), at: 0)
            dataSource?.sections = [section]
        }
    }

    @IBAction func didTapAddAndroid() {
        let visibleItems = dataSource?.sections.last?.cells
            .compactMap { $0 as? DeviceAndroidCellModel }
            .compactMap { $0.name } ?? []

        let available = Set(androids).subtracting(Set(visibleItems))
        if let item = available.first, let section = dataSource?.firstSection {
            var section = section
            section.cells.insert(DeviceAndroidCellModel(name: item), at: 0)
            dataSource?.sections = [section]
        }
    }
}

extension ViewController: CellModelDataSourceDelegate {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath) {
        if let section = dataSource?.sections[indexPath.section] {
            var section = section
            section.cells.remove(at: indexPath.row)
            dataSource?.sections = [section]
        }
    }
}
