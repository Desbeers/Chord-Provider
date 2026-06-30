//
//  AnyView+extensions.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import ChordProviderCore
import Adwaita
import CAdw

extension AnyView {

    /// Add a CSS style
    /// - Parameter name: The ``Markup/Class`` to add
    /// - Returns: A modified `AnyView`
    func style(_ name: Markup.Class) -> AnyView {
        style(name.description)
    }
}

extension AnyView {

    /// Add a CSS style to a log entry
    /// - Parameter level: The `LogUtils/Level``
    /// - Returns: A modified `AnyView`
    func logLevelStyle(_ level: LogUtils.Level) -> AnyView {
        style(.log).style("log-\(level.rawValue)")
    }
}

extension AnyView {

    /// Orientate a `Widget` vertical
    /// - Returns: A modified `AnyView`
    public func vertical() -> AnyView {
        inspect { storage, updateProperties in
            if updateProperties {
                gtk_orientable_set_orientation(storage.opaquePointer, .GTK_ORIENTATION_VERTICAL)
            }
        }
    }

    /// Orientate a `Widget` horizontal
    /// - Returns: A modified `AnyView`
    public func horizontal() -> AnyView {
        inspect { storage, updateProperties in
            if updateProperties {
                gtk_orientable_set_orientation(storage.opaquePointer, .GTK_ORIENTATION_HORIZONTAL)
            }
        }
    }
}

extension AnyView {

    /// Set the zoom factor of a `GtkLabel`
    /// - Parameter zoom: The zoom factor
    /// - Returns: Updated `AnyView`
    public func zoom(_ zoom: Double) -> AnyView {
        inspect { storage, _, updateProperties in
            if updateProperties {
                let list: OpaquePointer
                if let current = gtk_label_get_attributes(storage.opaquePointer) {
                    list = pango_attr_list_copy(current)
                } else {
                    list = pango_attr_list_new()
                }
                pango_attr_list_insert(list, pango_attr_scale_new(zoom))
                gtk_label_set_attributes(storage.opaquePointer, list)
                pango_attr_list_unref(list)
            }
        }
    }
}

extension AnyView {

    /// Highlight the background of a `GtlLabel`
    /// - Parameters:
    ///   - highlight: Bool to highlight or not
    ///   - color: The accent color
    /// - Returns: Updated `AnyView`
    public func highlight(_ highlight: Bool, color: (red: UInt16, green: UInt16, blue: UInt16)) -> AnyView {
        inspect { storage, _, updateProperties in
            if updateProperties {
                let list = pango_attr_list_new()
                defer {
                    gtk_label_set_attributes(storage.opaquePointer, list)
                    pango_attr_list_unref(list)
                }
                guard highlight, let backgroundHighlight = pango_attr_background_new(
                    color.red,
                    color.green,
                    color.blue
                ) else { return }
                pango_attr_list_insert(list, backgroundHighlight)
                let alpha = pango_attr_background_alpha_new(16384) // 50%
                pango_attr_list_insert(list, alpha)
            }
        }
    }
}
