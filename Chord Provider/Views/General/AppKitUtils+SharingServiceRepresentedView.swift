//
//  SharingServiceRepresentedView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppKitUtils {

    /// SwiftUI `NSViewRepresentable` for a Sharing Service Picker
    struct SharingServiceRepresentedView: NSViewRepresentable {
        /// Bool to show the sharing picker
        @Binding var isPresented: Bool
        /// The URLs of the document to share
        ///  - First is the source
        ///  - Last is the PDF
        @Binding var urls: [URL]?
        /// Make the `View`
        func makeNSView(context: Context) -> NSView {
            let view = NSView()
            return view
        }
        /// Update the `View`
        func updateNSView(_ nsView: NSView, context: Context) {
            if isPresented, let urls, let file = urls.first {
                let picker = NSSharingServicePicker(items: [file])
                picker.delegate = context.coordinator
                Task {
                    picker.show(relativeTo: .zero, of: nsView, preferredEdge: .minY)
                    isPresented = false
                }
            }
        }
        /// Make a `coordinator` for the `NSViewRepresentable`
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        // swiftlint:disable:next nesting
        class Coordinator: NSObject, @preconcurrency NSSharingServicePickerDelegate {
            /// The parent
            let parent: SharingServiceRepresentedView
            /// Init the **coordinator**
            init(_ parent: SharingServiceRepresentedView) {
                self.parent = parent
            }

            // MARK: Protocol Stuff

            /// Asks the delegate to provide an object that the selected sharing service can use as its delegate
            @MainActor func sharingServicePicker(
                _ sharingServicePicker: NSSharingServicePicker,
                sharingServicesForItems items: [Any],
                proposedSharingServices proposedServices: [NSSharingService]
            ) -> [NSSharingService] {
                var share = proposedServices
                /// Add a **print** service to the share-menu
                if
                    let url = parent.urls?.last,
                    let image = NSImage(systemSymbolName: "printer", accessibilityDescription: "Printer") {
                    let printService = NSSharingService(title: "Print as PDF", image: image, alternateImage: image) {
                        AppKitUtils.printDialog(exportURL: url)
                    }
                    share.insert(printService, at: 0)
                }
                return share
            }
            /// Tells the delegate that the user selected a sharing service for the current item
            func sharingServicePicker(
                _ sharingServicePicker: NSSharingServicePicker,
                didChoose service: NSSharingService?
            ) {
                /// Cleanup
                sharingServicePicker.delegate = nil
            }
        }
    }
}
