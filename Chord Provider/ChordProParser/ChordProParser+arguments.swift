//
//  ChordProParser+arguments.swift
//  Chord Provider
//
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Convert arguments to a single string
    /// - Parameter arguments: The arguments dictionary
    /// - Returns: A single string with arguments
    static func argumentsToString(_ arguments: ChordProParser.Arguments) -> String? {
        /// Return a simple argument (no `key=value` as a plain string
        if let plain = arguments[.plain] {
            return "\(plain)"
        }
        /// Go to all `key=value` items, skipping .plain
        var string: [String] = []
        for key in arguments.keys.sorted(by: <) where key != .plain {
            string.append("\(key)=\"\(arguments[key] ?? "Empty")\"")
        }
        return string.isEmpty ? nil : "\(string.joined(separator: " "))"
    }

    /// Convert an argument string into arguments
    /// - Parameters:
    ///   - parsedArgument: The parsed argument string
    ///   - currentSection: The current section of the song; this is to add optional warnings
    /// - Returns: The arguments in a dictionary
    static func stringToArguments(_ parsedArgument: String?, currentSection: inout Song.Section) -> ChordProParser.Arguments {
        var arguments = Arguments()
        /// Check if the label contains formatting attributes
        if let parsedArgument, parsedArgument.contains("="), !parsedArgument.starts(with: "http") {
            let attributes = parsedArgument.matches(of: RegexDefinitions.formattingAttributes)
            /// Map the attributes in a dictionary
            arguments = attributes.reduce(into: Arguments()) {
                if let argument = ChordPro.Directive.FormattingAttribute(rawValue: $1.1.lowercased()) {
                    var value = $1.2
                    if value.components(separatedBy: "\"").count < 3 {
                        currentSection.addWarning("Missing brackets around **\(value)**")
                    }
                    value = value.replacingOccurrences(of: "\"", with: "")
                    $0[argument] = value
                } else {
                    currentSection.addWarning("Unknown *key*: **\($1.1)**")
                }
            }
        } else if let parsedArgument {
            /// Set the default argument
            arguments[.plain] = parsedArgument
        }
        return arguments
    }
}
