import UIKit
import CellKit
import DiffableCellKit

enum Constants {

    static var iPhones = ["iPhone", "iPhone 3G", "iPhone 3GS", "iPhone 4", "iPhone 4S", "iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone SE", "iPhone 7", "iPhone 8", "iPhone X"]
    static var androids = ["Samsung Galaxy Note", "OnePlus 2", "Nexus 6", "Huawei P9", "Kindle Fire", "Samsung Galaxy S6", "Nexus 5"]
}

final class ViewController: UITableViewController {

    private var dataSource: ActionSensitiveDiffDataSource!

    private var phonesSection: DifferentiableCellModelSection {
        let iPhoneCellModels: [DifferentiableCellModel] = Constants.iPhones.prefix(5).map { DeviceiOSCellModel(numberOfTaps: 0, name: $0) }
        let androidCellModels: [DifferentiableCellModel] = Constants.androids.prefix(5).map { DeviceAndroidCellModel(numberOfTaps: 0, name: $0) }
        let cellModels = iPhoneCellModels + androidCellModels
        let header = PhonesHeaderModel(title: "Cell Phones")

        return DifferentiableCellModelSection(cells: cellModels, headerView: header, identifier: "Section 1")
    }

    private var welcomeSection: DifferentiableCellModelSection {
        return [NibTableViewCellModel(text: "Welcome!")]
    }

    private var defaultSections: [DifferentiableCellModelSection] {
        return [
            welcomeSection,
            phonesSection
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = ActionSensitiveDiffDataSource(tableView, sections: defaultSections)
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        dataSource.deletionHandler = { [weak self] indexPath, _ in
            self?.shouldDeleteRow(at: indexPath)
        }
    }

    @IBAction func didTapReset() {
        dataSource?.sections = defaultSections
    }

    @IBAction func didTapAddIPhone() {
        let visibleItems = dataSource?.sections.last?.cells
            .compactMap { $0 as? DeviceiOSCellModel }
            .compactMap { $0.name } ?? []

        let available = Set(Constants.iPhones).subtracting(Set(visibleItems))
        if let item = available.first {
            dataSource?.sections[1].cells.insert(DeviceiOSCellModel(numberOfTaps: 0, name: item), at: 0)
        }
    }

    @IBAction func didTapAddAndroid() {
        let visibleItems = dataSource?.sections.last?.cells
            .compactMap { $0 as? DeviceAndroidCellModel }
            .compactMap { $0.name } ?? []

        let available = Set(Constants.androids).subtracting(Set(visibleItems))
        if let item = available.first {
            dataSource?.sections[1].cells.insert(DeviceAndroidCellModel(numberOfTaps: 0, name: item), at: 0)
        }
    }

    private func shouldDeleteRow(at indexPath: IndexPath) {
        if indexPath.section == 1 {
            dataSource?.sections[indexPath.section].cells.remove(at: indexPath.row)
        }
    }
}

extension ViewController: CellModelDataSourceDelegate {
    func didSelectCellModel(_ cellModel: CellModel, at indexPath: IndexPath) {
        if indexPath.section == 1, var sourceModel = dataSource?.sections[indexPath.section].cells[indexPath.row] {
            if var iosModel = sourceModel as? DeviceiOSCellModel {
                iosModel.numberOfTaps += 1
                sourceModel = iosModel
            }
            if var android = sourceModel as? DeviceAndroidCellModel {
                android.numberOfTaps += 1
                sourceModel = android
            }
            dataSource?.sections[indexPath.section].cells[indexPath.row] = sourceModel
        }
    }
}
