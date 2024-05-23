//
//  NSRange+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension NSRange {

    /// Convert a `NSTextRange` into a `NSRange`
    /// - Parameters:
    ///   - textRange: The `NSTextRange`
    ///   - contentManager: The `NSTextContentManager`
    init?(textRange: NSTextRange, in contentManager: NSTextContentManager) {
        let location = contentManager.offset(from: contentManager.documentRange.location, to: textRange.location)
        let length = contentManager.offset(from: textRange.location, to: textRange.endLocation)
        if location == NSNotFound || length == NSNotFound { return nil }
        self.init(location: location, length: length)
    }
}

public extension NSRange {

    /// Convert a Range to a NSRange, optional skipping leading or trailing characters
    /// - Parameters:
    ///   - range: The `Range`
    ///   - string: The string
    ///   - leadingOffset: The leading offset
    ///   - trailingOffset: The trailing offset
    init(
        range: Range<String.Index>,
        in string: String,
        leadingOffset: Int = 0,
        trailingOffset: Int = 0
    ) {
        let utf16 = string.utf16
        guard
            let lowerBound = range.lowerBound.samePosition(in: utf16),
            let upperBound = range.upperBound.samePosition(in: utf16)
        else {
            /// This should not happen
            // swiftlint:disable:next fatal_error_message
            fatalError()
        }
        let location = utf16.distance(from: utf16.startIndex, to: lowerBound)
        let length = utf16.distance(from: lowerBound, to: upperBound)
        self.init(location: location + leadingOffset, length: length - leadingOffset - trailingOffset)
    }
}
