//
//  C64View.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` to show the song in Commodore 64 style
struct C64View: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// State of the Scene
    @Environment(\.scenePhase) var scenePhase

    @State var output: [Output] = []
    @State var run: Bool = false
    @State var runCounter: Int = 0
    @State var status: SceneStateModel.Status = .loading

    @State var windowSize: CGSize = .zero
    @State private var fontSize: Double = 18


    @State var page: Int = 0
    @State var totalPages: Int = 0
    @State var pageContent: [Output] = []
    @State var loadingPage: Bool = false
    // swiftlint:disable all
    let bootText: String = """

    **** commodore 64 basic v2 ****

 64k ram system  38911 basic bytes free 

ready.
poke 53272,23

ready.
"""
    // swiftlint:enable all
    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .loading:
                Text("Starting...")
                    .font(.custom("C64 Pro Mono", size: fontSize))
                    .foregroundStyle(C64Color.blue.swiftColor)
            case .ready:
                ZStack {
                    sourceView
                    if run {
                        runView
                    }
                }
                .frame(width: windowSize.width, height: windowSize.height)
                .font(.custom("C64 Pro Mono", size: fontSize))
                .foregroundStyle(C64Color.lightBlue.swiftColor)
                HStack {
                    Button {
                        withAnimation {
                            if !run {
                                runCounter += 1
                            }
                            run.toggle()
                        }
                    } label: {
                        Text(run ? "Stop" : "Run")
                    }
                    Button {
                        let string = output.map(\.code).joined(separator: "\n") + "\n"
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(string, forType: .string)
                    } label: {
                        Text("Copy BASIC Code to Clipboard")
                    }
#if DEBUG
                    Button {
                        if let song = appState.song {
                            Task {
                                let basic = output.map(\.code).joined(separator: "\n")
                                try? basic.write(to: song.metadata.basicURL, atomically: true, encoding: String.Encoding.utf8)
                                let command = "petcat -w2 -nc -o ~/Desktop/song.prg -- '\(song.metadata.basicURL.path)'"
                                _ = await ChordProCLI.runInShell(arguments: [command])
                            }
                        }
                    } label: {
                        Text("Make disk")
                    }
                    Button {
                        if let song = appState.song {
                            Task {
                                let basic = output.map(\.code).joined(separator: "\n")
                                try? basic.write(to: song.metadata.basicURL, atomically: true, encoding: String.Encoding.utf8)
                                let convert = "petcat -w2 -nc -o '\(song.metadata.basicProgramURL.path)' -- '\(song.metadata.basicURL.path)'"
                                _ = await ChordProCLI.runInShell(arguments: [convert])
                                let command = "x64 -autostart '\(song.metadata.basicProgramURL.path)'"
                                _ = await ChordProCLI.runInShell(arguments: [command])
                            }
                        }
                    } label: {
                        Text("Run in Vice")
                    }
#endif
                }
                .disabled(appState.song == nil)
                .buttonStyle(.bordered)
                .foregroundStyle(.white)
                Label("If you copy the **BASIC** code and paste it into **Vice**, it will work!", systemImage: "info.circle.fill")
                    .font(.caption)
                    .foregroundStyle(C64Color.white.swiftColor)
            case .error:
                Text("Something went wrong...")
            }
        }
        .frame(
            minWidth: 300,
            idealWidth: 640,
            maxWidth: .infinity,
            minHeight: 200,
            idealHeight: 480,
            maxHeight: .infinity
        )
        .padding()
        .background(run ? C64Color.darkGray.swiftColor : C64Color.lightBlue.swiftColor)
        .navigationSubtitle(appState.song?.metadata.title ?? "No song open")
        .animation(.default, value: run)
        .animation(.default, value: status)
        .task(id: appState.song) {
            if scenePhase == .active {
                await addOutput()
                status = .ready
            }
        }
        .task(id: scenePhase) {
            if scenePhase == .active {
                await addOutput()
                status = .ready
            }
        }
        .onDisappear {
            status = .loading
            run = false
            runCounter = 0
        }
        /// Remember the size of the whole window
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in

            let screenWidth = min(newValue.width - 20, newValue.height - 20)
            let screenHeight = screenWidth * 0.625

            windowSize = CGSize(width: screenWidth, height: screenHeight)
            fontSize = screenWidth / 40.5
        }
        .focusable()
        .onMoveCommand { direction in
            if run, !loadingPage {
                switch direction {
                case .up:
                    page = max(page - 1, 0)
                case .down:
                    page = min(page + 1, totalPages - 1)
                case .left:
                    break
                case .right:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}
