# CellKit

![Cocoapods](https://img.shields.io/cocoapods/v/CellKit.svg)
![Cocoapods platforms](https://img.shields.io/cocoapods/p/CellKit.svg)
![License](https://img.shields.io/cocoapods/l/CellKit.svg)
![Continuous integration](https://img.shields.io/bitrise/57c06040e101a852.svg?token=xvYC9NW6ZszIzFdjkapmVg)

CellKit is a swift package that simplifies the workflow with cells in collection views like UITableViews and UICollectionView with MVVM architecture. No more registering cell classes or xibs, no more dequing cells and setting its view models. CellKit handles this all.

## Installation
### Swift Package
```
.package(url: "https://github.com/futuredapp/CellKit", from: "0.8.0")
```
### CocoaPods
```
pod 'CellKit', '~> 0.8.0'
```

## Features
CellKit provides a dataSource and a section model which you fill with your cells, headers and footers. All you're left to do is to define your cell View and your cell ViewModel with CellKit protocols and CellKit will handle the rest.

### DataSource
DataSource and section model are pretty straight forward. CellKit comes with `CellModelDataSource` and `GenericCellModelSection` which represents your UITableView/UICollectionView cell structure. 

#### CellModelDataSource
`CellModelDataSource` is an open class which means that you can make a subclass a override its behaviour to suit your needs.
`CellModelDataSource` only accepts an array of `GenericCellModelSection` objects.

#### GenericCellModelSection
`GenericCellModelSection` represents a section in tableView/collectionView. It accepts following arguments:


### Cell protocols
In order for your cells and cell view models to work with CellKit, they have to conform to three protocols: `CellConfigurable`, `CellConvertible` and `CellModel`

#### CellConfigurable protocol
Provides a `configuration(model:)` method which gets call when a tableview dequest a new reusable cell. This protocol is for cell views only.

#### CellModel
Provides configurable informations about a cell view

| properties        | datatype | default                                                  | description                                                                 |
|-------------------|----------|----------------------------------------------------------|-----------------------------------------------------------------------------|
| registersLazily   | Bool     | true                                                     | Indicates whether DataSource should register a view to its presenting view. |
| usesNib           | Bool     | true                                                     | Indicates whether cell is defined in .xib file                              |
| nib               | UINib?   | xib with `cellClass` name. Or nil if `usesNib` is false. | An UINib reference of your .xib file containing you view                    |
| cellClass         | AnyClass |                                                          | A class reference to views class.                                           |
| reuseIdentifier   | String   |                                                          | a unique re-use identifier                                                  |
| cellHeight        | Double   | 44.0                                                     | hight for cell                                                              |
| highlighting      | Bool     | true                                                     | Indicates whether cell can be highlighted                                   |
| separatorIsHidden | Bool     | false                                                    | Indicates whether should hide separator                                     |

#### CellConvertible
Extends CellModel with associated type and thus can 

#### Cells
In order for your cells to work with 


## Usage
When using CellKit you have two 
CellKit provides a `CellModelDataSource` datasource and `GenericCellModelSection` section, where you define your TableView/CollectionView structure. 
Here's an example of typical CellKit datasource usage:
```swift
lazy var dataSource: CellModelDataSource = {
    CellModelDataSource([
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
}()

tableView.dataSource = dataSource
```

### With xib cell
cell:
```swift
class XIBCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    func configure(with model: XIBCellViewModel) {
        label.text = "\(model.name)"
    }
}
```
model:
```swift
struct XIBCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = XIBCell
    var cellHeight: Double = 64
}
```

### With storyboard prototype cell
cell:
```swift
class PrototypeCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
    
    func configure(with model: PrototypeCellViewModel) {
        label.text = "\(model.name)"
    }
}
```
model:
```swift
struct PrototypeCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = PrototypeCell
    var usesNib: Bool { false }
    var registersLazily: Bool { false }
}
```
### With cell defined in code
cell:
```swift
class CodeCell: UITableViewCell, CellConfigurable {
    var label: UILabel = UILabel()
    
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
```
model:
```swift
struct CodeCellViewModel: CellConvertible, CellModel {
    let name: String
    
    // MARK: CellConvertible
    typealias Cell = CodeCell
    var usesNib: Bool { false }
    var cellHeight: Double = 64
}
```