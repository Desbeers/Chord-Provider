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
        /// The SF symbol of the directive
        public var icon: String
        /// The text for a button to create this directive
        public var button: String
        /// The help text for the directive
        public var help: String
        /// The environment
        public var environment: ChordPro.Environment
        /// The line type
        public var lineType: ChordPro.LineType = .metadata
        /// Additional info
        public var info: String?
    }

    /// The details of a directive
    public var details: Details {
        switch self {
        case .title:
            Details(
                label: "Title",
                icon: "music.note",
                button: "Title",
                help: "This directive defines the title of the song",
                environment: .metadata,
            )
        case .sortTitle:
            Details(
                label: "Sorting Title",
                icon: "music.note",
                button: "Sorting Title",
                help: "This directive defines the sorting title of the song",
                environment: .metadata
            )
        case .subtitle:
            Details(
                label: "Subtitle",
                icon: "music.note",
                button: "Subtitle",
                help: "This directive defines a subtitle of the song",
                environment: .metadata
            )
        case .artist:
            Details(
                label: "Artist",
                icon: "person",
                button: "Artist",
                help: "This directive defines an artist",
                environment: .metadata
            )
        case .composer:
            Details(
                label: "Composer",
                icon: "pencil.line",
                button: "Composer",
                help: "This directive defines a composer",
                environment: .metadata
            )
        case .sortArtist:
            Details(
                label: "Sorting Artist",
                icon: "person",
                button: "Sorting Artist",
                help: "This directive defines the sorting name of artist",
                environment: .metadata
            )
        case .album:
            Details(
                label: "Album",
                icon: "music.quarternote.3",
                button: "Album",
                help: "This directive defines an album this song occurs on",
                environment: .metadata
            )
        case .year:
            Details(
                label: "Year",
                icon: "calendar",
                button: "Year",
                help: "The year this song was first published, as a four-digit number",
                environment: .metadata
            )
        case .key:
            Details(
                label: "Key",
                icon: "key",
                button: "Key",
                help: "This directive specifies the key the song is written in",
                environment: .metadata
            )
        case .time:
            Details(
                label: "Time",
                icon: "timer",
                button: "Time",
                help: "This directive specifies a time signature",
                environment: .metadata
            )
        case .tempo:
            Details(
                label: "Tempo",
                icon: "metronome",
                button: "Tempo",
                help: "This directive specifies the tempo in number of beats per minute for the song",
                environment: .metadata
            )
        case .capo:
            Details(
                label: "Capo",
                icon: "paperclip",
                button: "Capo",
                help: "This directive specifies the capo setting for the song",
                environment: .metadata
            )
        case .instrument:
            Details(
                label: "Instrument",
                icon: "guitars",
                button: "Instrument",
                help: "This directive specifies the instrument setting for the song",
                environment: .metadata
            )
        case .comment:
            Details(
                label: "Comment",
                icon: "text.bubble",
                button: "Comment",
                help: "This directive introduce a comment line",
                environment: .comment,
                lineType: .comment
            )
        case .image:
            Details(
                label: "Image",
                icon: "photo",
                button: "Insert Image",
                help: "Specifies the name of the file containing the image",
                environment: .image,
                lineType: .environmentDirective,
                info: "Aspect ratio will be kept. A size of zero means using the original size."
            )
        case .startOfChorus:
            Details(
                label: "Start of Chorus",
                icon: "music.note.list",
                button: "Chorus",
                help: "This directive indicates that the lines that follow form the song’s chorus",
                environment: .chorus,
                lineType: .environmentDirective
            )
        case .endOfChorus:
            Details(
                label: "End of Chorus",
                icon: "chart.line.flattrend.xyaxis",
                button: "Chorus",
                help: "This directive indicates the end of the chorus",
                environment: .chorus,
                lineType: .environmentDirective
            )
        case .chorus:
            Details(
                label: "Repeat Chorus",
                icon: "repeat",
                button: "Repeat Chorus",
                help: "his directive indicates that the song chorus must be played here",
                environment: .repeatChorus,
                lineType: .environmentDirective
            )
        case .startOfVerse:
            Details(
                label: "Start of Verse",
                icon: "list.star",
                button: "Verse",
                help: "Specifies that the following lines form a verse of the song",
                environment: .verse,
                lineType: .environmentDirective
            )
        case .endOfVerse:
            Details(
                label: "End of Verse",
                icon: "chart.line.flattrend.xyaxis",
                button: "Verse",
                help: "Specifies the end of the verse",
                environment: .verse,
                lineType: .environmentDirective
            )
        case .startOfBridge:
            Details(
                label: "Start of Bridge",
                icon: "list.bullet.indent",
                button: "Bridge",
                help: "Specifies that the following lines form a bridge of the song",
                environment: .bridge,
                lineType: .environmentDirective
            )
        case .endOfBridge:
            Details(
                label: "End of Bridge",
                icon: "chart.line.flattrend.xyaxis",
                button: "Bridge",
                help: "Specifies the end of the bridge",
                environment: .bridge,
                lineType: .environmentDirective
            )
        case .startOfTab:
            Details(
                label: "Start of Tab",
                icon: "tablecells",
                button: "Tab",
                help: "This directive indicates that the lines that follow form a section of guitar TAB instructions",
                environment: .tab,
                lineType: .environmentDirective
            )
        case .endOfTab:
            Details(
                label: "End of Tab",
                icon: "chart.line.flattrend.xyaxis",
                button: "Tab",
                help: "This directive indicates the end of the tab",
                environment: .tab,
                lineType: .environmentDirective
            )
        case .startOfGrid:
            Details(
                label: "Start of Grid",
                icon: "square.grid.2x2",
                button: "Grid",
                help: "This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles",
                environment: .grid,
                lineType: .environmentDirective
            )
        case .endOfGrid:
            Details(
                label: "End of Grid",
                icon: "chart.line.flattrend.xyaxis",
                button: "Grid",
                help: "This directive indicates the end of the grid",
                environment: .grid,
                lineType: .environmentDirective
            )
        case .startOfABC:
            Details(
                label: "Start of ABC",
                icon: "textformat.abc",
                button: "ABC",
                help: "This directive indicates that the lines that follow define a piece of music written in ABC music notation",
                environment: .abc,
                lineType: .environmentDirective
            )
        case .endOfABC:
            Details(
                label: "End of ABC",
                icon: "chart.line.flattrend.xyaxis",
                button: "ABC",
                help: "This directive indicates the end of the ABC",
                environment: .abc,
                lineType: .environmentDirective
            )
        case .startOfTextblock:
            Details(
                label: "Start of Textblock",
                icon: "textformat",
                button: "Textblock",
                help: "This directive indicates that the lines that follow define a piece of text that is combined into a single object",
                environment: .textblock,
                lineType: .environmentDirective
            )
        case .endOfTextblock:
            Details(
                label: "End of Textblock",
                icon: "chart.line.flattrend.xyaxis",
                button: "Textblock",
                help: "This directive indicates the end of the textblock",
                environment: .textblock,
                lineType: .environmentDirective
            )
        case .define:
            Details(
                label: "Chord Definition",
                icon: "hand.raised",
                button: "Define Chord",
                help: "This directive defines a chord in terms of fret/string positions and, optionally, finger settings",
                environment: .metadata
            )
        case .newPage:
            Details(
                label: "New Page",
                icon: "document.badge.plus",
                button: "New Page",
                help: "This directive forces a new page to be generated at the place where it occurs in the song",
                environment: .metadata
            )
        case .columnBreak:
            Details(
                label: "Column Break",
                icon: "square.split.2x1",
                button: "Column Break",
                help: "When printing songs in multiple columns, this directive forces printing to continue in the next column",
                environment: .metadata
            )
        case .tag:
            Details(
                label: "Tag",
                icon: "tag",
                button: "Tag",
                help: "This directive defines a tag for the song",
                environment: .metadata
            )
        case .startOfStrum:
            Details(
                label: "Start of Strum",
                icon: "arrow.up.arrow.down",
                button: "Strum",
                help: "This directive indicates that the lines that follow defines a strum pattern",
                environment: .strum,
                lineType: .environmentDirective,
                info: "**Tuplet** is a generic term that describes a grouping of notes that would not normally occur within a beat."
            )
        case .endOfStrum:
            Details(
                label: "End of Strum",
                icon: "chart.line.flattrend.xyaxis",
                button: "Strum",
                help: "This directive indicates the end of the strum",
                environment: .strum,
                lineType: .environmentDirective
            )

            // MARK: Custom directives

        case .sourceComment:
            Details(
                label: "Source Comment",
                icon: "bubble",
                button: "None",
                help: "Ignored in the Output",
                environment: .sourceComment,
                lineType: .sourceComment
            )
        case .emptyLine:
            Details(
                label: "Empty Line",
                icon: "pause",
                button: "None",
                help: "An empty line in the source",
                environment: .emptyLine,
                lineType: .emptyLine
            )
        case .unknown:
            Details(
                label: "Unknown",
                icon: "questionmark",
                button: "None",
                help: "This directive is unknown",
                environment: .none
            )
        }
    }
}
