//
//  PdfView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for a PDF document
struct PdfView: View {
    /// The scene state
    @Environment(SceneState.self) var sceneState
    /// The body of the `View`
    var body: some View {
        VStack {
            if let data = sceneState.pdfData {
                PDFKitRepresentedView(data: data, singlePage: false)
            } else {
                ProgressView()
            }
        }
    }
}
