# CellKit

![Cocoapods](https://img.shields.io/cocoapods/v/CellKit.svg)
![Cocoapods platforms](https://img.shields.io/cocoapods/p/CellKit.svg)
![License](https://img.shields.io/cocoapods/l/CellKit.svg)
![Continuous integration](https://img.shields.io/bitrise/57c06040e101a852.svg?token=xvYC9NW6ZszIzFdjkapmVg)

CellKit is a Swift package that streamlines the workflow with cells in UITableView and UICollectionView. No more registering cell classes or XIBs, no more dequeueing cells and setting its view models. CellKit handles this all.

## Installation
### Swift Package
Add following line to your swift package dependencies, or in Xcode, go to `File -> Swift Packages -> Add Package Dependency` and type in URL address of this repository.
```
.package(url: "https://github.com/futuredapp/CellKit", from: "0.8.0")
```
### CocoaPods
Add following line to your  `Podfile` and then run `bundle exec pod install`
```
pod 'CellKit', '~> 0.8'
```

## Usage
CellKit provides a data source and a section model which you fill with your cells, headers and footer models. All you're left to do is to define your cell view and your cell model with protocol conformance to CellConvertible and CellConfigurable and CellKit will handle the rest.

### 1. step: Set a DataSource
CellKit provides a `CellModelDataSource` datasource and `GenericCellModelSection` section, which define your `UITableView`/`UICollectionView` cell structure. You can always subclass `CellModelDataSource` and override it's methods to suit your needs.  
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
collectionView.dataSource = dataSource
```

### 2. step: Create your cell and CellModel
CellKit support wide variety of cell declarations including `.xib` files , `UITableView` interface builder prototype cells and Cells written entirely in code.  
*Please note that your `.xib` file, Cell subclass and Cell identifier have to to have the same name.* It is possible to not use the same identifier, but it is not recommended.

### 3. Implement CellKit protocols
In order for your cells and cell view models to work with CellKit, they have to conform to these protocols:

#### CellConfigurable
This is a protocol for your *Cell*. This protocol provides a `configure(model:)` method which gets call when a tableview request a reusable cell and is used to distribute your model to your cells. 
```swift
class XIBCell: UITableViewCell, CellConfigurable {
    @IBOutlet private weak var label: UILabel!
}

extension XIBCell: CellConfigurable {
    func configure(with model: XIBCellViewModel) {
        label.text = model.name
    }
}
```

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


## Examples
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

