//
//  UITextView+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(iOS) || os(visionOS)

import UIKit

/// Alias for UITextView
public typealias SWIFTTextView = UITextView

/// Alias for UITextViewDelegate
public typealias SWIFTTextViewDelegate = UITextViewDelegate

extension UITextView {

    /// iOS version of the `selectedRanges` var from macOS
    var selectedRanges: [NSValue] {
        [NSValue(range: selectedRange)]
    }

    /// Get the selected text from the UITextView
    /// - Note: This needs a `String` extension
    var selectedText: String {
        string[selectedRange]
    }
}
#endif
