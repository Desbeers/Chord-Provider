//
//  ChordProParser+processDirective.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Get the ``ChordPro/Directive`` from a `String`
    /// - Parameter directive: The directive as string
    /// - Returns: The optional directive with an optional warning if a 'short' directive is found
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
    ///   - currentSection: The current ``Song/Section``
    ///   - song: The whole ``Song``
    static func processDirective(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song
    ) {
        if let match = text.firstMatch(of: RegexDefinitions.directive) {
            let parsedDirective = match.1
            let parsedArgument = match.2

            if text.starts(with: "{\(parsedDirective):") {
                currentSection.addWarning("No need for a colon **:** in a directive")
            }

            let arguments = stringToArguments(parsedArgument, currentSection: &currentSection)

            /// Handle known directives
            if let directive = getDirective(parsedDirective.lowercased()) {

                if directive.warning {
                    currentSection.addWarning("Short directive for **\(directive.directive.label)**")
                }
                /// Always use long directives
                let directive = directive.directive

                if ChordPro.Directive.metadataDirectives.contains(directive) {

                    // MARK: Metadata directives

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
                        let tabs: [String] = currentSection.lines.map(\.arguments).compactMap { element -> String in
                            return element?[.plain] ?? "error"
                        }
                        if let maxLength = tabs.max(by: { $1.count > $0.count })?.count {
                            for index in currentSection.lines.indices {
                                let adjustedString = tabs[index] + String(repeating: " ", count: maxLength - tabs[index].count)
                                currentSection.lines[index].arguments?[.plain] = adjustedString
                            }
                        }
                        /// Add the directive as a single line in a section; this will close the current section
                        addSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )
                        currentSection.environment = .none

                    case .endOfChorus, .endOfVerse, .endOfBridge, .endOfGrid, .endOfABC, .endOfTextblock, .endOfStrum:
                        /// Add the directive as a single line in a section; this will close the current section
                        addSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )
                        currentSection.environment = .none

                        // MARK: Chord diagrams

                    case .define:
                        processDefine(arguments: arguments, currentSection: &currentSection, song: &song)

                        // MARK: Images

                    case .image:
                        addSection(
                            directive: directive,
                            arguments: arguments,
                            environment: .image,
                            currentSection: &currentSection,
                            song: &song
                        )

                        // MARK: Unsupported directives

                    default:
                        /// A known but unsupported directive
                        currentSection.addWarning("**\(directive.details.label)** is not supported")
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
