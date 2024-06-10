//
//  ExportFolderView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog
import SwiftlyChordUtilities

/// SwiftUI `View` for a folder export
struct ExportFolderView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowser.self) private var fileBrowser
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
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
            Form {
                LabeledContent("The folder with songs") {
                    FileButtonView(bookmark: .exportFolder) {
                        currentFolder = ExportFolderView.exportFolderTitle
                    }
                }
                appState.repeatWholeChorusToggle
                chordDisplayOptions.instrumentPicker
                Section("PDF info") {
                    TextField("Title of the export", text: $pdfInfo.title, prompt: Text("Title"))
                    TextField("Author of the export", text: $pdfInfo.author, prompt: Text("Author"))
                }
                    .pickerStyle(.segmented)
                Section("Diagrams") {
                    chordDisplayOptions.fingersToggle
                    chordDisplayOptions.notesToggle
                    chordDisplayOptions.mirrorToggle
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
                            progress = 0
                            exporting = true
                            for try await status in FolderExport.export(
                                info: pdfInfo,
                                generalOptions: appState.settings.general,
                                chordDisplayOptions: chordDisplayOptions.displayOptions
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
                    Label("Export Songs", systemImage: "square.and.arrow.up")
                }
            )
            .help("Export your folder as PDF")
            .labelStyle(.titleOnly)
            .disabled(currentFolder == nil || pdfInfo.title.isEmpty || pdfInfo.author.isEmpty || exporting)
            .padding()
        }
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
        .navigationTitle("Export Folder with Songs")
        .toolbar {
            Spacer()
        }
        .task(id: currentFolder) {
            pdfInfo.title = currentFolder ?? ""
        }
    }
    /// Get the current selected export folder
    private static var exportFolderTitle: String? {
        try? FileBookmark.getBookmarkURL(.exportFolder)?.lastPathComponent
    }
}
