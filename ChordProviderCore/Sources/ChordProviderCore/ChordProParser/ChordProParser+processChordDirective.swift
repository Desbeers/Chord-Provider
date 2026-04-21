//
//  ChordProParser+processChordDirective.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a chord directive

    /// Process a chord
    /// - Parameters:
    ///   - arguments: The optional arguments for the directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    /// - Returns: The processed `chord` as String
    static func processChordDirective(
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        let chord = (arguments[.plain] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        /// Set the source
        let source = arguments[.source]
        /// A comment should be rendered as part of a line
        var line = Song.Section.Line(
            sourceLineNumber: song.totalLines,
            source: source ?? "No source given, this is an error",
            sourceParsed: "{\(ChordPro.Directive.chord.rawValue.long): \(chord.trimmingCharacters(in: .whitespaces))}",
            directive: ChordPro.Directive.chord,
            type: .chordDiagram,
            context: .chordDiagram
        )
        /// Try to find the definition
        var chordDefinition: ChordDefinition?
        do {
            chordDefinition = try ChordDefinition(definition: chord, kind: .customChord, instrument: song.settings.instrument)
            if let chordDefinition, !chordDefinition.validationWarnings.isEmpty {
                for warning in chordDefinition.validationWarnings {
                    currentSection.addWarning(warning.description)
                }
            }
        } catch {
            chordDefinition = processChord(chord: chord, line: &line, song: &song)
        }
        if let chordDefinition {
            let part = Song.Section.Line.Part(id: 0, chordDefinition: chordDefinition)
            line.parts = [part]
        }
        /// Check where the chord belongs
        if currentSection.environment == .none || currentSection.environment == .metadata {
            /// Check if previous section is also  chord diagram
            /// If so, add it to that section
            if song.sections.last?.environment == .chordDiagram,
                let sectionID = song.sections.lastIndex(where: { $0.lines.last?.parts != nil }),
                var lastLine = song.sections[sectionID].lines.last {
                let part = Song.Section.Line.Part(id: (lastLine.parts?.count ?? 0) + 1, chordDefinition: chordDefinition)
                lastLine.parts?.append(part)
                song.sections[sectionID].lines = [lastLine]
                line.parts = nil
            }
            if chord.isEmpty {
                currentSection.addWarning("The chord is empty")
            }
            addSection(
                directive: .chord,
                arguments: arguments,
                line: line,
                currentSection: &currentSection,
                song: &song
            )
            /// Set the environment to none again
            currentSection.environment = .none
        } else {
            /// A comment inside a section
            if let warnings = currentSection.warnings {
                for warning in warnings {
                    line.addWarning(warning, level: warning.level)
                }
            }
            if chord.isEmpty {
                line.addWarning("The comment is empty")
            }
            currentSection.lines.append(line)
            /// Clear any warnings
            currentSection.resetWarnings()
        }
    }
}
