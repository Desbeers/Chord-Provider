//
//  UnicodeScalar+Extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension UnicodeScalar {
    var isWhitespace: Bool {
        return NSCharacterSet.whitespaces.contains(self) || NSCharacterSet.newlines.contains(self)
    }

    var isNewline: Bool {
        return NSCharacterSet.newlines.contains(self)
    }
}
