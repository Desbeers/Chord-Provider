//
//  AnyView+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Adwaita
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
