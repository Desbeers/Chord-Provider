//
//  ChordPro+Directive+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordPro.Directive {

    /// The SF symbol of the directive
    var sfSymbol: String {
        switch self {
        case .title: "music.note"
        case .sortTitle: "music.note"
        case .subtitle: "music.note"
        case .artist: "person"
        case .composer: "pencil.line"
        case .sortArtist: "person"
        case .album: "music.quarternote.3"
        case .year: "calendar"
        case .copyright: "chart.line.flattrend.xyaxis"
        case .duration: "timer"
        case .arranger: "person.2"
        case .lyricist: "person.2"
        case .key: "key"
        case .time: "timer"
        case .tempo: "metronome"
        case .capo: "paperclip"
        case .instrument: "guitars"
        case .comment: "text.bubble"
        case .image: "photo"
        case .startOfChorus: "music.note.list"
        case .endOfChorus: "chart.line.flattrend.xyaxis"
        case .chorus: "repeat"
        case .startOfVerse: "list.star"
        case .endOfVerse: "chart.line.flattrend.xyaxis"
        case .startOfBridge: "list.bullet.indent"
        case .endOfBridge: "chart.line.flattrend.xyaxis"
        case .startOfTab: "tablecells"
        case .endOfTab: "chart.line.flattrend.xyaxis"
        case .startOfGrid: "square.grid.2x2"
        case .endOfGrid: "chart.line.flattrend.xyaxis"
        case .startOfABC: "textformat.abc"
        case .endOfABC: "chart.line.flattrend.xyaxis"
        case .startOfTextblock: "textformat"
        case .endOfTextblock: "chart.line.flattrend.xyaxis"
        case .define: "hand.raised"
        case .defineGuitar: "hand.raised"
        case .defineGuitalele: "hand.raised"
        case .defineUkulele: "hand.raised"
        case .newPage: "document.badge.plus"
        case .columnBreak: "square.split.2x1"
        case .tag: "tag"
        case .startOfStrum: "arrow.up.arrow.down"
        case .endOfStrum: "chart.line.flattrend.xyaxis"
        case .transpose: "arrow.up.arrow.down"

            // MARK: Custom directives

        case .sourceComment: "bubble"
        case .emptyLine: "pause"
        case .unknown: "questionmark"
        }
    }

}
