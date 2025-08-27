//
//  Render+chords.swift
//  ChordProviderHTML
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension HtmlRender {

    /// All chord diagrams
    /// - Parameters:
    ///   - chords: All the known chords in the song
    ///   - settings: The settings
    /// - Returns: A `div` with tall he chord diagrams
    static func chords(chords: [ChordDefinition], settings: HtmlSettings) -> String {
        let diagrams = chords.map { chord in
            return diagram(chord: chord, settings: settings)
        }
        return "<div id=\"chord-diagrams\">" + diagrams.joined(separator: " ") + "</div>"
    }

    /// A single chord diagram
    /// - Parameters:
    ///   - chord: The chord to display
    ///   - settings: The settings
    /// - Returns: A `div` with the chord diagram
    static func diagram(chord: ChordDefinition, settings: HtmlSettings) -> String {

        /// Start of chord diagram
        var html = ""
        html += "<div class=\"chord-diagram \(chord.instrument.rawValue)\">"
        html += "<span class=\"chord\">" + chord.display + "</span>"

        /// Top bar
        html += "<div class=\"bar top\">"
        for index in chord.frets.indices {
            var string: String?
            let fret = chord.frets[index]
            switch fret {
            case -1:
                string = "X"
            case 0:
                string = "O"
            default:
                break
            }
            html += "<div>\(string ?? "&nbsp;")</div>"
        }
        html += "</div>"

        /// Nut or base-fret
        if chord.baseFret == 1 {
            html += "<div class=\"nut\"></div>"
        } else {
            html += "<div class=\"base-fret\">\(chord.baseFret)</div>"
        }

        /// Start of diagram
        html += "<div class=\"diagram\">"

        /// Grid
        html += "<div class=\"grid\">"
        html += String(repeating: "<div class=\"grid-item\">&nbsp;</div>", count: chord.instrument == .ukulele ? 15 : 25)
        html += "</div>"

        /// Finger positions
        html += "<div class=\"fingers\">"
        for fret in 1...5 {
            for string in chord.instrument.strings {

                if let barres = chord.barres, let barre = barres.first(where: { $0.fret == fret }) {
                    if (barre.startIndex...barre.endIndex - 1).contains(string) {
                        let part: String = string == barre.startIndex ? " start" : string == barre.endIndex - 1 ? " end" : ""
                        let finger = "\(barre.finger)"
                        let content: String = string == barre.startIndex ? finger : string == barre.endIndex - 1 ? finger : "&nbsp;"
                        html += "<div class=\"barre \(part)\">\(content)</div>"
                    } else {
                        html += "<div>&nbsp;</div>"
                    }
                } else {

                    if chord.frets[string] == fret {
                        html += "<div class=\"circle\">\(chord.fingers[string])</div>"
                    } else {
                        html += "<div>&nbsp;</div>"
                    }
                }
            }
        }
        html += "</div>"

        /// End of diagram
        html += "</div>"

        /// Notes
        let notes = chord.components
        html += "<div class=\"bar bottom\">"
        for note in notes {
            switch note.note {
            case .none:
                html += "<div>&nbsp;</div>"
            default:
                html += "<div>\(note.note.display)</div>"
            }
        }
        html += "</div>"

        /// End of chord diagram
        html += "</div>"

        return html
    }
}
