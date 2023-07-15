//
//  AudioPlayerView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import AVKit
import SwiftlyFolderUtilities

/// SwiftUI `View` for the audio player
struct AudioPlayerView: View {
    /// The music URL
    let musicURL: URL
    // swiftlint:disable implicitly_unwrapped_optional
    /// The `AVAudioPlayer`
    @State private var audioPlayer: AVAudioPlayer!
    // swiftlint:enable implicitly_unwrapped_optional
    /// Bool if the player is playing or not
    @State private var isPlaying: Bool = false
    /// Show an `Alert` if the music file is not found
    @State private var showAlert = false
    /// The body of the `View`
    var body: some View {
        HStack {
            Button(
                action: {
                    Task {
                        try? await FolderBookmark.action(bookmark: FileBrowser.bookmark) { _ in
                            do {
                                if isPlaying {
                                    audioPlayer.stop()
                                    audioPlayer = AVAudioPlayer.init()
                                }
                                audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
                                audioPlayer.play()
                                /// For the button state
                                isPlaying = true
                            } catch let error {
                                print(error)
                                showAlert = true
                            }
                        }
                    }
                },
                label: {
                    Image(systemName: "play.circle.fill").foregroundColor(.secondary)
                }
            )
            .padding(.leading)
            Button(
                action: {
                    if audioPlayer.isPlaying == true {
                        audioPlayer.pause()
                    } else {
                        audioPlayer.play()
                    }
                },
                label: {
                    Image(systemName: "pause.circle.fill").foregroundColor(.secondary)
                }
            )
            .disabled(!isPlaying)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Ooops..."),
                message: Text("The audio file was not found."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
