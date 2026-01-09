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
    /// - Returns: A modified `AnyView`
    public func round(_ active: Bool = true) -> AnyView {
        style("round", active: active)
    }
}

extension AnyView {
    
    /// Orientate a `Widget` vertical
    /// - Returns: A modified `AnyView`
    public func vertical() -> AnyView {
        inspect { storage, updateProperties in
            gtk_orientable_set_orientation(storage.opaquePointer, GTK_ORIENTATION_VERTICAL)
        }
    }
}
