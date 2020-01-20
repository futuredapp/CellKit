import UIKit
import CellKit
import DiffableCellKit

protocol DeletableCellModel {
    var allowDelete: Bool { get }
}

final class ActionSensitiveDiffDataSource: DifferentiableCellModelDataSource {

    var deletionHandler: ((IndexPath, DeletableCellModel) -> Void)?

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (sections[indexPath.section].cells[indexPath.row] as? DeletableCellModel)?.allowDelete == true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section == 1 else {
            return nil
        }

        return [UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            guard let model = self?.sections[indexPath.section].cells[indexPath.row] as? DeletableCellModel else {
                return
            }
            self?.deletionHandler?(indexPath, model)
        }]
    }

}
