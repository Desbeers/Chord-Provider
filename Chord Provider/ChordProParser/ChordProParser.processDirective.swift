//
//  ChordProParser.processDirective.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a directive

    /// Process a directive
    /// - Parameters:
    ///   - text: The text to process
    ///   - song: The `Song`
    ///   - currentSection: The current `section` of the `song`
    static func processDirective(
        text: String,
        song: inout Song,
        currentSection: inout Song.Section
    ) {
        if let match = text.firstMatch(of: RegexDefinitions.directive) {
            let parsedDirective = match.1
            var label = match.2
            /// Check if the label contains arguments
            if let attributes = label?.matches(of: RegexDefinitions.arguments) {
                for attribute in attributes where attribute.output.1 == .label {
                    label = attribute.output.2
                }
            }
            /// Handle known directives
            if let directive = ChordPro.Directive(rawValue: parsedDirective.lowercased()) {

                if directive != directive.shortToLong {
                    currentSection.warning = "Short directive for **\(directive.label)**"
                }

                let directive = directive.shortToLong

                /// Process metadata
                if ChordPro.Directive.metadataDirectives.contains(directive) {
                    processMetadata(directive: directive, label: label, currentSection: &currentSection, song: &song)
                }

                switch directive {

                    // MARK: Formatting directives

                case .c, .comment:
                    if let label {
                        processComment(comment: label, currentSection: &currentSection, song: &song)
                    }

                    // MARK: Environment directives

                    /// ## Start of Chorus
                case .soc, .startOfChorus:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.chorus.label,
                        directive: .startOfChorus,
                        directiveLabel: label,
                        environment: .chorus,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Repeat Chorus
                case .chorus:
                    /// Add the directive as a single line in a section
                    addSection(
                        /// - Note: Use the 'normal' chorus label because this directive can be replaced by a whole chorus with the same name
                        sectionLabel: label ?? ChordPro.Environment.chorus.label,
                        directive: .chorus,
                        directiveLabel: label,
                        environment: .repeatChorus,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Start of Verse
                case .sov, .startOfVerse:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.verse.label,
                        directive: .startOfVerse,
                        directiveLabel: label,
                        environment: .verse,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Start of Bridge
                case .sob, .startOfBridge:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.bridge.label,
                        directive: .startOfBridge,
                        directiveLabel: label,
                        environment: .bridge,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Start of Tab
                case .sot, .startOfTab:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.tab.label,
                        directive: .startOfTab,
                        directiveLabel: label,
                        environment: .tab,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Start of Grid
                case .sog, .startOfGrid:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.grid.label,
                        directive: .startOfGrid,
                        directiveLabel: label,
                        environment: .grid,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Start of Textblock
                case .startOfTextblock:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.textblock.label,
                        directive: .startOfTextblock,
                        directiveLabel: label,
                        environment: .textblock,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// ## Start of Strum (custom)
                case .sos, .startOfStrum:
                    openSection(
                        sectionLabel: label ?? ChordPro.Environment.strum.label,
                        directive: .startOfStrum,
                        directiveLabel: label,
                        environment: .strum,
                        currentSection: &currentSection,
                        song: &song
                    )

                    /// # End of environment

                case .eot, .endOfTab:
                    /// Make sure tab lines have the same length because of scaling
                    let tabs = currentSection.lines.map(\.argument)
                    if let maxLength = tabs.max(by: { $1.count > $0.count })?.count {
                        for index in currentSection.lines.indices {
                            currentSection.lines[index].argument += String(repeating: " ", count: maxLength - currentSection.lines[index].argument.count)
                        }
                    }
                    /// Add the directive as a single line in a section; this will close the current section
                    addSection(
                        directive: directive,
                        environment: .metadata,
                        currentSection: &currentSection,
                        song: &song
                    )

                case .eoc, .endOfChorus, .eov, .endOfVerse, .eob, .endOfBridge, .eog, .endOfGrid, .eos, .endOfTextblock, .endOfStrum:
                    /// Add the directive as a single line in a section; this will close the current section
                    addSection(
                        directive: directive,
                        environment: .metadata,
                        currentSection: &currentSection,
                        song: &song
                    )

                    // MARK: Chord diagrams

                case .define:
                    if let label {
                        processDefine(label: label, currentSection: &currentSection, song: &song)
                    }
                default:
                    break
                }
            } else {

                // MARK: Unknown directive

                /// Add the unknown directive as a single line in a section
                currentSection.warning = "Unknown directive"
                addSection(
                    sectionLabel: label,
                    directive: .unknownDirective,
                    directiveLabel: label,
                    environment: .metadata,
                    currentSection: &currentSection,
                    song: &song
                )
            }
        } else {

            // MARK: Not a (complete) directive

            /// Add the unknown directive as a single line in a section
            currentSection.warning = "Not a complete directive"
            addSection(
                directive: .unknownDirective,
                environment: .metadata,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
