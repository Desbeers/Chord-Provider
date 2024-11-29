//
//  ChordProParser.processDirective.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    static func getDirective(_ directive: String) -> (directive: ChordPro.Directive, warning: Bool)? {
        if let longDirective = ChordPro.Directive.allCases.first(where: { $0.rawValue.long == directive }) {
            return (longDirective, false)
        } else if let shortDirective = ChordPro.Directive.allCases.first(where: { $0.rawValue.short == directive }) {
            return (shortDirective, true)
        } else {
            return nil
        }
    }

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
            let parsedArgument = match.2

            var arguments = Arguments()
            /// Check if the label contains formatting attributes
            /// - Note: This will remove the default argument
            if let parsedArgument, parsedArgument.contains("=") {
                let attributes = parsedArgument.matches(of: RegexDefinitions.formattingAttributes)
                /// Map the attributes in a dictionary
                arguments = attributes.reduce(into: Arguments()) {
                    $0[$1.1] = $1.2
                }
            } else if let parsedArgument {
                /// Set the default argument
                arguments[.plain] = parsedArgument
            }

            /// Handle known directives
            if let directive = getDirective(parsedDirective.lowercased()) {

                if directive.warning {
                    currentSection.addWarning("Short directive for **\(directive.directive.label)**")
                }
                /// Always use long directives
                let directive = directive.directive

                if ChordPro.Directive.metadataDirectives.contains(directive) {

                    // MARK: Formatting directives

                    /// Process metadata
                    processMetadata(directive: directive, arguments: arguments, currentSection: &currentSection, song: &song)
                } else {
                    /// All other directives
                    switch directive {

                        // MARK: Formatting directives

                    case .comment:
                        processComment(arguments: arguments, currentSection: &currentSection, song: &song)

                        // MARK: Environment directives

                        /// ## Start of Chorus, Verse, Bridge, Tab, Grid, Textblock, Strum
                    case .startOfChorus, .startOfVerse, .startOfBridge, .startOfTab, .startOfGrid, .startOfTextblock, .startOfStrum:
                        openSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                        /// ## Repeat Chorus
                    case .chorus:
                        /// Add the directive as a single line in a section
                        addSection(
                            /// - Note: Use the 'normal' chorus label because this directive can be replaced by a whole chorus with the same name
                            sectionLabel: arguments[.plain] ?? ChordPro.Environment.chorus.label,
                            directive: .chorus,
                            arguments: arguments,
                            environment: .repeatChorus,
                            currentSection: &currentSection,
                            song: &song
                        )

                        /// ## Start of ABC
                    case .startOfABC:
                        currentSection.addWarning("**ABC** is not supported in the output")
                        openSection(
                            directive: .startOfABC,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                        /// # End of environment

                    case .endOfTab:
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
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .endOfChorus, .endOfVerse, .endOfBridge, .endOfGrid, .endOfABC, .endOfTextblock, .endOfStrum:
                        /// Add the directive as a single line in a section; this will close the current section
                        addSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                        // MARK: Chord diagrams

                    case .define:
                        processDefine(arguments: arguments, currentSection: &currentSection, song: &song)

                        // MARK: Unsupported directives

                    default:
                        /// A known but unsupported directive
                        currentSection.addWarning("**\(directive.rawValue.long)** is not supported")
                        addSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )
                    }
                }
            } else {

                // MARK: Unknown directive

                /// Add the unknown directive as a single line in a section
                currentSection.addWarning("Unknown directive")
                addSection(
                    source: text,
                    directive: .unknown,
                    arguments: arguments,
                    currentSection: &currentSection,
                    song: &song
                )
            }
        } else {

            // MARK: Not a (complete) directive

            /// Add the unknown directive as a single line in a section
            currentSection.addWarning("Not a complete directive")
            addSection(
                source: text,
                directive: .unknown,
                arguments: Arguments(),
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
