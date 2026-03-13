//
//  Widgets+ChordDiagram+Context.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Widgets.ChordDiagram {

    /// The context of a chord diagram drawing
    final class Context {

        /// Init the context
        /// - Parameters:
        ///   - definition: The chord definition
        ///   - showNotes: Show notes below the diagram
        init(definition: ChordDefinition, showNotes: Bool) {
            self.definition = definition
            self.showNotes = showNotes
        }
        /// The chord definition
        let definition: ChordDefinition
        /// Show notes below the diagram
        let showNotes: Bool
    }
}
