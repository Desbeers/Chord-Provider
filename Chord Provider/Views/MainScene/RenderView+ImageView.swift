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

        let maxWidth: Double

        var size: CGSize {
            var size = CGSize(width: imageView.size.width * scale, height: imageView.size.height * scale)
            if size.width > maxWidth {
                let ratio = maxWidth / size.width
                size.width *= ratio
                size.height *= ratio
            }
            return size
        }
        /// The offset of the image
        @State private var offset: CGSize
        /// Init the image
        init(fileURL: URL?, arguments: ChordProParser.Arguments?, scale: Double, maxWidth: Double) {
            self.arguments = arguments
            self.scale = scale
            self.offset = ChordProParser.getOffset(arguments)
            self.maxWidth = maxWidth
            imageView = ImageViewModel(arguments: arguments, fileURL: fileURL)
        }
        /// The body of the `View`
        var body: some View {
            Image(nsImage: imageView.image)
                .resizable()
                .frame(width: size.width * scale, height: size.height * scale)
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
