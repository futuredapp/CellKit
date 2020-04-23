//
//  ViewController.swift
//  TestCellKit
//
//  Created by Adam Salih on 21/04/2020.
//  Copyright © 2020 Salih. All rights reserved.
//

import UIKit
import CellKit

class PrototypeCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    
    func configure(with model: PrototypeCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct PrototypeCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = PrototypeCell
    var usesNib: Bool { false }
    var registersLazily: Bool { false }
}

class CodeCell: UITableViewCell, CellConfigurable {
    var label: UILabel = UILabel()
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: label.topAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            leftAnchor.constraint(equalTo: label.leftAnchor, constant: -16),
            heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func configure(with model: CodeCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct CodeCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = CodeCell
    var usesNib: Bool { false }
    var cellHeight: Double = 64
}

class XIBCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    func configure(with model: XIBCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct XIBCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = XIBCell
    var cellHeight: Double = 64
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataSource: CellModelDataSource = {
        CellModelDataSource([
            GenericCellModelSection(arrayLiteral:
                PrototypeCellViewModel(name: "Prototype")
            ),
            GenericCellModelSection(arrayLiteral:
                CodeCellViewModel(name: "Code")
            ),
            GenericCellModelSection(arrayLiteral:
                XIBCellViewModel(name: "XIB")
            )
        ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
}

