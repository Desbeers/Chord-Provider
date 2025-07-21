//
//  DebugView+source.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 23/06/2025.
//

import SwiftUI

extension DebugView {

    /// The source tab of the `View`
    @ViewBuilder var source: some View {
        if appState.song != nil {
            List {
                ForEach(content, id: \.line) { line in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(line.line)")
                                .monospaced()
                                .frame(width: 30, alignment: .trailing)
                                .font(
                                    .body
                                        .weight(line.source.warnings == nil ? .regular : .bold)
                                )
                            Image(systemName: line.source.directive?.details.icon ?? line.source.type.icon)
                                .font(.caption)
                            VStack(alignment: .leading) {
                                Text(JSONUtils.highlight(code: line.source.source, editorSettings: appState.settings.editor))
                                    .monospaced()
                                if let warnings = line.source.warnings {
                                    Text(.init("\(warnings.joined(separator: ", "))"))
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                }
                                if line.source.sourceLineNumber < 1 {
                                    Text("The directive is added by the parser")
                                        .foregroundStyle(.green)
                                        .font(.caption)
                                }
                            }
                        }
                        .tag(line.line)
                        if line.line == selectedLine {
                            let content = try? JSONUtils.encode(line.source)
                            Text(JSONUtils.highlight(code: content ?? "error", editorSettings: appState.settings.editor))
                                .padding(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundStyle(Color(nsColor: .textColor))
                                .padding(.horizontal, 30)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            selectedLine = selectedLine == line.line ? nil : line.line
                        }
                    }
                }
            }
        } else {
            noSong
        }
        Divider()
        VStack(alignment: .leading) {
            Label("A negative line number means the line is added by the *parser* and is not part of the current document", systemImage: "info.circle")
            Label("A **bold** line number means the *source line* has warnings that the parser will try to resolve", systemImage: "exclamationmark.triangle")
        }
        .frame(height: 50, alignment: .center)
        .font(.caption)
        .foregroundStyle(.secondary)
        .animation(.default, value: selectedLine)
    }
}
