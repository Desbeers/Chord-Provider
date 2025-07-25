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
                warning: currentSection.autoCreated ?? false ? false : true
            )
        }

        /// Update the current section
        currentSection.environment = directive.details.environment

        /// Remember the longest label for an environment
        /// - Note: Used in PDF output to calculate label offset
        if ChordPro.Directive.environmentDirectives.contains(directive) {
            let label = arguments[.label] ?? arguments[.plain] ?? directive.details.environment.label
            setLongestLabel(label: label, song: &song)
        }

        /// Set arguments
        var arguments = arguments

        /// Set the source
        let source = arguments[.source]
        /// Clear the passed source to avoid confusion with 'real' arguments
        arguments[.source] = nil

        /// Make a plain argument just plain
        var plain: String?
        if let plainArgument = arguments[.plain] {
            plain = plainArgument
            arguments[.plain] = nil
        }

        /// Add the single line
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            source: source ?? "ERROR, NO SOURCE GIVEN",
            directive: ChordPro.Directive.customDirectives.contains(directive) ? nil : directive,
            arguments: arguments.isEmpty ? nil : arguments,
            type: directive.details.lineType,
            context: directive.details.environment,
            plain: plain
        )
        if source == nil {
            line.addWarning("**CHORD PROVIDER** ERROR, NO SOURCE GIVEN")
        }
        /// Calculate the source
        line.calculateSource()


        /// Add optional warnings
        if let warnings = currentSection.warnings {
            for warning in warnings {
                line.addWarning(warning)
            }
        }

        /// Append the line
        currentSection.lines.append(line)

        /// Reset the warnings, there are handled now
        currentSection.resetWarnings()
    }
}
