//
//  FontUtils.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

/// Utilities to deal with fonts
enum FontUtils {
    // Just a placeholder
}

extension FontUtils {

    static func getAllFonts(includingTTCfonts: Bool) -> (families: [String], fonts: [FontItem]) {
        var fonts: [FontItem] = []
        let fontFamilies = NSFontManager.shared.availableFontFamilies.sorted()
        for fontFamily in fontFamilies {
            /// - Note: Go my *family* -> *fonts* to get the weight in normal order. Don't just get all the fonts...
            if let familyFonts = NSFontManager.shared.availableMembers(ofFontFamily: fontFamily) {
                for font in familyFonts {
                    guard let postScriptName = font[0] as? String else {
                        break
                    }
                    let nsFont = NSFont(name: postScriptName, size: 10) ?? NSFont.systemFont(ofSize: 10)
                    let descriptor = CTFontDescriptorCreateWithNameAndSize(nsFont.fontName as CFString, 10)
                    guard
                        let postScriptName = CTFontDescriptorCopyAttribute(descriptor, kCTFontNameAttribute) as? String,
                        let displayName = CTFontDescriptorCopyAttribute(descriptor, kCTFontDisplayNameAttribute) as? String,
                        let familyName = CTFontDescriptorCopyAttribute(descriptor, kCTFontFamilyNameAttribute) as? String,
                        let styleName = CTFontDescriptorCopyAttribute(descriptor, kCTFontStyleNameAttribute) as? String,
                        let url = CTFontDescriptorCopyAttribute(descriptor, kCTFontURLAttribute) as? URL
                    else {
                        break
                    }
                    fonts.append(
                        FontItem(
                            postScriptName: postScriptName,
                            displayName: displayName,
                            familyName: familyName,
                            styleName: styleName,
                            url: url
                        )
                    )
                }
            }
        }
        if !includingTTCfonts {
            fonts = fonts.filter { $0.url.pathExtension == "ttf" || $0.url.pathExtension == "otf" }
        }
        return (Set(fonts.map(\.familyName)).sorted(), fonts)
    }
}
