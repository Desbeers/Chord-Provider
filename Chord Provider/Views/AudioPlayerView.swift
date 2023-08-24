//
//  AudioPlayerView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import AVKit
#if os(macOS)
import SwiftlyFolderUtilities
#endif

/// SwiftUI `View` for the audio player
struct AudioPlayerView: View {
    /// The music URL
    let musicURL: URL
    /// The `AVAudioPlayer`
    @State private var audioPlayer: AVAudioPlayer?
    /// Bool if the player is playing or not
    @State private var isPlaying: Bool = false
    /// Show an `Alert` if the music file is not found
    @State private var showAlert = false
    /// The body of the `View`
    var body: some View {
        HStack {
            Button(
                action: {
#if os(macOS)
                    /// For macOS we need the bookmark to access the file
                    Task {
                        try? await FolderBookmark.action(bookmark: FileBrowser.bookmark) { _ in
                            playSong()
                        }
                    }
#else
                    /// iOS can just play it...
                    playSong()
#endif
                },
                label: {
                    Image(systemName: "play.fill")
                }
            )
            .padding(.leading)
            Button(
                action: {
                    if audioPlayer?.isPlaying == true {
                        audioPlayer?.pause()
                    } else {
                        audioPlayer?.play()
                    }
                },
                label: {
                    Image(systemName: "pause.fill")
                }
            )
            .disabled(!isPlaying)
        }
        .buttonStyle(.bordered)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Ooops..."),
                message: Text("The audio file was not found."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    /// Play the song file
    private func playSong() {
        do {
            if isPlaying {
                audioPlayer?.stop()
                audioPlayer = AVAudioPlayer.init()
            }
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            /// For the button state
            isPlaying = true
        } catch let error {
            print(error)
            showAlert = true
        }
    }
}
