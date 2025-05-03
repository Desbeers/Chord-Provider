//
//  PDFBuild+Clip.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import AVFoundation

extension PDFBuild {

    // MARK: A PDF **clip** element

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
            let tempRect = calculateDraw(rect: rect, elements: [element], pageRect: pageRect)
            var fillRect = rect
            fillRect.size.height = rect.height - tempRect.height
            let context = NSGraphicsContext.current?.cgContext
            switch shape {
            case .circle:
                let clipRect = AVMakeRect(
                    aspectRatio: CGSize(width: 1, height: 1),
                    insideRect: fillRect
                )
                NSBezierPath(
                    roundedRect: clipRect,
                    xRadius: clipRect.width / 2,
                    yRadius: clipRect.width / 2
                )
                .addClip()
            case .roundedRect(let radius):
                fillRect.size.height = 2 * radius
                fillRect.origin.y += (rect.size.height - fillRect.size.height) / 2
                NSBezierPath(
                    roundedRect: fillRect,
                    xRadius: radius,
                    yRadius: radius
                )
                .addClip()
            case .cornerRect(let cornerRadius):
                NSBezierPath(
                    roundedRect: fillRect,
                    xRadius: cornerRadius,
                    yRadius: cornerRadius
                )
                .addClip()
            }
            element.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
            context?.resetClip()
        }
    }

    /// Shape styles that can be used to clip an``PDFElement`` with a `Clip`
    enum ShapeStyle {
        /// A circle shape
        case circle
        /// A rounded rectangle shape
        case roundedRect(radius: CGFloat)
        /// A cornered shape
        case cornerRect(cornerRadius: CGFloat)
    }
}
