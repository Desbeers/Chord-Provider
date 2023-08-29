//
//  ChordDiagramView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

struct ChordDiagramView: View {
    /// The chord
    let chord: Song.Chord
    /// Size of the chord diagram
    var frame = CGRect(x: 0, y: 0, width: 100, height: 140)
    /// Bool to show the play button
    var playButton: Bool = false
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            Text("\(chord.display)")
                .foregroundColor(.accentColor)
                .font(.title2)
            switch chord.status {
            case .standard, .custom, .transposed:
                diagram
                if playButton {
                    MidiPlayer.PlayButton(chord: chord.chordPosition)
                        .font(.body)
                }
            case .customTransposed:
                warning(message: "Custom chords cannot transpose to its new shape")
            case .unknown:
                warning(message: "This chord is unknown")
            }
        }
        .frame(width: frame.width + 20, alignment: .center)
    }
    /// The chord diagram
    @ViewBuilder var diagram: some View {
        let showFingers = !chord.chordPosition
            .fingers
            .dropFirst()
            .allSatisfy { $0 == chord.chordPosition.fingers.first }
        let layer = chord.chordPosition.chordLayer(
            rect: frame,
            showFingers: showFingers,
            chordName: .init(show: false)
        )
        if let image = layer.image() {
            Image(swiftImage: image)
        }
    }
    /// The warning if we can't show a diagram
    private func warning(message: String) -> some View {
        VStack {
            Text(message)
                .font(.caption)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
            Image(systemName: "music.note")
        }
        .padding()
        .border(.primary)
    }
}
