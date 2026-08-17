//
//  Widgets+BundleImage.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita
import CAdw

extension Widgets {

    /// The `AdwaitaWidget` for an SVG image from the bundle
    struct BundleImage: AdwaitaWidget {
        /// The size in pixels to display icons at.
        var pixelSize: Int?
        /// A path to a resource file to display.
        var resource: String?

        /// Initialize `BundleImage` for an icon
        init(icon: ImageUtils.Icon) {
            if let url = ImageUtils.getImageFromBundle("Icons/\(icon.rawValue)") {
                self.resource = url.path
            }
        }

        /// Initialize `BundleImage` from a path
        init(path: String) {
            if let url = Bundle.module.url(forResource: path, withExtension: "svg") {
                self.resource = url.path
            }
        }

        /// Initialize `BundleImage` for a strum
        init(strum: Chord.Strum) {
            if let url = ImageUtils.getImageFromBundle("Strums/\(strum.svgIcon)") {
                self.resource = url.path
            }
        }

        /// The view storage.
        /// - Parameters:
        ///   - data: Data passed to widgets
        ///   - type: The view render data type
        /// - Returns: The view storage.
        func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            ViewStorage(gtk_image_new()?.opaque())
        }

        /// Update the stored content.
        /// - Parameters:
        ///   - storage: The storage to update.
        ///   - data: Data passed to widgets
        ///   - updateProperties: Whether to update the view's properties
        ///   - type: The view render data type
        func update<Data>(
            _ storage: ViewStorage,
            data: WidgetData,
            updateProperties: Bool,
            type: Data.Type
        ) where Data: ViewRenderData {
            storage.modify { widget in
                if let resource, updateProperties, (storage.previousState as? Self)?.resource != resource {
                    gtk_image_set_from_file(widget, resource)
                }
                if let pixelSize, updateProperties, (storage.previousState as? Self)?.pixelSize != pixelSize {
                    gtk_image_set_pixel_size(widget, pixelSize.cInt)
                }
            }
            if updateProperties {
                storage.previousState = self
            }
        }

        /// The size in pixels to display the icon
        /// - Parameter pixelSize: The pixel size
        /// - Returns: Modified Self
        func pixelSize(_ pixelSize: Int?) -> Self {
            modify { $0.pixelSize = pixelSize }
        }
    }
}
