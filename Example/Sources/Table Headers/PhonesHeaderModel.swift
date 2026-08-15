import CellKit
import Foundation
import UIKit.UIView

struct PhonesHeaderModel {
    let title: String
}

extension PhonesHeaderModel: @MainActor SupplementaryViewModel, @MainActor CellConvertible {
    typealias Cell = PhonesHeader

    var height: Double {
        50
    }
}
