//
//  CreateChordView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//
import SwiftUI

/// A SwiftUI `View` to create a ``ChordDefinition`` with pickers
public struct CreateChordView: View {
    /// Init the `View`
    public init(chordDisplayOptions: Bindable<ChordDisplayOptions>) {
        self._chordDisplayOptions = chordDisplayOptions
    }
    /// Chord Display Options object
    @Bindable var chordDisplayOptions: ChordDisplayOptions
    /// The chord diagram
    @State private var diagram: ChordDefinition?
    /// The current color scheme
    @Environment(\.colorScheme) private var colorScheme
    /// The chord finder result
    @State private var chordFinder: [ChordDefinition] = []
    /// The chord components result
    @State private var chordComponents: [[Chord.Root]] = []
    /// The body of the `View`
    public var body: some View {
        VStack {
            Text("\(chordDisplayOptions.definition.displayName(options: .init(rootDisplay: .raw, qualityDisplay: .raw)))")
                .font(.largeTitle)
            HStack {
                ForEach(chordDisplayOptions.definition.quality.intervals.intervals, id: \.self) { interval in
                    Text(interval.description)
                }
            }
            chordDisplayOptions.rootPicker
                .pickerStyle(.segmented)
                .padding(.bottom)
                .labelsHidden()
            HStack {
                LabeledContent(content: {
                    chordDisplayOptions.qualityPicker
                        .labelsHidden()
                }, label: {
                    Text("Quality:")
                })
                .frame(maxWidth: 150)
                LabeledContent(content: {
                    chordDisplayOptions.baseFretPicker
                    .labelsHidden()
                }, label: {
                    Text("Base fret:")
                })
                .frame(maxWidth: 150)
                LabeledContent(content: {
                    chordDisplayOptions.bassPicker
                        .labelsHidden()
                }, label: {
                    Text("Optional bass:")
                })
                .frame(maxWidth: 200)
            }
            HStack {
                VStack {
                    diagramView(width: 180)
                    Label(
                        title: {
                            if let components = chordComponents.first {
                                HStack {
                                    Text("**\(chordDisplayOptions.definition.displayName(options: .init()))** contains")
                                    ForEach(components, id: \.self) { element in
                                        Text(element.display.symbol)
                                            .fontWeight(checkRequiredNote(note: element) ? .bold : .regular)
                                    }
                                }
                            }
                        },
                        icon: { Image(systemName: "info.circle.fill") }
                    )
                    .padding(.bottom)
                    Text(diagram?.validate.description ?? "Unknown status")
                        .foregroundStyle(diagram?.validate.color ?? .primary)
                }
                .frame(width: 300)
                VStack {
                    Section(
                        content: {
                            chordDisplayOptions.fretsPicker
                        }, header: {
                            header(text: "Frets")
                        })
                    Section(
                        content: {
                            chordDisplayOptions.fingersPicker
                        }, header: {
                            header(text: "Fingers")
                        })
                }
#if os(macOS)
                .pickerStyle(.radioGroup)
#else
                .pickerStyle(.wheel)
#endif
                .frame(width: 400)
            }
        }
        .padding(.bottom)
        .overlay(alignment: .topLeading) {
            Label(chordDisplayOptions.displayOptions.instrument.label, systemImage: "guitars")
        }
        .task(id: chordDisplayOptions.definition) {
            let diagram = ChordDefinition(
                id: chordDisplayOptions.definition.id,
                name: chordDisplayOptions.definition.name,
                frets: chordDisplayOptions.definition.frets,
                fingers: chordDisplayOptions.definition.fingers,
                baseFret: chordDisplayOptions.definition.baseFret,
                root: chordDisplayOptions.definition.root,
                quality: chordDisplayOptions.definition.quality,
                bass: chordDisplayOptions.definition.bass,
                instrument: chordDisplayOptions.definition.instrument,
                status: .standardChord
            )
            self.diagram = diagram
            chordComponents = Utils.getChordComponents(chord: diagram)
        }
    }

    /// The diagram `View`
    @ViewBuilder func diagramView(width: Double) -> some View {
        if let diagram {
            ChordDefinitionView(chord: diagram, width: width, options: chordDisplayOptions.displayOptions)
                .foregroundStyle(.primary, colorScheme == .light ? .white : .black)
        } else {
            ProgressView()
        }
    }

    /// Check if a note is required for a chord
    ///
    /// The first array of the `chordComponents` contains all notes
    ///
    /// The last array of the `chordComponents` contains the least notes
    ///
    /// - Parameter note: The note to check
    /// - Returns: True or False
    func checkRequiredNote(note: Chord.Root) -> Bool {
        if let first = chordComponents.first, let last = chordComponents.last {
            let omitted = first.filter { !last.contains($0) }
            return omitted.contains(note) ? false : true
        }
        return true
    }

    /// The header `View`
    /// - Parameter text: The text as `String`
    /// - Returns: A `View` with the header title
    func header(text: String) -> some View {
        VStack {
            Text(text)
                .font(.title2)
                .padding(.top)
            Divider()
        }
    }
}
