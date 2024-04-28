//
//  PDFElement.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A collection of elements to create a PDF page from a ``Song``
protocol PDFElement {

    /// Check if a ``PDFElement`` fits on the current page or if it should break
    /// - Parameter rect: The available rectangle
    /// - Returns: Bool if the page should break
    func shoudPageBreak(rect: CGRect) -> Bool

    /// Draw the ``PDFElement``
    /// - Parameters:
    ///   - rect: The available rectangle
    ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
    func draw(rect: inout CGRect, calculationOnly: Bool)

    /// Calculate the Rect Bounds for an ``PDFElement`` array
    /// - Parameters:
    ///   - rect: The available rectangle
    ///   - elements: The ``PDFElement`` array
    /// - Returns: The available rectangle after the drawing
    func calculateDraw(rect: CGRect, elements: [PDFElement]) -> CGRect

    /// Convert a string into Markdown
    /// - Parameter text: The text as String
    /// - Returns: The Markdown text as `NSAttributedString`
    func stringToMarkdown(_ text: String) -> NSAttributedString
}

extension PDFElement {

    /// The default padding for text
    /// - Note: Static because it is used in inits
    var textPadding: CGFloat { 2 }

    /// The default text drawing options
    var textDrawingOptions: NSString.DrawingOptions {
        NSString.DrawingOptions(
            [
                /// Render the string in multiple lines
                .usesLineFragmentOrigin,
                .truncatesLastVisibleLine
            ]
        )
    }

    /// Check if a ``PDFElement`` fits on the current page or if it should break
    /// - Parameter rect: The available rectangle
    /// - Returns: Bool if the page should break
    func shoudPageBreak(rect: CGRect) -> Bool {
        var tempRect = rect
        draw(rect: &tempRect, calculationOnly: true)
        let breakPage = tempRect.origin.y > rect.maxY || rect.height < 10
        return breakPage
    }

    /// Calculate the Rect Bounds for an ``PDFElement`` array
    /// - Parameters:
    ///   - rect: The available rectangle
    ///   - elements: The ``PDFElement`` array
    /// - Returns: The available rectangle after the drawing
    func calculateDraw(rect: CGRect, elements: [PDFElement]) -> CGRect {
        var tempRect = rect
        for item in elements {
            item.draw(rect: &tempRect, calculationOnly: true)
        }
        return tempRect
    }

    /// Convert a string into Markdown
    /// - Parameter text: The text as String
    /// - Returns: The Markdown text as `NSAttributedString`
    func stringToMarkdown(_ text: String) -> NSAttributedString {
        do {
            return try NSAttributedString(markdown: text)
        } catch {
            return NSAttributedString(string: text)
        }
    }

    /// Draw the ``PDFElement``
    /// - Parameters:
    ///   - rect: The available rectangle
    ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
    func draw(rect: inout CGRect, calculationOnly: Bool) {}

    /// Add padding to a `PDFElement`
    /// - Parameter size: The size of the padding
    /// - Returns: A modified `PDFElement`
    func padding(_ size: CGFloat) -> PDFElement {
        PDFBuild.Padding(size: size, self)
    }

    /// Add a clip shape around a `PDFElement`
    /// - Parameter shape: The style of the shape
    /// - Returns: A modified `PDFElement`
    func clip(_ shape: PDFBuild.ShapeStyle) -> PDFElement {
        PDFBuild.Clip(shape, self)
    }

#if os(macOS)
    /// macOS version of the `UIGraphicsGetCurrentContext` function from iOS
    /// - Returns: An optional Quartz 2D drawing environment
    func UIGraphicsGetCurrentContext() -> CGContext? {
        NSGraphicsContext.current?.cgContext
    }
#endif
}
