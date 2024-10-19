//
//  MediaPlayerView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

@MainActor struct MediaPlayerView: View {
    /// The observable state of the application
    @State private var appState = AppStateModel.shared

    @State private var window: NSWindow?

    /// The AppDelegate to bring additional Windows into the SwiftUI world
    let appDelegate: AppDelegateModel
    /// The body of the `View`
    var body: some View {
        VStack {
            if let url = appState.media.url {
                AppKitUtils.QLPreviewRepresentedView(url: url)
            } else {
                ContentUnavailableView(
                    "Media not found",
                    systemImage: appState.media.kind.systemName,
                    description: Text("The media file belonging to the song is not found.")
                )
            }
        }
        .frame(minWidth: 240, minHeight: 280, alignment: .top)
        .background(.black)
        .navigationTitle(appState.media.title)
        .navigationSubtitle(appState.media.subtitle)
        .preferredColorScheme(.dark)
        .id(appState.media.id)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { notification in
            if let window = notification.object as? NSWindow, window.identifier == NSUserInterfaceItemIdentifier(
                AppDelegateModel.WindowID.mediaPlayerView.rawValue
            ) {
                appState.media.url = nil
            }
        }
        .task(id: appState.media.id) {
            if let window {
                var frame = window.frame
                switch appState.media.kind {
                case .audio:
                    frame.size.width = 240
                    frame.size.height = 280
                case .video:
                    frame.size.width = 440
                    frame.size.height = 360
                }
                window.setFrame(frame, display: true, animate: true)
            }
        }
        .withHostingWindow { window in
            self.window = window
        }
    }
}

extension MediaPlayerView {

    struct Buttons: View {
        /// The AppDelegate to bring additional Windows into the SwiftUI world
        @Environment(AppDelegateModel.self) private var appDelegate
        /// The observable state of the application
        @Environment(AppStateModel.self) var appState
        /// The observable state of the scene
        @Environment(SceneStateModel.self) var sceneState
        /// The body of the `View`
        var body: some View {
            if let tempo = sceneState.song.metaData.tempo, let bpm = Float(tempo) {
                MetronomeButton(time: sceneState.song.metaData.time ?? "4/4", bpm: bpm)
                    .padding(.leading)
            }
            if let musicURL = sceneState.song.metaData.audioURL {
                mediaButton(url: musicURL, kind: .audio)
            }
            if let videoURL = sceneState.song.metaData.videoURL {
                mediaButton(url: videoURL, kind: .video)
            }
        }
        @MainActor private func mediaButton(url: URL, kind: Kind) -> some View {
            Button {
                if appState.media.url == nil || appState.media.kind != kind {
                    appState.media = .init(
                        kind: kind,
                        title: sceneState.song.metaData.artist,
                        subtitle: sceneState.song.metaData.title,
                        url: url
                    )
                    appDelegate.showMediaPlayerWindow()
                } else {
                    appState.media = .init()
                    appDelegate.closeMediaPlayerWindow()
                }
            } label: {
                Image(systemName: kind.systemName + (appState.media.url != nil && appState.media.kind == kind ? ".fill" : ""))
            }
        }
    }
}

extension MediaPlayerView {

    struct Item: Identifiable {
        var id = UUID()
        var kind: Kind = .audio
        var title: String = "Chord Provider"
        var subtitle: String = "Media"
        var url: URL?
    }

    enum Kind {
        case audio
        case video

        var systemName: String {
            switch self {
            case .audio: "hifispeaker"
            case .video: "video"
            }
        }
    }
}
