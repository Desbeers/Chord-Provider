//
//  Utils.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

enum Utils {
    static func getAlign(_ arguments: ChordProParser.DirectiveArguments?) -> Alignment {
        if let align = arguments?[.align] {
            switch align {
            case "center":
                return .center
            case "right":
                return .end
            default:
                return .start
            }
        }
        return .start
    }
}
