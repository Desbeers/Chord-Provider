//
//  Widgets+BundleImage.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CChordProvider
import Adwaita

extension Widgets {

    /// The `AdwaitaWidget` for an SVG image from the bundle
    struct BundleImage: AdwaitaWidget {
        /// The size in pixels to display icons at.
        var pixelSize: Int?
        /// A path to a resource file to display.
        var resource: String?

        /// Initialize `BundleImage` for an icon
        public init(name: String) {
            if let url = ImageUtils.getImageFromBundle("Icons/\(name)") {
                self.resource = url.path
            }
        }

        /// Initialize `BundleImage` from a path
        public init(path: String) {
            if let urlPath = Bundle.module.url(forResource: path, withExtension: "svg") {
                self.resource = urlPath.path
            }
        }

        /// Initialize `BundleImage` for a strum
        public init(strum: Song.Section.Line.Strum.Action) {
            if let url = ImageUtils.getImageFromBundle("Strums/\(strum.svgIcon)") {
                self.resource = url.path
            }
        }

        /// The view storage.
        /// - Parameters:
        ///     - modifiers: Modify views before being updated.
        ///     - type: The view render data type.
        /// - Returns: The view storage.
        func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            let storage = ViewStorage(gtk_image_new()?.opaque())
            update(storage, data: data, updateProperties: true, type: type)

            return storage
        }

        /// Update the stored content.
        /// - Parameters:
        ///     - storage: The storage to update.
        ///     - data: Data passed to widgets
        ///     - updateProperties: Whether to update the view's properties.
        ///     - type: The view render data type.
        func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) where Data: ViewRenderData {
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

        /// The size in pixels to display icons at.
        ///
        /// If set to a value != -1, this property overrides the
        /// ``iconSize(_:)`` property for images of type
        /// `GTK_IMAGE_ICON_NAME`.
        func pixelSize(_ pixelSize: Int?) -> Self {
            modify { $0.pixelSize = pixelSize }
        }
    }
}
