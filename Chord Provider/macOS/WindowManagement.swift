//
//  WindowManagement.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

// Code from https://www.woodys-findings.com/posts/positioning-window-macos

import SwiftUI

extension NSWindow {

    /// Structure for a 'window position'
    struct Position {
        /// The default 'padding' of the window
        static let defaultPadding: CGFloat = 16
        /// The vertical position
        var vertical: Vertical
        /// The horizontal position
        var horizontal: Horizontal
        /// The padding
        var padding = Self.defaultPadding
    }

    /// Find the NSWindow of the scene
    struct HostingWindowFinder: NSViewRepresentable {
        /// The optional `NSWindow`
        var callback: (NSWindow?) -> Void
        func makeNSView(context: Context) -> NSView {
            let view = NSView()
            Task { @MainActor in
                callback(view.window)
            }
            return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
    }

    /// Set the position of a 'Window'
    /// - Parameters:
    ///   - position: The `Position`
    ///   - screen: The screen to use
    func setPosition(position: Position, in screen: NSScreen?) {
        guard let visibleFrame = (screen ?? self.screen)?.visibleFrame else {
            return
        }
        let origin = position.value(forWindow: frame, inScreen: visibleFrame)
        setFrameOrigin(origin)
    }

    /// Set the position of a 'Window'
    /// - Parameters:
    ///   - vertical: The vertical `Position`
    ///   - horizontal: The horizontal `Position`
    ///   - padding: The 'padding' of the Window
    ///   - screen: The screen to use
    func setPosition(vertical: Position.Vertical, horizontal: Position.Horizontal, padding: CGFloat = Position.defaultPadding, screen: NSScreen? = nil) {
        setPosition(
            position: Position(
                vertical: vertical,
                horizontal: horizontal,
                padding: padding),
            in: screen
        )
    }
}

extension NSWindow.Position {

    /// Horizontal 'Window' positions
    enum Horizontal {
        /// Align left
        case left
        /// Align center
        case center
        /// Align right
        case right
    }

    /// Vertical  'Window' positions
    enum Vertical {
        /// Align top
        case top
        /// Align center
        case center
        /// Align bottom
        case bottom
    }

    /// Calculate 'Window' position
    /// - Parameters:
    ///   - windowRect: The window size
    ///   - screenRect: The screen size
    /// - Returns: The calculated window position
    func value(forWindow windowRect: CGRect, inScreen screenRect: CGRect) -> CGPoint {
        let xPosition = horizontal.valueFor(
            screenRange: screenRect.minX..<screenRect.maxX,
            width: windowRect.width,
            padding: padding
        )
        let yPosition = vertical.valueFor(
            screenRange: screenRect.minY..<screenRect.maxY,
            height: windowRect.height,
            padding: padding
        )
        return CGPoint(x: xPosition, y: yPosition)
    }
}

extension NSWindow.Position.Vertical {

    /// Calculate vertical position
    /// - Parameters:
    ///   - screenRange: The range of the screen
    ///   - height: The window height
    ///   - padding: The padding of the window
    /// - Returns: The calculated vertical position
    func valueFor(screenRange: Range<CGFloat>, height: CGFloat, padding: CGFloat) -> CGFloat {
        switch self {
        case .top:
            return screenRange.upperBound - height - padding
        case .center:
            return (screenRange.upperBound + screenRange.lowerBound - height) / 2
        case .bottom:
            return screenRange.lowerBound + padding
        }
    }
}

extension NSWindow.Position.Horizontal {

    /// Calculate horizontal position
    /// - Parameters:
    ///   - screenRange: The range of the screen
    ///   - width: The window width
    ///   - padding: The padding of the window
    /// - Returns: The calculated horizontal position
    func valueFor(screenRange: Range<CGFloat>, width: CGFloat, padding: CGFloat) -> CGFloat {
        switch self {
        case .left:
            return screenRange.upperBound - width - padding
        case .center:
            return ((screenRange.upperBound + screenRange.lowerBound - width) / 2) + padding
        case .right:
            return screenRange.lowerBound + padding
        }
    }
}

extension View {

    /// Find the NSWindow of the scene
    /// - Parameter callback: The optional `NSWindow`
    /// - Returns: A SwiftUI `background` View
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(NSWindow.HostingWindowFinder(callback: callback))
    }
}
