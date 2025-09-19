//
//  PDFBuild+arguments.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import ChordProviderCore

extension PDFBuild {

    /// Get the optional alignment from directive arguments
    /// - Parameter arguments: The directive argument
    /// - Returns: The alignment, `.left` if not set
    static func getAlign(_ arguments: ChordProParser.DirectiveArguments?) -> NSTextAlignment {
        if let align = arguments?[.align] {
            switch align {
            case "center":
                return .center
            case "right":
                return .right
            default:
                return .left
            }
        }
        return .left
    }

    /// Get the optional flush from the arguments
    /// - Parameter arguments: The arguments of the directive
    /// - Returns: The flush
    static func getFlush(_ arguments: ChordProParser.DirectiveArguments?) -> NSTextAlignment {
        if let flush = arguments?[.flush] {
            switch flush {
            case "center":
                return .center
            case "right":
                return .right
            default:
                return .left
            }
        }
        return .left
    }
}
