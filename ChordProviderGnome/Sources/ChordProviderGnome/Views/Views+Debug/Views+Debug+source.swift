//
//  Views+Debug+source.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderEditor

extension Views.Debug {

    // MARK: Source View

    /// The `View` for the source view
    @ViewBuilder var source: Body {
        ScrollView {
            VStack {
                ForEach(getSource()) { line in
                    VStack {
                        HStack {
                            Text("\(line.id)")
                                .style(line.source.warnings.isEmpty ? .noStyle : .bold)
                                .frame(minWidth: 40)
                                .halign(.end)
                            sourceView(line.source.sourceParsed, language: .chordpro)
                                .hexpand()
                        }
                        .valign(.end)
                        VStack(spacing: 0) {
                            if !line.source.warnings.isEmpty {
                                ForEach(Array(line.source.warnings)) { warning in
                                    Text(warning.message.escapeSpecialCharacters)
                                        .useMarkup()
                                        .logLevelStyle(warning.level)
                                        .halign(.start)
                                }
                                Text("<b>Current source</b>: \(line.source.source)")
                                    .useMarkup()
                                    .style(.caption)
                                    .padding(5, .leading)
                                    .halign(.start)
                            }
                            if line.source.sourceLineNumber < 1 {
                                Text("The directive is added by the parser")
                                    .logLevelStyle(.info)
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

    /// Get the source of the song
    /// - Returns: The source in a ``Source`` array
    private func getSource() -> [Source] {
        appState.editor.song.allLines.map { line in
            Source(id: line.sourceLineNumber, source: line)
        }
    }

    /// The structure for a source line
    private struct Source: Identifiable {
        /// The ID of the source line
        let id: Int
        /// The actual line
        let source: Song.Section.Line
    }
}
