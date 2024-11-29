//
//  ChordPro+Directive+FormattingAttribute.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// Optional formatting attributes for directives
    enum FormattingAttribute: String, Codable {
        case plain
        case label
        case align
    }
}
