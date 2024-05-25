//
//  NSBezierPath+extension (macOS).swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)

import AppKit

extension NSBezierPath {

    /// Init a `NSBezierPath`
    /// - Parameters:
    ///   - roundedRect: The rounded `CGRect`
    ///   - cornerRadius: The corner radius as `CGFloat`
    convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
}

#endif
