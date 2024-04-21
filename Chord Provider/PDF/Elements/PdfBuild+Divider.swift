//
//  PdfBuild+Divider.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild {

    public enum Direction {
        case horizontal
        case vertical
    }

    /// A PDF divider item
    public class Divider: PdfElement {

        let direction: Direction

        init(direction: Direction = .vertical) {
            self.direction = direction
        }

        open override func draw(rect: inout CGRect) {

            if let context = UIGraphicsGetCurrentContext() {

                switch direction {
                case .horizontal:
                    let start = CGPoint(x: rect.origin.x, y: rect.origin.y + 2.5)

                    context.move(to: start)
                    context.addLine(to: CGPoint(x: start.x + rect.size.width, y: start.y))

                    context.setStrokeColor(SWIFTColor.lightGray.cgColor)
                    context.setLineWidth(0.6)
                    context.strokePath()

                    rect.origin.y += 5
                    rect.size.height -= 5
                case .vertical:
                    let start = CGPoint(
                        x: rect.origin.x + (rect.width / 2) - 0.3,
                        y: rect.origin.y
                    )

                    context.move(to: start)
                    context.addLine(to: CGPoint(x: start.x, y: start.y + rect.size.height))

                    context.setStrokeColor(SWIFTColor.lightGray.cgColor)
                    context.setLineWidth(0.6)
                    context.strokePath()

                    rect.origin.x += 1
                    rect.size.width -= 1
                }
            }
        }
    }
}
