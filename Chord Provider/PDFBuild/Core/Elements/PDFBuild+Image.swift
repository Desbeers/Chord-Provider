//
//  PDFBuild+Image.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit
import AVFoundation

extension PDFBuild {

    // MARK: A PDF **image** element

    /// A PDF **image** element
    class Image: PDFElement {
        /// The image to draw
        let image: NSImage
        /// The optional fixed size of the image
        let fixedSize: CGSize?

        /// Init the **image** element
        /// - Parameters:
        ///   - image: The `NSImage` to draw
        ///   - size: the optional size of the image
        init(_ image: NSImage, size: CGSize? = nil) {
            self.image = image
            self.fixedSize = size
        }

        /// Draw the **image**
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the size should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var size = fixedSize ?? .zero
            if fixedSize == nil {
                size = CGSize(
                    width: rect.width,
                    height: rect.width / image.size.width * image.size.height
                )
            }
            let tempRect = CGRect(
                x: rect.minX + ((rect.maxX - rect.minX) - size.width) / 2,
                y: rect.minY,
                width: size.width,
                height: size.height
            )
            let imgRect = AVMakeRect(
                aspectRatio: image.size,
                insideRect: tempRect
            )
            if !calculationOnly {
                image.draw(in: imgRect)
            }
            rect.origin.y += tempRect.height
            if tempRect.height > rect.size.height {
                rect.size.height = 0
            } else {
                rect.size.height -= tempRect.height
            }
        }
    }
}
