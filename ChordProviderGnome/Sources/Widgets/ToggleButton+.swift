//
//  ToggleButton+.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import CAdw

/// A button widget.
extension ToggleButton {

    /// Initialize a button.
    /// - Parameters:
    ///   - label: The button's label
    ///   - icon: The button's icon
    ///   - isOn: Bool if the button is on
    ///   - handler: The button's action handler
    public init(_ label: String? = nil, icon: Icon, isOn: Binding<Bool>, handler: @escaping () -> Void) {
        self.init()
        self = self.child {
            ButtonContent()
                .label(label)
                .iconName(icon.string)
        }
        self = self.active(isOn)
        self = self.clicked(handler)
    }

    /// Initialize a button.
    /// - Parameters:
    ///   - label: The buttons label
    ///   - isOn: Bool if the button is on
    ///   - handler: The button's action handler
    public init(_ label: String, isOn: Binding<Bool>, handler: @escaping () -> Void) {
        self.init()
        self = self.label(label)
        self = self.active(isOn)
        self = self.clicked(handler)
    }
}
