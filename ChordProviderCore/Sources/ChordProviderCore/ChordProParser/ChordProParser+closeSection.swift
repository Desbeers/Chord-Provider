//
//  ChordProParser+closeSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Close a section in the song
    /// - Note: This will open a new empty section as well
    /// - Parameters:
    ///   - directive: The closing directive
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    ///   - warning: Bool to add a warning that the section is not properly closed
    static func closeSection(
        directive: ChordPro.Directive,
        currentSection: inout Song.Section,
        song: inout Song,
        warning: Bool = false
    ) {
        let closingDirective = currentSection.environment.directives.close
        /// Add the closing directive for an automatic created environment or if a environment is not properly closed
        if currentSection.autoCreated ?? false || warning, let lastLineIndex = currentSection.lines.lastIndex(where: { $0.directive != .emptyLine }) {
            let line = Song.Section.Line(
                sourceLineNumber: -(currentSection.lines[lastLineIndex].sourceLineNumber + 1),
                source: "{\(directive.rawValue.long)}",
                sourceParsed: "{\(closingDirective.rawValue.long)}",
                directive: closingDirective,
                type: .environmentDirective,
                context: currentSection.environment
            )
            if warning {
                currentSection.lines[lastLineIndex].addWarning("The section is not properly closed with **{\(closingDirective.rawValue.long)}**")
            }
            currentSection.lines.insert(line, at: lastLineIndex + 1)
        } else {
            /// Just add the closing line
            var line = Song.Section.Line(
                sourceLineNumber: song.lines,
                source: "{\(directive.rawValue.long)}",
                sourceParsed: "{\(closingDirective.rawValue.long)}",
                directive: closingDirective,
                type: .environmentDirective,
                context: currentSection.environment
            )
            /// Add optional warnings
            if let warnings = currentSection.warnings {
                for warning in warnings {
                    line.addWarning(warning)
                }
            }
            if directive != closingDirective {
                line.addWarning("Wrong closing directive, it should be **{\(closingDirective.rawValue.long)}**")
            }
            currentSection.lines.append(line)
        }

        /// Clear any warnings in the section; they should be handled now
        currentSection.resetWarnings()

        /// Close the current section
        song.sections.append(currentSection)
        currentSection = Song.Section(id: song.sections.count + 1)
    }
}
