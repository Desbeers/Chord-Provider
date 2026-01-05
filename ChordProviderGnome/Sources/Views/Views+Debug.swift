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
        /// The state of the application
        @Binding var appState: AppState
        /// The selected json page
        @State private var jsonSelection: JSONPage = .metadata
        /// The body of the `View`
        var view: Body {
            VStack {
                ToggleGroup(selection: $appState.scene.selectedDebugTab, values: Tab.allCases)
                    .padding()
                Text(appState.scene.selectedDebugTab.help)
                    .style(.title)
                    .padding(5, .bottom)
                Separator()
                switch appState.scene.selectedDebugTab {
                case .json:
                    json
                case .log:
                    Views.Log()
                case .source:
                    source
                }
            }
            .vexpand()
            .hexpand()
            .card()
            .padding()
            Button("Back to your song") {
                appState.scene.showDebug = false
            }
            .halign(.center)
            .suggested()
            .padding(5, .bottom)
        }

        // MARK: Source View

        @ViewBuilder var source: Body {
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
                                    ForEach(Array(warnings)) { warning in
                                        Text(warning.message)
                                            .useMarkup()
                                            .levelStyle(warning.level)
                                            .halign(.start)
                                    }
                                    Text(line.source.source)
                                        .style(.caption)
                                        .padding(5, .leading)
                                        .halign(.start)
                                }
                                if line.source.sourceLineNumber < 1 {
                                    Text("The directive is added by the parser")
                                        .levelStyle(.info)
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
            }
            .padding()
        }

        // MARK: JSON View

        @ViewBuilder var json: Body {
            NavigationSplitView {
                List(JSONPage.allCases, selection: $jsonSelection) { element in
                    Text(element.description)
                        .halign(.start)
                        .padding()
                }
            } content: {
                ScrollView {
                    VStack {
                        switch jsonSelection {
                        case .metadata:
                            let metadata = try? JSONUtils.encode(appState.editor.song.metadata)
                            sourceView(metadata)
                        case .sections:
                            ForEach(appState.editor.song.sections) { section in
                                let content = try? JSONUtils.encode(section)
                                sectionPart(
                                    row: ExpanderRow().title("Section <b>\(section.environment.rawValue)</b>").rows {
                                        sourceView(content)
                                    }
                                )
                            }
                        case .chords:
                            ForEach(appState.editor.song.chords) { chord in
                                let content = try? JSONUtils.encode(chord)
                                sectionPart(
                                    row: ExpanderRow().title("Chord <b>\(chord.display)</b>").rows {
                                        HStack {
                                            Widgets.ChordDiagram(chord: chord, settings: appState.editor.song.settings)
                                                .valign(.start)
                                            sourceView(content)
                                                .hexpand()
                                        }
                                    }
                                )
                            }
                        case .settings:
                            let metadata = try? JSONUtils.encode(appState.editor.song.settings)
                            sourceView(metadata)
                        }
                    }
                    .padding()
                }
            }
            .vexpand()
        }

        enum Tab: String, ToggleGroupItem, CaseIterable, CustomStringConvertible {
            var id: Self { self }

            var description: String { rawValue }

            var help: String {
                switch self {
                case .log:
                    "The logging messages generated during the song parsing"
                case .source:
                    "The generated source for your song"
                case .json:
                    "The JSON representation of the song"
                }
            }

            var icon: Icon? {
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

            var showLabel: Bool { true }
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
               rawValue
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
            SourceView(bridge: .constant(SourceViewBridge(song: Song(id: UUID(), content: text ?? ""))))
                .language(language)
                .editable(false)
                .highlightCurrentLine(false)
        }

        func getSource() -> [Source] {
            dump(appState.editor.song.settings)
            var source: [Source] = []
            for line in appState.editor.song.sections.flatMap(\.lines) {
                source.append(Source(id: line.sourceLineNumber, source: line))
            }
            return source
        }
    }
}
