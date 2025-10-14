//
//  Pango.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation

enum Pango: String {
    case italic = " style='italic' "
    case bold = " weight='bold' "
    case monospace = " face='monospace' "
    static func color(_ hex: String) -> String {
        " color='\(hex)' "
    }
    static func font(_ size: Double) -> String {
        " font='\(size)' "
    }
}
