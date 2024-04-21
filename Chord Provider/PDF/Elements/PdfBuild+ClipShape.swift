//
//  PdfBuild+ClipShape.swift
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

extension PdfBuild {

    public enum Shape {
        case circle
        case roundedRect(radius: CGFloat)
    }

    /// A PDF clipshape item
    open class ClipShape: PdfElement {

        let shape: Shape
        let element: PdfElement

        public init(_ shape: Shape, _ element: PdfElement) {
            self.shape = shape
            self.element = element
        }

        open override func draw(rect: inout CGRect) {
            let tempRect = estimateDraw(rect: rect, elements: [element])

            var fillRect = rect
            fillRect.size.height = rect.height - tempRect.height

            let context = UIGraphicsGetCurrentContext()
            switch shape {

            case .circle:
                let clipRect = AVMakeRect(
                    aspectRatio: CGSize(width: 1, height: 1),
                    insideRect: fillRect)
                SWIFTBezierPath(roundedRect: clipRect, cornerRadius: clipRect.width / 2).addClip()

            case .roundedRect(let radius):

                fillRect.size.height = 2 * radius

                fillRect.origin.y += (rect.size.height - fillRect.size.height) / 2

                SWIFTBezierPath(roundedRect: fillRect, cornerRadius: radius).addClip()
            }
            context?.clip()

            element.draw(rect: &rect)

            context?.resetClip()
        }
    }
}
