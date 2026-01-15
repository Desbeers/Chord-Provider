//
//  Views+Editor+Edit.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Editor {

    /// The `View` to edit a line
    struct Edit: View {
        init(appState: Binding<AppState>) {
            self._appState = appState
            self.directive = appState.editor.currentLine.directive.wrappedValue ?? appState.editor.handleDirective.wrappedValue ?? .title
            let state = FormState(line: appState.editor.currentLine.wrappedValue)
            /// Store the initial values to disable the button if nothing has changed
            self.initialState = state
            self._formState = State(wrappedValue: state)
            self.newDefinition = appState.editor.currentLine.directive.wrappedValue == nil
        }

        let directive: ChordPro.Directive

        let newDefinition: Bool

        /// The state of the application
        @Binding var appState: AppState

        let initialState: FormState

        @State private var formState: FormState
        var view: Body {
            VStack {
                Text(directive.details.help)
                    .wrap()
                    .padding(.bottom)
                Separator()
                    .padding(.bottom)
                ForEach(directive.attributes) { attribute in
                    switch attribute {
                    case .plain:
                        PlainField(label: directive.details.label, prompt: directive.details.label, value: $formState.plain)
                            .padding(.bottom)
                    case .label:
                        PlainField(label: "Label", prompt: directive.details.label, value: $formState.label)
                            .padding(.bottom)
                    case .align:
                        AlignPicker(label: "Align", value: $formState.align)
                            .padding(.bottom)
                    case .flush:
                        AlignPicker(label: "Flush", value: $formState.flush)
                            .padding(.bottom)
                    case .src:
                        // TODO: Make this a file picker
                        PlainField(label: "File", prompt: directive.details.label, value: $formState.src)
                            .padding(.bottom)
                    case .width:
                        NumberSpinner(
                            label: "Optional Width",
                            start: 0, end: 1000,
                            suffix: "points",
                            value: $formState.width,
                            help: attribute.help
                        )
                        .padding(.bottom)
                    case .height:
                        NumberSpinner(
                            label: "Optional Height",
                            start: 0, end: 1000,
                            suffix: "points",
                            value: $formState.height,
                            help: attribute.help
                        )
                        .padding(.bottom)
                    case .scale:
                        NumberSpinner(
                            label: "Optional Scale",
                            start: 0, end: 100,
                            suffix: "%",
                            value: $formState.scale,
                            help: attribute.help
                        )
                        .padding(.bottom)
                    case .tuplet:
                        NumberSpinner(
                            label: "Optional Tuplet",
                            start: 2, end: 4,
                            suffix: "",
                            value: $formState.tuplet,
                            help: attribute.help
                        )
                        .padding(.bottom)
                    case .numeric:
                        switch directive {
                        case .year, .copyright:
                            NumberSpinner(
                                label: directive.details.label,
                                start: 1900, end: 2030,
                                suffix: "",
                                value: $formState.numeric,
                                help: attribute.help
                            )
                            .padding(.bottom)
                        case .tempo:
                            NumberSpinner(
                                label: "Tempo",
                                start: 60, end: 240,
                                suffix: "bpm",
                                value: $formState.numeric,
                                help: attribute.help
                            )
                            .padding(.bottom)
                        default:
                            NumberSpinner(
                                label: "Unknown",
                                start: 0, end: 100,
                                suffix: "",
                                value: $formState.numeric,
                                help: attribute.help
                            )
                            .padding(.bottom)
                        }
                    case .key:
                        KeyPicker(label: "Key", value: $formState.plain)
                            .padding(.bottom)
                    default:
                        Text("\(attribute.rawValue) is not implemented")
                            .padding(.bottom)
                    }
                }
                if let info = directive.details.info {
                    Text(info)
                        .caption()
                        .padding([.leading, .trailing, .bottom])
                }
                Separator()
                HStack(spacing: 10) {
                    Button("Cancel") {
                        appState.editor.command = .clearSelection
                        appState.editor.showEditDirectiveDialog = false
                        appState.editor.handleDirective = nil
                    }
                    Button("\(newDefinition ? "Insert" : "Update") Directive") {
                        appState.editor.currentLine.plain = formState.plain.isEmpty ? nil : formState.plain
                        /// The directive might have plain argument that we have here as numeric
                        if ChordPro.Directive.withPlainArgument.contains(directive) {
                            /// This is a simple plain argument
                            appState.editor.currentLine.plain = formState.numeric == 0 ? formState.plain : String(formState.numeric)
                        } else {
                            /// Update the current arguments
                            var arguments = appState.editor.currentLine.arguments ?? [:]
                            arguments[.label] = formState.label.isEmpty ? nil : formState.label
                            arguments[.align] = formState.align.isEmpty ? nil : formState.align
                            arguments[.flush] = formState.flush.isEmpty ? nil : formState.flush
                            arguments[.src] = formState.src.isEmpty ? nil : formState.src
                            arguments[.width] = formState.width == 0 ? nil : String(Int(formState.width))
                            arguments[.height] = formState.height == 0 ? nil : String(Int(formState.height))
                            arguments[.tuplet] = formState.tuplet == 0 ? nil : String(formState.tuplet)
                            arguments[.scale] = formState.scale == 0 ? nil : String("\(Int(formState.scale))%")
                            appState.editor.currentLine.arguments = arguments
                        }
                        let directiveArgument = ChordProParser.argumentsToString(appState.editor.currentLine) ?? ""
                        /// Make space for optional arguments
                        let spacer = directiveArgument.isEmpty ? "" : " "
                        let replacement = "{\(directive.rawValue.long)\(spacer)\(directiveArgument)}"
                        appState.editor.command = .replaceLineText(text: replacement)
                        appState.editor.showEditDirectiveDialog = false
                        appState.editor.handleDirective = nil
                    }
                    .suggested()
                    .insensitive(!enableSubmit)
                }
                .halign(.center)
                .padding(.top)
            }
            .padding([.leading, .trailing, .bottom])
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: "",
                            title: "\(directive.details.buttonLabel ?? directive.details.label)"
                        )
                    }
            }
        }

        private var enableSubmit: Bool {
            var result = false
            result  = formState == initialState ? false : true
            result = ChordPro.Directive.withPlainArgument.contains(directive) && formState.plain.isEmpty ? false : result
            return result
        }
    }
}
