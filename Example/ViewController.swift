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
    var dataSource: CellModelDataSource? = nil

    var phones = ["iPhone", "iPhone 3G", "iPhone 3GS", "iPhone 4", "iPhone 4S", "iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone SE", "iPhone 7", "iPhone 8", "iPhone X"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = CellModelDataSource([CellModelSection()]) { (cell, model) in
            switch (cell, model) {
            case let (cell as DeviceiOSCell, model as DeviceiOSCellModel):
                cell.configure(with: model)
            default:
                break
            }
        }
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }

    @IBAction func didTapAddSection() {
        
    }

    @IBAction func didTapAddRowA() {
        var section = dataSource?.sections.first
        
    }

    @IBAction func didTapAddRowB() {

    }
}

