import class Foundation.Bundle
import class UIKit.UINib

public protocol ReusableView {
    var registersLazily: Bool { get }
    var usesNib: Bool { get }
    var bundle: Bundle { get }
    var nib: UINib? { get }

    var cellClass: AnyClass { get }
    var reuseIdentifier: String { get }
}

public extension ReusableView {
    var registersLazily: Bool {
        return true
    }

    var usesNib: Bool {
        return true
    }

    var bundle: Bundle {
        return Bundle(for: cellClass)
    }

    var nib: UINib? {
        if usesNib {
            return UINib(nibName: String(describing: cellClass), bundle: bundle)
        }
        return nil
    }
}
