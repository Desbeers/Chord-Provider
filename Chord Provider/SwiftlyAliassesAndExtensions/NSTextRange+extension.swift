//
//  NSTextRange+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension NSTextRange {

    /// Convert a `NSRange` into a `NSTextRange`
    /// - Parameters:
    ///   - range: The `NSRange`
    ///   - contentManager: The `NSTextContentManager`
    convenience init?(range: NSRange, in contentManager: NSTextContentManager) {
        guard
            let location = contentManager.location(contentManager.documentRange.location, offsetBy: range.location),
            let endLocation = contentManager.location(location, offsetBy: range.length)
        else {
            return nil
        }
        self.init(location: location, end: endLocation)
    }
}
