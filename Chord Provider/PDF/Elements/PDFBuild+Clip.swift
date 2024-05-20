//
//  PDFBuild+Clip.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import AVFoundation

extension PDFBuild {

    /// Shape styles that can be used to clip an``PDFElement`` with a `Clip`
    enum ShapeStyle {
        /// A circle shape
        case circle
        /// A rounded retangle shape
        case roundedRect(radius: CGFloat)
    }

    /// A PDF **clip** element
    /// - Clip a ``PDFElement`` with a shape style
    class Clip: PDFElement {

        /// The style of the clipping shape
        let shape: ShapeStyle
        /// The ``PDFElement`` to clip
        let element: PDFElement

        /// Init a **clip** element
        /// - Parameters:
        ///   - shape: The style of the clipping shape
        ///   - element: The ``PDFElement`` to clip
        init(_ shape: ShapeStyle, _ element: PDFElement) {
            self.shape = shape
            self.element = element
        }

        /// Draw the **clip**
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the size should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Clipping will not use any rectangle space, so nothing to calculate
            if !calculationOnly {
                let tempRect = calculateDraw(rect: rect, elements: [element], pageRect: pageRect)
                var fillRect = rect
                fillRect.size.height = rect.height - tempRect.height
                let context = UIGraphicsGetCurrentContext()
                switch shape {
                case .circle:
                    let clipRect = AVMakeRect(
                        aspectRatio: CGSize(width: 1, height: 1),
                        insideRect: fillRect
                    )
                    SWIFTBezierPath(roundedRect: clipRect, cornerRadius: clipRect.width / 2).addClip()
                case .roundedRect(let radius):
                    fillRect.size.height = 2 * radius
                    fillRect.origin.y += (rect.size.height - fillRect.size.height) / 2
                    SWIFTBezierPath(roundedRect: fillRect, cornerRadius: radius).addClip()
                }
                element.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                context?.resetClip()
            }
        }
    }
}
