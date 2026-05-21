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
        ///   - preset: The MIDI preset
        init(chord: ChordDefinition, coreSettings: ChordProviderSettings) {
            self.chord = chord
            self.coreSettings = coreSettings
        }
        /// The chord to play
        let chord: ChordDefinition
        /// The core settings
        let coreSettings: ChordProviderSettings
        /// The body of the `View`
        var view: Body {
            HStack {
                Button(chord.display, icon: .default(icon: .mediaPlaybackStart)) {
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
