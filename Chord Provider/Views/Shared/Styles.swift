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

    /// The style for a labeled editor item
    struct EditorLabeledContentStyle: LabeledContentStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .center) {
                configuration.label
                    .bold()
                    .frame(width: 70, alignment: .trailing)
                configuration.content
            }
        }
    }

    /// The style for a labeled debug item
    struct DebugLabeledContentStyle: LabeledContentStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .top) {
                configuration.label
                    .font(.title2)
                    .frame(width: 200, alignment: .trailing)
                configuration.content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

extension LabelStyle where Self == Styles.CreateDocumentLabelStyle {

    /// The style of a label to create a document
    static var createDocument: Styles.CreateDocumentLabelStyle { .init() }
}

extension LabelStyle where Self == Styles.SongFileLabelStyle {

    /// The style of a label for a song file
    static var SongFile: Styles.SongFileLabelStyle { .init() }
}

extension LabeledContentStyle where Self == Styles.EditorLabeledContentStyle {

    /// The style for a labeled editor item
    static var editor: Styles.EditorLabeledContentStyle { .init() }
}

extension LabeledContentStyle where Self == Styles.DebugLabeledContentStyle {

    /// The style for a labeled debug item
    static var debug: Styles.DebugLabeledContentStyle { .init() }
}
