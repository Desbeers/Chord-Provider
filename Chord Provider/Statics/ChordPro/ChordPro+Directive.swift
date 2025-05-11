//
// ChordPro+Directive.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// The source of a directive
    ///
    /// The source is defined as `long|short`, eg: `start_of_chorus|soc`
    struct DirectiveSource: Equatable, Codable, ExpressibleByStringLiteral {
        /// The long version of the directive
        var long: String
        /// The short version of the directive
        var short: String
        /// Init the directive by splitting a string into *long* and *short* version
        init(stringLiteral: String) {
            let parts = stringLiteral.split(separator: "|")
            long = String(parts.first ?? "")
            short = String(parts.last ?? "")
        }
    }

    /// All the directives we know about
    static let directives = ChordPro.Directive.allCases.map(\.rawValue.long)

    // MARK: 'ChordPro' directives

    /// The directives Chord Provider supports
    enum Directive: DirectiveSource, CaseIterable, Identifiable, Codable {
        /// The ID of the directive
        var id: String {
            self.rawValue.long
        }
        /// The label of the directive
        var label: String {
            self.details.label
        }
        /// The directive as string
        var directive: String {
            self.rawValue.long
        }
        /// The icon of the directive
        var icon: String {
            self.details.icon
        }
        /// Bool if the directive is editable
        var editable: Bool {
            ChordPro.Directive.editableDirectives.contains(self)
        }
        /// The help for the directive
        var help: String {
            self.details.help
        }
        /// The button label of the directive
        var button: String {
            self.details.button
        }
        /// The environment of the directive
        var environment: ChordPro.Environment {
            self.details.environment
        }

        // MARK: Official directives

        /// # Meta-data directives

        /// This directive defines the title of the song
        case title = "title|t"
        /// This directive defines the sorting title of the song
        case sortTitle = "sorttitle"
        /// This directive defines a subtitle of the song
        case subtitle = "subtitle|st"
        /// This directive defines an artist
        case artist
        /// This directive defines the sorting of an artist
        case sortArtist = "sortartist"
        /// This directive defines a composer. Multiple composers can be specified using multiple directives
        case composer
        /// This directive defines an album this song occurs on
        case album
        /// The year this song was first published, as a four-digit number
        case year
        /// This directive specifies the key the song is written in
        case key
        /// This directive specifies a time signature
        case time
        /// This directive specifies the tempo in number of beats per minute for the song
        case tempo
        /// This directive specifies the capo setting for the song
        case capo
        /// This directive specifies the instrument setting for the song
        case instrument
        /// This directive defines a tag for the song
        case tag

        /// # Formatting directives

        /// This directive introduce a comment line
        case comment = "comment|c"
        /// Specifies the name of the file containing the image
        case image

        /// # Environment directives

        /// ## Chorus

        /// This directive indicates that the lines that follow form the song’s chorus
        case startOfChorus = "start_of_chorus|soc"
        /// This directive indicates the end of the chorus
        case endOfChorus = "end_of_chorus|eoc"
        /// This directive indicates that the song chorus must be played here
        case chorus

        /// ## Verse

        /// Specifies that the following lines form a verse of the song
        case startOfVerse = "start_of_verse|sov"
        /// Specifies the end of the verse
        case endOfVerse = "end_of_verse|eov"

        /// ## Bridge

        /// Specifies that the following lines form a bridge of the song
        case startOfBridge = "start_of_bridge|sob"
        /// Specifies the end of the bridge
        case endOfBridge = "end_of_bridge|eob"

        /// ## Tab

        /// This directive indicates that the lines that follow form a section of guitar TAB instructions
        case startOfTab = "start_of_tab|sot"
        /// This directive indicates the end of the tab
        case endOfTab = "end_of_tab|eot"

        /// ## Grid

        /// This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles
        case startOfGrid = "start_of_grid|sog"
        /// This directive indicates the end of the grid
        case endOfGrid = "end_of_grid|eog"

        /// ### Strum

        /// This directive indicates that the lines that follow defines a strum pattern
        case startOfStrum = "start_of_strum|sos"
        /// This directive indicates the end of the strum
        case endOfStrum = "end_of_strum|eos"

        /// # Delegated environment directives

        /// ## ABC

        /// This directive indicates that the lines that follow define a piece of music written in ABC music notation
        case startOfABC = "start_of_abc"
        /// This directive indicates the end of the ABC
        case endOfABC = "end_of_abc"

        /// ## Textblock

        /// This directive indicates that the lines that follow define a piece of text that is combined into a
        /// single object that can be placed as an image
        case startOfTextblock = "start_of_textblock"
        /// This directive indicates the end of the textblock
        case endOfTextblock = "end_of_textblock"

        /// # Chord diagrams

        /// This directive defines a chord in terms of fret/string positions and, optionally, finger settings
        case define

        // MARK: Output related directives

        /// This directive forces a new page to be generated at the place where it occurs in the song
        case newPage = "new_page|np"

        /// When printing songs in multiple columns, this directive forces printing to continue in the next column
        case columnBreak = "column_break|colb"

        // MARK: Custom metadata directives

        /// - Note: These are not *real* directives

        /// A comment in the source
        case sourceComment = "source_comment"
        /// A line that is inside an environment
        case environmentLine = "environment_line"
        /// An empty line
        case emptyLine = "empty_line"
        /// An unknown directive
        case unknown
    }
}
