//
//  SceneStateModel+Elements.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import QuickLook
import ChordProviderCore

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
                systemImage: sceneState.settings.display.showChords ? "number.circle.fill" : "number.circle"
            ) {
                sceneState.showChordsButton
                Divider()
                sceneState.chordsPositionPicker
                    .pickerStyle(.inline)
            }
            .menuIndicator(.hidden)
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
                sceneState.settings.display.showChords.toggle()
            } label: {
                Text(sceneState.settings.display.showChords ? "Hide Chords" : "Show Chords")
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
            Toggle(isOn: $sceneState.settings.display.showInlineDiagrams) {
                Text("Chords as Diagram")
                    .font(.caption)
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
            Picker("Pager", selection: $sceneState.settings.display.paging) {
                ForEach(AppSettings.Display.Paging.allCases, id: \.rawValue) { paging in
                    Label(paging.label.text, systemImage: paging.label.sfSymbol)
                        .help(paging.label.help)
                        .tag(paging)
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
            Picker("Position", selection: $sceneState.settings.display.chordsPosition) {
                ForEach(AppSettings.Display.ChordsPosition.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .disabled(sceneState.settings.display.showChords == false)
        }
    }

    // MARK: Root Picker

    /// SwiftUI `View` with a `Picker` to select a root value
    func rootPicker(showAllOption: Bool, hideFlats: Bool) -> some View {
        RootPicker(sceneState: self, showAllOption: showAllOption, hideFlats: hideFlats)
    }
    /// SwiftUI `View` with a `Picker` to select a root value
    struct RootPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// Bool to show the 'all' option
        let showAllOption: Bool
        /// Bool to hide the flats
        let hideFlats: Bool
        /// The body of the `View`
        var body: some View {
            Picker("Root:", selection: $sceneState.definition.root) {
                ForEach(cases, id: \.rawValue) { value in
                    Text(hideFlats ? value.naturalAndSharpDisplay : value.display)
                        .tag(value)
                }
            }
        }
        /// Root notes to show
        var cases: [Chord.Root] {
            var cases: [Chord.Root] = []
            switch hideFlats {
            case true: cases = Chord.Root.naturalAndSharp.dropLast()
            case false: cases = Array(Chord.Root.allCases.dropLast())
            }
            return showAllOption ? cases : Array(cases.dropFirst())
        }
    }

    // MARK: Quality Picker

    /// SwiftUI `View` with a `Picker` to select a quality value
    func qualityPicker(showAll: Bool = false) -> some View {
        QualityPicker(sceneState: self, showAll: showAll)
    }
    /// SwiftUI `View` with a `Picker` to select a quality value
    struct QualityPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// Bool to show the 'all' option
        let showAll: Bool
        /// The body of the `View`
        var body: some View {
            Picker("Quality:", selection: $sceneState.definition.quality) {
                ForEach(cases, id: \.rawValue) { value in
                    Text(value == .major ? "major" : value.display)
                        .tag(value)
                }
            }
        }
        /// Qualities to show
        var cases: [Chord.Quality] {
            switch showAll {
            case true: Chord.Quality.allCases
            case false: Array(Chord.Quality.allCases.dropFirst())
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
        /// The body of the `View`
        var body: some View {
            Picker("Base fret:", selection: $sceneState.definition.baseFret) {
                ForEach(Chord.BaseFret.allCases, id: \.self) { value in
                    Text(value.description)
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

    // MARK: Slash Picker

    /// SwiftUI `View` with a `Picker` to select a root value as slash bass note
    var slashPicker: some View {
        SlashPicker(sceneState: self)
    }
    /// SwiftUI `View` with a `Picker` to select a root value as slash bass note
    struct SlashPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The selected bass note
        @State private var slash: Chord.Root = .none
        /// The body of the `View`
        var body: some View {
            Picker("Bass:", selection: $slash) {
                ForEach(Chord.Root.allCases) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .task {
                if let slashNote = sceneState.definition.slash {
                    slash = slashNote
                }
            }
            .task(id: slash) {
                sceneState.definition.slash = slash == .none ? nil : slash
            }
        }
    }

    // MARK: Frets Picker

    /// SwiftUI `View` with a `Picker` to select `fret` values
    var fretsPicker: some View {
        FretsPicker(
            instrument: definition.instrument,
            guitarTuningOrder: self.settings.core.diagram.mirror ? definition.instrument.strings.reversed() : definition.instrument.strings,
            sceneState: self
        )
    }

    /// SwiftUI `View` with a `Picker` to select `fret` values
    struct FretsPicker: View {
        /// The instrument
        let instrument: Chord.Instrument
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
                                    .instrument.offset[fret] + (value == 0 ? 1 : sceneState.definition.baseFret.rawValue) + 40 + value
                                /// Convert the fret to a label
                                let label = ChordUtils.valueToNote(value: fret, scale: sceneState.definition.root)
                                Text(label.display)
                                    .tag(value)
                            }
                        },
                        label: {
                            Text("\(instrument.stringNames[fret].display)")
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
            guitarTuningOrder: self.settings.core.diagram.mirror ? definition.instrument.strings.reversed() : definition.instrument.strings,
            sceneState: self
        )
    }
    /// SwiftUI `View` with a `Picker` to select `finger` values
    struct FingersPicker: View {
        /// The instrument
        let instrument: Chord.Instrument
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
                            Text("\(instrument.stringNames[finger].display)")
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
            Slider(value: $sceneState.settings.scale.magnifier, in: 0.8...2.0) {
                Label("Zoom", systemImage: "magnifyingglass")
            }
            .labelStyle(.iconOnly)
        }
    }
}

extension SceneStateModel {

    // MARK: Editor Button

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
            Button {
                /// Remember the current song renderer
                let renderer = sceneState.songRenderer
                sceneState.songRenderer = renderer == .standard ? .animating : renderer
                withAnimation {
                    sceneState.showEditor.toggle()
                } completion: {
                    sceneState.songRenderer = renderer
                }
            } label: {
                Label("Edit", systemImage: sceneState.showEditor ? "pencil.circle.fill" : "pencil.circle")
            }
            .help("Edit the song")
        }
    }
}

extension SceneStateModel {

    // MARK: Clean Source Button

    /// Clean Source Button
    var cleanSourceButton: some View {
        CleanSourceButton(sceneState: self)
    }
    /// Clean Source Button
    private struct CleanSourceButton: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The observable state of the document
        @FocusedValue(\.document) private var document: FileDocumentConfiguration<ChordProDocument>?
        /// The body of the `View`
        var body: some View {
            Button {
                sceneState.cleanConfirmation = true
            } label: {
                Label("Clean Source", systemImage: "paintbrush")
            }
            .help("Try to fix warnings in the document")
            .disabled(document == nil)
            .confirmationDialog(
                "Clean the document source?",
                isPresented: $sceneState.cleanConfirmation,
                titleVisibility: .visible,
                actions: {
                    Button("Clean") {
                        if let document {
                            let content = sceneState.song.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                            document.document.text = content
                        }
                    }
                },
                message: {
                    Text("This will try to clean the source but can give unexpected results.\n\nYou can always undo this.")
                }
            )
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
                sceneState.settings.core.transpose += 1
            } label: {
                Label(
                    "♯",
                    systemImage: sceneState.settings.core.transpose > 0 ? "arrow.up.circle.fill" : "arrow.up.circle"
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
                sceneState.settings.core.transpose -= 1
            } label: {
                Label(
                    "♭",
                    systemImage: sceneState.settings.core.transpose < 0 ? "arrow.down.circle.fill" : "arrow.down.circle"
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

    /// SwiftUI `Picker` to select an instrument value
    var instrumentPicker: some View {
        InstrumentPicker(sceneState: self)
    }
    /// SwiftUI `Picker` to select an instrument value
    struct InstrumentPicker: View {
        /// The binding to the observable state of the scene
        @Bindable var sceneState: SceneStateModel
        /// The body of the `View`
        var body: some View {
            Picker("Instrument", selection: $sceneState.settings.core.instrument) {
                ForEach(Chord.Instrument.allCases, id: \.rawValue) { value in
                    Text(value.description)
                        .tag(value)
                        .help(value.label)
                }
            }
        }
    }
}
