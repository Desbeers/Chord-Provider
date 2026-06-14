//
//  Song+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore
import Adwaita
import CAdw

extension Song {

    /// The tooltip for the transpose toggle button
    var transposeTooltip: String {
        var text = "Transpose"
        if transposing == 0 {
            text += " the song"
        } else {
            text += " by \(transposing) semitones"
        }
        return text
    }
}

extension Song {

    /// The initial name of the song file
    func initialName(format: ChordProviderSettings.Export.Format) -> String {
        /// The optional current URL
        let fileURL = settings.fileURL?.deletingPathExtension().lastPathComponent
        /// Use the current URL if exists or else use the metadata
        var name = fileURL ?? "\(metadata.artist) - \(metadata.title)"
        /// Add the extension
        name.append(".\(format.rawValue)")
        return name
    }
}

extension Song.Section.Line.Tab {
    
    /// Highlight a tab line
    /// - Parameters:
    ///   - storage: The view storage
    ///   - color: The accent color
    ///   - playingTabNotes: Bool if the tab is playing with MIDI 
    ///   - currentColumnID: The current column ID
    func highlight(
        storage: ViewStorage,
        color: (red: UInt16, green: UInt16, blue: UInt16),
        playingTabNotes: Bool,
        currentColumnID: Int
    ) {
        let list = pango_attr_list_new()
        defer {
            pango_attr_list_unref(list)
        }
        for event in events {
            switch event.content {
                case .fret, .transition:
                    let bold = pango_attr_weight_new(PANGO_WEIGHT_ULTRAHEAVY)
                    bold?.pointee.start_index = UInt32(event.startIndex)
                    bold?.pointee.end_index = UInt32(event.endIndex)
                    pango_attr_list_insert(list, bold)

                    let foregroundColor = pango_attr_foreground_new(
                        color.red,
                        color.green,
                        color.blue
                    )
                    foregroundColor?.pointee.start_index = UInt32(event.startIndex)
                    foregroundColor?.pointee.end_index = UInt32(event.endIndex)
                    pango_attr_list_insert(list, foregroundColor)
                    if playingTabNotes, event.column == currentColumnID {
                        let backgroundHighlight = pango_attr_background_new(
                            color.red,
                            color.green,
                            color.blue
                        )
                        backgroundHighlight?.pointee.start_index = UInt32(event.startIndex)
                        backgroundHighlight?.pointee.end_index   = UInt32(event.endIndex)
                        pango_attr_list_insert(list, backgroundHighlight)
                        let alpha = pango_attr_background_alpha_new(16384)
                        pango_attr_list_insert(list, alpha)
                    }
                default:
                    // Do not highlight other events
                    break
            }
        }
        gtk_label_set_attributes(storage.opaquePointer, list)
    }
}
