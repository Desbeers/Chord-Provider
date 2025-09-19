//
//  C64View+runView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension C64View {

    /// The run view
    var runView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(pageContent) {line in
                if line.command == .print {
                    Text(line.text)
                        .foregroundStyle(line.color?.swiftColor ?? .white)
                        .frame(height: fontSize)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(C64Color.black.swiftColor)
        .foregroundStyle(.white)
        .task(id: output) {
            await getPageContent()
        }
        .task(id: page) {
            await getPageContent()
        }
    }
}
