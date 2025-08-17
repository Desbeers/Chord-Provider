//
//  Output.swift
//  chordprovider
//
//  Created by Nick Berendsen on 17/08/2025.
//

import Foundation
import ArgumentParser

enum Output: ExpressibleByArgument {
    init?(argument: String) {
        switch argument.lowercased() {
            case "json":
            self = .json
        case "source":
            self = .source
        default:
            return nil

        }
    }
    case json
    case source
}
