//
//  Views+Debug.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

extension Views {

    /// The `View` for showing debug messages
    struct Debug: View {
        /// The app
        let app: AdwaitaApp
        /// The state of the application
        @Binding var appState: AppState
        /// The current song
        let song: Song
        /// The selected tab
        @State private var selectedTab: Tab = .source
        /// the selected json page
        @State private var jsonSelection: JSONPage = .metadata
        /// The body of the `View`
        var view: Body {
            VStack {
                if song.content.isEmpty {
                    StatusPage(
                        "No song open",
                        icon: .default(icon: .folderMusic),
                        description: "There is nothing to show."
                    )
                } else {
                    switch selectedTab {
                    case .json:
                        json
                    case .log:
                        Views.Log(main: false, app: app)
                    case .source:
                        source
                    }
                }
            }
            .hexpand()
            .topToolbar {
                HeaderBar { } end: { }
                    .headerBarTitle {
                        ViewSwitcher(selectedElement: $selectedTab)
                            .wideDesign(true)
                    }
            }
        }

        // MARK: Source View

        @ViewBuilder var source: Body {
            Separator()
            ScrollView {
                VStack {
                    ForEach(getSource()) { line in
                        VStack {
                            HStack {
                                Text("\(line.id)")
                                    .style(line.source.warnings == nil ? .none : .bold)
                                    .frame(minWidth: 40)
                                    .halign(.end)
                                sourceView(line.source.sourceParsed, language: .chordpro)
                                    .hexpand()
                            }
                            .valign(.center)
                            VStack(spacing: 0) {
                                if let warnings = line.source.warnings {
                                    Text(Utils.convertMarkdown("\(warnings.joined(separator: ", "))"))
                                        .useMarkup()
                                        .padding()
                                        .style(.logError)
                                }
                                if line.source.sourceLineNumber < 1 {
                                    Text("The directive is added by the parser")
                                        .padding()
                                        .style(.logWarning)
                                }
                            }
                            .halign(.start)
                            .hexpand()
                        }
                        .padding()
                        Separator()
                    }
                }
                .vexpand()
            }
            Separator()
            HStack {
                VStack {
                    Label("A negative line number means the line is added by the <b>parser</b> and is not part of the current document")
                        .useMarkup()
                        .halign(.start)
                    Label("A <b>bold</b> line number means the <b>source line</b> has warnings that the parser will try to resolve")
                        .useMarkup()
                        .halign(.start)
                }
                .style("caption")
                .hexpand()
                if appState.settings.editor.showEditor {
                    Button("Clean Source") {
                        appState.scene.source = song.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                    }
                } else {
                    Button("Open Editor") {
                        appState.settings.editor.splitter = appState.settings.editor.restoreSplitter
                        appState.settings.editor.showEditor.toggle()
                    }
                }
            }
            .padding()
        }

        // MARK: JSON View

        @ViewBuilder var json: Body {
            Separator()
            NavigationSplitView {
                List(JSONPage.allCases, selection: $jsonSelection) { element in
                    Text(element.description)
                        .ellipsize()
                        .halign(.start)
                        .padding()
                }
                .sidebarStyle()
            } content: {
                ScrollView {
                    VStack {
                        switch jsonSelection {
                        case .metadata:
                            let metadata = try? JSONUtils.encode(song.metadata)
                            sourceView(metadata)
                        case .sections:
                            ForEach(song.sections) { section in
                                let content = try? JSONUtils.encode(section)
                                sectionPart(
                                    row: ExpanderRow().title("Section <b>\(section.environment.rawValue)</b>").rows {
                                        sourceView(content)
                                    }
                                )
                            }
                        case .chords:
                            ForEach(song.chords) { chord in
                                let content = try? JSONUtils.encode(chord)
                                sectionPart(
                                    row: ExpanderRow().title("Chord <b>\(chord.display)</b>").rows {
                                        HStack {
                                            Widgets.ChordDiagram(chord: chord, settings: appState.settings)
                                                .valign(.start)
                                            sourceView(content)
                                                .hexpand()
                                        }
                                    }
                                )
                            }
                        case .settings:
                            let metadata = try? JSONUtils.encode(song.settings)
                            sourceView(metadata)
                        }
                    }
                    .padding()
                }
            }
            .vexpand()
        }

        enum Tab: String, CaseIterable, ViewSwitcherOption {
            /// The title of the tab
            var title: String {
                self.rawValue
            }
            /// The icon of the tab
            var icon: Icon {
                .default(icon: {
                    switch self {
                    case .log:
                        .dialogInformation
                    case .source:
                        .formatJustifyLeft
                    case .json:
                        .viewListBullet
                    }
                }())
            }
            /// Log messages
            case log = "Log output"
            /// Song source messages
            case source = "Generated Source"
            /// Generated JSON messages
            case json = "JSON output"
        }

        enum JSONPage: String, Identifiable, CaseIterable, Codable, CustomStringConvertible {
            var id: Self {
                self
            }
            var description: String {
                self.rawValue
            }
            case metadata = "Metadata"
            case sections = "Sections"
            case chords = "Chords"
            case settings = "Settings"
        }

        struct Source: Identifiable {
            let id: Int
            let source: Song.Section.Line
        }

        private func sectionPart(row: AnyView) -> AnyView {
            Form {
                row
            }
            .padding()
        }

        private func sourceView(_ text: String?, language: Language = .json) -> AnyView {
            SourceView(text: .constant(text ?? "Error"))
                .language(language)
                .editable(false)
                .highlightCurrentLine(false)
        }

        func getSource() -> [Source] {
            var source: [Source] = []
            for line in song.sections.flatMap(\.lines) {
                source.append(Source(id: line.sourceLineNumber, source: line))
            }
            return source
        }
    }
}
