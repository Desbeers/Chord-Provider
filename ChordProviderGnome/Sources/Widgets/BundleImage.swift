//
//  BundleImage.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import CChordProvider
import Adwaita
import CAdw

/// The `AdwaitaWidget` for an SVG image from the bundle
public struct BundleImage: AdwaitaWidget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, WidgetData, Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, WidgetData) -> Void] = []

    /// The accessible role of the given `GtkAccessible` implementation.
    ///
    /// The accessible role cannot be changed once set.
    var accessibleRole: String?
    /// The name of the icon in the icon theme.
    ///
    /// If the icon theme is changed, the image will be updated automatically.
    var iconName: String?
    /// The size in pixels to display icons at.
    var pixelSize: Int?
    /// A path to a resource file to display.
    var resource: String?
    /// The representation being used for image data.
    var storageType: String?
    /// Whether the icon displayed in the `GtkImage` will use
    /// standard icon names fallback.
    ///
    /// The value of this property is only relevant for images of type
    /// %GTK_IMAGE_ICON_NAME and %GTK_IMAGE_GICON.
    var useFallback: Bool?

    /// Initialize `BundleImage`.
    public init(name: String) {
        let dark = app_prefers_dark_theme() == 1 ? true : false
        let name = "Icons/\(name)\(dark ? "-dark" : "")"
        if let urlPath = Bundle.module.url(forResource: name, withExtension: "svg") {
            self.resource = urlPath.path
        }
    }

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
        let storage = ViewStorage(gtk_image_new()?.opaque())
        for function in appearFunctions {
            function(storage, data)
        }
        update(storage, data: data, updateProperties: true, type: type)

        return storage
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - modifiers: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) where Data: ViewRenderData {
        storage.modify { widget in
            if let resource, updateProperties, (storage.previousState as? Self)?.resource != resource {
                gtk_image_set_from_file(widget, resource)
            }
        }
        for function in updateFunctions {
            function(storage, data, updateProperties)
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
    public func pixelSize(_ pixelSize: Int?) -> Self {
        modify { $0.pixelSize = pixelSize }
    }

    /// The representation being used for image data.
    public func storageType(_ storageType: String?) -> Self {
        modify { $0.storageType = storageType }
    }
}
