//
//  PDFBuild+arguments.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

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
