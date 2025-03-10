//
//  AppKitUtils+QLPreviewRepresentedView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import Quartz

extension AppKitUtils {

    /// Show a QL preview of an URL
    /// - Note: I don't use the SwiftUI ` .quickLookPreview($url)` here because
    ///         that seems to conflict with a `NSTextView` in a `NSViewRepresentable.
    ///         Unsaved documents cannot be previewed on macOS 14 for some unknown reason...
    public struct QLPreviewRepresentedView: NSViewRepresentable {
        /// The URL to view
        var url: URL
        /// Init the `View`
        /// - Parameter url: The URL to view
        public init(url: URL) {
            self.url = url
        }
        /// Make the `View`
        public func makeNSView(context: NSViewRepresentableContext<QLPreviewRepresentedView>) -> QLPreviewView {
            let preview = QLPreviewView(frame: .zero, style: .normal)
            preview?.autostarts = true
            preview?.previewItem = url as QLPreviewItem
            preview?.shouldCloseWithWindow = true

            return preview ?? QLPreviewView()
        }
        /// Update the `View`
        public func updateNSView(
            _ nsView: QLPreviewView,
            context: NSViewRepresentableContext<QLPreviewRepresentedView>
        ) {
            /// Nothing to do here
        }
    }
}
