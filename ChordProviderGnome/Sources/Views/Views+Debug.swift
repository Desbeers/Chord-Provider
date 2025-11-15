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
        /// The current song
        let song: Song
        // the app
        let app: AdwaitaApp
        /// the selected tab
        @State private var selectedTab: Tab = .source
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
                        Views.Log(app: app)
                    case .source:
                        source
                    }
                }
            }
            .hexpand()
            .topToolbar {
                HeaderBar() { } end: { }
                    .headerBarTitle {
                        ViewSwitcher(selectedElement: $selectedTab)
                            .wideDesign(true)
                    }
            }
        }

        @ViewBuilder var source: Body {
            Separator()
            //SourceView(text: .constant(song.content))
            ScrollView {
                VStack {
                    ForEach(getSource()) { line in
                        VStack {
                            HStack {
                                Text("\(line.id)")
                                    .frame(minWidth: 40)
                                    .halign(.end)
                                SourceView(text: .constant(line.source.sourceParsed))
                                    .editable(false)
                                    .highlightCurrentLine(false)
                                    .language(.chordpro)
                                    .hexpand()
                            }
                            .valign(.center)
                            VStack(spacing: 0) {
                                if let warnings = line.source.warnings {
                                    Text(.init("\(warnings.joined(separator: ", "))"))
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
            VStack {
                Separator()
                Label("A negative line number means the line is added by the <b>parser</b> and is not part of the current document")
                    .useMarkup()
                Label("A <b>bold</b> line number means the <b>source line</b> has warnings that the parser will try to resolve")
                    .useMarkup()
            }
        }

        @ViewBuilder var json: Body {
            Separator()
            ScrollView {
                VStack {
                    FormSection("Metadata") {
                        let metadata = try? JSONUtils.encode(song.metadata)
                        sectionPart(
                            row: ExpanderRow().title("<b>Metadata</b>").rows {
                                sourceView(metadata)
                            }
                        )
                    }
                    FormSection("Sections") {
                        ForEach(song.sections) { section in
                            let content = try? JSONUtils.encode(section)

                            sectionPart(
                                row: ExpanderRow().title("Section <b>\(section.environment.rawValue)</b>").rows {
                                    sourceView(content)
                                }
                            )
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 700)
            }
            .vexpand()
        }

        enum Tab: String, CaseIterable, ViewSwitcherOption {
            var title: String {
                self.rawValue
            }

            var icon: Adwaita.Icon {
                .default(icon: .acAdapter)
            }

            /// Log messages
            case log = "Log output"
            /// Song source messages
            case source = "Generated Source"
            /// Generated JSON messages
            case json = "JSON output"
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

        private func sourceView(_ text: String?) -> AnyView {
            SourceView(text: .constant(text ?? "Error"))
                .language(.json)
                .editable(false)
        }

        func getSource() -> [Source]  {
            var source: [Source] = []
            for line in song.sections.flatMap(\.lines) {
                source.append(Source(id: line.sourceLineNumber, source: line))
            }
            return source
        }
    }
}
