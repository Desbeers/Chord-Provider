//
//  ChordsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for the chord diagrams
struct ChordsView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// Sheet with chords of the selected type
    @State var selectedChord: ChordDefinition?
    /// A new chord definition in the sheet
    @State var defineChord: ChordDefinition?
    /// The body of the `View`
    var body: some View {
        let layout = sceneState.settings.display.chordsPosition == .bottom ?
        AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
        ScrollView([sceneState.settings.display.chordsPosition == .bottom ? .horizontal : .vertical]) {
            layout {
                ForEach(sceneState.song.chords) { chord in
                    switch chord.status {
                    case .standardChord, .transposedChord:
                        Button(
                            action: {
                                selectedChord = chord
                            },
                            label: {
                                VStack(spacing: 0) {
                                    ChordDefinitionView(chord: chord, width: 100, settings: sceneState.settings)
                                }
                            }
                        )
                        .buttonStyle(.plain)
                        .scrollTransition { effect, phase in
                            effect
                                .scaleEffect(phase.isIdentity ? 1 : 0.6)
                        }
                    default:
                        ChordDefinitionView(chord: chord, width: 100, settings: sceneState.settings)
                            .scrollTransition { effect, phase in
                                effect
                                    .scaleEffect(phase.isIdentity ? 1 : 0.6)
                            }
                    }
                }
            }
        }
        .sheet(item: $selectedChord) { _ in
            chordsSheet
        }
    }
}

extension ChordsView {

    /// Present a Sheet with chord definitions for the selected chord name
    @ViewBuilder var chordsSheet: some View {
        if let selectedChord {
            VStack {
                Text("Chord: \(selectedChord.display)")
                    .font(.title)
                HStack {
                    ForEach(selectedChord.quality.intervals.intervals, id: \.self) { interval in
                        Text(interval.description)
                    }
                }
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 140))],
                        alignment: .center,
                        spacing: 4,
                        pinnedViews: [.sectionHeaders, .sectionFooters]
                    ) {
                        ForEach(getChordDefinitions()) { chord in
                            Button(action: {
                                self.defineChord = selected(chord: chord) ? nil : chord
                            }, label: {
                                ChordDefinitionView(
                                    chord: chord,
                                    width: 140,
                                    settings: sceneState.settings,
                                    useDefaultColors: true
                                )
                            })
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            .background(
                                self.defineChord == chord ? .accent.opacity(0.3) : .clear
                            )
                            .background(
                                selected(chord: chord) ? .accent.opacity(0.1) : .clear
                            )
                            .cornerRadius(10)
                        }
                    }
                }
                HStack {
                    Button(
                        action: {
                            self.defineChord = nil
                            self.selectedChord = nil
                        },
                        label: {
                            Text("Close")
                        }
                    )
                    .keyboardShortcut(.defaultAction)
                    if sceneState.showEditor {
                        Button(
                            action: {
                                if let chord = self.defineChord {
                                    if let range = document.text.range(of: selectedChord.define) {
                                        document.text = document.text.replacingCharacters(in: range, with: chord.define)
                                    } else {
                                        document.text += "\n\n{define-\(chord.instrument.rawValue) \(chord.define)}"
                                    }
                                }
                                self.defineChord = nil
                                self.selectedChord = nil
                            },
                            label: {
                                Text("Use Definition")
                            }
                        )
                        .disabled(self.defineChord == nil)
                    }
                }
            }
            .padding()
            .frame(minWidth: 600, idealWidth: 600, minHeight: 600, idealHeight: 600)
            .animation(.default, value: self.defineChord)
        }
    }

    /// Get all chord definitions for the selected chord name
    /// - Returns: An array of chord definitions`
    private func getChordDefinitions() -> [ChordDefinition] {
        guard let selectedChord else {
            return []
        }
        let allChords = ChordUtils.getAllChordsForInstrument(instrument: selectedChord.instrument)
        return allChords
            .matching(root: selectedChord.root)
            .matching(quality: selectedChord.quality)
            .matching(slash: selectedChord.slash)
    }

    /// Check of a chord in the sheet is the currrent selected chord
    /// - Parameter chord: The chord definition
    /// - Returns: True when current selection; else false
    private func selected(chord: ChordDefinition) -> Bool {
        chord.frets == selectedChord?.frets && chord.baseFret == selectedChord?.baseFret
    }
}
