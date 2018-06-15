//
//  CellConvertible.swift
//  CellKit-iOS
//
//  Created by Petr Zvoníček on 08.06.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import UIKit

public extension UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

public protocol CellConvertible {
    var reuseIdentifier: String { get }

    func cellType() -> UIView.Type
    func model() -> Any
}

extension CellConvertible {
    public var reuseIdentifier: String {
        return cellType().nibName
    }

    public func model() -> Any {
        return self
    }
}

public protocol CellConfigurable {
    associatedtype Model
    func configure(with model: Model)
}
