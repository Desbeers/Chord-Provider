//
//  Song+Section+Line+codable.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Custom codable implementation
extension Song.Section.Line {
    /// :nodoc:
    enum CodingKeys: CodingKey {
        case sourceLineNumber
        case directive
        case arguments
        case source
        case sourceParsed
        case lineLength
        case warnings
        case parts
        case grid
        case strums
        case plain
        case type
        case context
    }
    /// :nodoc:
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        /// Decode an optional directive string to a ``ChordPro/Directive``
        if let directive = try container.decodeIfPresent(String.self, forKey: .directive) {
            self.directive = ChordProParser.getDirective(directive)?.directive
        } else {
            self.directive = nil
        }

        /// Decode the context string to a ``ChordPro/Environment``
        let context = try container.decode(String.self, forKey: .context)
        self.context = ChordPro.Environment(rawValue: context) ?? .none

        /// Decode a type string to a ``Song/Section/Line/LineType``
        let type = try container.decode(String.self, forKey: .type)
        self.type = ChordPro.LineType(rawValue: type) ?? .unknown

        /// Decode the arguments dictionary into `[String: String]`
        if let stringDictionary = try container.decodeIfPresent([String: String].self, forKey: .arguments) {
            var enumDictionary: [ChordPro.Directive.FormattingAttribute: String] = [:]
            for (stringKey, value) in stringDictionary {
                guard let key = ChordPro.Directive.FormattingAttribute(rawValue: stringKey) else {
                    return
                }
                enumDictionary[key] = value
            }
            self.arguments = enumDictionary
        } else {
            self.arguments = nil
        }

        self.sourceLineNumber = try container.decode(Int.self, forKey: .sourceLineNumber)
        self.source = try container.decode(String.self, forKey: .source)
        self.sourceParsed = try container.decode(String.self, forKey: .sourceParsed)
        self.lineLength = try container.decodeIfPresent(String.self, forKey: .lineLength)
        self.warnings = try container.decodeIfPresent([LogUtils.LogMessage].self, forKey: .warnings)
        self.parts = try container.decodeIfPresent([Song.Section.Line.Part].self, forKey: .parts)
        self.grid = try container.decodeIfPresent([Song.Section.Line.Grid].self, forKey: .grid)
        self.strums = try container.decodeIfPresent([Strums].self, forKey: .strums)
        self.plain = try container.decodeIfPresent(String.self, forKey: .plain)
    }
    /// :nodoc:
    public func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.sourceLineNumber, forKey: .sourceLineNumber)

        /// Encode an optional directive ``ChordPro/Directive`` to a String
        try container.encodeIfPresent(self.directive?.rawValue.long, forKey: .directive)

        /// Encode a type ``ChordPro/LineType`` to a String
        try container.encode(self.type, forKey: .type)

        /// Encode arguments into a ``ChordProParser/DirectiveArguments`` dictionary
        var stringDictionary: [String: String]?
        if let arguments = self.arguments {
            stringDictionary = Dictionary(
                uniqueKeysWithValues: arguments.map { ($0.rawValue, $1) }
            )
        }
        try container.encodeIfPresent(stringDictionary, forKey: .arguments)

        /// Encode an optional context ``ChordPro/Environment`` to a String
        try container.encode(self.context.rawValue, forKey: .context)

        try container.encode(self.source, forKey: .source)
        try container.encode(self.sourceParsed, forKey: .sourceParsed)
        try container.encodeIfPresent(self.lineLength, forKey: .lineLength)
        try container.encodeIfPresent(self.warnings, forKey: .warnings)
        try container.encodeIfPresent(self.parts, forKey: .parts)
        try container.encodeIfPresent(self.grid, forKey: .grid)
        try container.encodeIfPresent(self.strums, forKey: .strums)
        try container.encodeIfPresent(self.plain, forKey: .plain)
    }
}
