//
//  Utils.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-07-22.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import Foundation

extension String {
    var removeExtraWhiteSpace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter({ (s) -> Bool in
            return !s.isEmpty
        }).joined(separator: " ")
    }
}
