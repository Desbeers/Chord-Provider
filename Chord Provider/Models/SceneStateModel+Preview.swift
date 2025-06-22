//
//  SceneStateModel+Preview.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CoreTransferable

extension SceneStateModel {

    /// The state of a PDF preview
    struct Preview: Equatable, Transferable {
        /// The optional data for a preview
        var data: Data?
        /// Bool if the preview is outdated
        var outdated: Bool = false
        /// The preview URL
        var previewURL: URL?
        /// The default name for the export
        var exportName: String = ""

        static var transferRepresentation: some TransferRepresentation {

            FileRepresentation(exportedContentType: .pdf) { preview in
                // swiftlint:disable:next force_unwrapping
                SentTransferredFile(preview.previewURL ?? URL(string: "error")!, allowAccessingOriginalFile: false)
            }
            .suggestedFileName { preview in
                preview.exportName + ".pdf"
            }
            .exportingCondition { preview in
                preview.data != nil
            }
        }
    }
}
