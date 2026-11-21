//
//  Editor+Scheme.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

extension Editor {

    /// Color scheme for GtkSourceView
    public struct Scheme: Codable, Equatable, Identifiable {

        /// The ID of the scheme.
        public let id: String
        /// The display name of the scheme.
        public let display: String
        /// The description of the scheme.
        public let description: String
        /// Init the scheme
        /// - Parameter id: The ID of the scheme.
        public init(_ id: String) {
            self.id = id
            let manager = gtk_source_style_scheme_manager_get_default()
            let schemePointer = gtk_source_style_scheme_manager_get_scheme(manager, id)
            if let schemePointer,
                let cName = gtk_source_style_scheme_get_name(schemePointer),
                let cDescription = gtk_source_style_scheme_get_description(schemePointer) {
                self.display = String(cString: cName)
                self.description = String(cString: cDescription)
            } else {
                self.display = id
                self.description = id
            }
        }
    }
}
