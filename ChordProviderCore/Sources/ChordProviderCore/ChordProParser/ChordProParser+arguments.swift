//
//  ChordProParser+arguments.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Convert arguments to a single string
    /// - Parameter line: The line with arguments
    /// - Returns: A single string with arguments
    public static func argumentsToString(_ line: Song.Section.Line) -> String? {
        /// Return a simple argument (no `key=value` as a plain string
        if let plain = line.plain {
            return "\(plain)"
        } else if let arguments = line.arguments {
            /// Go to all `key=value` items, skipping .plain and source (that should not be there anyway)
            var string: [String] = []
            for key in arguments.keys.sorted(by: <) where key != .plain && key != .source {
                if let value = arguments[key] {
                    string.append("\(key)=\"\(value)\"")
                }
            }
            return string.isEmpty ? nil : "\(string.joined(separator: " "))"
        }
        /// Nothing found
        return nil
    }

    /// Convert an argument string into arguments
    /// - Parameters:
    ///   - parsedArgument: The parsed argument string
    ///   - currentSection: The current section of the song; this is to add optional warnings
    /// - Returns: The arguments in a dictionary
    static func stringToArguments(
        _ parsedArgument: String?,
        currentSection: inout Song.Section
    ) -> ChordProParser.DirectiveArguments {
        var arguments = DirectiveArguments()
        /// Check if the label contains formatting attributes; skip html tags and http links
        if
            let parsedArgument,
            parsedArgument.contains("="),
            !parsedArgument.contains("<")
            //!parsedArgument.contains("http")
        {
            let attributes = parsedArgument.matches(of: ChordPro.RegexDefinitions.formattingAttributes)
            /// Map the attributes in a dictionary
            arguments = attributes.reduce(into: DirectiveArguments()) {
                if let argument = ChordPro.Directive.FormattingAttribute(rawValue: $1.1.lowercased()) {
                    var value = $1.2
                    if value.first != "\"" || value.last != "\"" {
                        currentSection.addWarning("Missing brackets around <b>\(value)</b>")
                    }
                    value.replace("\"", with: "")
                    $0[argument] = value
                } else {
                    currentSection.addWarning("Unknown <i>key</i>: <b>\($1.1)</b>")
                }
            }
        } else {
            /// Set the argument as simply *plain*
            /// - Note: Later, this will be moved to its own part of a line because it is not a *real* argument
            arguments[.plain] = parsedArgument
        }
        return arguments
    }
}
