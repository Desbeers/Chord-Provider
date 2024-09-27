//
//  ChordsView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the chord diagrams
struct ChordsView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The app state
    @Environment(AppStateModel.self) private var appState
    /// The scene state
    @Environment(SceneStateModel.self) private var sceneState
    /// Sheet with chords of the selected type
    @State var selectedChord: ChordDefinition?
    /// A new chord definition in the sheet
    @State var defineChord: ChordDefinition?
    /// The body of the `View`
    var body: some View {
        let layout = sceneState.songDisplayOptions.chordsPosition == .bottom ?
        AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
        ScrollView([sceneState.songDisplayOptions.chordsPosition == .bottom ? .horizontal : .vertical]) {
            layout {
                ForEach(sceneState.song.chords.sorted(using: KeyPathComparator(\.name))) { chord in
                    switch chord.status {
                    case .standardChord, .transposedChord:
                        Button(
                            action: {
                                selectedChord = chord
                            },
                            label: {
                                VStack(spacing: 0) {
                                    ChordDiagramView(chord: chord, width: 100)
                                }
                            }
                        )
                        .buttonStyle(.plain)
                        .scrollTransition { effect, phase in
                            effect
                                .scaleEffect(phase.isIdentity ? 1 : 0.6)
                        }
                    default:
                        ChordDiagramView(chord: chord, width: 100)
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
                Text("Chord: \(selectedChord.displayName(options: .init()))")
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
                                ChordDiagramView(chord: chord, width: 140)
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
                                        document.text += "\n\n{define: \(chord.define)}"
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
        let allChords = Chords.getAllChordsForInstrument(instrument: selectedChord.instrument)
        return allChords
            .matching(root: selectedChord.root)
            .matching(quality: selectedChord.quality)
            .matching(bass: selectedChord.bass)
    }

    /// Check of a chord in the sheet is the currrent selected chord
    /// - Parameter chord: The chord definition
    /// - Returns: True when current selection; else false
    private func selected(chord: ChordDefinition) -> Bool {
        chord.frets == selectedChord?.frets && chord.baseFret == selectedChord?.baseFret
    }
}
