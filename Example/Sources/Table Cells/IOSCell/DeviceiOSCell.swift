import CellKit
import UIKit

final class DeviceiOSCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
}

extension DeviceiOSCell: CellConfigurable {
    func configure(with model: DeviceiOSCellModel) {
        self.nameLabel.text = model.name + " tapped: \(model.numberOfTaps)"
    }
}
