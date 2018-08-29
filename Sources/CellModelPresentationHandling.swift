//
//  CellModelPresentationHandling.swift
//  CellKit-iOS
//
//  Created by Mikoláš Stuchlík on 29.08.18.
//  Copyright © 2018 FUNTASTY Digital, s.r.o. All rights reserved.
//

import Foundation

public protocol CellModelPresentationHandling: class {
    func willDisplay()
    func didEndDisplay()
}
