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
        /// Grab the directive to handle if unknown or not complete
        let unparsedDirective = text.dropFirst().split(separator: " ").first ?? ""

        if let match = text.firstMatch(of: RegexDefinitions.directive) {
            let parsedDirective = match.1
            let parsedArgument = match.2
            /// Handle known directives
            if let directive = getDirective(parsedDirective.lowercased()) {
                /// Parse the arguments
                var arguments = stringToArguments(parsedArgument, currentSection: &currentSection)
                if directive.warning {
                    currentSection.addWarning(
                        "Short directive for <b>\(directive.directive.details.label)</b>; the long version is preferable"
                    )
                }
                /// Always use long directives
                let directive = directive.directive

                /// Get the optional arguments for a directive
                let optionalAttributes = directive.attributes

                if arguments[.plain] != nil, optionalAttributes.contains(.plain), text.starts(with: "{\(parsedDirective) ") {
                    currentSection.addWarning(
                        "It is preferable to use a colon <b>:</b> for a simple argument",
                        //"No need for a colon <b>:</b> for a simple argument",
                        level: .notice
                    )
                } else if arguments[.plain] != nil, !optionalAttributes.contains(.plain) {
                    currentSection.addWarning(
                        "It is always best to use the variant with explicit attribute\(optionalAttributes.count == 1 ? "" : "s")",
                        level: .notice
                    )
                } else if arguments[.plain] == nil, text.starts(with: "{\(parsedDirective): ") {
                    currentSection.addWarning(
                        "It is not recommended to use a colon <b>:</b> when the directive has attributes",
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
                        processComment(
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

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
                        currentSection.addWarning("<b>ABC</b> is not supported in the output")
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
                        closeSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .endOfChorus, .endOfVerse, .endOfBridge, .endOfGrid, .endOfABC, .endOfTextblock, .endOfStrum:
                        closeSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                        // MARK: Chord diagrams

                    case .define:
                        processDefine(
                            kind: song.settings.instrument.kind,
                            directive: .define,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .defineGuitar:
                        processDefine(
                            kind: .guitar,
                            directive: .defineGuitar,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .defineUkulele:
                        processDefine(
                            kind: .ukulele,
                            directive: .defineUkulele,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )

                    case .defineGuitalele:
                        processDefine(
                            kind: .guitalele,
                            directive: .defineGuitalele,
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
                        currentSection.addWarning("<b>\(directive.details.label)</b> directive is not supported")
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
                let warning = "\(unparsedDirective.isEmpty ? "This " : "<b>\(unparsedDirective)</b>") is an unknown directive"
                currentSection.addWarning(
                    warning,
                    level: .error
                )
                addSection(
                    directive: .unknown,
                    arguments: [.source: text],
                    currentSection: &currentSection,
                    song: &song
                )
            }
        } else {

            // MARK: Not a (complete) directive

            /// Add the unknown directive as a single line in a section
            let warning = "\(unparsedDirective.isEmpty ? "This " : "<b>\(unparsedDirective)</b>") is not a complete directive"
            currentSection.addWarning(
                warning,
                level: .error
            )
            addSection(
                directive: .unknown,
                arguments: [.source: text],
                currentSection: &currentSection,
                song: &song
            )
        }
    }
}
