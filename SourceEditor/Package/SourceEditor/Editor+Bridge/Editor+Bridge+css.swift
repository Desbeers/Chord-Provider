//
//  Editor+Bridge+css.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import CAdw
import CGtkSourceView

extension Editor.Bridge {

    /// Convert the colors into a CSS style.
    public func css(colorfull: Bool) -> String {
        guard
            /// The foreground color.
            let foreground = styleInfo[.text]?.foreground,
            /// The background color.
            let background = styleInfo[.text]?.background
        else {
            print("ERROR")
            return ""
        }

        let windowStart = styleInfo[.accent] == nil ? styleInfo.accent.withAlpha(0.05) : background

        let windowEnd = background.mixed(with: styleInfo[.accent] == nil ? styleInfo.accent : foreground, 0.1)

        /// Surfaces: the scheme background nudged towards the foreground
        func raise(_ amount: Double) -> Color {
            background.mixed(with: foreground, amount)
        }
        /// Shades and borders must be partially transparent black
        func shade(_ light: Double, _ dark: Double) -> Color {
            Color.black.withAlpha(styleInfo.isDark ? dark : light)
        }

        var variables: [(name: String, color: Color)] = []

        // Move below to Chord Provider

        variables.append(
            contentsOf:
            [
                ("chord-render",
                    (
                        styleInfo[.chordProChordRender]?.foreground) ??
                        styleInfo[.selection]?.background.withAlpha(1) ??
                        Color.systemAccent
                    ),

                ("icon-foreground", styleInfo.isDark ? foreground : raise(0.08)),
                ("icon-background-start", styleInfo.accent.mixed(with: background, 0.5)),
                ("icon-background-end", styleInfo.accent)
            ]
        )

        variables.append(("link-color", styleInfo[.defNetAddress]?.foreground ?? foreground))

        if colorfull {
        variables.append(contentsOf: [
            ("editor-window-start", windowStart),
            ("editor-window-end", windowEnd),
            ("window-fg-color", foreground),
            ("card-fg-color", foreground),
            ("active-toggle-fg-color", foreground),
            ("headerbar-fg-color", foreground),
            ("popover-bg-color", background),
            ("popover-fg-color", foreground)
        ])
        }

        // if colorfull {
        //     /// CSS variables.
        //     variables.append(contentsOf: [
        //         // GtkSourceView scheme
        //         ("sourceview-keyword", (styleInfo[.defKeyword]?.foreground) ?? foreground),
        //         // Window
        //         // ("window-bg-color", background),
        //         // ("window-fg-color", foreground),
        //         ("editor-window-start", windowStart),
        //         ("editor-window-end", windowEnd),
        //         // View
        //         ("view-bg-color", background),
        //         ("view-fg-color", foreground),
        //         // Header bar
        //         // ("headerbar-bg-color", raise(0.06)),
        //         // ("headerbar-fg-color", foreground),
        //         // ("headerbar-border-color", foreground),
        //         // ("headerbar-backdrop-color", background),
        //         // ("headerbar-shade-color", shade(0.12, 0.36)),
        //         // ("headerbar-darker-shade-color", shade(0.12, 0.90)),
        //         // Sidebar
        //         ("sidebar-bg-color", raise(0.03)),
        //         ("sidebar-fg-color", foreground),
        //         ("sidebar-backdrop-color", raise(0.015)),
        //         ("sidebar-border-color", shade(0.07, 0.36)),
        //         ("sidebar-shade-color", shade(0.07, 0.25)),
        //         // Secondary sidebar
        //         ("secondary-sidebar-bg-color", raise(0.02)),
        //         ("secondary-sidebar-fg-color", foreground),
        //         ("secondary-sidebar-backdrop-color", raise(0.01)),
        //         ("secondary-sidebar-border-color", shade(0.07, 0.36)),
        //         ("secondary-sidebar-shade-color", shade(0.07, 0.25)),
        //         // Card
        //         // ("card-bg-color", raise(0.06)),
        //         ("card-bg-color", background.rgba.lighten(by: 0.06).color),
        //         ("card-fg-color", foreground),
        //         ("card-shade-color", shade(0.07, 0.36)),
        //         // Tab overview and thumbnails
        //         ("overview-bg-color", raise(0.02)),
        //         ("overview-fg-color", foreground),
        //         ("thumbnail-bg-color", raise(0.08)),
        //         ("thumbnail-fg-color", foreground),
        //         // Active toggle (AdwToggleGroup)
        //         // ("active-toggle-bg-color", raise(0.15)),
        //         // ("active-toggle-fg-color", foreground),
        //         // Dialog
        //         ("dialog-bg-color", raise(0.04)),
        //         ("dialog-fg-color", foreground),
        //         // Popover
        //         // ("popover-bg-color", raise(0.06)),
        //         ("popover-bg-color", background.lighten(by: 0.06)),
        //         // ("popover-fg-color", foreground),
        //         // ("popover-shade-color", shade(0.07, 0.25)),
        //         // Miscellaneous
        //         ("shade-color", shade(0.07, 0.25)),
        //         ("scrollbar-outline-color", isDark ? GdkRGBA.black.withAlpha(0.5).color : GdkRGBA.white.color)
        //     ])
        // }

        // Accent: libadwaita derives the standalone `--accent-color` from the background

        /// The accent color. Only apply when set in the scheme.
        if let accent = styleInfo[.accent]?.background ?? styleInfo[.selection]?.background.withAlpha(1) {
            let accentBackground = accent
            variables.append(("accent-bg-color", accentBackground))
            variables.append(("accent-fg-color", colorfull ? styleInfo.isDark ? foreground : background : Color.white))
        }

        /// Compose the body.
        var body = variables
            .map { "    --\($0.name): \($0.color.hex);" }
            .joined(separator: "\n")
        body = ":root {\n\(body)\n}\n"

        if colorfull {
            body += """
            window, dialog sheet {
                background-image: linear-gradient(135deg, var(--editor-window-start), var(--editor-window-end));
            }

            .sidebar-pane {
                background-color: var(--editor-window-start);
            }
            """
        }

        body += """
        .symbolic-app-icon {
            color: rgba(248, 244, 226, 1);
        }
        .scheme-accent-preview  label{
            background-color: \(Color.systemAccent.hex);
            opacity: 0.1;
        }
        .scheme-preview image {
            background-color: var(--accent-bg-color);
        }
        .scheme-preview{
            box-shadow: none;
            border: 1px solid transparent;
        }
        .scheme-preview.selected{
            border: 1px solid var(--accent-color);
        }

        /* Links: make the always blue insead of accent color */

        label.link {
            --accent-color: \(styleInfo.isDark ? "#8ed5fe" : "#1974cf");
        }
        """

        /// Return the CSS string.
        return body
    }
}
