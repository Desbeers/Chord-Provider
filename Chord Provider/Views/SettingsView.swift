//
//  SettingsView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the settings
struct SettingsView: View {
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowserModel.self) private var fileBrowser
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// The AppDelegate to bring additional Windows into the SwiftUI world
    @Environment(AppDelegateModel.self) private var appDelegate
    /// Bool if **ChordPro CLI** averrable
    @State var haveChordProCLI: Bool = false
    /// The body of the `View`
    var body: some View {
        TabView {
            general
                .tabItem {
                    Label("General", systemImage: "gear")
                }
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
        .task {
            haveChordProCLI = await checkChordProCLI()
        }
    }

    /// `View` with general options
    @ViewBuilder var general: some View {
        @Bindable var appState = appState

        VStack {
            VStack(alignment: .leading) {
                Toggle("Show the welcome screen when creating a new document", isOn: $appState.settings.application.showWelcomeWindow)
                Text("When enabled you can choose between a new song, a new songbook or open an existing song. When disabled, a new song will be created.")
                    .font(.caption)
                Toggle("Add quick access to the menu bar", isOn: $appState.settings.application.showMenuBarExtra)
                Text("When enabled, you can access the welcome screen from the menu bar.")
                    .font(.caption)
                Toggle("Use a custom template for a new song", isOn: $appState.settings.application.useCustomSongTemplate)
                    .onChange(of: appState.settings.application.useCustomSongTemplate) {
                        /// Update the appState with the new song content
                        appState.standardDocumentContent = ChordProDocument.getSongTemplateContent(settings: appState.settings)
                        appState.newDocumentContent = appState.standardDocumentContent
                    }
            }
            UserFileButton(
                userFile: UserFileItem.customSongTemplate
            ) {
                /// Update the appState with the new song content
                appState.standardDocumentContent = ChordProDocument.getSongTemplateContent(settings: appState.settings)
                appState.newDocumentContent = appState.standardDocumentContent
            }
            .disabled(!appState.settings.application.useCustomSongTemplate)
            Text("You can use your own **ChordPro** file as a starting point when you create a new song")
                .font(.caption)
        }
        .wrapSettingsSection(title: "General Options")
        .frame(maxHeight: .infinity, alignment: .top)
    }

    /// `View` with song options
    @ViewBuilder var options: some View {
        @Bindable var appState = appState
        ScrollView {
            VStack(alignment: .leading) {
                AppStateModel.RepeatWholeChorusToggle(appState: appState)
                AppStateModel.LyricsOnlyToggle(appState: appState)
            }
            .wrapSettingsSection(title: "Display Options")
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
                }
                UserFileButton(
                    userFile: UserFileItem.customChordProConfig
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
                    userFile: UserFileItem.customChordProLibrary
                ) {}
                    .disabled(!appState.settings.chordPro.useChordProCLI || !appState.settings.chordPro.useAdditionalLibrary)
            }
            .wrapSettingsSection(title: "ChordPro Integration")
            .disabled(!haveChordProCLI)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    /// `View` with diagram display options
    var diagram: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    AppStateModel.FingersToggle(appState: appState)
                    AppStateModel.NotesToggle(appState: appState)
                    AppStateModel.MirrorToggle(appState: appState)
                }
                .wrapSettingsSection(title: "General")
                VStack(alignment: .leading) {
                    AppStateModel.PlayToggle(appState: appState)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if appState.settings.song.diagram.showPlayButton {
                        AppStateModel.MidiInstrumentPicker(appState: appState)
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
                    Text(.init(Help.fileBrowser))
                        .padding()
                    fileBrowser.folderSelector
                        .padding()
                    Text(.init(Help.musicPath))
                        .font(.caption)
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
