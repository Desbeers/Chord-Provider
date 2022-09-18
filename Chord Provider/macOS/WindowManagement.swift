//
//  WindowManagement.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//
// Code from https://www.woodys-findings.com/posts/positioning-window-macos

import SwiftUI

extension NSWindow {
    
    struct Position {
        static let defaultPadding: CGFloat = 16
        var vertical: Vertical
        var horizontal: Horizontal
        var padding = Self.defaultPadding
    }
    
    func setPosition(position: Position, in screen: NSScreen?) {
        guard let visibleFrame = (screen ?? self.screen)?.visibleFrame else {
            return
        }
        let origin = position.value(forWindow: frame, inScreen: visibleFrame)
        setFrameOrigin(origin)
    }
    
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
    
    enum Horizontal {
        case left, center, right
    }
    
    enum Vertical {
        case top, center, bottom
    }
    
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
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

/// Find the NSWindow of the scene
private struct HostingWindowFinder: NSViewRepresentable {
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
