//
//  PDFBuild+Image.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
        /// The alignment
        let alignment: NSTextAlignment
        /// The optional offset
        let offset: CGSize

        /// Init the **image** element
        /// - Parameters:
        ///   - image: The `NSImage` to draw
        ///   - size: the optional size of the image
        ///   - alignment: The alignment of the image
        ///   - offset: The offset of the image
        init(_ image: NSImage, size: CGSize? = nil, alignment: NSTextAlignment = .center, offset: CGSize = .zero) {
            self.image = image
            self.fixedSize = size
            self.alignment = alignment
            self.offset = offset
        }

        /// Draw the **image**
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the size should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Set the size of the image
            var size = fixedSize ?? .zero
            if fixedSize == nil {
                size = CGSize(
                    width: rect.width,
                    height: rect.width / image.size.width * image.size.height
                )
            }
            /// Make sure images always fit
            if size.width > rect.width {
                size.width = rect.width
                size.height = rect.width / image.size.width * image.size.height
            }
            /// Apply optional y-offset
            rect.origin.y += offset.height
            rect.size.height -= offset.height
            /// Build a rect
            var tempRect = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: size.width,
                height: size.height
            )
            /// Apply alignment and optional x-offset
            switch alignment {
            case .left:
                tempRect.origin.x = rect.minX + offset.width
            case .right:
                tempRect.origin.x = rect.maxX - size.width + offset.width
            default:
                /// Center align
                tempRect.origin.x = offset.width + rect.minX + ((rect.maxX - rect.minX) - size.width) / 2
            }
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
