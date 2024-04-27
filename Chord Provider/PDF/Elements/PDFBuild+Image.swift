//
//  PDFBuild+Image.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import AVFoundation

extension PDFBuild {

    /// A PDF image item
    open class Image: PDFElement {
        let image: SWIFTImage
        let fixedSize: CGSize?

        public init(_ image: SWIFTImage, size: CGSize? = nil) {
            self.image = image
            self.fixedSize = size
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            var size = fixedSize ?? .zero

            if fixedSize == nil {
                size = CGSize(
                    width: rect.width,
                    height: rect.width / image.size.width * image.size.height )
            }

            let tempRect = CGRect(
                x: rect.minX + ((rect.maxX - rect.minX) - size.width) / 2,
                y: rect.minY,
                width: size.width,
                height: size.height)

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
