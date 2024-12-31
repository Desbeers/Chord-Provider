//
//  Styles.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI styles
enum Styles {
    // Just a placeholder
}

// MARK: Label Styles

extension Styles {

    /// The style of a label to create a document
    struct CreateDocumentLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .foregroundColor(.secondary)
                    .imageScale(.large)
                    .frame(width: 20, alignment: .trailing)
                configuration.title
            }
            .padding(.vertical, 2)
        }
    }

    /// The style of a label for a song file
    struct SongFileLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .foregroundColor(.secondary)
                    .imageScale(.large)
                configuration.title
                    .padding(.trailing)
            }
            .padding(.leading)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(nsColor: .windowBackgroundColor).opacity(0.5))
            .cornerRadius(6)
        }
    }
}

extension LabelStyle where Self == Styles.CreateDocumentLabelStyle {

    /// The style of a label to create a document
    static var createDocument: Styles.CreateDocumentLabelStyle {
        Styles.CreateDocumentLabelStyle()
    }
}

extension LabelStyle where Self == Styles.SongFileLabelStyle {

    /// The style of a label for a song file
    static var SongFile: Styles.SongFileLabelStyle {
        Styles.SongFileLabelStyle()
    }
}
