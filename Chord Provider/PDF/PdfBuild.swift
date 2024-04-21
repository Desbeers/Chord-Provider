//
//  PdfBuild.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import OSLog

public enum PdfBuild {

    // MARK: Paper formats

    /// A4 Portrait Page
    public static let a4portraitPage = CGRect(x: 0, y: 0, width: 612, height: 792)

    /// A4 Landscape Page
    public static let a4landscapePage = CGRect(x: 0, y: 0, width: 792, height: 612)

    static var pdfContext: CGContext?


    // MARK: Logging

    public static var logEnabled = false

    static var isEstimating = false

    public static func log(_ msg: Any? = nil, function: String = #function, file: String = #file, line: Int = #line) {
        if logEnabled, !isEstimating {
            Logger.pdfBuild.log("􀉆 \(makeTag(function: function, file: file, line: line), privacy: .public) 􀅴 \(msg.debugDescription)")
        }
    }

    private static func makeTag(function: String, file: String, line: Int) -> String {
        let className = NSURL(fileURLWithPath: file).lastPathComponent ?? file
        return "\(className): \(line) 􀄫 \(function)"
    }

    // MARK: Drawing helper

    public static func drawImage(size: CGSize, block: () -> Void) -> SWIFTImage? {

#if os(macOS)
        guard let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0) else {
            return nil
        }

        guard let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
            return nil
        }

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context

        block()

        NSGraphicsContext.restoreGraphicsState()

        let img = NSImage(size: size)
        img.addRepresentation(bitmap)
#else
        UIGraphicsBeginImageContext(size)
        block()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
#endif
        return img
    }
}
