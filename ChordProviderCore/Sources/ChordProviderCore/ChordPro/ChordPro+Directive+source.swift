//
//  ChordPro+Directive+source.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro.Directive {

    /// The directive source definition
    public var source: ChordPro.DirectiveSource {

        switch self {

        // MARK: Meta-data directives

        case .title:           "title|t"
        case .sortTitle:       "sorttitle"
        case .subtitle:        "subtitle|st"
        case .artist:          "artist"
        case .sortArtist:      "sortartist"
        case .composer:        "composer"
        case .album:           "album"
        case .year:            "year"
        case .key:             "key"
        case .time:            "time"
        case .tempo:           "tempo"
        case .capo:            "capo"
        case .instrument:      "instrument"
        case .tag:             "tag"
        case .copyright:       "copyright"
        case .duration:        "duration"
        case .arranger:        "arranger"
        case .lyricist:        "lyricist"
        case .meta:            "meta"

        // MARK: Formatting directives

        case .comment:         "comment|c"
        case .commentItalic:   "comment_italic|ci"
        case .commentBox:      "comment_box|cb"
        case .highlight:       "highlight"
        case .image:           "image"

        // MARK: Environment directives

        case .startOfChorus:   "start_of_chorus|soc"
        case .endOfChorus:     "end_of_chorus|eoc"
        case .chorus:          "chorus"

        case .startOfVerse:    "start_of_verse|sov"
        case .endOfVerse:      "end_of_verse|eov"

        case .startOfBridge:   "start_of_bridge|sob"
        case .endOfBridge:     "end_of_bridge|eob"

        case .startOfTab:      "start_of_tab|sot"
        case .endOfTab:        "end_of_tab|eot"

        case .startOfGrid:     "start_of_grid|sog"
        case .endOfGrid:       "end_of_grid|eog"

        // MARK: Delegated environments

        case .startOfABC:          "start_of_abc"
        case .endOfABC:            "end_of_abc"
        case .startOfTextblock:    "start_of_textblock"
        case .endOfTextblock:      "end_of_textblock"
        case .startOfLy:           "start_of_ly"
        case .endOfLy:             "end_of_ly"
        case .startOfSvg:          "start_of_svg"
        case .endOfSvg:            "end_of_svg"

        // MARK: Chord diagrams

        case .defineGuitar:    "define-guitar"
        case .defineGuitalele: "define-guitalele"
        case .defineUkulele:   "define-ukulele"
        case .define:          "define"
        case .chord:           "chord"

        // MARK: Output

        case .newPage:         "new_page|np"
        case .columnBreak:     "column_break|colb"

        // MARK: Transposition

        case .transpose:       "transpose"

        // MARK: Custom directives

        case .sourceComment:   "source_comment"
        case .emptyLine:       "empty_line"

        case .startOfCustomEnvironment(let name), .endOfCustomEnvironment(let name):
            .init(stringLiteral: name)

        case .unknown:
            "unknown"
        }
    }
}
