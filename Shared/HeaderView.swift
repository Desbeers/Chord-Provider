import SwiftUI
import AVKit

var audioPlayer: AVAudioPlayer!

struct HeaderView: View {
    @Binding var song: Song
    //@State var audioPlayer: AVAudioPlayer!
    @State var isPlaying:Bool = false
    @State private var showingAlert = false
    
    var body: some View {
            HStack(alignment: .center) {
                Spacer()
                if song.artist != nil {
                    Text(song.artist!).font(.headline)
                }
                if song.title != nil {
                    Text(song.title!)
                }
                if song.key != nil {
                    Label(song.key!, systemImage: "key").padding(.leading)
                }
                if song.capo != nil {
                    Label(song.capo!, systemImage: "paperclip").padding(.leading)
                }
                if song.tempo != nil {
                    Label(song.tempo!, systemImage: "metronome").padding(.leading)
                }
                #if os(macOS)
                if song.musicpath != nil {
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
                        Image(systemName: "play.circle.fill")
                    }.padding(.leading)
                    Button(action: {
                        if (audioPlayer.isPlaying == true) {
                            audioPlayer.pause()
                        }
                        else {
                            audioPlayer.play()
                        }
                    }) {
                        Image(systemName: "pause.circle.fill")
                    }.disabled(!isPlaying)
                }
                #endif
                Spacer()
            }
            .padding(4)
            .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Ooops..."), message: Text("The audio file was not found."), dismissButton: .default(Text("OK")))
                    }
    }
}
