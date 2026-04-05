
import Adwaita
import CAdw

/// A button widget.
extension Button {

    /// Initialize a button with a `Fret` structure
    /// - Note: Used in Define View
    init(_ button: Views.DefineChord.Fret, active: Bool, handler: @escaping () -> Void) {
        if let icon = button.icon {
            self.init(icon: icon, handler: handler)
        } else {
            self.init(button.label, handler: handler)
        }
        self = self.hasFrame(active)
    }
}
