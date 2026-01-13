//
//  ChordPro+Directive+Details.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    // MARK: Details of a directive

    /// Details of a directive
    public struct Details {
        /// The label of the directive
        public var label: String
        /// Default value when the directive needs an argument
        public var defaultValue: String?
        /// The help text for the directive
        public var help: String
        /// The environment
        public var environment: ChordPro.Environment
        /// The line type
        public var lineType: ChordPro.LineType
        /// Additional info
        public var info: String?
        /// Optional button label
        public var buttonLabel: String?
    }

    /// The details of a directive
    public var details: Details {
        switch self {
        case .title:
            Details(
                label: "Title",
                help: "This directive defines the title of the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .sortTitle:
            Details(
                label: "Sorting Title",
                help: "This directive defines the sorting title of the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .subtitle:
            Details(
                label: "Subtitle",
                help: "This directive defines a subtitle of the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .artist:
            Details(
                label: "Artist",
                help: "This directive defines an artist",
                environment: .metadata,
                lineType: .metadata
            )
        case .composer:
            Details(
                label: "Composer",
                help: "This directive defines a composer",
                environment: .metadata,
                lineType: .metadata
            )
        case .sortArtist:
            Details(
                label: "Sorting Artist",
                help: "This directive defines the sorting name of artist",
                environment: .metadata,
                lineType: .metadata
            )
        case .album:
            Details(
                label: "Album",
                help: "This directive defines an album this song occurs on",
                environment: .metadata,
                lineType: .metadata
            )
        case .year:
            Details(
                label: "Year",
                defaultValue: "1975",
                help: "The year this song was first published, as a four-digit number",
                environment: .metadata,
                lineType: .metadata
            )
        case .copyright:
            Details(
                label: "Copyright",
                help: "Copyright information for the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .duration:
            Details(
                label: "Duration",
                help: "This directive specifies the duration of the song",
                environment: .metadata,
                lineType: .metadata,
                info: "This can be a number indicating seconds, or a time specification conforming to the extended ordinal time format as defined in ISO 8601."
            )
        case .arranger:
            Details(
                label: "Arranger",
                help: "This directive defines the arranger of the song",
                environment: .metadata,
                lineType: .metadata,
                info: "Multiple arrangers can be specified using multiple directives."
            )
        case .lyricist:
            Details(
                label: "Lyricist",
                help: "This directive defines the writer of the lyrics of the song",
                environment: .metadata,
                lineType: .metadata,
                info: "Multiple lyricists can be specified using multiple directives."
            )
        case .key:
            Details(
                label: "Key",
                defaultValue: "C",
                help: "This directive specifies the key the song is written in",
                environment: .metadata,
                lineType: .metadata
            )
        case .time:
            Details(
                label: "Time",
                defaultValue: "4/4",
                help: "This directive specifies a time signature",
                environment: .metadata,
                lineType: .metadata
            )
        case .tempo:
            Details(
                label: "Tempo",
                defaultValue: "128",
                help: "This directive specifies the tempo in number of beats per minute for the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .capo:
            Details(
                label: "Capo",
                defaultValue: "1",
                help: "This directive specifies the capo setting for the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .instrument:
            Details(
                label: "Instrument",
                help: "This directive specifies the instrument setting for the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .comment:
            Details(
                label: "Comment",
                help: "This directive introduce a comment line",
                environment: .comment,
                lineType: .comment,
                buttonLabel: "Add a new comment"
            )
        case .image:
            Details(
                label: "Image",
                help: "Specifies the name of the file containing the image",
                environment: .image,
                lineType: .environmentDirective,
                info: "Aspect ratio will be kept. A size of zero means using the original size."
            )
        case .startOfChorus:
            Details(
                label: "Start of Chorus",
                help: "This directive indicates that the lines that follow form the song’s chorus",
                environment: .chorus,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Chorus"
            )
        case .endOfChorus:
            Details(
                label: "End of Chorus",
                help: "This directive indicates the end of the chorus",
                environment: .chorus,
                lineType: .environmentDirective
            )
        case .chorus:
            Details(
                label: "Label",
                help: "This directive indicates that the song chorus must be played here",
                environment: .repeatChorus,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Repeat Chorus"
            )
        case .startOfVerse:
            Details(
                label: "Start of Verse",
                help: "Specifies that the following lines form a verse of the song",
                environment: .verse,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Verse"
            )
        case .endOfVerse:
            Details(
                label: "End of Verse",
                help: "Specifies the end of the verse",
                environment: .verse,
                lineType: .environmentDirective
            )
        case .startOfBridge:
            Details(
                label: "Start of Bridge",
                help: "Specifies that the following lines form a bridge of the song",
                environment: .bridge,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Bridge"
            )
        case .endOfBridge:
            Details(
                label: "End of Bridge",
                help: "Specifies the end of the bridge",
                environment: .bridge,
                lineType: .environmentDirective
            )
        case .startOfTab:
            Details(
                label: "Start of Tab",
                help: "This directive indicates that the lines that follow form a section of guitar TAB instructions",
                environment: .tab,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Tab"
            )
        case .endOfTab:
            Details(
                label: "End of Tab",
                help: "This directive indicates the end of the tab",
                environment: .tab,
                lineType: .environmentDirective
            )
        case .startOfGrid:
            Details(
                label: "Start of Grid",
                help: "This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles",
                environment: .grid,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Grid"
            )
        case .endOfGrid:
            Details(
                label: "End of Grid",
                help: "This directive indicates the end of the grid",
                environment: .grid,
                lineType: .environmentDirective
            )
        case .startOfABC:
            Details(
                label: "Start of ABC",
                help: "This directive indicates that the lines that follow define a piece of music written in ABC music notation",
                environment: .abc,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "ABC"
            )
        case .endOfABC:
            Details(
                label: "End of ABC",
                help: "This directive indicates the end of the ABC",
                environment: .abc,
                lineType: .environmentDirective
            )
        case .startOfTextblock:
            Details(
                label: "Start of Textblock",
                help: "This directive indicates that the lines that follow define a piece of text that is combined into a single object",
                environment: .textblock,
                lineType: .environmentDirective,
                info: "The label is optional",
                buttonLabel: "Textblock"
            )
        case .endOfTextblock:
            Details(
                label: "End of Textblock",
                help: "This directive indicates the end of the textblock",
                environment: .textblock,
                lineType: .environmentDirective
            )
        case .define:
            Details(
                label: "Chord Definition",
                help: "This directive defines a chord in terms of fret/string positions and, optionally, finger settings",
                environment: .metadata,
                lineType: .metadata
            )
        case .defineGuitar:
            Details(
                label: "Chord Definition for a guitar",
                defaultValue: "C base-fret 1 frets x 3 2 0 1 0 fingers 0 3 2 0 1 0",
                help: "This directive defines a guitar chord in terms of fret/string positions and, optionally, finger settings",
                environment: .metadata,
                lineType: .metadata
            )
        case .defineGuitalele:
            Details(
                label: "Chord Definition for a guitalele",
                defaultValue: "C base-fret 1 frets 3 2 0 0 0 3 fingers 2 1 0 0 0 3",
                help: "This directive defines a guitalele chord in terms of fret/string positions and, optionally, finger settings",
                environment: .metadata,
                lineType: .metadata
            )
        case .defineUkulele:
            Details(
                label: "Chord Definition for a ukulele",
                defaultValue: "C base-fret 1 frets 0 0 0 3 fingers 0 0 0 3",
                help: "This directive defines a ukulele chord in terms of fret/string positions and, optionally, finger settings",
                environment: .metadata,
                lineType: .metadata
            )
        case .newPage:
            Details(
                label: "New Page",
                help: "This directive forces a new page to be generated at the place where it occurs in the song",
                environment: .metadata,
                lineType: .metadata
            )
        case .columnBreak:
            Details(
                label: "Column Break",
                help: "When printing songs in multiple columns, this directive forces printing to continue in the next column",
                environment: .metadata,
                lineType: .metadata
            )
        case .tag:
            Details(
                label: "Tag",
                help: "This directive defines a tag for the song",
                environment: .metadata,
                lineType: .metadata,
                info: "You can have more than one `tag` in the song."
            )
        case .startOfStrum:
            Details(
                label: "Start of Strum",
                help: "This directive indicates that the lines that follow defines a strum pattern",
                environment: .strum,
                lineType: .environmentDirective,
                info: "- `Tuplet` is a generic term that describes a grouping of notes that would not normally occur within a beat.\n- The label is optional.",
                buttonLabel: "Strum"
            )
        case .endOfStrum:
            Details(
                label: "End of Strum",
                help: "This directive indicates the end of the strum",
                environment: .strum,
                lineType: .environmentDirective
            )
        case .transpose:
            Details(
                label: "Transpose",
                help: "This directive indicates that the remainder of the song should be transposed the number of semitones according to the given value",
                environment: .metadata,
                lineType: .metadata
            )

            // MARK: Custom directives

        case .sourceComment:
            Details(
                label: "Source Comment",
                help: "Ignored in the Output",
                environment: .sourceComment,
                lineType: .sourceComment
            )
        case .emptyLine:
            Details(
                label: "Empty Line",
                help: "An empty line in the source",
                environment: .emptyLine,
                lineType: .emptyLine
            )
        case .unknown:
            Details(
                label: "Unknown",
                help: "This directive is unknown",
                environment: .none,
                lineType: .unknown
            )
        }
    }
}
