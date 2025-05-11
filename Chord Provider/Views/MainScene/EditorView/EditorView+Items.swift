//
//  EditorView+Items.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 11/05/2025.
//

import SwiftUI

extension EditorView.DirectiveSheet {
    
    @Observable final class FormStateModel {
        var plain: String = ""
        var label: String = ""
        var align: String = ""
        var flush: String = ""
        var width: Double = 0
        var src: String = ""
    }
    
    struct Header: View {
        /// The directive
        let directive: ChordPro.Directive
        var body: some View {
            Text(directive.details.label)
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
            LabeledContent(label) {
                TextField(
                    text: $value,
                    prompt: Text(prompt),
                    axis: .vertical
                ) {
                    Text(label)
                }
                //.labelsHidden()
            }
        }
    }
    
    
    struct AlignPicker: View {
        let label: String
        @Binding var value: String
        var body: some View {
            Picker(label, selection: $value) {
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
    
    struct SizeSlider: View {
        let label: String
        let start: Double
        let end: Double
        @Binding var value: Double
        var body: some View {
            
            LabeledContent(label) {
                VStack {
                    Slider(value: $value, in: start...end, step: 1)
                    Text(verbatim: "\(Int(value))")
                        .font(.caption)
                }
                .padding()
            }
        }
    }
    
    struct Items: View {
        
        let items: [ChordPro.Directive.FormattingAttribute]
        
        /// The directive
        let directive: ChordPro.Directive
        
        /// The observable state of the scene
        @Environment(SceneStateModel.self) var sceneState
        
        @State private var formState = FormStateModel()
        
        /// The dismiss environment
        @Environment(\.dismiss) var dismiss
        
        /// The label for the action button
        var actionLabel: String {
            sceneState.editorInternals.clickedDirective ? "Edit" : "Add"
        }
        
        var body: some View {
            VStack {
                Header(directive: directive)
                ForEach(items, id: \.self) { item in
                    switch item {
                    case .plain:
                        PlainField(label: "Content", prompt: directive.details.button, value: $formState.plain)
                    case .label:
                        PlainField(label: "Label", prompt: directive.details.button, value: $formState.label)
                    case .align:
                        AlignPicker(label: "Align", value: $formState.align)
                    case .flush:
                        AlignPicker(label: "Flush", value: $formState.flush)
                    case .src:
                        PlainField(label: "Source", prompt: directive.details.button, value: $formState.src)
                    case .width:
                        SizeSlider(label: "Width", start: 0, end: 1000, value: $formState.width)
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
                        
                        if items.contains(.plain) {
                            sceneState.editorInternals.directiveArgument = formState.plain
                        } else {
                            
                            var directiveArguments = sceneState.editorInternals.directiveArguments
                            directiveArguments[.plain] = nil
                            directiveArguments[.label] = formState.label.isEmpty ? nil : formState.label
                            directiveArguments[.align] = formState.align.isEmpty ? nil : formState.align
                            directiveArguments[.flush] = formState.flush.isEmpty ? nil : formState.flush
                            directiveArguments[.src] = formState.src.isEmpty ? nil : formState.src
                            directiveArguments[.width] = formState.width == 0 ? nil : String(Int(formState.width))
                            
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
            .task {
                formState.plain = sceneState.editorInternals.directiveArgument
                let arguments = sceneState.editorInternals.directiveArguments
                formState.label = arguments[.plain] ?? arguments[.label] ?? ""
                formState.align = arguments[.align] ?? ""
                formState.flush = arguments[.flush] ?? ""
                formState.width = Double(arguments[.width] ?? "0") ?? 0
                formState.src = arguments[.src] ?? ""
            }
        }
    }
}
