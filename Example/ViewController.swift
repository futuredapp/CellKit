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

    @IBOutlet var tableView: UITableView!
    var dataSource: EquatableCellModelDataSource!

    var phones = ["iPhone", "iPhone 3G", "iPhone 3GS", "iPhone 4", "iPhone 4S", "iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone SE", "iPhone 7", "iPhone 8", "iPhone X"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellModels = phones.map { DeviceiOSCellModel(name: $0) }
        let section = EquatableCellModelSection(cells: cellModels, identifier: "Section 1")
        dataSource = EquatableCellModelDataSource(tableView, sections: [section])
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }

    @IBAction func didTapAddSection() {
        
    }

    @IBAction func didTapAddRowA() {
        if let section = dataSource?.sections[0] {
            var section = section
            section.cells.insert(DeviceiOSCellModel(name: "iPhone X \(arc4random() % 100)"), at: 0)
            dataSource?.sections = [section]
        }
    }

    @IBAction func didTapAddRowB() {

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
