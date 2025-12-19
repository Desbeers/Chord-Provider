//
//  ChordPro+LineType+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordPro.LineType {

    /// The SF symbol of the line type
    var sfSymbol: String {
        switch self {
        case .songLine:
            "lines.measurement.vertical"
        case .emptyLine:
            "pause"
        case .metadata:
            "info"
        case .comment:
            "text.bubble"
        case .sourceComment:
            "bubble"
        case .unknown:
            "questionmark"
        case .environmentDirective:
            "arrowshape.left.arrowshape.right"
        }
    }
}
