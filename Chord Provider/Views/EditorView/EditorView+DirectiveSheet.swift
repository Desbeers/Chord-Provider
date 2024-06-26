//
//  EditorView+DirectiveSheet.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension EditorView {

    /// SwiftUI `View` to define a directive
    struct DirectiveSheet: View {

        /// The directive settings
        @Binding var settings: DirectiveSettings

        /// The scene state
        @Environment(SceneState.self) var sceneState

        /// The label for the action button
        var actionLabel: String

        /// The value for a slider
        @State private var sliderValue: Double = 0

        /// Init the `View`
        init(settings: Binding<DirectiveSettings>) {
            self._settings = settings
            self.actionLabel = settings.clickedFragment.wrappedValue == nil ? "Add" : "Update"
        }
        /// The dismiss environment
        @Environment(\.dismiss) var dismiss
        /// The body of the `View`
        var body: some View {
            VStack {
                switch settings.directive {
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
                    settings.definition = ""
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

extension EditorView.DirectiveSheet {

    /// `View` of the directive sheet title
    @ViewBuilder var directiveTitleView: some View {
        Text(settings.directive.details.label)
            .font(.title)
            .padding(.bottom, 4)
        Text(settings.directive.details.help)
            .foregroundStyle(.secondary)
            .padding(.bottom)
    }
}

extension EditorView.DirectiveSheet {
    /// The default `View` when there is no specific `View` for the ``ChordPro/Directive``
    @ViewBuilder var defaultView: some View {
        directiveTitleView
        TextField(
            text: $settings.definition,
            prompt: Text(settings.directive.details.label)
        ) {
            Text("Value")
        }
        .frame(width: 400)
        .padding(.bottom)
        HStack {
            cancelButton
            Button(
                action: {
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
                    settings.definition = sceneState.chordDisplayOptions.definition.define
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
            Slider(value: $sliderValue, in: start...end, step: 1) { _ in
                settings.definition = String(Int(sliderValue))
            }
            Text(verbatim: "\(Int(sliderValue))")
                .font(.caption)
        }
        .padding()
        HStack {
            cancelButton
            Button(
                action: {
                    settings.definition = String(Int(sliderValue))
                    dismiss()
                },
                label: {
                    Text("\(actionLabel) \(settings.directive.details.label)")
                }
            )
            .keyboardShortcut(.defaultAction)
        }
        .onAppear {
            sliderValue = Double(settings.definition) ?? (start + end) / 2
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
                    settings.definition = "\(sceneState.chordDisplayOptions.definition.root.rawValue)\(sceneState.chordDisplayOptions.definition.quality.rawValue)"
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
