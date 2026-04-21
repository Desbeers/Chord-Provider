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
    static func getDirective(_ directive: String) -> (directive: ChordPro.Directive, short: Bool)? {
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
                /// Warn for short directive
                if directive.short {
                    currentSection.addWarning(
                        "Short directive for <b>\(directive.directive.details.label)</b>; the long version is preferable"
                    )
                }
                let directive = directive.directive
                /// Parse the arguments
                let directiveArguments = stringToArguments(parsedArgument)
                var arguments = directiveArguments.arguments
                /// Keep the original source
                arguments[.source] = text

                /// Get the array of optional arguments for a directive
                let optionalAttributes = directive.attributes

                if optionalAttributes == [.plain], arguments[.haveAttributes] != nil {
                    currentSection.addWarning(
                        "Attributes are not supported for <b>\(directive)</b>",
                        level: .error
                    )
                    addSection(
                        directive: directive,
                        arguments: arguments,
                        currentSection: &currentSection,
                        song: &song
                    )
                    /// Fatal, nothing else to do here
                    return
                } else if arguments[.plain] != nil, optionalAttributes.contains(.plain), text.starts(with: "{\(parsedDirective) ") {
                    currentSection.addWarning(
                        "It is preferable to use a colon <b>:</b> for a simple argument",
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
                /// Remove the attributes check
                arguments[.haveAttributes] = nil

                if ChordPro.Directive.metadataDirectives.contains(directive) {

                    // MARK: Metadata directives

                    /// Process metadata
                    if arguments[.plain] != nil {
                        processMetadata(directive: directive, arguments: arguments, currentSection: &currentSection, song: &song)
                    } else {
                        currentSection.addWarning(
                            "Metadata <b>\(directive.details.label)</b> has no value",
                            level: .error
                        )
                        addSection(
                            directive: directive,
                            arguments: arguments,
                            currentSection: &currentSection,
                            song: &song
                        )
                        return
                    }
                } else if !getOnlyMetadata {
                    /// Add optional arguments warnings
                    /// - Note: Metadata cannot have arguments
                    for warning in directiveArguments.warnings {
                        currentSection.addWarning(
                            warning,
                            level: .notice
                        )
                    }
                    /// All other directives
                    switch directive {

                        // MARK: Formatting directives

                    case .comment, .highlight:
                        processComment(
                            directive: directive,
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

                        /// ## Start of ABC, Lilipound, SVG
                    case .startOfABC, .startOfLy, .startOfSvg:
                        currentSection.addWarning("The <b>\(directive.details.buttonLabel ?? "")</b> environment is not supported in <i>Chord Provider</i>")
                        openSection(
                            directive: directive,
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

                    case .endOfChorus, .endOfVerse, .endOfBridge, .endOfGrid, .endOfABC, .endOfTextblock, .endOfStrum, .endOfLy, .endOfSvg:
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

                    case .chord:
                        processChordDirective(
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
                        currentSection.addWarning("The <b>\(directive.details.label)</b> directive is not supported in <i>Chord Provider</i>")
                        addSection(
                            directive: .unknown,
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
