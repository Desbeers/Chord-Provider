//
//  Utils.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import RegexBuilder

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

    /// Get text flush from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The text flush alignment
    static func getTextFlush(_ arguments: ChordProParser.DirectiveArguments?) -> Alignment {
        if let flush = arguments?[.flush] {
            switch flush {
            case "center":
                return .center
            case "right":
                return .end
            default:
                return .start
            }
        }
        /// Use the align argument by default
        return getAlign(arguments)
    }

    static func convertSimpleLinks(_ content: String) -> String {
        let link = Regex {
            Regex {
                "http"
                Optionally { "s" }
                "://"
                OneOrMore {
                    CharacterClass(
                        ("A"..."Z"),
                        ("a"..."z"),
                        .digit,
                        .anyOf(":/?&=%._~-#@!$'*+,;")
                    )
                }
            }
        }
        var content = content
        /// Convert simple links
        if !content.contains("<"), content.contains("http") {
            let matches = content.matches(of: link)
            for match in matches {
                content = content.replacingOccurrences(of: match.0, with: "<a href=\"\(match.0)\">\(match.0)</a>")
            }
        }
        return content
    }
}
