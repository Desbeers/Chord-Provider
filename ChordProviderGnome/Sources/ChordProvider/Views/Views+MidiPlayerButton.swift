//
//  Views+MidiPlayerButton.swift
//  ChordProvider
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderMIDI

extension Views {

    /// A `View` with a button that plays a Chord Definition
    struct MidiPlayerButton: View {
        /// Init the `View`
        /// - Parameters:
        ///   - chord: The chord definition
        ///   - showAccidental: Bool if the name should display as accidental
        ///   - coreSettings: The core settings
        init(chord: ChordDefinition, showAccidental: Bool = false, coreSettings: ChordProviderSettings) {
            self.chord = chord
            self.coreSettings = coreSettings
            self.display = showAccidental ? chord.displayNaturalOrAccidentals : chord.display 
        }
        /// The chord to play
        let chord: ChordDefinition
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// Bool if the name should display as accidental
        let display: String
        /// The body of the `View`
        var view: Body {
            HStack {
                Button("") {
                    Task {
                        await ChordProviderMIDI.shared.playChord(
                            chord,
                            strum: chord.strum ?? coreSettings.chordStrum
                        )
                    }
                }
                .child{
                    HStack(spacing: 5) {
                        Symbol(icon: .default(icon: .mediaPlaybackStart))
                        Text("\(display)")
                        if let strum = chord.strum {
                            Widgets.BundleImage(strum: strum)
                                .pixelSize(12)
                        }
                    }
                }
                .insensitive(!chord.knownChord)
                .style(.midiButton)
                .flat(true)
            }
            .halign(.center)
            .padding(.top)
        }
    }
}
