//
//  Views+Debug+source.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

extension Views.Debug {

    // MARK: Source View

    /// The `Body` for the source view
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
                                        .logLevelStyle(warning.level)
                                        .halign(.start)
                                }
                                Text(line.source.source)
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
        var source: [Source] = []
        for line in appState.editor.song.sections.flatMap(\.lines) {
            source.append(Source(id: line.sourceLineNumber, source: line))
        }
        return source
    }
    
    /// The structure for a source line
    private struct Source: Identifiable {
        /// The ID of the source line
        let id: Int
        /// The actual line
        let source: Song.Section.Line
    }
}
