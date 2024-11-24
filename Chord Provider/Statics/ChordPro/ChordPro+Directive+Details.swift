//
//  ChordPro+Directive+Details.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    // MARK: Details of a directive

    /// Details of a directive
    struct Details {
        /// The label of the directive
        var label: String
        /// The SF symbol of the directive
        var icon: String
        /// The text for a button to create this directive
        var button: String
        /// The help text for the directive
        var help: String
        /// The optional environment
        var environment: ChordPro.Environment?
    }

    /// The details of a directive
    var details: Details {
        switch self {
        case .title, .t:
            Details(
                label: "Title",
                icon: "music.note",
                button: "Title",
                help: "This directive defines the title of the song"
            )
        case .subtitle, .st:
            Details(
                label: "Subtitle",
                icon: "music.note",
                button: "Title",
                help: "This directive defines a subtitle of the song"
            )
        case .artist:
            Details(
                label: "Artist",
                icon: "person",
                button: "Artist",
                help: "This directive defines an artist"
            )
        case .album:
            Details(
                label: "Album",
                icon: "music.quarternote.3",
                button: "Album",
                help: "This directive defines an album this song occurs on"
            )
        case .year:
            Details(
                label: "Year",
                icon: "calendar",
                button: "Year",
                help: "The year this song was first published, as a four-digit number"
            )
        case .key:
            Details(
                label: "Key",
                icon: "key",
                button: "Key",
                help: "This directive specifies the key the song is written in"
            )
        case .time:
            Details(
                label: "Time",
                icon: "timer",
                button: "Time",
                help: "This directive specifies a time signature"
            )
        case .tempo:
            Details(
                label: "Tempo",
                icon: "metronome",
                button: "Tempo",
                help: "This directive specifies the tempo in number of beats per minute for the song"
            )
        case .capo:
            Details(
                label: "Capo",
                icon: "paperclip",
                button: "Capo",
                help: "This directive specifies the capo setting for the song"
            )
        case .instrument:
            Details(
                label: "Instrument",
                icon: "guitars",
                button: "Instrument",
                help: "This directive specifies the instrument setting for the song"
            )
        case .comment, .c:
            Details(
                label: "Comment",
                icon: "text.bubble",
                button: "Comment",
                help: "This directive introduce a comment line"
            )
        case .startOfChorus, .soc:
            Details(
                label: "Start of Chorus",
                icon: "music.note.list",
                button: "Chorus",
                help: "This directive indicates that the lines that follow form the song’s chorus",
                environment: .chorus
            )
        case .endOfChorus, .eoc:
            Details(
                label: "End of Chorus",
                icon: "chart.line.flattrend.xyaxis",
                button: "Chorus",
                help: "This directive indicates the end of the chorus"
            )
        case .chorus:
            Details(
                label: "Repeat Chorus",
                icon: "repeat",
                button: "Repeat Chorus",
                help: "his directive indicates that the song chorus must be played here"
            )
        case .startOfVerse, .sov:
            Details(
                label: "Start of Verse",
                icon: "list.star",
                button: "Verse",
                help: "Specifies that the following lines form a verse of the song",
                environment: .verse
            )
        case .endOfVerse, .eov:
            Details(
                label: "End of Verse",
                icon: "chart.line.flattrend.xyaxis",
                button: "Verse",
                help: "Specifies the end of the verse"
            )
        case .startOfBridge, .sob:
            Details(
                label: "Start of Bridge",
                icon: "list.bullet.indent",
                button: "Bridge",
                help: "Specifies that the following lines form a bridge of the song"
            )
        case .endOfBridge, .eob:
            Details(
                label: "End of Bridge",
                icon: "chart.line.flattrend.xyaxis",
                button: "Bridge",
                help: "Specifies the end of the bridge"
            )
        case .startOfTab, .sot:
            Details(
                label: "Start of Tab",
                icon: "tablecells",
                button: "Tab",
                help: "This directive indicates that the lines that follow form a section of guitar TAB instructions"
            )
        case .endOfTab, .eot:
            Details(
                label: "End of Tab",
                icon: "chart.line.flattrend.xyaxis",
                button: "Tab",
                help: "This directive indicates the end of the tab"
            )
        case .startOfGrid, .sog:
            Details(
                label: "Start of Grid",
                icon: "square.grid.2x2",
                button: "Grid",
                help: "This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles"
            )
        case .endOfGrid, .eog:
            Details(
                label: "End of Grid",
                icon: "chart.line.flattrend.xyaxis",
                button: "Grid",
                help: "This directive indicates the end of the grid"
            )
        case .startOfTextblock:
            Details(
                label: "Start of Textblock",
                icon: "music.quarternote.3",
                button: "Textblock",
                help: "This directive indicates that the lines that follow define a piece of text that is combined into a single object"
            )
        case .endOfTextblock:
            Details(
                label: "End of Textblock",
                icon: "chart.line.flattrend.xyaxis",
                button: "Textblock",
                help: "This directive indicates the end of the textblock"
            )
        case .define:
            Details(
                label: "Chord Definition",
                icon: "hand.raised",
                button: "Define Chord",
                help: "This directive defines a chord in terms of fret/string positions and, optionally, finger settings"
            )
        case .tag:
            Details(
                label: "Tag",
                icon: "tag",
                button: "Tag",
                help: "This directive defines a tag for the song"
            )
        case .startOfStrum, .sos:
            Details(
                label: "Start of Strum",
                icon: "arrow.up.arrow.down",
                button: "Strum",
                help: "This directive indicates that the lines that follow defines a strum pattern"
            )
        case .endOfStrum, .eos:
            Details(
                label: "End of Strum",
                icon: "chart.line.flattrend.xyaxis",
                button: "Strum",
                help: "This directive indicates the end of the strum"
            )
        case .sourceComment:
            Details(
                label: "Source Comment",
                icon: "bubble",
                button: "None",
                help: "Ignored in the Output"
            )
        case .environmentLine:
            Details(
                label: "Inside Environment Block",
                icon: "lines.measurement.vertical",
                button: "None",
                help: "Inside Environment Block"
            )
        case .unknownDirective:
            Details(
                label: "Unknown",
                icon: "questionmark",
                button: "None",
                help: "This directive is unknown"
            )
        case .none:
            Details(
                label: "None",
                icon: "questionmark",
                button: "None",
                help: "No Help"
            )
        }
    }

    /// Information of a directive as a combined string with label and help
    var infoString: String {
        "**\(self.details.label)**: \(self.details.help)"
    }
}
