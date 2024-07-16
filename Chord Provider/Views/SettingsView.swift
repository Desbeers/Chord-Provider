//
//  SettingsView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import ChordProShared
import SwiftlyChordUtilities

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// Chord Display Options
    @State private var chordDisplayOptions = ChordDisplayOptions(defaults: AppSettings.defaults)
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowser.self) private var fileBrowser
    /// The app state
    @Environment(AppState.self) var appState
    /// Dismiss
    @Environment(\.dismiss) private var dismiss
    /// The body of the `View`
    var body: some View {
        TabView {
            editor
                .tabItem {
                    Label("Editor", systemImage: "pencil")
                }
            diagram
                .tabItem {
                    Label("Diagrams", systemImage: "guitars")
                }
            folder
                .tabItem {
                    Label("Songs", systemImage: "folder")
                }
            options
                .tabItem {
                    Label("Options", systemImage: "music.quarternote.3")
                }
        }
        .background(Color.white.colorMultiply(Color.telecaster))
        .toolbarBackground(.telecaster.gradient)
        .task {
            chordDisplayOptions.displayOptions = appState.settings.chordDisplayOptions
        }
        .onChange(of: chordDisplayOptions.displayOptions) {
            appState.settings.chordDisplayOptions = chordDisplayOptions.displayOptions
        }
    }

    /// `View` with general options
    @ViewBuilder var options: some View {
        @Bindable var appState = appState
        VStack(alignment: .leading) {
            appState.repeatWholeChorusToggle
            appState.lyricsOnlyToggle
        }
        .wrapSettingsSection(title: "General Options")
        .frame(maxHeight: .infinity, alignment: .top)
    }

    /// `View` with diagram display options
    var diagram: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    chordDisplayOptions.fingersToggle
                    chordDisplayOptions.notesToggle
                    chordDisplayOptions.mirrorToggle
                }
                .wrapSettingsSection(title: "General")
                VStack(alignment: .leading) {
                    chordDisplayOptions.playToggle
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if chordDisplayOptions.displayOptions.general.showPlayButton {
                        HStack {
                            Image(systemName: "guitars.fill")
                            chordDisplayOptions.midiInstrumentPicker
                        }
                        .disabled(!chordDisplayOptions.displayOptions.general.showPlayButton)
                        .padding([.top, .leading])
                    }
                }
                .wrapSettingsSection(title: "MIDI")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Button(
                action: {
                    chordDisplayOptions.displayOptions = AppSettings.defaults
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(chordDisplayOptions.displayOptions == AppSettings.defaults)
            .padding(.bottom)
        }
        .animation(.default, value: chordDisplayOptions.displayOptions.general)
    }

    /// `View` with editor settings
    @ViewBuilder var `editor`: some View {
        @Bindable var appState = appState
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("A")
                            .font(.system(size: ChordProEditor.Settings.fontSizeRange.lowerBound))
                        Slider(
                            value: $appState.settings.editor.fontSize,
                            in: ChordProEditor.Settings.fontSizeRange,
                            step: 1
                        )
                        Text("A")
                            .font(.system(size: ChordProEditor.Settings.fontSizeRange.upperBound))
                    }
                    .foregroundColor(.secondary)
                    Picker("Font style", selection: $appState.settings.editor.fontStyle) {
                        ForEach(ChordProEditor.Settings.FontStyle.allCases, id: \.self) { font in
                            Text("\(font.rawValue)")
                                .font(font.font())
                        }
                    }
                }
                .wrapSettingsSection(title: "Editor Font")
                VStack {
                    ColorPickerButtonView(
                        selectedColor: $appState.settings.editor.chordColor,
                        label: "Color for **chords**"
                    )
                    ColorPickerButtonView(
                        selectedColor: $appState.settings.editor.directiveColor,
                        label: "Color for **directives**"
                    )
                    ColorPickerButtonView(
                        selectedColor: $appState.settings.editor.argumentColor,
                        label: "Color for **arguments**"
                    )
                    ColorPickerButtonView(
                        selectedColor: $appState.settings.editor.markupColor,
                        label: "Color for **markup**"
                    )
                    ColorPickerButtonView(
                        selectedColor: $appState.settings.editor.bracketColor,
                        label: "Color for **brackets**"
                    )
                    ColorPickerButtonView(
                        selectedColor: $appState.settings.editor.commentColor,
                        label: "Color for **comments**"
                    )
                }
                .wrapSettingsSection(title: "Highlight Colors")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Button(
                action: {
                    appState.settings.editor = ChordProEditor.Settings()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(appState.settings.editor == ChordProEditor.Settings())
        }
    }

    /// `View` with folder selector
    var folder: some View {
        VStack {
            ScrollView {
                VStack {
                    Text(.init(Help.folderSelector))
                        .padding()
                    Text(.init(Help.macOSbrowser))
                        .padding()
                    fileBrowser.folderSelector
                        .padding()
                }
                .wrapSettingsSection(title: "The folder with your songs")
            }
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity)
    }
}

extension SettingsView {

    struct WrapSettingsSection: ViewModifier {
        let title: String
        func body(content: Content) -> some View {
            VStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary.opacity(0.04).cornerRadius(8))
            }
            .padding([.top, .horizontal])
            .frame(maxWidth: .infinity)
        }
    }
}

extension View {

    /// Shortcut to the `WrapSettingsSection` modifier
    /// - Parameter title: The title
    /// - Returns: A modified `View`
    func wrapSettingsSection(title: String) -> some View {
        modifier(SettingsView.WrapSettingsSection(title: title))
    }
}
