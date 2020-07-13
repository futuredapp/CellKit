import DifferenceKit
#if SWIFT_PACKAGE
import CellKit
#endif

public typealias DifferentiableCellModelSection = GenericCellModelSection<DifferentiableCellModel>

struct SectionMetadata: Differentiable {
    func isContentEqual(to source: SectionMetadata) -> Bool {
        source.identifier == identifier
    }

    var differenceIdentifier: String {
        identifier
    }

    var headerView, footerView: SupplementaryViewModel?
    let identifier: String

    init<T>(from section: GenericCellModelSection<T>) {
        headerView = section.headerView
        footerView = section.footerView
        identifier = section.identifier
    }
}

extension DifferentiableCellModelSection {
    var arraySection: ArraySection<SectionMetadata, DifferentiableCellModelWrapper> {
        DiffSection(model: SectionMetadata(from: self), elements: self.cells.map(DifferentiableCellModelWrapper.init))
    }
}

typealias DiffSection = ArraySection<SectionMetadata, DifferentiableCellModelWrapper>
