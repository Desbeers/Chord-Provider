//
//  Aliasses.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// Alias for a `NSAttributedString` key and value
public typealias SWIFTStringAttribute = [NSAttributedString.Key: Any]

public extension SWIFTTextView {

    /// Wrap the `SWIFTTextView` textStorage in an optional
    /// - Note: `NSTextStorage` is an optional in macOS and not in iOS
    var attributedStorage: NSMutableAttributedString? {
        textStorage
    }
}

#if os(macOS)

// MARK: macOS type aliases

/// Alias for NSImage
public typealias SWIFTImage = NSImage
/// Alias for NSColor
public typealias SWIFTColor = NSColor
/// Alias for NSFont
public typealias SWIFTFont = NSFont
/// Alias for NSTextView
public typealias SWIFTTextView = NSTextView
/// Alias for NSEdgeInsets
public typealias SWIFTEdgeInsets = NSEdgeInsets
/// Alias for NSBezierPath
public typealias SWIFTBezierPath = NSBezierPath
/// Alias for NSViewRepresentable
public typealias SWIFTViewRepresentable = NSViewRepresentable
/// Alias for NSTextViewDelegate
public typealias SWIFTTextViewDelegate = NSTextViewDelegate

#else

// MARK: iOS typealiases

/// Alias for UIImage
public typealias SWIFTImage = UIImage
/// Alias for UIColor
public typealias SWIFTColor = UIColor
/// Alias for SWIFTFont
public typealias SWIFTFont = UIFont

/// Alias for UIEdgeInsets
public typealias SWIFTEdgeInsets = UIEdgeInsets
/// Alias for UIBezierPath
public typealias SWIFTBezierPath = UIBezierPath
/// Alias for UIViewRepresentable
public typealias SWIFTViewRepresentable = UIViewRepresentable


// MARK: iOS extensions

extension NSString {
    typealias DrawingOptions = NSStringDrawingOptions
}

extension UIColor {

    /// iOS version of the `NSColor.textColor` from macOS
    static var textColor: UIColor {
        UIColor.label
    }
}

extension UITextView {

    /// iOS version of the `NSTextView.string` from macOS
    var string: String {
        text
    }
}

#endif
