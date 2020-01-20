import UIKit
import CellKit

class PhonesHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var titleLabel: UILabel!
}

extension PhonesHeader: CellConfigurable {
    func configure(with model: PhonesHeaderModel) {
        titleLabel.text = model.title
    }
}
