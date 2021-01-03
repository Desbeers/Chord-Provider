//  MARK: - View: Audio Player for macOS

/// A very simple audio player that is part of the Header View

import SwiftUI
import AVKit

var audioPlayer: AVAudioPlayer!

struct AudioPlayer: View {
    var song: Song
    
    @State var isPlaying:Bool = false
    @State private var showingAlert = false
    
    var body: some View {
        HStack {
            Button(action: {
                /// Sandbox stuff: get path for selected folder
                if var persistentURL = GetPersistentFileURL("pathSongs") {
                    _ = persistentURL.startAccessingSecurityScopedResource()
                    persistentURL = persistentURL.appendingPathComponent(song.musicpath!, isDirectory: false)
                    // TODO: move check to song loading
                    //let isReachable = try! persistentURL.checkResourceIsReachable()
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: persistentURL)
                        audioPlayer.play()
                        /// For the button state
                        isPlaying = true
                        } catch let error {
                            print(error)
                            showingAlert = true
                        }
                    persistentURL.stopAccessingSecurityScopedResource()
                }
            }) {
                Image(systemName: "play.circle.fill").foregroundColor(.secondary)
            }.padding(.leading)
            Button(action: {
                if (audioPlayer.isPlaying == true) {
                    audioPlayer.pause()
                }
                else {
                    audioPlayer.play()
                }
            }) {
                Image(systemName: "pause.circle.fill").foregroundColor(.secondary)
            }.disabled(!isPlaying)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Ooops..."), message: Text("The audio file was not found."), dismissButton: .default(Text("OK")))
        }
    }
}

