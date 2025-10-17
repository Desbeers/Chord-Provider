//
//  Markup+css.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Markup {

    enum Class: String, CustomStringConvertible {
        var description: String {
            self.rawValue
        }

        case tagLabel = "tag-label"
    }

    static let css =
"""
.tag-label {
    background-color: @green_1;
    padding: 0.5em;
    border-radius: 0.5em;
}
"""
}
