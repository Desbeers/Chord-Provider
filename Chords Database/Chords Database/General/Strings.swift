//
//  Strings.swift
//  Chords Database
//
//  Created by Nick Berendsen on 30/10/2022.
//

import Foundation

/// The strings on the guitar
enum Strings: Int, CaseIterable {
    case E
    case A
    case D
    case G
    case B
    case e
    /// The offset for each string from the base 'E'
    ///  - Note: -1, because of the BaseFret value in `ChordPosition`
    var offset: Int {
        switch self {
        case .E:
            return -1
        case .A:
            return 4
        case .D:
            return 9
        case .G:
            return 14
        case .B:
            return 18
        case .e:
            return 23
        }
    }
}
