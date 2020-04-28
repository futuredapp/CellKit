import Foundation
import UIKit.UIView
import CellKit

struct PhonesHeaderModel {
    let title: String
}

extension PhonesHeaderModel: SupplementaryViewModel, CellConvertible {
    typealias Cell = PhonesHeader

    var height: Double {
        return 50
    }
}
