//
//  AudioPlayerView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import AVKit

/// SwiftUI `View` for a very simple audio player
struct AudioPlayerView: View {
    /// The ``Song``
    var song: Song
    /// The `AVAudioPlayer`
    @State var audioPlayer: AVAudioPlayer!
    /// Bool if the player is playing or not
    @State var isPlaying: Bool = false
    /// Show an `Alert` if the music file is not found
    @State private var showingAlert = false
    /// The body of the `View`
    var body: some View {
        HStack {
            Button {
                /// Sandbox stuff: get path for selected folder
                if let persistentURL = FolderBookmark.getPersistentFileURL("pathSongs") {
                    _ = persistentURL.startAccessingSecurityScopedResource()
                    // todo: move check to song loading
                    // let isReachable = try! persistentURL.checkResourceIsReachable()
                    do {
                        if isPlaying {
                            audioPlayer.stop()
                            audioPlayer = AVAudioPlayer.init()
                        }
                        audioPlayer = try AVAudioPlayer(contentsOf: song.musicpath!)
                        audioPlayer.play()
                        /// For the button state
                        isPlaying = true
                    } catch let error {
                        print(error)
                        showingAlert = true
                    }
                    persistentURL.stopAccessingSecurityScopedResource()
                }            }
                label: {
                    Image(systemName: "play.circle.fill").foregroundColor(.secondary)
                }
                .padding(.leading)
            Button {
                if audioPlayer.isPlaying == true {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            }
            label: {
                Image(systemName: "pause.circle.fill").foregroundColor(.secondary)
            }
            .disabled(!isPlaying)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Ooops..."), message: Text("The audio file was not found."), dismissButton: .default(Text("OK")))
        }
    }
}
