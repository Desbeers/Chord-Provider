//
//  ChordProParser+arguments.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
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
        }
        if let arguments = line.arguments {
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
    ///   - directive: The ``ChordPro/Directive`` that has the arguments
    ///   - parsedArgument: The arguments as string
    /// - Returns: The arguments in a dictionary and optional warnings
    static func stringToArguments(
        _ directive: ChordPro.Directive,
        _ parsedArgument: String?,
    ) -> (arguments: ChordProParser.DirectiveArguments, warnings: [LogUtils.LogEntrance]) {
        var arguments = DirectiveArguments()
        var warnings: [LogUtils.LogEntrance] = []
        /// Check if the label contains formatting attributes; skip html tags
        if
            let parsedArgument,
            parsedArgument.contains("="),
            !parsedArgument.contains("<"),
            !parsedArgument.contains("://")
        {
            let attributes = parsedArgument.matches(of: RegexDefinitions.formattingAttributes)
            // Map the attributes in a dictionary
            arguments = attributes.reduce(into: DirectiveArguments()) { directiveArguments, output in
                if let argument = ChordPro.Directive.FormattingAttribute(rawValue: output.1.lowercased()) {
                    var value = output.2
                    if value.first != "\"" || value.last != "\"" {
                        warnings.append(
                            LogUtils.LogEntrance(
                                level: .warning,
                                message: "Missing brackets around <b>\(value)</b>"
                            )
                        )
                    }
                    value.replace("\"", with: "")
                    if !directive.attributes.contains(argument) {
                        warnings.append(
                            LogUtils.LogEntrance(
                                level: .warning,
                                message: "<b>\(argument)</b> is an unknown argument and will be ignored"
                            )
                        )
                    }
                    directiveArguments[argument] = value
                    arguments[.haveAttributes] = "true"
                } else {
                    warnings.append(
                        LogUtils.LogEntrance(
                            level: .warning,
                            message: "<b>\(output.1)</b> is an unknown argument and will be ignored"
                        )
                    )
                }
            }
        } else {
            /// Set the argument as simply *plain*
            /// - Note: Later, this will be moved to its own part of a line because it is not a *real* argument
            arguments[.plain] = parsedArgument
        }
        return (arguments, warnings)
    }
}
