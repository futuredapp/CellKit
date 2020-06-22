@available(iOS 13.0, tvOS 13.0, *)
public protocol CollectionSupplementaryViewModel: ReusableView {
    var kind: SupplementaryElementKind { get }

    func configure(cell: AnyObject)
}
