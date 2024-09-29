//
//  ExportFolderView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for a folder export
@MainActor struct ExportFolderView: View {
    /// The app state
    @State private var appState = AppStateModel(id: .exportFolderView)
    /// The state of the scene
    @State private var sceneState = SceneStateModel(id: .exportFolderView)
    /// The observable ``FileBrowser`` class
    @State private var fileBrowser = FileBrowserModel.shared
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
                    UserFileButton(userFile: UserFileItem.exportFolder) {
                        currentFolder = ExportFolderView.exportFolderTitle
                    }
                }
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
                            /// Bring the sceneSate settings to the appState
                            appState.settings.song = sceneState.settings.song
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
        .frame(minWidth: 460, minHeight: 680)
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
        .task(id: currentFolder) {
            pdfInfo.title = currentFolder ?? ""
        }
    }
    /// Get the current selected export folder
    private static var exportFolderTitle: String? {
        UserFileBookmark.getBookmarkURL(UserFileItem.exportFolder)?.lastPathComponent
    }
}
