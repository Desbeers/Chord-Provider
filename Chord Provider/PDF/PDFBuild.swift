//
//  PDFBuild.swift
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

public enum PDFBuild {

    // MARK: Defaults

    /// A4 Portrait Page
    public static let a4portraitPage = CGRect(x: 0, y: 0, width: 612, height: 792)

    /// A4 Landscape Page
    public static let a4landscapePage = CGRect(x: 0, y: 0, width: 792, height: 612)

    /// The default padding for a page
    public static let pagePadding: CGFloat = 40

    /// The Quartz 2D drawing destination
    static var pdfContext: CGContext?


//    // MARK: Logging
//
//    public static var logEnabled = true
//
    static var calculationOnly = false
//
//    public static func log(_ msg: Any? = nil, function: String = #function, file: String = #file, line: Int = #line) {
//        if logEnabled, !calculationOnly {
//            Logger.pdfBuild.log("􀉆 \(makeTag(function: function, file: file, line: line), privacy: .public) 􀅴 \(msg.debugDescription)")
//        }
//    }
//
//    private static func makeTag(function: String, file: String, line: Int) -> String {
//        let className = NSURL(fileURLWithPath: file).lastPathComponent ?? file
//        return "\(className): \(line) 􀄫 \(function)"
//    }
}
