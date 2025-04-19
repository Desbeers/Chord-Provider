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
    var postScriptName: String = "Verdana"
    /// The display name
    var displayName: String = "Verdana"
    /// The style name
    var familyName: String = "Verdana"
    /// The style, *italic* for example
    var styleName: String = "Regular"
    /// The font url
    var url: URL = URL(fileURLWithPath: "/System/Library/Fonts/Supplemental/Verdana.ttf")
}
