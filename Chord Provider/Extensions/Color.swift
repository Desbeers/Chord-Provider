// MARK: - class: App Appearance for macOS and iOS

/// Color related stuff.

import SwiftUI

// MARK: - typealias: Get the correct function for macOS and iOS

#if os(macOS)
    typealias SWIFTColor = NSColor
#endif
#if os(iOS)
    typealias SWIFTColor = UIColor
#endif

// MARK: - extensions to get system colors for the html view

extension Color {
    var hexString: String {
        return SWIFTColor(self).hexString
    }
    static let sectionHtmlColor = Color("SectionColor").hexString
    /// macOS has variable accent colors; iOS does not
//    #if os(macOS)
        static let accentHtmlColor = Color.accentColor.hexString
//    #endif
//    #if os(iOS)
//        static let accentHtmlColor = Color("AccentColor").hexString
//    #endif
    /// Highlight color is the accent color with transparancy
    /// It mimics the Higlight color in the macOS settings
    static let highlightHtmlColor = Color.accentHtmlColor + "53"
    static let commentHtmlBackground = Color("CommentBackground").hexString
}

/// SWIFTColor is the type alias for NSColor or UIColor, depending on os
extension SWIFTColor {
    var hexString: String {
        #if os(macOS)
        let rgbColor = usingColorSpace(.extendedSRGB) ?? SWIFTColor(red: 1, green: 1, blue: 1, alpha: 1)
        #endif
        #if os(iOS)
        let rgbColor = self
        #endif
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
