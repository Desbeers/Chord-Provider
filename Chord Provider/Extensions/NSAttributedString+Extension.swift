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
