//
//  SceneStateModel+Elements.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import QuickLook

// MARK: Menus

extension SceneStateModel {

    // MARK: Chords Menu

    /// Chords menu
    var chordsMenu: some View {
        ChordsMenu(sceneState: self)
    }
    /// Chords menu
    private struct ChordsMenu: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Menu(
                "Chords",
                systemImage: sceneState.settings.song.showChords ? "number.circle.fill" : "number.circle"
            ) {
                sceneState.showChordsButton
                Divider()
                sceneState.chordsPositionPicker
                    .pickerStyle(.inline)
            }
        }
    }
}

// MARK: Buttons

extension SceneStateModel {

    // MARK: Show Chords Button

    /// Show chords button
    var showChordsButton: some View {
        ShowChordsButton(sceneState: self)
    }
    /// Show chords button
    private struct ShowChordsButton: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.settings.song.showChords.toggle()
            } label: {
                Text(sceneState.settings.song.showChords ? "Hide Chords" : "Show Chords")
            }
        }
    }
}

// MARK: Toggles

extension SceneStateModel {

    // MARK: Chords As Diagram Toggle

    /// Chords As Diagram Toggle
    var chordsAsDiagramToggle: some View {
        ChordsAsDiagramToggle(sceneState: self)
    }

    /// Chords As Diagram Toggle
    private struct ChordsAsDiagramToggle: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $sceneState.settings.song.showInlineDiagrams) {
                Text("Chords as Diagram")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .toggleStyle(.switch)
            .minimumScaleFactor(0.1)
        }
    }
}

// MARK: Pickers

extension SceneStateModel {

    // MARK: Song Paging Picker

    /// Song Paging Picker
    var songPagingPicker: some View {
        SongPagingPicker(sceneState: self)
    }
    /// Song Paging Picker
    private struct SongPagingPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Picker("Pager:", selection: $sceneState.settings.song.paging) {
                ForEach(AppSettings.SongDisplayOptions.Paging.allCases, id: \.rawValue) { value in
                    value.label
                        .tag(value)
                }
            }
        }
    }

    // MARK: Chords Position Picker

    /// Chords Position Picker
    var chordsPositionPicker: some View {
        ChordsPositionPicker(sceneState: self)
    }
    /// Chords Position Picker
    private struct ChordsPositionPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Picker("Position:", selection: $sceneState.settings.song.chordsPosition) {
                ForEach(AppSettings.SongDisplayOptions.ChordsPosition.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .disabled(sceneState.settings.song.showChords == false)
        }
    }

    // MARK: Root Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value
    var rootPicker: some View {
        RootPicker(sceneState: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value
    struct RootPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Picker("Root:", selection: $sceneState.definition.root) {
                ForEach(Chord.Root.allCases.dropFirst(), id: \.rawValue) { value in
                    Text(value.display)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Quality Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Quality`` value
    var qualityPicker: some View {
        QualityPicker(sceneState: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Quality`` value
    struct QualityPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Picker("Quality:", selection: $sceneState.definition.quality) {
                ForEach(Chord.Quality.allCases, id: \.rawValue) { value in
                    Text(value == .major ? "major" : value.rawValue)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Base Fret Picker

    /// SwiftUI `View` with a `Picker` to select a `baseFret` value
    var baseFretPicker: some View {
        BaseFretPicker(sceneState: self)
    }
    /// SwiftUI `View` with a `Picker` to select a `baseFret` value
    struct BaseFretPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The selected bass note
        @State private var bass: Chord.Root = .none
        /// The body of the `View`
        var body: some View {
            Picker("Base fret:", selection: $sceneState.definition.baseFret) {
                ForEach(1...20, id: \.self) { value in
                    Text(fretLabel(fret: value))
                        .tag(value)
                }
            }
        }
        /// Make the label fancy
        private func fretLabel(fret: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter.string(from: NSNumber(value: Int32(fret))) ?? "\(fret)"
        }
    }

    // MARK: Bass Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value as bass note
    var bassPicker: some View {
        BassPicker(sceneState: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value as bass note
    struct BassPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The selected bass note
        @State private var bass: Chord.Root = .none
        /// The body of the `View`
        var body: some View {
            Picker("Bass:", selection: $bass) {
                ForEach(Chord.Root.allCases) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .task {
                if let bassNote = sceneState.definition.bass {
                    bass = bassNote
                }
            }
            .task(id: bass) {
                sceneState.definition.bass = bass == .none ? nil : bass
            }
        }
    }

    // MARK: Frets Picker

    /// SwiftUI `View` with a `Picker` to select `fret` values
    var fretsPicker: some View {
        FretsPicker(
            instrument: definition.instrument,
            guitarTuningOrder: self.settings.diagram.mirrorDiagram ? definition.instrument.strings.reversed() : definition.instrument.strings,
            sceneState: self
        )
    }

    /// SwiftUI `View` with a `Picker` to select `fret` values
    struct FretsPicker: View {
        /// The instrument
        let instrument: Instrument
        /// The order of the tuning
        let guitarTuningOrder: [Int]
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            HStack {
                ForEach(guitarTuningOrder, id: \.self) { fret in
                    Picker(
                        selection: $sceneState.definition.frets[fret],
                        content: {
                            Text("⛌")
                                .tag(-1)
                                .foregroundColor(.red)
                            ForEach(0...5, id: \.self) { value in
                                /// Calculate the fret note
                                /// - Note: Only add the base fret after the first row because the note can still be played open
                                let fret = sceneState
                                    .definition
                                    .instrument.offset[fret] + (value == 0 ? 1 : sceneState.definition.baseFret) + 40 + value
                                /// Convert the fret to a label
                                let label = Utils.valueToNote(value: fret, scale: sceneState.definition.root)
                                Text(label.display)
                                    .tag(value)
                            }
                        },
                        label: {
                            Text("\(instrument.stringName[fret].display)")
                                .font(.title3)
                        }
                    )
                }
            }
        }
    }

    // MARK: Fingers Picker

    /// SwiftUI `View` with a `Picker` to select `finger` values
    var fingersPicker: some View {
        FingersPicker(
            instrument: definition.instrument,
            guitarTuningOrder: self.settings.diagram.mirrorDiagram ? definition.instrument.strings.reversed() : definition.instrument.strings,
            sceneState: self
        )
    }
    /// SwiftUI `View` with a `Picker` to select `finger` values
    struct FingersPicker: View {
        /// The instrument
        let instrument: Instrument
        /// The order of the tuning
        let guitarTuningOrder: [Int]
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            HStack {
                ForEach(guitarTuningOrder, id: \.self) { finger in
                    Picker(
                        selection: $sceneState.definition.fingers[finger],
                        content: {
                            ForEach(0...4, id: \.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        },
                        label: {
                            Text("\(instrument.stringName[finger].display)")
                                .font(.title3)
                        }
                    )
                }
            }
        }
    }
}

// MARK: Sliders

extension SceneStateModel {

    // MARK: Scale Slider

    /// Scale Slider
    var scaleSlider: some View {
        ScaleSlider(sceneState: self)
    }
    /// Scale Slider
    private struct ScaleSlider: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Slider(value: $sceneState.settings.song.scale, in: 0.8...2.0) {
                Label("Zoom", systemImage: "magnifyingglass")
            }
            .labelStyle(.iconOnly)
        }
    }
}

extension SceneStateModel {

    // MARK: Show Editor Button

    /// Show Editor Button
    var showEditorButton: some View {
        ShowEditorButton(sceneState: self)
    }
    /// Show Editor Button
    private struct ShowEditorButton: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Toggle(isOn: $sceneState.showEditor) {
                Label("Edit", systemImage: sceneState.showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
        }
    }
}

extension SceneStateModel {

    // MARK: Transpose Buttons

    /// Transpose Up
    var transposeUp: some View {
        TransposeUp(sceneState: self)
    }
    /// Transpose Up
    private struct TransposeUp: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.song.metaData.transpose += 1
            } label: {
                Label(
                    "♯",
                    systemImage: sceneState.song.metaData.transpose > 0 ? "arrow.up.circle.fill" : "arrow.up.circle"
                )
            }
        }
    }

    /// Transpose Down
    var transposeDown: some View {
        TransposeDown(sceneState: self)
    }
    /// Transpose Down
    private struct TransposeDown: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.song.metaData.transpose -= 1
            } label: {
                Label(
                    "♭",
                    systemImage: sceneState.song.metaData.transpose < 0 ? "arrow.down.circle.fill" : "arrow.down.circle"
                )
            }
        }
    }
}

extension SceneStateModel {

    // MARK: Transpose Menu

    /// Transpose Menu
    var transposeMenu: some View {
        TransposeMenu(sceneState: self)
    }
    /// Transpose Menu
    private struct TransposeMenu: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            ControlGroup {
                sceneState.transposeDown
                sceneState.transposeUp
            }
        }
    }
}

// MARK: Pickers

extension SceneStateModel {

    // MARK: Instrument Picker

    /// SwiftUI `Picker` to select a  ``Instrument`` value
    var instrumentPicker: some View {
        InstrumentPicker(sceneState: self)
    }
    /// SwiftUI `Picker` to select a  ``Instrument`` value
    struct InstrumentPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Picker("Instrument:", selection: $sceneState.settings.song.instrument) {
                ForEach(Instrument.allCases, id: \.rawValue) { value in
                    Text(value.label)
                        .tag(value)
                }
            }
        }
    }
}
