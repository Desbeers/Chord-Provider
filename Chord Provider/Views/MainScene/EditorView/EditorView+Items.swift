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
        /// Optional suffix for the value
        var suffix: String = ""
        /// The observable state of the scene
        @Environment(SceneStateModel.self) private var sceneState
        /// The state of the form
        @State private var formState = FormState()
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
                        ImageSelector(value: $formState.src)
                    case .width:
                        NumberSlider(label: "Width", start: 0, end: 1000, suffix: " points", value: $formState.width)
                    case .height:
                        NumberSlider(label: "Height", start: 0, end: 1000, suffix: " points", value: $formState.height)
                    case .scale:
                        NumberSlider(label: "Scale", start: 0, end: 200, suffix: "%", value: $formState.scale)
                    case .tuplet:
                        NumberPicker(label: "Tuplet", start: 2, end: 4, value: $formState.tuplet)
                    case .numeric:
                        NumberSlider(label: directive.details.button, start: start, end: end, suffix: suffix, value: $formState.numeric)
                    case .key:
                        HStack {
                            sceneState.rootPicker(showAllOption: false, hideFlats: false)
                            sceneState.qualityPicker()
                        }
                    case .define:
                        CreateChordView(showAllOption: false, hideFlats: false, sceneState: sceneState)
                            .labeledContentStyle(.automatic)
                    default:
                        EmptyView()
                    }
                }
                if let info = directive.details.info {
                    Label(.init(info), systemImage: "info.circle.fill")
                        .padding(.top)
                        .font(.caption)
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
                        update()
                        dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                }
                .padding(.top)
            }
            .labeledContentStyle(.editor)
            .task {
                formState.plain = sceneState.editorInternals.currentLine.plain ?? ""
                let arguments = sceneState.editorInternals.currentLine.arguments ?? [:]
                formState.label = arguments[.label] ?? ""
                formState.align = arguments[.align] ?? ""
                formState.flush = arguments[.flush] ?? ""
                formState.width = Double(arguments[.width] ?? "0") ?? 0
                formState.height = Double(arguments[.height] ?? "0") ?? 0
                formState.src = arguments[.src] ?? ""
                formState.tuplet = Int(arguments[.tuplet] ?? "0") ?? 0
                formState.numeric = Double(arguments[.plain] ?? "\(start)") ?? 0
                if let scaleArgument = arguments[.scale], let value = Double(scaleArgument.replacingOccurrences(of: "%", with: "")) {
                    formState.scale = value
                }
            }
        }
        /// Update the values
        private func update() {
            switch items.first {
            case .plain:
                /// Just plain text
                sceneState.editorInternals.currentLine.plain = formState.plain
            case .numeric:
                /// Just a plain number
                sceneState.editorInternals.currentLine.plain = String(Int(formState.numeric))
            case .key:
                /// The key of the song
                sceneState.editorInternals.currentLine.plain =
                "\(sceneState.definition.root.rawValue)" +
                "\(sceneState.definition.quality.rawValue)"
            case .define:
                /// A chord definition
                sceneState.editorInternals.currentLine.plain = sceneState.definition.define
            default:
                /// Anything else
                var arguments = sceneState.editorInternals.currentLine.arguments ?? [:]
                arguments[.label] = formState.label.isEmpty ? nil : formState.label
                arguments[.align] = formState.align.isEmpty ? nil : formState.align
                arguments[.flush] = formState.flush.isEmpty ? nil : formState.flush
                arguments[.src] = formState.src.isEmpty ? nil : formState.src
                arguments[.width] = formState.width == 0 ? nil : String(Int(formState.width))
                arguments[.height] = formState.height == 0 ? nil : String(Int(formState.height))
                arguments[.tuplet] = formState.tuplet == 0 ? nil : String(formState.tuplet)
                arguments[.scale] = formState.scale == 0 ? nil : String("\(Int(formState.scale))%")
                sceneState.editorInternals.currentLine.arguments = arguments
            }
            Editor.format(directive: directive, editorInternals: sceneState.editorInternals)
        }
    }

    /// The structure of the form items
    struct FormState: Equatable {
        /// Plain text
        var plain: String = ""
        /// A label
        var label: String = ""
        /// Alignment of item
        var align: String = ""
        /// Flush of item
        var flush: String = ""
        /// Width of item
        var width: Double = 0
        /// Height of item
        var height: Double = 0
        /// Source of an image
        var src: String = ""
        /// The tuplet for a strum
        var tuplet: Int = 0
        /// Plain numeric text
        var numeric: Double = 0
        /// The scale of an item
        var scale: Double = 0
    }

    // MARK: Form elements

    /// SwiftUI `View` for the header of the form
    struct Header: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The body of the `View`
        var body: some View {
            VStack {
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
            }
            .padding(.bottom)
        }
    }

    /// SwiftUI `View` for a plain text field
    struct PlainField: View {
        /// The label of the text field
        let label: String
        /// The prompt of the text field
        let prompt: String
        /// The value of the text field
        @Binding var value: String
        /// The body of the `View`
        var body: some View {
            LabeledContent("\(label)") {
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

    /// SwiftUI `View` to select an image
    struct ImageSelector: View {
        /// The value of the selection
        @Binding var value: String
        /// The body of the `View`
        var body: some View {
            LabeledContent("Image") {
                HStack {
                    TextField(
                        text: $value,
                        prompt: Text("Image path")
                    ) {
                        Text("Image")
                    }
                    UserFileButton(userFile: .image, showSelection: false) {
                        if let url = UserFileUtils.Selection.image.getBookmarkURL {
                            value = url.path(percentEncoded: false)
                        }
                    }
                }
            }
        }
    }

    /// SwiftUI `View` to select an alignment
    struct AlignPicker: View {
        /// The label for the picker
        let label: String
        /// The selected value
        @Binding var value: String
        /// The body of the `View`
        var body: some View {
            Picker("\(label)", selection: $value) {
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

    /// SwiftUI `View` to pick a number
    struct NumberPicker: View {
        /// The label for the picker
        let label: String
        /// Start
        let start: Int
        /// End
        let end: Int
        /// The selected value
        @Binding var value: Int
        /// The body of the `View`
        var body: some View {
            Picker("\(label)", selection: $value) {
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

    /// SwiftUI `View` slider to select a number
    struct NumberSlider: View {
        /// The label for the slider
        let label: String
        /// Start
        let start: Double
        /// End
        let end: Double
        /// The suffix for the displayed value
        let suffix: String
        /// The selected value
        @Binding var value: Double
        /// The body of the `View`
        var body: some View {
            LabeledContent("\(label)") {
                HStack {
                    Slider(value: $value, in: start...end)
                    Text(verbatim: "\(Int(value))\(suffix)")
                        .frame(width: 80, alignment: .trailing)
                }
            }
        }
    }
}
