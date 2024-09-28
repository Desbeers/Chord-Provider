//
//  ChordDisplayOptions+pickers.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//


import SwiftUI

extension ChordDisplayOptions {

    // MARK: Display Root Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root/display`` value
    public var displayRootPicker: some View {
        DisplayRootPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root/display`` value
    struct DisplayRootPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            Picker("Root:", selection: $chordDisplayOptions.displayOptions.general.rootDisplay) {
                ForEach(ChordDefinition.DisplayOptions.Display.Root.allCases) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Display Quality Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Quality/display`` value
    public var displayQualityPicker: some View {
        DisplayQualityPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Quality/display`` value
    struct DisplayQualityPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            Picker("Quality:", selection: $chordDisplayOptions.displayOptions.general.qualityDisplay) {
                ForEach(ChordDefinition.DisplayOptions.Display.Quality.allCases) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Midi Instrument Picker

    /// SwiftUI `Picker` to select a MIDI ``Midi/Instrument`` value
    public var midiInstrumentPicker: some View {
        MidiInstrumentPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `Picker` to select a MIDI ``Midi/Instrument`` value
    struct MidiInstrumentPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        public var body: some View {
            Picker("MIDI Instrument:", selection: $chordDisplayOptions.displayOptions.general.midiInstrument) {
                ForEach(Midi.Instrument.allCases) { value in
                    Text(value.label)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Instrument Picker

    /// SwiftUI `Picker` to select a  ``Instrument`` value
    public var instrumentPicker: some View {
        InstrumentPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `Picker` to select a  ``Instrument`` value
    struct InstrumentPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        public var body: some View {
            Picker("Instrument:", selection: $chordDisplayOptions.displayOptions.instrument) {
                ForEach(Instrument.allCases, id: \.rawValue) { value in
                    Text(value.label)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Root Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value
    public var rootPicker: some View {
        RootPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value
    struct RootPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            Picker("Root:", selection: $chordDisplayOptions.definition.root) {
                ForEach(Chord.Root.allCases.dropFirst(), id: \.rawValue) { value in
                    Text(value.display.symbol)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Quality Picker

    /// SwiftUI `View` with a `Picker` to select a ``Chord/Quality`` value
    public var qualityPicker: some View {
        QualityPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Quality`` value
    struct QualityPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            Picker("Quality:", selection: $chordDisplayOptions.definition.quality) {
                ForEach(Chord.Quality.allCases, id: \.rawValue) { value in
                    Text(value == .major ? "major" : value.rawValue)
                        .tag(value)
                }
            }
        }
    }

    // MARK: Base Fret Picker

    /// SwiftUI `View` with a `Picker` to select a `baseFret` value
    public var baseFretPicker: some View {
        BaseFretPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Picker` to select a `baseFret` value
    struct BaseFretPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The selected bass note
        @State private var bass: Chord.Root = .none
        /// The body of the `View`
        var body: some View {
            Picker("Base fret:", selection: $chordDisplayOptions.definition.baseFret) {
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
    public var bassPicker: some View {
        BassPicker(chordDisplayOptions: self)
    }
    /// SwiftUI `View` with a `Picker` to select a ``Chord/Root`` value as bass note
    struct BassPicker: View {
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
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
                if let bassNote = chordDisplayOptions.definition.bass {
                    bass = bassNote
                }
            }
            .task(id: bass) {
                chordDisplayOptions.definition.bass = bass == .none ? nil : bass
            }
        }
    }

    // MARK: Frets Picker

    /// SwiftUI `View` with a `Picker` to select `fret` values
    public var fretsPicker: some View {
        FretsPicker(
            instrument: definition.instrument,
            guitarTuningOrder: displayOptions.general.mirrorDiagram ? definition.instrument.strings.reversed() : definition.instrument.strings,
            chordDisplayOptions: self
        )
    }

    /// SwiftUI `View` with a `Picker` to select `fret` values
    struct FretsPicker: View {
        /// The instrument
        let instrument: Instrument
        /// The order of the tuning
        let guitarTuningOrder: [Int]
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            HStack {
                ForEach(guitarTuningOrder, id: \.self) { fret in
#if !os(macOS)
                    Text("\(instrument.stringName[fret].display.symbol)")
                        .font(.title3)
#endif
                    Picker(
                        selection: $chordDisplayOptions.definition.frets[fret],
                        content: {
                            Text("⛌")
                                .tag(-1)
                                .foregroundColor(.red)
                            ForEach(0...5, id: \.self) { value in
                                /// Calculate the fret note
                                /// - Note: Only add the basefret after the first row because the note can still be played open
                                let fret = chordDisplayOptions
                                    .definition
                                    .instrument.offset[fret] + (value == 0 ? 1 : chordDisplayOptions.definition.baseFret) + 40 + value
                                /// Convert the fret to a label
                                let label = Utils.valueToNote(value: fret, scale: chordDisplayOptions.definition.root)
                                Text(label.display.symbol)
                                    .tag(value)
                            }
                        },
                        label: {
                            Text("\(instrument.stringName[fret].display.symbol)")
                                .font(.title3)
                        }
                    )
                }
            }
        }
    }

    // MARK: Fingers Picker

    /// SwiftUI `View` with a `Picker` to select `finger` values
    public var fingersPicker: some View {
        FingersPicker(
            instrument: definition.instrument,
            guitarTuningOrder: displayOptions.general.mirrorDiagram ? definition.instrument.strings.reversed() : definition.instrument.strings,
            chordDisplayOptions: self
        )
    }
    /// SwiftUI `View` with a `Picker` to select `finger` values
    struct FingersPicker: View {
        /// The instrument
        let instrument: Instrument
        /// The order of the tuning
        let guitarTuningOrder: [Int]
        /// Chord Display Options object
        @Bindable var chordDisplayOptions: ChordDisplayOptions
        /// The body of the `View`
        var body: some View {
            HStack {
                ForEach(guitarTuningOrder, id: \.self) { finger in
#if !os(macOS)
                    Text("\(instrument.stringName[finger].display.symbol)")
                        .font(.title3)
#endif
                    Picker(
                        selection: $chordDisplayOptions.definition.fingers[finger],
                        content: {
                            ForEach(0...4, id: \.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        },
                        label: {
                            Text("\(instrument.stringName[finger].display.symbol)")
                                .font(.title3)
                        }
                    )
                }
            }
        }
    }
}
