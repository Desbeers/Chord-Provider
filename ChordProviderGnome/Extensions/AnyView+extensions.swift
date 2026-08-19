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
