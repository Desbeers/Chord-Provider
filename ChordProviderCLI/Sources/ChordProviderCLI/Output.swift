//
//  Output.swift
//  chordprovider
//
//  Created by Nick Berendsen on 17/08/2025.
//

import Foundation
import ArgumentParser

enum OutputFormat: String, ExpressibleByArgument {
    init?(argument: String) {
        switch argument.lowercased() {
        case "json":
            self = .json
        case "source":
            self = .source
        case "html":
            self = .html
        default:
            return nil
        }
    }
    case json
    case source
    case html
}
