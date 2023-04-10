//
//  Sequence+Extension.swift
//  YOUMAWO
//
//  Created by Admin on 31.03.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
