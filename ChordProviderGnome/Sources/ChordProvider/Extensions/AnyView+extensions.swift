//
//  AnyView+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Adwaita
import CAdw
import ChordProviderCore

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
    /// - Parameter name: The `LogUtils/Level``
    /// - Returns: A level `AnyView`
    func logLevelStyle(_ level : LogUtils.Level) -> AnyView {
        style(.log).style("log-\(level.rawValue)")
    }
}

extension AnyView {

    /// Make a button or similar widget use round appearance.
    /// - Parameter active: Whether the style is currently applied.
    /// - Returns: A view.
    public func round(_ active: Bool = true) -> AnyView {
        style("round", active: active)
    }
}

extension AnyView {

    public func vertical() -> AnyView {
        inspect { storage, updateProperties in
            gtk_orientable_set_orientation(storage.opaquePointer, GTK_ORIENTATION_VERTICAL)
//            let cssID = "internal-css"
//            let previous = storage.fields[cssID] as? String
//            let string = getString()
//            if updateProperties, string != previous {
//                let provider = gtk_css_provider_new()
//                gtk_css_provider_load_from_string(
//                    provider,
//                    string
//                )
//                let display = gdk_display_get_default()
//                gtk_style_context_add_provider_for_display(
//                    display,
//                    provider?.opaque(),
//                    .init(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
//                )
//                g_object_unref(provider)
//            }
        }
    }
}
