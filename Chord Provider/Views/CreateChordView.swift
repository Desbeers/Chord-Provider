//
//  CreateChordView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//
import SwiftUI

/// SwiftUI `View` to create a ``ChordDefinition`` with pickers
struct CreateChordView: View {
    /// Bool to show the 'all' option
    let showAllOption: Bool
    /// Bool to hide the flats
    let hideFlats: Bool
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The binding to the observable state of the scene
    @Bindable var sceneState: SceneStateModel
    /// The chord diagram
    @State private var diagram: ChordDefinition?
    /// The current color scheme
    @Environment(\.colorScheme) private var colorScheme
    /// The chord finder result
    @State private var chordFinder: [ChordDefinition] = []
    /// The chord components result
    @State private var chordComponents: [[Chord.Root]] = []
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("\(sceneState.definition.display)")
                .font(.largeTitle)
            HStack {
                ForEach(sceneState.definition.quality.intervals.intervals, id: \.self) { interval in
                    Text(interval.description)
                }
            }
            Group {
                sceneState.rootPicker(showAllOption: showAllOption, hideFlats: hideFlats)
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    .labelsHidden()
                HStack {
                    LabeledContent(content: {
                        sceneState.qualityPicker()
                            .labelsHidden()
                    }, label: {
                        Text("Quality:")
                    })
                    .frame(maxWidth: 150)
                    LabeledContent(content: {
                        sceneState.baseFretPicker
                            .labelsHidden()
                    }, label: {
                        Text("Base fret:")
                    })
                    .frame(maxWidth: 150)
                    LabeledContent(content: {
                        sceneState.bassPicker
                            .labelsHidden()
                    }, label: {
                        Text("Optional bass:")
                    })
                    .frame(maxWidth: 200)
                }
            }
            .disabled(sceneState.definition.status == .editDefinition)
            HStack {
                VStack {
                    diagramView(width: 180)
                    Label(
                        title: {
                            if let components = chordComponents.first {
                                HStack {
                                    Text("**\(sceneState.definition.display)** contains")
                                    ForEach(components, id: \.self) { element in
                                        Text(element.display)
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
                            sceneState.fretsPicker
                        }, header: {
                            header(text: "Frets")
                        })
                    Section(
                        content: {
                            sceneState.fingersPicker
                        }, header: {
                            header(text: "Fingers")
                        })
                }
                .pickerStyle(.radioGroup)
                .frame(width: 400)
            }
        }
        .task(id: sceneState.definition) {
            let diagram = ChordDefinition(
                id: sceneState.definition.id,
                name: sceneState.definition.name,
                frets: sceneState.definition.frets,
                fingers: sceneState.definition.fingers,
                baseFret: sceneState.definition.baseFret,
                root: sceneState.definition.root,
                quality: sceneState.definition.quality,
                bass: sceneState.definition.bass,
                instrument: sceneState.definition.instrument,
                status: .standardChord
            )
            self.diagram = diagram
            chordComponents = Utils.getChordComponents(chord: diagram)
        }
    }

    /// The diagram `View`
    @MainActor @ViewBuilder func diagramView(width: Double) -> some View {
        if let diagram {
            ChordDefinitionView(
                chord: diagram,
                width: width,
                settings: appState.settings
            )
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
