//
//  EditorView+DirectiveSheet.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension EditorView {

    /// SwiftUI `View` to define a directive
    struct DirectiveSheet: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The body of the `View`
        var body: some View {
            VStack {
                switch directive {
                case .startOfVerse, .startOfChorus, .startOfTab, .startOfGrid, .startOfBridge:
                    Items(directive: directive)
                case .startOfStrum:
                    Items(directive: directive)
                case .startOfTextblock:
                    Items(directive: directive)
                case .image:
                    Items(directive: directive)
                case .key:
                    Items(directive: directive)
                case .define, .defineGuitar, .defineGuitalele, .defineUkulele:
                    Items(directive: directive)
                case .tempo:
                    Items(directive: directive, start: 60, end: 240, suffix: " bpm")
                case .year:
                    Items(directive: directive, start: 1900, end: 2030)
                default:
                    Items(directive: directive)
                }
            }
            .padding()
        }
    }
}
