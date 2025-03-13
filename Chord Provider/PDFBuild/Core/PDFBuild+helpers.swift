////
////  PDFBuild+helpers.swift
////  Chord Provider
////
////  Created by Nick Berendsen on 13/03/2025.
////
//
//import AppKit
//
//extension PDFBuild {
//
//    /// Get alignment from the arguments
//    /// - Parameter arguments: The arguments of the directive
//    /// - Returns: The alignment
//    func getAlign(_ arguments: ChordProParser.Arguments?) -> NSTextAlignment {
//        if let align = arguments?[.align] {
//            switch align {
//            case "center":
//                return .center
//            case "right":
//                return .right
//            default:
//                return .left
//            }
//        }
//        return .left
//    }
//
//    /// Get flush from the arguments
//    /// - Parameter arguments: The arguments of the directive
//    /// - Returns: The flush
//    func getFlush(_ arguments: ChordProParser.Arguments?) -> NSTextAlignment {
//        if let flush = arguments?[.flush] {
//            switch flush {
//            case "center":
//                return .center
//            case "right":
//                return .right
//            default:
//                return .left
//            }
//        }
//        return .left
//    }
//}
