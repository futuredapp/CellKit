import UIKit
import CellKit

final class DeviceiOSCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension DeviceiOSCell: CellConfigurable {
    func configure(with model: DeviceiOSCellModel) {
        self.nameLabel.text = model.name + " tapped: \(model.numberOfTaps)"
    }
}
