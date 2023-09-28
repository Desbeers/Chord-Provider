//
//  EditorView+DirectiveSheet.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension EditorView {

    /// SwiftUI `View` to difine a directive
    struct DirectiveSheet: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The definition
        @Binding var definition: String
        /// Chord Display Options
        @EnvironmentObject private var chordDisplayOptions: ChordDisplayOptions
        /// The dismiss environment
        @Environment(\.dismiss) var dismiss
        /// The body of the `View`
        var body: some View {
            VStack {
                switch directive {
                case .define:
                    CreateChordView()
                    HStack {
                        cancelButton
                        Button(
                            action: {
                                definition = chordDisplayOptions.definition.define
                                dismiss()
                            },
                            label: {
                                Text("Add Definition")
                            }
                        )
                        .keyboardShortcut(.defaultAction)
                    }
                default:
                    Text(directive.label.text)
                        .font(.title)
                    TextField(
                        text: $definition,
                        prompt: Text(directive.label.text),
                        label: {
                            Text("Value")
                        })
                    .frame(width: 400)
                    .padding(.bottom)
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        cancelButton
                        Button(
                            action: {
                                dismiss()
                            },
                            label: {
                                Text("Add Directive")
                            }
                        )
                        .keyboardShortcut(.defaultAction)
                    }
                }
            }
            .padding()
        }
        /// The cancel buttion
        var cancelButton: some View {
            Button(
                action: {
                    definition = ""
                    dismiss()
                },
                label: {
                    Text("Cancel")
                }
            )
            .keyboardShortcut(.cancelAction)
        }
    }
}
