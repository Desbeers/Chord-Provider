//
//  TemplateView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` when creating a new document
struct TemplateView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The song struct
    @Bindable var sceneState: SceneState
    /// The FileBrowser model
    @Environment(FileBrowser.self) private var fileBrowser
    /// The dismiss environment
    @Environment(\.dismiss) var dismiss
    /// The title of the song
    @State private var title: String = ChordProDocument.newSong
    /// The artist of the song
    @State private var artist: String = ChordProDocument.newArtist
    /// The body of the `View`
    var body: some View {
        VStack {
            Text("Add a new song")
                .font(.title)
            HStack {
                SongFolderView()
                Divider()
                    .padding(.horizontal)
                VStack {
                    Form {
                        TextField(
                            text: $title,
                            prompt: Text(ChordPro.Directive.title.label.text)
                        ) {
                            Text(ChordPro.Directive.title.label.text)
                        }
                        TextField(
                            text: $artist,
                            prompt: Text(ChordPro.Directive.artist.label.text)
                        ) {
                            Text(ChordPro.Directive.artist.label.text)
                        }
                        Button("Add song") {
                            /// Convert the meta data
                            var metaData: [String] = []
                            metaData.append(EditorView.format(directive: .title, argument: title))
                            metaData.append(EditorView.format(directive: .artist, argument: artist))
                            /// Add the meta data to the document
                            document.text = "\(metaData.joined())\n"
                            /// Close the sheet
                            dismiss()
                        }
                        .keyboardShortcut(.defaultAction)
                        .buttonStyle(.bordered)
                    }
                    .formStyle(.columns)
#if !os(macOS)
                    .textFieldStyle(.roundedBorder)
#endif
                }
            }
            .padding()
        }
        .padding()
    }
}
