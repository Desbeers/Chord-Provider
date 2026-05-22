//
// ChordPro+Directive.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// The source of a directive
    ///
    /// The source is defined as `long|short`, eg: `start_of_chorus|soc`
    public struct DirectiveSource: Equatable, Codable, ExpressibleByStringLiteral {
        /// The long version of the directive
        public var long: String
        /// The short version of the directive
        public var short: String
        /// Init the directive by splitting a string into *long* and *short* version
        public init(stringLiteral directive: String) {
            let parts = directive.split(separator: "|")
            long = String(parts.first ?? "")
            short = String(parts.last ?? "")
        }
    }

    /// All the directives we know about
    /// - Note: **ChordPro** has more official directives
    public static let knownDirectives = ChordPro.Directive.allCases.map(\.source.long)

    // MARK: 'ChordPro' directives

    /// The directives Chord Provider supports
    public enum Directive: Identifiable, Codable, Sendable, Equatable {
        /// The ID of the directive
        public var id: String {
            source.long
        }
        /// Bool if the directive is editable
        public var editable: Bool {
            ChordPro.Directive.editableDirectives.contains(self)
        }

        // MARK: Official directives

        /// # Meta-data directives

        /// This directive defines the title of the song
        case title
        /// This directive defines the sorting title of the song
        case sortTitle
        /// This directive defines a subtitle of the song
        case subtitle
        /// This directive defines an artist
        case artist
        /// This directive defines the sorting of an artist
        case sortArtist
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
        /// Copyright information for the song
        case copyright
        /// This directive specifies the duration of the song
        case duration
        /// This directive defines the arranger of the song
        case arranger
        /// This directive defines the writer of the lyrics of the song
        case lyricist
        /// This directive defines a meta-data item
        case meta

        /// # Formatting directives

        /// This directive introduce a comment line
        case comment
        /// This directive introduce a comment line using an italic typeface
        case commentItalic
        /// This directive introduce a comment line with a box around the text
        case commentBox
        /// This is an alternative to comment
        case highlight
        /// Specifies the name of the file containing the image
        case image

        /// # Environment directives

        /// ## Chorus

        /// This directive indicates that the lines that follow form the song’s chorus
        case startOfChorus
        /// This directive indicates the end of the chorus
        case endOfChorus
        /// This directive indicates that the song chorus must be played here
        case chorus

        /// ## Verse

        /// Specifies that the following lines form a verse of the song
        case startOfVerse
        /// Specifies the end of the verse
        case endOfVerse

        /// ## Bridge

        /// Specifies that the following lines form a bridge of the song
        case startOfBridge
        /// Specifies the end of the bridge
        case endOfBridge

        /// ## Tab

        /// This directive indicates that the lines that follow form a section of guitar TAB instructions
        case startOfTab
        /// This directive indicates the end of the tab
        case endOfTab

        /// ## Grid

        /// This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles
        case startOfGrid
        /// This directive indicates the end of the grid
        case endOfGrid


        case startOfCustomEnvironment(name : String)
        case endOfCustomEnvironment(name : String)

        /// # Delegated environment directives

        /// ## ABC

        /// This directive indicates that the lines that follow define a piece of music written in ABC music notation
        case startOfABC
        /// This directive indicates the end of the ABC
        case endOfABC

        /// ## Textblock

        /// This directive indicates that the lines that follow define a piece of text that is combined into a
        /// single object that can be placed as an image
        case startOfTextblock
        /// This directive indicates the end of the textblock
        case endOfTextblock

        /// ## Lilipound

        /// Start of Lilipound embedding
        case startOfLy
        /// End of Lilipound embedding
        case endOfLy

        /// ## SVG

        /// Start of SVG embedding
        case startOfSvg
        /// End of SVG embedding
        case endOfSvg

        /// # Chord diagrams

        /// This directive defines a chord in terms of fret/string positions and,
        /// optionally, finger settings for a guitar
        case defineGuitar
        /// This directive defines a chord in terms of fret/string positions and, optionally,
        /// finger settings for a guitalele
        case defineGuitalele
        /// This directive defines a chord in terms of fret/string positions and, optionally,
        /// finger settings for a ukulele
        case defineUkulele
        /// This directive defines a chord in terms of fret/string positions and,
        /// optionally, finger settings
        case define
        /// This directive is similar to *define* but it only displays the chord diagram
        /// immediately in the song where the directive occurs
        case chord

        // MARK: Output related directives

        /// This directive forces a new page to be generated at the place where it occurs in the song
        case newPage

        /// When printing songs in multiple columns, this directive forces printing to continue in the next column
        case columnBreak

        // MARK: Transposition

        /// This directive indicates that the remainder of the song should be transposed
        /// the number of semitones according to the given value
        case transpose

        // MARK: Custom metadata directives

        /// - Note: These are not *real* directives

        /// A comment in the source
        case sourceComment
        /// An empty line
        case emptyLine
        /// An unknown directive
        case unknown
    }
}

extension ChordPro.Directive {
    public static let allCases: [ChordPro.Directive] = [
        // MARK: Meta-data directives
        .title, .sortTitle, .subtitle, .artist, .sortArtist, .composer,
        .album, .year, .key, .time, .tempo, .capo, .instrument, .tag,
        .copyright, .duration, .arranger, .lyricist, .meta,

        // MARK: Formatting directives
        .comment, .commentItalic, .commentBox, .highlight, .image,

        // MARK: Environment directives
        .startOfChorus, .endOfChorus, .chorus,
        .startOfVerse, .endOfVerse,
        .startOfBridge, .endOfBridge,
        .startOfTab, .endOfTab,
        .startOfGrid, .endOfGrid,

        // MARK: Delegated environment directives
        .startOfABC, .endOfABC,
        .startOfTextblock, .endOfTextblock,
        .startOfLy, .endOfLy,
        .startOfSvg, .endOfSvg,

        // MARK: Chord diagrams
        .defineGuitar, .defineGuitalele, .defineUkulele, .define, .chord,

        // MARK: Output related directives
        .newPage, .columnBreak,

        // MARK: Transposition
        .transpose,

        // MARK: Custom metadata directives
        .sourceComment, .emptyLine, .unknown
    ]
}