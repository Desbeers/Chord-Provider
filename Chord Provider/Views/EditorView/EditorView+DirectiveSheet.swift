//
//  EditorView+DirectiveSheet.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// SwiftUI `View` to define a directive
    struct DirectiveSheet: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The observable state of the scene
        @Environment(SceneStateModel.self) var sceneState
        /// The label for the action button
        var actionLabel: String {
            sceneState.editorInternals.clickedDirective ? "Edit" : "Add"
        }
        /// The value for a slider
        @State private var sliderValue: Double = 0
        /// The dismiss environment
        @Environment(\.dismiss) var dismiss
        /// The body of the `View`
        var body: some View {
            VStack {
                switch directive {
                case .key:
                    keyView
                case .define:
                    defineView
                case .tempo:
                    sliderView(start: 60, end: 240)
                case .year:
                    sliderView(start: 1900, end: 2024)
                default:
                    defaultView
                }
            }
            .padding()
            .animation(.smooth, value: sliderValue)
        }
        /// The cancel button
        var cancelButton: some View {
            Button(
                action: {
                    dismiss()
                },
                label: {
                    Text("Cancel")
                }
            )
            .keyboardShortcut(.cancelAction)
        }

        private func format() {
            Editor.format(directive: directive, editorInternals: sceneState.editorInternals)
        }
    }
}

extension EditorView.DirectiveSheet {

    /// `View` of the directive sheet title
    @ViewBuilder var directiveTitleView: some View {
        Text(directive.details.label)
            .font(.title)
            .padding(.bottom, 4)
        Text(directive.details.help)
            .foregroundStyle(.secondary)
            .padding(.bottom)
    }
}

extension EditorView.DirectiveSheet {
    /// The default `View` when there is no specific `View` for the ``ChordPro/Directive``
    @ViewBuilder var defaultView: some View {
        @Bindable var sceneState = sceneState
        directiveTitleView
        TextField(
            text: $sceneState.editorInternals.directiveArgument,
            prompt: Text(directive.details.label)
        ) {
            Text("Value")
        }
        .frame(width: 400)
        .padding(.bottom)
        HStack {
            cancelButton
            Button(
                action: {
                    format()
                    dismiss()
                },
                label: {
                    Text("\(actionLabel) Directive")
                }
            )
            .keyboardShortcut(.defaultAction)
        }
    }
}

extension EditorView.DirectiveSheet {

    /// `View` to define a chord
    @ViewBuilder var defineView: some View {
        @Bindable var chordDisplayOptions = sceneState.chordDisplayOptions
        CreateChordView(chordDisplayOptions: $chordDisplayOptions)
        HStack {
            cancelButton
            Button(
                action: {
                    sceneState.editorInternals.directiveArgument = sceneState.chordDisplayOptions.definition.define
                    format()
                    dismiss()
                },
                label: {
                    Text("\(actionLabel) Definition")
                }
            )
            .keyboardShortcut(.defaultAction)
        }
    }
}

extension EditorView.DirectiveSheet {

    /// `View` to define the 'slider' for a number directive
    @ViewBuilder func sliderView(start: Double, end: Double) -> some View {
        directiveTitleView
        VStack {
            Slider(value: $sliderValue, in: start...end, step: 1)
            Text(verbatim: "\(Int(sliderValue))")
                .font(.caption)
        }
        .padding()
        HStack {
            cancelButton
            Button(
                action: {
                    sceneState.editorInternals.directiveArgument = String(Int(sliderValue))
                    format()
                    dismiss()
                },
                label: {
                    Text("\(actionLabel) \(directive.details.label)")
                }
            )
            .keyboardShortcut(.defaultAction)
        }
        .onAppear {
            sliderValue = Double(sceneState.editorInternals.directiveArgument) ?? (start + end) / 2
        }
    }
}

extension EditorView.DirectiveSheet {

    /// `View` to define the 'key' of the song
    @ViewBuilder var keyView: some View {
        directiveTitleView
        HStack {
            sceneState.chordDisplayOptions.rootPicker
            sceneState.chordDisplayOptions.qualityPicker
        }
        .padding()
        .labelsHidden()
        HStack {
            cancelButton
            Button(
                action: {
                    sceneState.editorInternals.directiveArgument =
                    "\(sceneState.chordDisplayOptions.definition.root.rawValue)" +
                    "\(sceneState.chordDisplayOptions.definition.quality.rawValue)"
                    format()
                    dismiss()
                },
                label: {
                    Text("\(actionLabel) Key")
                }
            )
            .keyboardShortcut(.defaultAction)
        }
    }
}
