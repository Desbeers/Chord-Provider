//
//  NSAttributedString+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension NSAttributedString {

    /// Set a `BoundingRect` with a `CGSize`
    /// - Parameter withSize: The size of the rect
    /// - Returns: A `CGRexct with options`
    func bounds(withSize: CGSize) -> CGRect {
        boundingRect(
            with: withSize,
            /// Render the string in multiple lines
            options: NSString.DrawingOptions.usesLineFragmentOrigin,
            context: nil
        )
    }
}

extension NSAttributedString.Key {

    /// Make `definition` an attributed string key
    static let definition: NSAttributedString.Key = .init("definition")
}

public extension Sequence where Iterator.Element == NSAttributedString {

    /// Join an `NSAttributedString` with a seperator
    /// - Parameter separator: The separator as `NSAttributedString`
    /// - Returns: A joined `NSAttributedString`
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        self.reduce(NSMutableAttributedString()) { accumulator, current in
            if accumulator.length > 0 {
                accumulator.append(separator)
            }
            accumulator.append(current)
            return accumulator
        }
    }

    /// Join an `NSAttributedString`
    /// - Parameter separator: The separator as `String`
    /// - Returns: A joined `NSAttributedString`
    func joined(with separator: String = "") -> NSAttributedString {
        self.joined(with: NSAttributedString(string: separator))
    }
}
