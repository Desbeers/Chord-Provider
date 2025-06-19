//
//  ChordProParser+openSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Open a new section in the song
    /// - Parameters:
    ///   - directive: The ``ChordPro/Directive`` to add to the line
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func openSection(
        directive: ChordPro.Directive,
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {

        /// Close the current section if it has lines and give it a warning if the environment is not auto-created
        /// - Note: a new section will be created in that function
        if !currentSection.lines.isEmpty {
            closeSection(
                directive: currentSection.environment.directives.close,
                currentSection: &currentSection,
                song: &song,
                warning: currentSection.autoCreated ? false : true
            )
        }

        /// Update the current section
        currentSection.environment = directive.details.environment

        /// Remember the longest label for an environment
        /// - Note: Used in PDF output to calculate label offset
        if ChordPro.Directive.environmentDirectives.contains(directive) {
            let label = arguments[.label] ?? arguments[.plain] ?? directive.details.environment.label
            if label.count > song.metadata.longestLabel.count {
                song.metadata.longestLabel = label
            }
        }

        /// Calculate the source if not set
        var source = arguments[.source]
        if source == nil {
            let argumentsString: String = argumentsToString(arguments) ?? ""
            source = "{\(directive.rawValue.long)\(argumentsString.isEmpty ? "" : " \(argumentsString)")}"
        }

        var arguments = arguments
        /// Clear the (optional) passed source to avoid confusion with 'real' arguments
        arguments[.source] = nil
        /// Set the default label (if not empty) if there are no arguments
        if arguments.isEmpty, !directive.details.environment.label.isEmpty {
            arguments[.plain] = directive.details.environment.label
        }

        /// Add the single line
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            directive: directive,
            arguments: arguments.isEmpty ? nil : arguments,
            source: source ?? "",
            plain: arguments[.plain] ?? ""
        )

        /// Add optional warnings
        if let warnings = currentSection.warnings {
            for warning in warnings {
                line.addWarning(warning)
            }
        }

        /// Append the line
        currentSection.lines.append(line)
    }
}
