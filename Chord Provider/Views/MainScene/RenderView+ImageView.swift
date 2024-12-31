//
//  RenderView+ImageView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension RenderView {

    /// SwiftUI `View` for an image
    struct ImageView: View {
        /// The observable state of the image
        @State private var imageView: ImageViewModel
        /// The arguments for the image
        let arguments: ChordProParser.Arguments?
        /// The scale of the image
        let scale: Double
        /// The offset of the image
        @State private var offset: CGSize
        /// Init the image
        init(fileURL: URL?, arguments: ChordProParser.Arguments?, scale: Double) {
            self.arguments = arguments
            self.scale = scale
            self.offset = ChordProParser.getOffset(arguments)
            imageView = ImageViewModel(arguments: arguments, fileURL: fileURL)
        }
        /// The body of the `View`
        var body: some View {
            Image(nsImage: imageView.image)
                .resizable()
                .frame(width: imageView.size.width * scale, height: imageView.size.height * scale)
                .offset(x: offset.width, y: offset.height)
                .task(id: arguments) {
                    offset = ChordProParser.getOffset(arguments)
                    await imageView.updateArguments(arguments)
                }
                .animation(.default, value: imageView.size)
                .animation(.default, value: imageView.image)
        }
    }
}
