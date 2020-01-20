public protocol CellConfigurable: class {
    associatedtype Model
    func configure(with model: Model)
}
