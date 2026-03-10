//
//  Utils.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore
import RegexBuilder

/// General utils shared in the application
enum Utils {

    /// Get text alignment from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The text alignment
    static func getTextAlignment(_ arguments: ChordProParser.DirectiveArguments?) -> Alignment {
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
        return getTextAlignment(arguments)
    }

    /// Convert simple links to a full link
    /// - Parameter content: The string
    /// - Returns: A full link if the content has a simple link, else just the text
    static func convertSimpleLinks(_ content: String) -> String {
        if let url = URL(string: content),
            let host = url.host {
            let domain = host.replacingOccurrences(of: "^www\\.", with: "", options: .regularExpression)
            return "<a href=\"\(content)\">\(domain)</a>"
        } else {
            return content
        }
    }
}
