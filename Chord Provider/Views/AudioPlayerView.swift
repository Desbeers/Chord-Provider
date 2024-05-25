//
//  AudioPlayerView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog
import AVKit
import SwiftlyFolderUtilities
import SwiftlyAlertMessage

/// SwiftUI `View` for the audio player
struct AudioPlayerView: View {
    /// The music URL
    let musicURL: URL
    /// The `AVAudioPlayer`
    @State private var audioPlayer: AVAudioPlayer?
    /// Bool if the player is playing or not
    @State private var isPlaying: Bool = false
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowser.self) private var fileBrowser
    /// The status of the song
    @State private var status: ChordProviderError = .unknownStatus
    /// The iCloud URL of the song
    private var iCloudURL: URL {
        let hiddenFile = ".\(musicURL.lastPathComponent).icloud"
        return musicURL.deletingLastPathComponent().appending(path: hiddenFile)
    }
    /// Show an `Alert` if the music file is not found
    @State private var errorAlert: AlertMessage?
    /// Show an `ConfirmationDialog` if the music file is not downloaded
    @State private var confirmationDialog: AlertMessage?
    /// Bool to show the folder selector
    @State private var showFolderSelector: Bool = false

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        HStack {
            playButton
            switch status {
            case .audioFileNotFoundError:
                Button(action: {
                    confirmationDialog = status.alert {
                        showFolderSelector = true
                    }
                }, label: {
                    status.icon
                })
            case .audioFileNotDownloadedError:
                Button(
                    action: {
                        confirmationDialog = status.alert {
                            downloadSong(musicURL: musicURL, iCloudURL: iCloudURL)
                        }
                    },
                    label: {
                        status.icon
                    }
                )
            case .noSongsFolderSelectedError:
                Button(action: {
                    confirmationDialog = status.alert {
                        showFolderSelector = true
                    }
                }, label: {
                    status.icon
                })
            case .readyToPlay:
                pauseButton
            default:
                Button(action: {
                    errorAlert = status.alert()
                }, label: {
                    status.icon
                })
            }
        }
        .errorAlert(message: $errorAlert)
        .confirmationDialog(message: $confirmationDialog)
        .selectFolderSheet(
            isPresented: $showFolderSelector,
            bookmark: FileBrowser.folderBookmark,
            message: FileBrowser.message,
            confirmationLabel: FileBrowser.confirmationLabel
        ) {
            fileBrowser.getFiles()
        }
        .animation(.default, value: status)
        .task(id: musicURL) {
            status = AudioPlayerView.checkSong(musicURL: musicURL, iCloudURL: iCloudURL)
        }
        .task(id: fileBrowser.songsFolder) {
            status = AudioPlayerView.checkSong(musicURL: musicURL, iCloudURL: iCloudURL)
        }
    }

    // MARK: Additional View parts

    /// The play button
    @ViewBuilder var playButton: some View {
        Button(
            action: {
                try? FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { _ in
                    playSong()
                }
            },
            label: {
                Image(systemName: "play.fill")
            }
        )
        .disabled(status != .readyToPlay)
    }

    /// The pause button
    @ViewBuilder var pauseButton: some View {
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

    // MARK: Prive functions

    /// Check the song file
    private static func checkSong(musicURL: URL, iCloudURL: URL) -> ChordProviderError {
        var status = ChordProviderError.noSongsFolderSelectedError
        try? FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { _ in
            if musicURL.exist() {
                status = .readyToPlay
            } else {
                if iCloudURL.exist() {
                    status = .audioFileNotDownloadedError
                } else {
                    status = .audioFileNotFoundError
                }
            }
        }
        return status
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
        } catch {
            errorAlert = ChordProviderError.audioFileNotFoundError.alert()
        }
    }

    /// Download the song
    private func downloadSong(musicURL: URL, iCloudURL: URL) {
        try? FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { _ in
            Task {
                do {
                    try FileManager.default.startDownloadingUbiquitousItem(at: iCloudURL )
                } catch {
                    Logger.application.error("Export downloading song: \(error.localizedDescription, privacy: .public)")
                }
                while AudioPlayerView.checkSong(musicURL: musicURL, iCloudURL: iCloudURL) != .readyToPlay {
                    try? await Task.sleep(for: .seconds(1))
                }
            }
        }
    }
}
