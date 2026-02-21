import Foundation
import Adwaita

struct FontSizeSpinner: View {
    /// Nested struct has issues
    @Binding var appState: AppState
    /// Directly passing the Int as Binding: same issues.
    /// @Binding var editorFontSize: Int
    /// Passing the Theme; same issues
    /// @Binding var theme: Theme
    var view: Body {
        SpinRow("Spin Row", value: $appState.theme.editorFontSize, min: 8, max: 20)
        /// SpinRow("Spin Row", value: $editorFontSize, min: 8, max: 20)
        /// SpinRow("Spin Row", value: $theme.editorFontSize, min: 8, max: 20)
    }
}
