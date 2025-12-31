//
//  ChordProParser+processImage.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Process an image
    /// - Parameters:
    ///   - arguments: The directive arguments
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processImage(
        arguments: DirectiveArguments,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if !currentSection.lines.isEmpty && currentSection.autoCreated ?? false == false {
            /// An image inside a section, **Chord Provider** does not support that
            let source = arguments[.source] ?? "ERROR"
            var line = Song.Section.Line(
                sourceLineNumber: song.lines,
                source: source,
                directive: .image,
                arguments: arguments,
                context: .image
            )
            line.calculateSource()
            line.addWarning("Images inside a <b>\(currentSection.environment.rawValue)</b> section is not supported")
            currentSection.lines.append(line)
        } else {
            /// An image in its own section
            addSection(
                directive: .image,
                arguments: arguments,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
