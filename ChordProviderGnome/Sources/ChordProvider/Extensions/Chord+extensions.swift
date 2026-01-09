//
//  Chord+extensions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore
import Adwaita


extension Chord.Instrument: @retroactive ViewSwitcherOption {

    /// Conform to `ViewSwitcherOption` by adding a title
    public var title: String {
        self.description
    }
    /// Conform to `ViewSwitcherOption` by adding an icon
    public var icon: Adwaita.Icon {
        .default(icon: .folderMusic)
    }
}

extension Chord.Root: @retroactive ToggleGroupItem {

    /// Conform to `ToggleGroupItem` by adding an icon
    public var icon: Adwaita.Icon? {
        nil
    }
    /// Conform to `ToggleGroupItem` by adding *showLabel*
    public var showLabel: Bool {
        true
    }
}
