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
        let prefixes = AppSettings.load(id: .mainView).application.sortTokens
        let pattern = "^(\(prefixes.map { "\\Q" + $0 + "\\E" }.joined(separator: "|")))\\s"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }
        return String(self[range.upperBound...])
    }
}

extension String {

    /// Convert a String to Markdown
    /// - Parameters:
    ///   - fontOptions: The font options
    ///   - scale: The scale of the font
    /// - Returns: A formatted `AttributedString`
    func toMarkdown(fontOptions: ConfigOptions.FontOptions, scale: Double) -> AttributedString {
        guard var output = try? AttributedString(
            markdown: self,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible
            ),
            baseURL: nil) else {
            return AttributedString(stringLiteral: self)
        }

        let nsFont = fontOptions.nsFont(scale: scale)

        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = nsFont
        let listBullet = " •  "
        let headIndent = (listBullet as NSString).size(withAttributes: attributes).width

        /// Set the defaults
        output.font = nsFont
        output.foregroundColor = fontOptions.color.nsColor

        var isList: Bool = false

        for run in output.runs {

            // MARK: Inline Intents

            if let inlinePresentationIntent = run.inlinePresentationIntent {
                var attributeContainer = AttributeContainer()
                switch inlinePresentationIntent {
                case .stronglyEmphasized:
                    let bold = NSFontManager.shared.convert(nsFont, toHaveTrait: .boldFontMask)
                    attributeContainer.font = bold
                case .emphasized:
                    let italic = NSFontManager.shared.convert(nsFont, toHaveTrait: .italicFontMask)
                    attributeContainer.font = italic
                case .strikethrough:
                    attributeContainer.strikethroughStyle = .single
                    attributeContainer.appKit.strikethroughStyle = .single
                case .code:
                    let code = NSFont.monospacedSystemFont(ofSize: fontOptions.size * scale, weight: .regular)
                    attributeContainer.font = code
                default:
                    break
                }
                output[run.range].mergeAttributes(attributeContainer, mergePolicy: .keepNew)
            }

            // MARK: Link

            if run.link != nil {
                var attributeContainer = AttributeContainer()
                attributeContainer.swiftUI.foregroundColor = Color(NSColor.linkColor)
                output[run.range].mergeAttributes(attributeContainer, mergePolicy: .keepNew)
            }
        }

        // MARK: Block Intents

        for (intentBlock, intentRange) in output.runs[AttributeScopes.FoundationAttributes.PresentationIntentAttribute.self].reversed() {
            guard let intentBlock = intentBlock else { continue }
            for intent in intentBlock.components {
                switch intent.kind {
                case .header(let level):
                    let scale: Double = (Double(10 + (7 - level)) / 10) * scale
                    output[intentRange].appKit.font = fontOptions.nsFont(scale: scale)
                case .unorderedList:
                    var string = AttributedString(listBullet)
                    string.appKit.foregroundColor = fontOptions.color.nsColor
                    output.insert(string, at: intentRange.lowerBound)
                    isList = true
                default:
                    break
                }
            }
        }

        if isList {
            /// - Note: This only works for the PDF, *not* in the SwiftUI View
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = headIndent
            paragraphStyle.firstLineHeadIndent = 0
            output.paragraphStyle = paragraphStyle
        }
        return output
    }
}
