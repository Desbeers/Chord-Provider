//
//  WindowManagement.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//
// Code from https://www.woodys-findings.com/posts/positioning-window-macos

import SwiftUI

extension NSWindow {

    /// Struct to position a new `Window`
    struct Position {
        /// The padding for new windows
        static let defaultPadding: Double = 16
        /// The vertical position
        var vertical: Vertical
        /// The horizontal position
        var horizontal: Horizontal
        /// The padding
        var padding = Self.defaultPadding
    }

    /// Set the position of a `Window`
    /// - Parameters:
    ///   - position: The `Position`
    ///   - screen: The `Screen`
    func setPosition(position: Position, in screen: NSScreen?) {
        guard let visibleFrame = (screen ?? self.screen)?.visibleFrame else {
            return
        }
        let origin = position.value(forWindow: frame, inScreen: visibleFrame)
        setFrameOrigin(origin)
    }

    /// Set the position of a `Window`
    /// - Parameters:
    ///   - vertical: The vertical position
    ///   - horizontal: The horizontal position
    ///   - padding: The padding
    ///   - screen: The screen
    func setPosition(vertical: Position.Vertical, horizontal: Position.Horizontal, padding: Double = Position.defaultPadding, screen: NSScreen? = nil) {
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

    /// Hoizontal positions
    enum Horizontal {
        /// Left
        case left
        /// Center
        case center
        /// Right
        case right
    }

    /// Vertical positions
    enum Vertical {
        /// Top
        case top
        /// Center
        case center
        /// Bottom
        case bottom
    }

    /// Calculate position
    /// - Parameters:
    ///   - windowRect: The `CGRect`for the window
    ///   - screenRect: The `CGRect`for the screen
    /// - Returns: A `CGPoint`
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

    /// Calculate height
    /// - Parameters:
    ///   - screenRange: The `Range`
    ///   - height: The height
    ///   - padding: The padding
    /// - Returns: Height as `CGFloat`
    func valueFor(screenRange: Range<Double>, height: Double, padding: Double) -> Double {
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

    /// Calculate width
    /// - Parameters:
    ///   - screenRange: The `Range`
    ///   - height: The height
    ///   - padding: The padding
    /// - Returns: Width as `CGFloat`
    func valueFor(screenRange: Range<Double>, width: Double, padding: Double) -> Double {
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
    /// - Parameter callback: The `callback`
    /// - Returns: A `View`
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

/// Find the NSWindow of the scene
private struct HostingWindowFinder: NSViewRepresentable {
    /// The callback
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
