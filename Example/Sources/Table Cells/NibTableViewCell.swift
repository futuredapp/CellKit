import UIKit
import CellKit
import DiffableCellKit

struct NibTableViewCellModel: ReusableCellConvertible, DifferentiableCellModel {
    var domainIndentifier: Int {
        return text.hashValue
    }

    func hasEqualContent(with other: CellModel) -> Bool {
        guard let other = other as? NibTableViewCellModel else {
            return false
        }

        return other.text == self.text
    }

    typealias Cell = NibTableViewCell

    let text: String
    let cellHeight: CGFloat  = 170.0
}

final class NibTableViewCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var headerLabel: UILabel!

    func configure(with model: NibTableViewCellModel) {
        headerLabel.text = model.text
    }
}
