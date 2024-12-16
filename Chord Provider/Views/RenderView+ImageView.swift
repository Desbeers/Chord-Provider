//
//  RenderView+ImageView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 16/12/2024.
//

import SwiftUI

extension RenderView {
    @MainActor struct ImageView: View {
        @State private var imageView: ImageViewModel

        let arguments: ChordProParser.Arguments?
        let scale: Double
        @State private var offset: CGSize

        init(fileURL: URL?, arguments: ChordProParser.Arguments?, scale: Double) {
            self.arguments = arguments
            self.scale = scale
            self.offset = ChordProParser.getOffset(arguments)
            imageView = ImageViewModel(arguments: arguments, fileURL: fileURL, scale: scale)
        }

        var body: some View {
            Image(nsImage: imageView.image)
                .resizable()
                .frame(width: imageView.size.width * scale, height: imageView.size.height * scale)
                .offset(x: offset.width, y: offset.height)
                .onChange(of: arguments) {
                    offset = ChordProParser.getOffset(arguments)
                    imageView.updateArguments(arguments)
                }
                .animation(.default, value: imageView.size)
                .animation(.default, value: imageView.image)
        }
    }
}
