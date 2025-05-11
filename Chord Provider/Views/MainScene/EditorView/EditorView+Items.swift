//
//  EditorView+Items.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 11/05/2025.
//

import SwiftUI

extension EditorView.DirectiveSheet {

    /// SwiftUI `View to show editable items for the directive`
    struct Items: View {
        /// The available items
        let items: [ChordPro.Directive.FormattingAttribute]
        /// The directive
        let directive: ChordPro.Directive
        /// Start value (for sliders)
        var start: Double = 0
        /// Start value (for sliders)
        var end: Double = 0
        /// The observable state of the scene
        @Environment(SceneStateModel.self) private var sceneState
        /// The state of the form
        @State private var formState = FormStateModel()
        /// The dismiss environment
        @Environment(\.dismiss) private var dismiss
        /// The label for the action button
        var actionLabel: String {
            sceneState.editorInternals.clickedDirective ? "Edit" : "Add"
        }
        /// The body of the `View`
        var body: some View {
            VStack {
                if items.first != .define {
                    Header(directive: directive)
                }
                ForEach(items, id: \.self) { item in
                    switch item {
                    case .plain:
                        PlainField(label: directive.details.button, prompt: directive.details.button, value: $formState.plain)
                    case .label:
                        PlainField(label: "Label", prompt: directive.details.button, value: $formState.label)
                    case .align:
                        AlignPicker(label: "Align", value: $formState.align)
                    case .flush:
                        AlignPicker(label: "Flush", value: $formState.flush)
                    case .src:
                        PlainField(label: "Source", prompt: directive.details.button, value: $formState.src)
                    case .width:
                        NumberSlider(label: "Width", start: 0, end: 1000, value: $formState.width)
                    case .height:
                        NumberSlider(label: "Height", start: 0, end: 1000, value: $formState.height)
                    case .tuplet:
                        NumberPicker(label: "Tuplet", start: 2, end: 4, value: $formState.tuplet)
                    case .numeric:
                        NumberSlider(label: directive.details.button, start: start, end: end, value: $formState.numeric)
                    case .key:
                        HStack {
                            sceneState.rootPicker(showAllOption: false, hideFlats: false)
                            sceneState.qualityPicker()
                        }
                    case .define:
                        CreateChordView(showAllOption: false, hideFlats: false, sceneState: sceneState)
                    default:
                        EmptyView()
                    }
                }
                HStack {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Text("Cancel")
                        }
                    )
                    .keyboardShortcut(.cancelAction)
                    Button("\(actionLabel) Directive") {
                        switch items.first {
                        case .plain:
                            /// Just plain text
                            sceneState.editorInternals.directiveArgument = formState.plain
                        case .numeric:
                            /// Just a plain number
                            sceneState.editorInternals.directiveArgument = String(Int(formState.numeric))
                        case .key:
                            /// The key of the song
                            sceneState.editorInternals.directiveArgument =
                            "\(sceneState.definition.root.rawValue)" +
                            "\(sceneState.definition.quality.rawValue)"
                        case .define:
                            /// A chord definition
                            sceneState.editorInternals.directiveArgument = sceneState.definition.define
                        default:
                            /// Anything else
                            var directiveArguments = sceneState.editorInternals.directiveArguments
                            directiveArguments[.plain] = nil
                            directiveArguments[.label] = formState.label.isEmpty ? nil : formState.label
                            directiveArguments[.align] = formState.align.isEmpty ? nil : formState.align
                            directiveArguments[.flush] = formState.flush.isEmpty ? nil : formState.flush
                            directiveArguments[.src] = formState.src.isEmpty ? nil : formState.src
                            directiveArguments[.width] = formState.width == 0 ? nil : String(Int(formState.width))
                            directiveArguments[.height] = formState.height == 0 ? nil : String(Int(formState.height))
                            directiveArguments[.tuplet] = formState.tuplet == 0 ? nil : String(formState.tuplet)
                            let result = ChordProParser.argumentsToString(directiveArguments)
                            sceneState.editorInternals.directiveArgument = result ?? ""
                        }
                        Editor.format(directive: directive, editorInternals: sceneState.editorInternals)
                        dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding(.top)
            }
            .labeledContentStyle(.editor)
            .task {
                formState.plain = sceneState.editorInternals.directiveArgument
                let arguments = sceneState.editorInternals.directiveArguments
                formState.label = arguments[.plain] ?? arguments[.label] ?? ""
                formState.align = arguments[.align] ?? ""
                formState.flush = arguments[.flush] ?? ""
                formState.width = Double(arguments[.width] ?? "0") ?? 0
                formState.height = Double(arguments[.height] ?? "0") ?? 0
                formState.src = arguments[.src] ?? ""
                formState.tuplet = Int(arguments[.tuplet] ?? "0") ?? 0
                formState.numeric = Double(arguments[.plain] ?? "\(start)") ?? 0
            }
        }
    }

    @Observable final class FormStateModel {
        var plain: String = ""
        var label: String = ""
        var align: String = ""
        var flush: String = ""
        var width: Double = 0
        var height: Double = 0
        var src: String = ""
        var tuplet: Int = 0
        var numeric: Double = 0
    }

    struct Header: View {
        /// The directive
        let directive: ChordPro.Directive
        var body: some View {
            Label {
                Text(directive.details.label)
            } icon: {
                Image(systemName: directive.details.icon)
                    .foregroundStyle(.secondary)
            }
                .font(.title)
                .padding(.bottom, 4)
            Text(directive.details.help)
                .foregroundStyle(.secondary)
                .padding(.bottom)
        }
    }

    struct PlainField: View {
        let label: String
        let prompt: String
        @Binding var value: String
        var body: some View {
            LabeledContent("\(label):") {
                TextField(
                    text: $value,
                    prompt: Text(prompt),
                    axis: .vertical
                ) {
                    Text(label)
                }
            }
        }
    }

    struct AlignPicker: View {
        let label: String
        @Binding var value: String
        var body: some View {
            Picker("\(label):", selection: $value) {
                Text("Default")
                    .tag("")
                Text("Left")
                    .tag("left")
                Text("Center")
                    .tag("center")
                Text("Right")
                    .tag("right")
            }
            .pickerStyle(.segmented)
        }
    }

    struct NumberPicker: View {
        let label: String
        let start: Int
        let end: Int
        @Binding var value: Int
        var body: some View {
            Picker("\(label):", selection: $value) {
                Text("Default")
                    .tag(0)
                ForEach(start...end, id: \.self) {number in
                    Text("\(number)")
                        .tag(number)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    struct NumberSlider: View {
        let label: String
        let start: Double
        let end: Double
        @Binding var value: Double
        var body: some View {

            LabeledContent("\(label):") {
                HStack {
                    Slider(value: $value, in: start...end)
                    Text(verbatim: "\(Int(value))")
                        .font(.caption)
                        .frame(width: 30)
                }
            }
        }
    }
}


struct EditorLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.label
                .bold()
                .frame(width: 70, alignment: .trailing)
            configuration.content
        }
    }
}

extension LabeledContentStyle where Self == EditorLabeledContentStyle {
    static var editor: EditorLabeledContentStyle { .init() }
}
