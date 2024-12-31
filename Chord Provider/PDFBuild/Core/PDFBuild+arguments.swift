//
//  PDFBuild+arguments.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    /// Get the optional alignment from directive arguments
    /// - Parameter arguments: The ``ChordProParser/Arguments``
    /// - Returns: The alignment, `.left` if not set
    static func getAlign(_ arguments: ChordProParser.Arguments?) -> NSTextAlignment {
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
}
