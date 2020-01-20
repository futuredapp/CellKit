import UIKit
import CellKit
import DiffableCellKit

struct DeviceiOSCellModel: CellConvertible, DifferentiableCellModel, DeletableCellModel {

    var domainIndentifier: Int {
        return name.hashValue
    }

    func hasEqualContent(with other: CellModel) -> Bool {
        guard let other = other as? DeviceiOSCellModel else {
            return false
        }
        return other.name == self.name && other.numberOfTaps == self.numberOfTaps
    }

    typealias Cell = DeviceiOSCell

    var numberOfTaps: Int
    let name: String
    let cellHeight: CGFloat = 60.0
    let registersLazily: Bool = false
    let allowDelete: Bool = true
}

extension DeviceiOSCellModel: CellModelSelectable {
    func didSelect() {
        print("Did select \(self.name)")
    }
}
