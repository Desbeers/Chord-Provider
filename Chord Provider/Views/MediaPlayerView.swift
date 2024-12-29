//
//  MediaPlayerView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

struct MediaPlayerView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState

    @State private var window: NSWindow?

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
        /// The observable state of the application
        @Environment(AppStateModel.self) var appState
        /// The observable state of the scene
        @Environment(SceneStateModel.self) var sceneState

        @Environment(\.openWindow) private var openWindow

        @Environment(\.dismissWindow) private var dismissWindow

        /// The body of the `View`
        var body: some View {
            if let tempo = sceneState.song.metadata.tempo, let bpm = Float(tempo) {
                MetronomeButton(time: sceneState.song.metadata.time ?? "4/4", bpm: bpm)
                    .padding(.leading)
            }
            if let musicURL = sceneState.song.metadata.audioURL {
                mediaButton(url: musicURL, kind: .audio)
            }
            if let videoURL = sceneState.song.metadata.videoURL {
                mediaButton(url: videoURL, kind: .video)
            }
        }
        private func mediaButton(url: URL, kind: Kind) -> some View {
            Button {
                if appState.media.url == nil || appState.media.kind != kind {
                    appState.media = .init(
                        kind: kind,
                        title: sceneState.song.metadata.artist,
                        subtitle: sceneState.song.metadata.title,
                        url: url
                    )
                    openWindow(id: AppDelegateModel.WindowID.mediaPlayerView.rawValue)
                } else {
                    appState.media = .init()
                    dismissWindow(id: AppDelegateModel.WindowID.mediaPlayerView.rawValue)
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
