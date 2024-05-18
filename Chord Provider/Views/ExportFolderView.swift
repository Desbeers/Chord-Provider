//
//  ExportFolderView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import OSLog
import SwiftlyChordUtilities
import SwiftlyFolderUtilities

struct ExportFolderView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The FileBrowser model
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
    var body: some View {
        VStack {
            Form {
                LabeledContent("The folder with songs") {
                    FolderBookmark.SelectFolderButton(
                        bookmark: FileBrowser.exportBookmark,
                        message: FileBrowser.message,
                        confirmationLabel: FileBrowser.confirmationLabel,
                        buttonLabel: currentFolder ?? "No folder selected",
                        buttonSystemImage: "square.and.arrow.down"
                    ) {
                        currentFolder = ExportFolderView.exportFolderTitle ?? "No folder selected"
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
                            exporting = true
                            if let render = try await FolderExport.export(
                                info: pdfInfo,
                                generalOptions: appState.settings.general,
                                chordDisplayOptions: chordDisplayOptions.displayOptions,
                                progress: { page in
                                    progress = Double(page)
                                }
                            ) {
                                pdf = render.dataRepresentation()
                                /// Stop the progress indicator
                                exporting = false
                                progress = 1
                                /// Show the export dialog
                                exportFile = true
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
        .frame(width: 400, height: 600)
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
        FolderBookmark.getBookmarkLink(bookmark: FileBrowser.exportBookmark)?.lastPathComponent
    }
}
