//
//  AudioPlayerView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog
import AVKit
import ChordProShared

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
    @State private var status: AppError = .unknownStatus
    /// The iCloud URL of the song
    private var iCloudURL: URL {
        let hiddenFile = ".\(musicURL.lastPathComponent).icloud"
        return musicURL.deletingLastPathComponent().appending(path: hiddenFile)
    }
    /// Show an `Alert` if the music file is not found
    @State private var errorAlert: AlertMessage?
    /// Show an `ConfirmationDialog` if the music file is not downloaded
    @State private var confirmationDialog: AlertMessage?

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        HStack {
            playButton
            switch status {
            case .audioFileNotFoundError:
                Button(action: {
                    confirmationDialog = status.alert {
                        Task {
                            try? AppKitUtils.openPanel(userFile: UserFileItem.songsFolder) {
                                fileBrowser.songsFolder = try? UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder)
                            }
                        }
                    }
                }, label: {
                    status.icon
                })
            case .audioFileNotDownloadedError:
                Button(
                    action: {
                        confirmationDialog = status.alert {
                            Task {
                                status = await AudioPlayerView.downloadSong(musicURL: musicURL, iCloudURL: iCloudURL)
                            }
                        }
                    },
                    label: {
                        status.icon
                    }
                )
            case .noSongsFolderSelectedError:
                Button(action: {
                    confirmationDialog = status.alert {
                        Task {
                            try? AppKitUtils.openPanel(userFile: UserFileItem.songsFolder) {
                                fileBrowser.songsFolder = try? UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder)
                            }
                        }
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
                if let songsFolder = try? UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder) {
                    /// Get access to the URL
                    _ = songsFolder.startAccessingSecurityScopedResource()
                    playSong()
                    /// Stop access to the URL
                    songsFolder.stopAccessingSecurityScopedResource()
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

    // MARK: Private functions

    /// Check the song file
    private static func checkSong(musicURL: URL, iCloudURL: URL) -> AppError {
        var status = AppError.noSongsFolderSelectedError
        if let songsFolder = try? UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder) {
            /// Get access to the URL
            _ = songsFolder.startAccessingSecurityScopedResource()
            if musicURL.exist() {
                status = .readyToPlay
            } else {
                if iCloudURL.exist() {
                    status = .audioFileNotDownloadedError
                } else {
                    status = .audioFileNotFoundError
                }
            }
            /// Stop access to the URL
            songsFolder.stopAccessingSecurityScopedResource()
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
            errorAlert = AppError.audioFileNotFoundError.alert()
        }
    }

    /// Download the song
    private static func downloadSong(musicURL: URL, iCloudURL: URL) async -> AppError {
        if let songsFolder = try? UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder) {
            /// Get access to the URL
            _ = songsFolder.startAccessingSecurityScopedResource()
            do {
                try FileManager.default.startDownloadingUbiquitousItem(at: iCloudURL )
            } catch {
                Logger.application.error("Error downloading song: \(error.localizedDescription, privacy: .public)")
            }
            while AudioPlayerView.checkSong(musicURL: musicURL, iCloudURL: iCloudURL) != .readyToPlay {
                try? await Task.sleep(for: .seconds(1))
            }
            /// Stop access to the URL
            songsFolder.stopAccessingSecurityScopedResource()
            return .readyToPlay
        }
        return .audioFileNotDownloadedError
    }
}
