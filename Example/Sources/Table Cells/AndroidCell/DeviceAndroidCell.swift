import UIKit
import CellKit

final class DeviceAndroidCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension DeviceAndroidCell: CellConfigurable {
    func configure(with model: DeviceAndroidCellModel) {
        self.nameLabel.text = model.name + " tapped: \(model.numberOfTaps)"
    }
}
