//
//  String+extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension String: @retroactive Identifiable {

    /// Make a String identifiable
    public var id: Int {
        hash
    }
}

extension String {

    /// Remove prefixes from a String
    /// - Returns: A String with al optional prefixes removed
    func removePrefixes() -> String {
        let prefixes = AppSettings.load(id: .mainView).core.sortTokens
        let pattern = "^(\(prefixes.map { "\\Q" + $0 + "\\E" }.joined(separator: "|")))\\s"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }
        return String(self[range.upperBound...])
    }
}

extension String {

    func fromHTML(fontOptions: FontUtils.Options? = nil, scale: Double = 1, fontSize: Double = 12) -> AttributedString {
        var modifiedString = self
        /// Preserve whitespaces
        if modifiedString.first == " " {
            modifiedString = "&nbsp;" + modifiedString.dropFirst()
        }
        if modifiedString.last == " " {
            modifiedString = modifiedString.dropLast() + "&nbsp;"
        }
        // swiftlint:disable:next colon
        modifiedString = String(format:"<span style=\"font-family: '\(fontOptions?.font.familyName ?? "-apple-system")'; font-size: \((fontOptions?.size ?? fontSize) * scale)\">%@</span>", modifiedString)

        if let nsAttributedString = try? NSAttributedString(
            data: Data(modifiedString.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ), let attributedString = try? AttributedString(nsAttributedString, including: \.appKit) {
            return attributedString
        } else {
            return AttributedString(self)
        }
    }
}
