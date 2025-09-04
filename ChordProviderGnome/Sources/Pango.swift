//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 04/09/2025.
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
