//
//  DebugView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 29/11/2024.
//

import SwiftUI

/// SwiftUI `View` for the debug window
struct DebugView: View {
    /// The currently selected tab
    @State private var tab: DebugMessage = .source
    /// The source of the song
    @State private var content: [(line: Int, source: Song.Section.Line)] = []
    /// The AppDelegate to bring additional Windows into the SwiftUI world
    @Bindable var  appDelegate: AppDelegateModel
    /// The currently selected line
    @State private var selectedLine: Int?
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            switch tab {
            case .json:
                json
            case .source:
                source
            }
        }
        .frame(minWidth: 400, minHeight: 600)
        .frame(maxWidth: .infinity)
        .toolbar {
            Picker("Tab", selection: $tab) {
                ForEach(DebugMessage.allCases, id: \.self) { tab in
                    Label(tab.rawValue, systemImage: "gear")
                }
            }
            .pickerStyle(.segmented)
        }
        .labelStyle(.titleAndIcon)
        .task(id: appDelegate.song) {
            if let song = appDelegate.song {
                var content: [(line: Int, source: Song.Section.Line)] = []
                for line in song.sections.flatMap(\.lines) {
                    content.append((line: line.sourceLineNumber, source: line))
                }
                self.content = content
            }
        }
        .task(id: tab) {
            selectedLine = nil
        }
    }
    /// The source tab of the `View`
    @ViewBuilder var source: some View {
        List(selection: $selectedLine) {
            ForEach(content, id: \.line) { line in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(line.line)")
                            .frame(width: 30, alignment: .trailing)
                            .font(
                                .body
                                    .weight(line.source.warning == nil ? .regular : .bold)
                            )
                        Text(line.source.source)
                    }
                    .tag(line.line)
                    if line.line == selectedLine {
                        Text(ChordProParser.encode(line.source))
                            .padding(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(nsColor: .textBackgroundColor))
                            .foregroundStyle(Color(nsColor: .textColor))
                            .padding(.horizontal, 30)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        VStack(alignment: .leading) {
            Label("A negative line number means the line is added by the *parser* and is not part of the current document", systemImage: "info.circle")
            Label("A **bold** line number means the *source line* has warnings that the parser will try to resolve", systemImage: "exclamationmark.triangle")
        }
        .font(.caption)
        .padding()
        .foregroundStyle(.secondary)
    }
    /// The json tab of the `View`
    var json: some View {
        ScrollView {
            if let song = appDelegate.song {
                Text(ChordProParser.encode(song))
            } else {
                Text("No song open")
            }
        }
    }
}
