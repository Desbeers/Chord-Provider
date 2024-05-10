//
//  String+UnicodeScalar+Extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension String.UnicodeScalarView {

    subscript(index: Int) -> UnicodeScalar {
        var startIndex = self.startIndex
        self.formIndex(&startIndex, offsetBy: index)
        return self[startIndex]
    }
}
