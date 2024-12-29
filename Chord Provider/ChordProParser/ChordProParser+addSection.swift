//
//  ChordProParser+addSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Add a complete section with a single directive in a line
    /// - Parameters:
    ///   - source: The optional source of the line; else it will be calculated
    ///   - sectionLabel: The optional override of the section label
    ///   - directive: The ``ChordPro/Directive`` to add to the line
    ///   - arguments: The optional arguments for the directive
    ///   - environment: The optional environment for the section; defaults to 'metadata`
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func addSection(
        source: String? = nil,
        sectionLabel: String? = nil,
        directive: ChordPro.Directive,
        arguments: Arguments,
        environment: ChordPro.Environment = .metadata,
        currentSection: inout Song.Section,
        song: inout Song
    ) {

        /// Preserve the optional warning in the current section
        let warning = currentSection.warning

        /// Close the current section if it has lines
        /// - Note: a new one will be created in that function
        if !currentSection.lines.isEmpty {
            closeSection(
                currentSection: &currentSection,
                song: &song
            )
        }

        /// Update the current section
        currentSection.environment = environment
        currentSection.label = sectionLabel ?? arguments[.plain] ?? arguments[.label] ?? directive.environment.label
        /// Set the arguments
        currentSection.arguments = arguments

        /// Calculate the source
        var calculatedSource = source ?? ""
        if source == nil {
            let label: String = argumentsToString(arguments) ?? ""
            calculatedSource = "{\(directive.rawValue.long)\(label.isEmpty ? "" : " \(label)")}"
        }

        /// Add the single line
        var line = Song.Section.Line(
            sourceLineNumber: song.lines,
            environment: directive.environment,
            directive: directive,
            arguments: arguments.isEmpty ? nil : arguments,
            source: calculatedSource
        )

        /// Add the optional warnings
        if let warning {
            line.addWarning(warning)
        }

        /// Append the line
        currentSection.lines.append(line)

        /// Close the section
        closeSection(
            currentSection: &currentSection,
            song: &song
        )

        /// Set the environment
        currentSection.environment = directive.environment
        /// Set the arguments
        currentSection.arguments = arguments
    }
}
