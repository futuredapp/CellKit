//
//  CellConfigurable.swift
//  CellKit-iOS
//
//  Created by Matěj Jirásek on 18/06/2018.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

public protocol CellConfigurable: class {
    associatedtype Model
    func configure(with model: Model)
}
