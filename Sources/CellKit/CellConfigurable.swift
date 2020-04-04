public protocol CellConfigurable: AnyObject {
    associatedtype Model
    func configure(with model: Model)
}
