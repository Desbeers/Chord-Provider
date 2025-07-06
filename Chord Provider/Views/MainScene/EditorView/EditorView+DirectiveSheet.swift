//
//  EditorView+DirectiveSheet.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

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
                    Items(items: [.label], directive: directive)
                case .startOfStrum:
                    Items(items: [.label, .tuplet], directive: directive)
                case .startOfTextblock:
                    Items(items: [.label, .align, .flush], directive: directive)
                case .image:
                    Items(items: [.label, .src, .width, .height, .scale, .align], directive: directive)
                case .key:
                    Items(items: [.key], directive: directive)
                case .define:
                    Items(items: [.define], directive: directive)
                case .tempo:
                    Items(items: [.numeric], directive: directive, start: 60, end: 240, suffix: " bpm")
                case .year:
                    Items(items: [.numeric], directive: directive, start: 1900, end: 2030)
                default:
                    Items(items: [.plain], directive: directive)
                }
            }
            .padding()
        }
    }
}
