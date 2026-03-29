//
//  StringExtensions.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Foundation

extension String {
    
    static var empty: String { String() }
    
    func withHorizontalPadding() -> Self {
        return "  \(self)  "
    }
}
