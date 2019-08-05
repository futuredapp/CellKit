//
//  ViewController.swift
//  Example
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit
import CellKit
import DiffableCellKit

final class ViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!

    private var dataSource: EquatableCellModelDataSource!

    private var iPhones = ["iPhone", "iPhone 3G", "iPhone 3GS", "iPhone 4", "iPhone 4S", "iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone SE", "iPhone 7", "iPhone 8", "iPhone X"]
    private var androids = ["Samsung Galaxy Note", "OnePlus 2", "Nexus 6", "Huawei P9", "Kindle Fire", "Samsung Galaxy S6", "Nexus 5"]

    private var phonesSection: EquatableCellModelSection {
        let iPhoneCellModels: [EquatableCellModel] = iPhones.prefix(5).map { DeviceiOSCellModel(name: $0) }
        let androidCellModels: [EquatableCellModel] = androids.prefix(5).map { DeviceAndroidCellModel(name: $0) }
        let cellModels = iPhoneCellModels + androidCellModels
        let header = PhonesHeaderModel(title: "Cell Phones")

        return EquatableCellModelSection(cells: cellModels, headerView: header, identifier: "Section 1")
    }

    private var welcomeSection: EquatableCellModelSection {
        return [NibTableViewCellModel(text: "Welcome!")]
    }

    private var defaultSections: [EquatableCellModelSection] {
        return [
            welcomeSection,
            phonesSection
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = EquatableCellModelDataSource(tableView, sections: defaultSections)
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }

    @IBAction func didTapReset() {
        dataSource?.sections = defaultSections
    }

    @IBAction func didTapAddIPhone() {
        let visibleItems = dataSource?.sections.last?.cells
            .compactMap { $0 as? DeviceiOSCellModel }
            .compactMap { $0.name } ?? []

        let available = Set(iPhones).subtracting(Set(visibleItems))
        if let item = available.first {
            dataSource?.sections[1].cells.insert(DeviceiOSCellModel(name: item), at: 0)
        }
    }

    @IBAction func didTapAddAndroid() {
        let visibleItems = dataSource?.sections.last?.cells
            .compactMap { $0 as? DeviceAndroidCellModel }
            .compactMap { $0.name } ?? []

        let available = Set(androids).subtracting(Set(visibleItems))
        if let item = available.first {
            dataSource?.sections[1].cells.insert(DeviceAndroidCellModel(name: item), at: 0)
        }
    }
}

extension ViewController: CellModelDataSourceDelegate {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath) {
        if indexPath.section == 1 {
            dataSource?.sections[indexPath.section].cells.remove(at: indexPath.row)
        }
    }
}
