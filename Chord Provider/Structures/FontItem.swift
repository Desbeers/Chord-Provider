//
//  FontItem.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Structure of a font item
struct FontItem: Codable, Equatable, Hashable {
    /// The postscript name
    var postScriptName: String = "HelveticaNeue"
    /// The display name
    var displayName: String = "Helvetica Neue"
    /// The style name
    var familyName: String = "Helvetica Neue"
    /// The style, *italic* for example
    var styleName: String = "Regular"
    /// The font url
    var url: URL = URL(fileURLWithPath: "/System/Library/Fonts/HelveticaNeue.ttc")
}
