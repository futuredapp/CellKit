public protocol CollectionSupplementaryViewModel: ReusableView {
    var kind: SupplementaryElementKind { get }

    func configure(cell: AnyObject)
}
