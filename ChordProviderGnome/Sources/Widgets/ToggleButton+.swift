//
//  Button+.swift
//  Adwaita
//
//  Created by david-swift on 15.01.24.
//

import Adwaita
import CAdw

/// A button widget.
extension ToggleButton {

    // swiftlint:disable function_default_parameter_at_end
    /// Initialize a button.
    /// - Parameters:
    ///   - label: The button's label.
    ///   - icon: The button's icon.
    ///   - handler: The button's action handler.
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
    // swiftlint:enable function_default_parameter_at_end

    /// Initialize a button.
    /// - Parameters:
    ///   - label: The buttons label.
    ///   - handler: The button's action handler.
    public init(_ label: String, isOn: Binding<Bool>, handler: @escaping () -> Void) {
        self.init()
        self = self.label(label)
        self = self.active(isOn)
        self = self.clicked(handler)
    }
}
