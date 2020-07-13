<img alt="CellKit icon" src="Documentation/CellKit.svg" align="right">

# CellKit

![Cocoapods](https://img.shields.io/cocoapods/v/CellKit.svg)
![Cocoapods platforms](https://img.shields.io/cocoapods/p/CellKit.svg)
![License](https://img.shields.io/cocoapods/l/CellKit.svg)

CellKit is a Swift package that streamlines the workflow with cells in UITableView and UICollectionView. No more registering cell classes or XIBs, no more dequeueing cells and setting its view models. CellKit handles this all.

## Installation

### Swift Package

Add following line to your swift package dependencies, or in Xcode, go to `File -> Swift Packages -> Add Package Dependency` and type in URL address of this repository.

```swift
.package(url: "https://github.com/futuredapp/CellKit", from: "0.8.1")
```

Optionally you can add `DiffableCellKit`.

### CocoaPods

Add following line to your `Podfile` and then run `pod install`:

```ruby
pod 'CellKit', '~> 0.8'
```
Optionally you can add `DiffableCellKit` subspec:

```ruby
pod 'CellKit', '~> 0.8', subspecs: ['Diffable']
```

## Usage
CellKit provides a data source and a section model which you fill with your cells, headers and footer models. All you're left to do is to define your cell view and your cell model with protocol conformance to CellConvertible and CellConfigurable and CellKit will handle the rest.

### 1. Set a DataSource

CellKit provides a `CellModelDataSource` and `GenericCellModelSection`, which define your `UITableView`/`UICollectionView` cell structure. You can always subclass `CellModelDataSource` and override its methods to suit your needs.  
Here's an example of typical CellKit data source usage:

```swift
let dataSource = CellModelDataSource([
    GenericCellModelSection(arrayLiteral:
        PrototypeCellViewModel(name: "Prototype")
    ),
    GenericCellModelSection(arrayLiteral:
        CodeCellViewModel(name: "Code")
    ),
    GenericCellModelSection(arrayLiteral:
        XIBCellViewModel(name: "XIB")
    )
])

tableView.dataSource = dataSource
collectionView.dataSource = dataSource
```

### 2. Create your cell and CellModel

CellKit support wide variety of cell declarations including `.xib` files , `UITableView` interface builder prototype cells and Cells written entirely in code.  
*Please note that your `.xib` file, Cell subclass and Cell identifier have to to have the same name.* It is possible to not use the same identifier, but it is not recommended.  
Pro tip: You can use our [custom teplates](https://github.com/futuredapp/MVVM-C-Templates) to generate Cell with CellKit protocols in just a few clicks.

### 3. Conform to CellKit protocols

In order for your cells and cell view models to work with CellKit, they have to conform to these protocols:

#### CellConfigurable

This is a protocol for your *Cell*. This protocol provides a `configure(model:)` method which gets call when a tableview request a reusable cell and is used to distribute your model to your cells. 

```swift
class XIBCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
}

extension XIBCell: CellConfigurable {
    func configure(with model: XIBCellViewModel) {
        label.text = model.name
    }
}
```

#### CellModel

Protocol for your cell model. Use this procotol to specify your cell configuration such as height, xib location, whether the cell is highlightable, etc.

```swift
struct PrototypeCellViewModel {
    let name: String
}

extension PrototypeCellViewModel: CellModel {
    var usesNib: Bool { false }
    var registersLazily: Bool { false }
}
```

Here is a handy table of configurable properties and their default values in which you can provide your own values.
| properties        | datatype | default                                                  | description                                                                 |
|-------------------|----------|----------------------------------------------------------|-----------------------------------------------------------------------------|
| registersLazily   | Bool     | true                                                     | Indicates whether DataSource should register a view to its presenting view. |
| usesNib           | Bool     | true                                                     | Indicates whether cell is defined in .xib file                              |
| nib               | UINib?   | xib with `cellClass` name. Or nil if `usesNib` is false. | An `UINib` reference of your .xib file containing you view                    |
| cellClass         | AnyClass |                                                          | A class reference to views class.                                           |
| reuseIdentifier   | String   |                                                          | a unique re-use identifier                                                  |
| cellHeight        | Double   | 44.0                                                     | hight for cell                                                              |
| highlighting      | Bool     | true                                                     | Indicates whether cell can be highlighted                                   |
| separatorIsHidden | Bool     | false                                                    | Indicates whether should hide separator                                     |

#### CellConvertible 

This protocol extends CellModel with associated type and thus can provide a default `cellClass` and `reuseIdentifier` value based on type's name.    
It's espetially handy when you declare your cell in XIB, because all you need to do is to define its associated type and CellKit will provide the rest.    
Here's an example:

```swift
class XIBCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    
    func configure(with model: XIBCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct XIBCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = XIBCell
}
```

## DiffableCellKit

DiffableCellKit is an extension build on top of `CellKit` and `DifferenceKit` which captures your data source changes and automatically updates/removes/inserts your `UITableView`/`UICollectionView` cells.  

### DifferentiableCellModelDataSource

`DifferentiableCellModelDataSource` is built on top of the same foundation as `CellModelDataSource` with the difference (no pun intended), that it accepts `DifferentiableCellModelSection` and when you change the content of its `sections` property, the data source will issue an animated update to its `UITableView`/`UICollectionView`. 
`DifferentiableCellModelDataSource` is still an open class, so you can subclass it and override its methods and propertes to suit your needs.

```swift
let datasource = DifferentiableCellModelDataSource(self.tableView, sections: [
    DifferentiableCellModelSection(arrayLiteral:
        PrototypeCellViewModel(domainIdentifier: 1, name: "Prototype")
    ),
    DifferentiableCellModelSection(arrayLiteral:
        CodeCellViewModel(domainIdentifier: 2, name: "Code")
    ),
    DifferentiableCellModelSection(arrayLiteral:
        XIBCellViewModel(domainIdentifier: 3, name: "XIB")
    )
])
```

### DifferentiableCellModel

Just like `CellModel`, `DifferentiableCellModel` is a protocol for your cell model. `DifferentiableCellModel` provides one new `domainIdentifier` property  and a `hasEqualContent(with:)` method which provides enough information for `DiffableCellKit` to recognize changes and issue `UITableView`/`UICollectionView` update.  
When your cell model conforms to `Equatable` protocol, `DiffableCellKit` provides an `Equatable` extension, so you don't have to implement `hasEqualContent(with:)` method.
DifferentiableCellModel can still be combined with `CellConvertible` protocol.

```swift
class XIBCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    
    func configure(with model: XIBCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct XIBCellViewModel: CellConvertible, DifferentiableCellModel, Equatable {
    let name: String
    
    // MARK: DifferentiableCellModel
    var domainIdentifier: Int
    
    // MARK: CellConvertible
    typealias Cell = XIBCell
}
```

## CellKit Examples

### XIB cell

```swift
class XIBCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    func configure(with model: XIBCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct XIBCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = XIBCell
}
```

### Storyboard prototype cell

```swift
class PrototypeCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    
    func configure(with model: PrototypeCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct PrototypeCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = PrototypeCell
    let usesNib: Bool = false
    let registersLazily: Bool = false
}
```
### Cell defined in code

```swift
class CodeCell: UITableViewCell, CellConfigurable {
    let label: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: label.topAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            leftAnchor.constraint(equalTo: label.leftAnchor, constant: -16),
            heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func configure(with model: CodeCellViewModel) {
        label.text = "\(model.name)"
    }
}

struct CodeCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = CodeCell
    let usesNib: Bool = false
    let cellHeight: Double = 64
}
```

## Contributors

Current maintainer and main contributor is [Matěj Kašpar Jirásek](https://github.com/mkj-is), <matej.jirasek@futured.app>.

We want to thank other contributors, namely:

- [Matěj Kašpar Jirásek](https://github.com/mkj-is)
- [Petr Zvoníček](https://github.com/zvonicek)
- [Mikoláš Stuchlík](https://github.com/mikolasstuchlik)
- [Michal Šrůtek](https://github.com/michalsrutek)
- [Tomáš Babulák](https://github.com/tomasbabulak)
- [Adam Salih](https://github.com/max9631)
- [Michal Martinů](https://github.com/MichalMartinu)

## License

CellKit is available under the MIT license. See the [LICENSE](LICENSE) for more information.
