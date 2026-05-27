//
//  SourceViewController+marks.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView
import ChordProviderCore

extension SourceViewController {

    static func setMarksStyle(sourceView: ViewStorage, darkMode: Bool) {
        for level in LogUtils.Level.allCases {
            gtk_source_view_set_show_line_marks(sourceView.opaquePointer?.cast(), 1)
            let attributes = gtk_source_mark_attributes_new()
            var color = GdkRGBA()
            gtk_source_mark_attributes_set_icon_name(
                attributes,
                level.style.icon
            )
            gdk_rgba_parse(&color, "\(level.style.color)\(darkMode ? 20 : 10)")
            gtk_source_mark_attributes_set_background(attributes, &color)
            gtk_source_view_set_mark_attributes(sourceView.opaquePointer?.cast(), level.rawValue, attributes, 1)
        }
    }
}