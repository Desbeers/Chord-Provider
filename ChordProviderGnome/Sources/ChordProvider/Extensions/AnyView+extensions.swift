//
//  AnyView+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
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
    /// - Parameter name: The `LogUtils/Level``
    /// - Returns: A level `AnyView`
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
                gtk_orientable_set_orientation(storage.opaquePointer, GTK_ORIENTATION_VERTICAL)
            }
        }
    }

    /// Orientate a `Widget` horizontal
    /// - Returns: A modified `AnyView`
    public func horizontal() -> AnyView {
        inspect { storage, updateProperties in
            if updateProperties {
                gtk_orientable_set_orientation(storage.opaquePointer, GTK_ORIENTATION_HORIZONTAL)
            }
        }
    }
}
