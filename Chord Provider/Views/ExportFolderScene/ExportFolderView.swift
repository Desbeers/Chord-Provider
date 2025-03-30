//
//  ExportFolderView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for a folder export
struct ExportFolderView: View {
    /// The observable state of the application
    @State private var appState = AppStateModel(id: .exportFolderView)
    /// The state of the scene
    @State private var sceneState = SceneStateModel(id: .exportFolderView)
    /// The observable state of the file browser
    @Environment(FileBrowserModel.self) var fileBrowser
    /// The current selected folder
    @State private var currentFolder: String? = ExportFolderView.exportFolderTitle
    /// The PDF info
    @State private var pdfInfo = PDFBuild.DocumentInfo()
    /// Present an export dialog
    @State private var exportFile: Bool = false
    /// Bool if we are exporting
    @State private var exporting: Bool = false
    /// Progress
    @State private var progress: Double = 0
    /// The library as PDF
    @State private var pdf: Data?
    /// The body of the `View`
    var body: some View {
        VStack {
            Divider()
            Form {
                Section("Export a folder with your **ChordPro** Songs to a single PDF") {}
                LabeledContent("The folder with songs") {
                    UserFileButton(userFile: UserFile.exportFolder) {
                        currentFolder = ExportFolderView.exportFolderTitle
                    }
                }
                appState.songSortPicker
                    .pickerStyle(.segmented)
                appState.repeatWholeChorusToggle
                appState.lyricsOnlyToggle
                sceneState.instrumentPicker
                    .pickerStyle(.segmented)
                Section("PDF info") {
                    TextField("Title of the export", text: $pdfInfo.title, prompt: Text("Title"))
                    TextField("Author of the export", text: $pdfInfo.author, prompt: Text("Author"))
                }
                    .pickerStyle(.segmented)
                Section("Diagrams") {
                    appState.fingersToggle
                    appState.notesToggle
                    appState.mirrorToggle
                }
            }
            .formStyle(.grouped)
            ProgressView(value: progress, total: 1)
                .padding(.horizontal)
                .opacity(exporting ? 0.6 : 0)
            Spacer()
            Button(
                action: {
                    Task {
                        do {
                            let settings = AppSettings.load(id: .mainView)
                            appState.settings.style = settings.style
                            /// Bring the sceneState instrument to the appState
                            appState.settings.song.display.instrument = sceneState.settings.song.display.instrument
                            progress = 0
                            exporting = true
                            for try await status in FolderExport.export(
                                documentInfo: pdfInfo,
                                appSettings: appState.settings
                            ) {
                                switch status {
                                case .progress(let progress):
                                    self.progress = progress
                                case .finished(let data):
                                    pdf = data
                                    /// Stop the progress indicator
                                    exporting = false
                                    /// Show the export dialog
                                    exportFile = true
                                }
                            }
                        } catch {
                            Logger.application.error("\(error, privacy: .public)")
                        }
                    }
                },
                label: {
                    Label("Export Folder", systemImage: "square.and.arrow.up")
                }
            )
            .help("Export your folder as PDF")
            .labelStyle(.titleOnly)
            .disabled(currentFolder == nil || pdfInfo.title.isEmpty || pdfInfo.author.isEmpty || exporting)
            .padding()
        }
        .frame(width: 460, height: 680)
        .buttonStyle(.bordered)
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(pdf: pdf),
            contentTypes: [.pdf],
            defaultFilename: pdfInfo.title.isEmpty ? "Export" : pdfInfo.title,
            onCompletion: { result in
                switch result {
                case .success(let url):
                    Logger.application.notice("Export folder to \(url.lastPathComponent, privacy: .public) completed")
                case .failure(let error):
                    Logger.application.error("Export folder error: \(error.localizedDescription, privacy: .public)")
                }
            },
            onCancellation: {
                Logger.application.notice("Export canceled")
            }
        )
        .scrollContentBackground(.hidden)
        .task {
            let settings = AppSettings.load(id: .mainView)
            appState.settings.style = settings.style
        }
        .task(id: currentFolder) {
            pdfInfo.title = currentFolder ?? ""
        }
    }
    /// Get the current selected export folder
    private static var exportFolderTitle: String? {
        UserFile.exportFolder.getBookmarkURL?.lastPathComponent
    }
}
