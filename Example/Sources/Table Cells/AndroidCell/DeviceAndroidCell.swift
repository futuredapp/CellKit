import CellKit
import UIKit

final class DeviceAndroidCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
}

extension DeviceAndroidCell: CellConfigurable {
    func configure(with model: DeviceAndroidCellModel) {
        self.nameLabel.text = model.name + " tapped: \(model.numberOfTaps)"
    }
}
