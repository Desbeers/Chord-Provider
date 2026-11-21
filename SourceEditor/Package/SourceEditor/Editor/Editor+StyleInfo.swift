//
//  Editor+StyleInfo.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

extension Editor {

    /// The style info for a Style ID
    public struct StyleInfo {

        /// The style ID.
        public var id: Editor.StyleID
        /// The style ID that was used instead when the scheme does not define `id`;
        /// nil if there was no fallback.
        public var fallback: Editor.StyleID?
        /// The foreground color.
        public var foreground: Color
        /// The background color, painted behind the characters of the styled text only.
        public var background: Color
        /// The line background color, painted across the whole line; `transparent` paints nothing.
        public var lineBackground: String
        /// The underline color; follows the foreground when not set.
        public var underlineColor: String
        /// Bool if the text is bold.
        public var bold: Bool
        /// Bool if the text is italic.
        public var italic: Bool
        /// Bool if the text is struck through.
        public var strikethrough: Bool
        /// The size factor of the text; 1.0 is normal size.
        public var scale: Double

        /// Init the style info.
        /// - Parameters:
        ///   - id: The style ID.
        ///   - fallback: The style ID that was used instead, if any.
        ///   - foreground: The foreground color.
        ///   - background: The background color.
        ///   - lineBackground: The line background color; `transparent` paints nothing.
        ///   - underlineColor: The underline color; defaults to the foreground.
        ///   - bold: Bool if the text is bold.
        ///   - italic: Bool if the text is italic.
        ///   - strikethrough: Bool if the text is struck through.
        ///   - scale: The size factor; the string will be converted to `Double`.
        init(
            id: Editor.StyleID,
            fallback: Editor.StyleID?,
            foreground: GdkRGBA,
            background: GdkRGBA,
            lineBackground: String,
            underlineColor: String?,
            bold: Bool,
            italic: Bool,
            strikethrough: Bool,
            scale: String?
        ) {
            self.id = id
            self.fallback = fallback
            self.foreground = foreground.color
            self.background = background.color
            self.lineBackground = lineBackground
            self.underlineColor = underlineColor ?? foreground.color.hex
            self.bold = bold
            self.italic = italic
            self.strikethrough = strikethrough
            self.scale = Self.scaleFactor(scale)
        }
    }
}

extension Editor.StyleInfo {

    /// The scale as a factor; 1.0 is normal size.
    private static func scaleFactor(_ value: String?) -> Double {
        switch value {
        case "xx-small":
            0.5787
        case "x-small":
            0.6444
        case "small":
            0.8333
        case "medium", nil:
            1.0
        case "large":
            1.2
        case "x-large":
            1.44
        case "xx-large":
            1.728
        case let number?:
            Double(number) ?? 1.0
        }
    }
}
