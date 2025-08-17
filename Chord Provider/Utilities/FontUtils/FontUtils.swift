//
//  FontUtils.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import os
import ChordProviderCore

/// Utilities to deal with fonts
enum FontUtils {
    // Just a placeholder
}

extension FontUtils {

    /// Get all the fonts from the system
    /// - Returns: All fonts on the system
    static func getAllFonts() -> (families: [String], fonts: [FontUtils.Item]) {
        var fonts: [FontUtils.Item] = []
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
                        FontUtils.Item(
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
        return (Set(fonts.map(\.familyName)).sorted(), fonts)
    }
}


extension FontUtils {

    /// Get `ttf` fonts from a `ttc` font
    /// - Parameter font: The `ttc` font
    /// - Returns: The path of the extracted `ttf` font
    static func getTTFfont(font: FontUtils.Item) -> String {
        /// Only deal with *ttc* fonts
        if font.url.pathExtension == "ttc" {
            let fontsFolderURL = Song.temporaryDirectoryURL
            let manager = FileManager.default
            var result: String = fontsFolderURL.appending(path: "\(font.postScriptName).ttf").path()
            if !manager.fileExists(atPath: result) {
                manager.changeCurrentDirectoryPath(fontsFolderURL.path())
                let file = NSString(string: font.url.path(percentEncoded: false))
                let unsafePointerOfFilename = file.utf8String
                // swiftlint:disable:next force_unwrapping
                let unsafeMutablePointerOfFilename: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>(mutating: unsafePointerOfFilename!)
                _ = handlefile(unsafeMutablePointerOfFilename)
                do {
                    let items = try manager.contentsOfDirectory(atPath: fontsFolderURL.path())

                    for item in items where item.hasSuffix("ttf") {
                        let fontData = try Data(contentsOf: URL(fileURLWithPath: item))

                        if
                            let provider = CGDataProvider.init(data: fontData as CFData),
                            let cgFont = CGFont(provider),
                            let postScriptName = cgFont.postScriptName as? String {
                            let toPath = URL(fileURLWithPath: item).deletingLastPathComponent().appending(path: "\(postScriptName).ttf").path()
                            try manager.moveItem(atPath: item, toPath: toPath)
                            if postScriptName == font.postScriptName {
                                result = toPath
                            }
                        }
                    }
                } catch {
                    /// This should not happen
                    return font.url.path(percentEncoded: false)
                }
            }
            return result
        }
        return font.url.path(percentEncoded: false)
    }
}
