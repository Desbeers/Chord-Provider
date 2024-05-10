//
//  NSAttributedString+Extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension NSAttributedString {

    func bounds(withSize: CGSize) -> CGRect {
        boundingRect(
            with: withSize,
            options: NSString
                .DrawingOptions
            /// Render the string in multiple lines
                .usesLineFragmentOrigin,
            context: nil
        )
    }
}

public extension Sequence where Iterator.Element == NSAttributedString {

    func joined(with separator: NSAttributedString) -> NSAttributedString {
        self.reduce(NSMutableAttributedString()) { accumulator, current in
            if accumulator.length > 0 {
                accumulator.append(separator)
            }
            accumulator.append(current)
            return accumulator
        }
    }

    func joined(with separator: String = "") -> NSAttributedString {
        self.joined(with: NSAttributedString(string: separator))
    }
}

extension NSAttributedString {

    /// Returns an NSRange containing the argument location that starts after
    /// a newline (or the beginning of the string) and ends at a new line (or the end of the string)
    /// - Parameter location: The location
    /// - Returns: The NSRange
    func rangeOfLineAtLocation(_ location: Int) -> NSRange {
        let scalars = string.unicodeScalars
        var start: Int = location
        while start > 0 && !scalars[start - 1].isNewline {
            start -= 1
        }
        var end = location
        while end < scalars.count - 1 && !scalars[end].isNewline {
            end += 1
        }
        return NSRange(location: start, length: end - start)
    }
}
