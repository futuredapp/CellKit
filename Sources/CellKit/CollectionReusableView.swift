//
//  CollectionReusableView.swift
//  CellKit-iOS
//
//  Created by Matěj Kašpar Jirásek on 08/05/2019.
//  Copyright © 2019 FUNTASTY Digital, s.r.o. All rights reserved.
//

import class UIKit.UICollectionReusableView

public final class CollectionReusableView: UICollectionReusableView, CellConfigurable {
    public func configure(with model: CollectionReusableViewModel) {
    }
}

public struct CollectionReusableViewModel: SupplementaryViewModel, CellConvertible {
    public typealias Cell = CollectionReusableView

    public var height: Double {
        return 0.0
    }

    public var usesNib: Bool {
        return false
    }
}
