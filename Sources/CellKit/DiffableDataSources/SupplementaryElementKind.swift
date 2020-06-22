import UIKit

@available(iOS 13.0, tvOS 13.0, *)
public enum SupplementaryElementKind {
    case header
    case footer
    case custom(String)

    public init?(rawValue: String) {
        switch rawValue {
        case UICollectionView.elementKindSectionHeader:
            self = .header
        case UICollectionView.elementKindSectionFooter:
            self = .footer
        default:
            self = .custom(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        case .custom(let identifier):
            return identifier
        }
    }
}
