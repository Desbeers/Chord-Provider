//
//  Label+extensions.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import ChordProviderCore
import Adwaita
import CAdw

extension Label {

    /// Set the zoom factor of a `GtkLabel`
    /// - Parameter zoom: The zoom factor
    /// - Returns: Updated `Self`
    func zoom(_ zoom: Double) -> Self {
        var newSelf = self
        newSelf.updateFunctions.append { storage, _, updateProperties in
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
        return newSelf
    }
}

extension Label {

    /// Highlight the background of a `GtlLabel`
    /// - Parameters:
    ///   - highlight: Bool to highlight or not
    ///   - color: The accent color
    /// - Returns: Updated `AnyView`
    public func highlight(_ highlight: Bool, color: (red: UInt16, green: UInt16, blue: UInt16)) -> Self {
        var newSelf = self
        newSelf.updateFunctions.append { storage, _, updateProperties in
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
        return newSelf
    }
}
