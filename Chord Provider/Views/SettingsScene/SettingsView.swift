//
//  SettingsView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowserModel.self) private var fileBrowser
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// Bool if **ChordPro CLI** is available
    @State var haveChordProCLI: Bool = false
    /// The body of the `View`
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                general
            }
            Tab("Editor", systemImage: "pencil") {
                editor
            }
            Tab("Diagrams", systemImage: "guitars") {
                diagram
            }
            Tab("Songs", systemImage: "folder") {
                folder
            }
            Tab("Options", systemImage: "music.quarternote.3") {
                options
            }
        }
        .task {
            haveChordProCLI = await checkChordProCLI()
        }
    }

    /// `View` with general options
    @ViewBuilder var general: some View {
        @Bindable var appState = appState
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Toggle("Use a custom template for a new song", isOn: $appState.settings.application.useCustomSongTemplate)
                }
                UserFileButton(
                    userFile: UserFile.customSongTemplate
                ) {}
                    .disabled(!appState.settings.application.useCustomSongTemplate)
                Text("You can use your own **ChordPro** file as a starting point when you create a new song")
                    .font(.caption)
            }
            .wrapSettingsSection(title: "General Options")
            VStack {
                VStack(alignment: .leading) {
                    Toggle(isOn: $appState.settings.chordPro.useChordProCLI) {
                        Text("Use the official ChordPro to create a PDF")
                        Text("When enabled, PDF's will be rendered with the official ChordPro reference implementation.")
                    }
                    Toggle(isOn: $appState.settings.chordPro.useCustomConfig) {
                        Text("Use a custom ChordPro configuration")
                        Text("When enabled, ChordPro will use your own configuration.")
                    }
                    .disabled(!appState.settings.chordPro.useChordProCLI)
                }
                UserFileButton(
                    userFile: UserFile.customChordProConfig
                ) {}
                    .disabled(!appState.settings.chordPro.useChordProCLI || !appState.settings.chordPro.useCustomConfig)
                VStack(alignment: .leading) {
                    Toggle(isOn: $appState.settings.chordPro.useAdditionalLibrary) {
                        Text("Add a custom library")
                        // swiftlint:disable:next line_length
                        Text("**ChordPro** has a built-in library with configs and other data. With *custom library* you can add an additional location where to look for data.")
                    }
                    .disabled(!appState.settings.chordPro.useChordProCLI)
                }
                UserFileButton(
                    userFile: UserFile.customChordProLibrary
                ) {}
                    .disabled(!appState.settings.chordPro.useChordProCLI || !appState.settings.chordPro.useAdditionalLibrary)
            }
            .wrapSettingsSection(title: "ChordPro CLI Integration")
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    /// `View` with song options
    @ViewBuilder var options: some View {
        @Bindable var appState = appState
        ScrollView {
            VStack(alignment: .leading) {
                appState.repeatWholeChorusToggle
                appState.lyricsOnlyToggle
            }
            .wrapSettingsSection(title: "Display Options")
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    /// `View` with diagram display options
    var diagram: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    appState.fingersToggle
                    appState.notesToggle
                    appState.mirrorToggle
                }
                .wrapSettingsSection(title: "General")
                VStack(alignment: .leading) {
                    appState.playToggle
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if appState.settings.song.diagram.showPlayButton {
                        appState.midiInstrumentPicker
                            .padding([.top, .leading])
                    }
                }
                .wrapSettingsSection(title: "MIDI")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Button(
                action: {
                    appState.settings.song.diagram = AppSettings.DiagramDisplayOptions()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .disabled(appState.settings.song.diagram == AppSettings.DiagramDisplayOptions())
            .padding(.bottom)
        }
        .animation(.default, value: appState.settings.song.diagram.showPlayButton)
    }

    /// `View` with editor settings
    @ViewBuilder var `editor`: some View {
        @Bindable var appState = appState
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("A")
                            .font(.system(size: Editor.Settings.fontSizeRange.lowerBound))
                        Slider(
                            value: $appState.settings.editor.fontSize,
                            in: Editor.Settings.fontSizeRange,
                            step: 1
                        )
                        Text("A")
                            .font(.system(size: Editor.Settings.fontSizeRange.upperBound))
                    }
                    .foregroundColor(.secondary)
                    Picker("Font style", selection: $appState.settings.editor.fontStyle) {
                        ForEach(Editor.Settings.FontStyle.allCases, id: \.self) { font in
                            Text("\(font.rawValue)")
                                .font(font.font())
                        }
                    }
                }
                .wrapSettingsSection(title: "Editor Font")
                VStack {
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.chordColor,
                        label: "Color for **chords**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.directiveColor,
                        label: "Color for **directives**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.argumentColor,
                        label: "Color for **arguments**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.markupColor,
                        label: "Color for **markup**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.bracketColor,
                        label: "Color for **brackets**"
                    )
                    ColorPickerButton(
                        selectedColor: $appState.settings.editor.commentColor,
                        label: "Color for **comments**"
                    )
                }
                .wrapSettingsSection(title: "Highlight Colors")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            Button(
                action: {
                    appState.settings.editor = Editor.Settings()
                },
                label: {
                    Text("Reset to defaults")
                }
            )
            .padding(.bottom)
            .disabled(appState.settings.editor == Editor.Settings())
        }
    }

    /// `View` with folder selector
    var folder: some View {
        VStack {
            ScrollView {
                VStack {
                    Text(.init(Help.fileBrowser))
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

    func checkChordProCLI() async -> Bool {
        if (try? await Terminal.getChordProBinary()) != nil {
            return true
        }
        return false
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
