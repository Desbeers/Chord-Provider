//
//  Views+MidiPlayerButton.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
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
        ///   - preset: The MIDI preset
        init(chord: ChordDefinition, showAccidental: Bool = false ,coreSettings: ChordProviderSettings) {
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
                Button(display, icon: .default(icon: .mediaPlaybackStart)) {
                    Task {
                        await ChordProviderMIDI.shared.playChord(
                            chord,
                            strum: chord.strum ?? coreSettings.chordStrum
                        )
                    }
                }
                .insensitive(!chord.knownChord)
                .style(.midiButton)
                .flat(true)
                if let strum = chord.strum {
                    Widgets.BundleImage(strum: strum)
                        .pixelSize(12)
                        .style(.svgIcon)
                        .padding(.leading)
                }
            }
            .halign(.center)
            .padding(.top)
        }
    }
}
