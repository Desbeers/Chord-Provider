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
    ///   - icon: The button's icon
    ///   - isOn: Bool if the button is on
    ///   - handler: The button's action handler
    public init(icon: Icon, isOn: Binding<Bool>, handler: @escaping () -> Void) {
        self.init(isOn: isOn)
        self = self.child {
            ButtonContent()
                .iconName(icon.string)
        }
        self = self.active(isOn)
        self = self.clicked(handler)
    }
}
