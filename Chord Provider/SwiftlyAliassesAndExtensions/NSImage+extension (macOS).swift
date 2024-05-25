//
//  NSImage+extension (macOS).swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)

import AppKit

public extension NSImage {

    // MARK: Init a `NSImage` with an SF symbol

    /// Init a `NSImage` with an SF symbol
    /// - Parameter systemName: The name of the SF symbol
    convenience init(systemName: String) {
        // swiftlint:disable:next force_unwrapping
        self.init(systemSymbolName: systemName, accessibilityDescription: nil)!
    }
}

#endif
