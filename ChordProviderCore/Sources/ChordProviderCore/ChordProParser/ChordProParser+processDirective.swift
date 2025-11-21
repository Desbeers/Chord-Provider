//
//  ChordProParser+processDirective.swift
//  ChordProviderCore
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
    ///   - getOnlyMetadata: Bool to get only metadata of the song
    static func processDirective(
        text: String,
        currentSection: inout Song.Section,
        song: inout Song,
        getOnlyMetadata: Bool
    ) {
        /// Keep the current text as source when we cannot handle the directive
        let sourceArgument: DirectiveArguments = [.source: text]

        if let match = text.firstMatch(of: Chord.RegexDefinitions.directive) {
            let parsedDirective = match.1
            let parsedArgument = match.2

            /// Handle known directives
            if let directive = getDirective(parsedDirective.lowercased()) {

                var arguments = stringToArguments(parsedArgument, currentSection: &currentSection)

                if directive.warning {
                    currentSection.addWarning("Short directive for **\(directive.directive.details.label)**; long is preferrable")
                }
                /// Always use long directives
                let directive = directive.directive

                if arguments[.plain] != nil, text.starts(with: "{\(parsedDirective):") {
                    currentSection.addWarning(
                        "No need for a colon **:** for a simple argument",
                        level: .notice
                    )
                }
                /// Keep the original source
                arguments[.source] = text

                if ChordPro.Directive.metadataDirectives.contains(directive) {

                    // MARK: Metadata directives

                    /// Process metadata
                    processMetadata(directive: directive, arguments: arguments, currentSection: &currentSection, song: &song)
                } else if !getOnlyMetadata {
                    /// All other directives
                    switch directive {

                        // MARK: Formatting directives

                    case .comment:
                        processComment(arguments: arguments, currentSection: &currentSection, song: &song)

                        // MARK: Environment directives

                        /// ## Start of Chorus, Verse, Bridge, Tab, Grid, Textblock, Strum
                    case .startOfChorus, .startOfVerse, .startOfBridge, .startOfTab, .startOfGrid, .startOfTextblock, .startOfStrum:

                        if let label = arguments[.plain] {
                            arguments[.label] = label
                            arguments[.plain] = nil
                        }
                        openSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                        /// ## Repeat Chorus
                    case .chorus:
                        addSection(
                            directive: directive,
                            arguments: arguments,
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
                            for index in currentSection.lines.indices where currentSection.lines[index].type == .songLine {
                                let adjustedString = tabs[index] + String(repeating: " ", count: maxLength - tabs[index].count)
                                currentSection.lines[index].arguments?[.plain] = adjustedString
                            }
                        }
                        closeSection(directive: directive, currentSection: &currentSection, song: &song)

                    case .endOfChorus, .endOfVerse, .endOfBridge, .endOfGrid, .endOfABC, .endOfTextblock, .endOfStrum:
                        closeSection(directive: directive, currentSection: &currentSection, song: &song)

                        // MARK: Chord diagrams

                    case .define:
                        processDefine(arguments: arguments, currentSection: &currentSection, song: &song)

                    case .defineGuitar:
                        processDefine(
                            instrument: .guitar,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .defineUkulele:
                        processDefine(
                            instrument: .ukulele,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .defineGuitalele:
                        processDefine(
                            instrument: .guitalele,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                        // MARK: Images

                    case .image:
                        processImage(arguments: arguments, currentSection: &currentSection, song: &song)

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
                currentSection.addWarning(
                    "This is an unknown directive",
                    level: .error
                )
                addSection(
                    directive: .unknown,
                    arguments: sourceArgument,
                    currentSection: &currentSection,
                    song: &song
                )
            }
        } else {

            // MARK: Not a (complete) directive

            /// Add the unknown directive as a single line in a section
            currentSection.addWarning(
                "This is not a complete directive",
                level: .error
            )
            addSection(
                directive: .unknown,
                arguments: sourceArgument,
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
