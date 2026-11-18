//
//  Editor+StyleID.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

extension Editor {

    /// Style IDs used by the GtkSourceView schemes.
    public enum StyleID: String, CaseIterable {

        // MARK: Global styles.

        /// The default text.
        case text
        /// The selected text.
        case selection
        /// The line with the cursor.
        case currentLine = "current-line"
        /// The line numbers in the gutter.
        case lineNumbers = "line-numbers"
        /// The text cursor.
        case cursor
        /// The matching bracket next to the cursor.
        case bracketMatch = "bracket-match"
        /// The matches of a search.
        case searchMatch = "search-match"

        // MARK: Default styles.

        /// A comment.
        case defComment = "def:comment"
        /// A shebang line, like `#!/bin/bash`.
        case defShebang = "def:shebang"
        /// An element inside a documentation comment.
        case defDocCommentElement = "def:doc-comment-element"
        /// A constant.
        case defConstant = "def:constant"
        /// A special character, like an escape sequence.
        case defSpecialChar = "def:special-char"
        /// A special constant, like `null`.
        case defSpecialConstant = "def:special-constant"
        /// A type name.
        case defType = "def:type"
        /// A function name.
        case defFunction = "def:function"
        /// A built-in function or type.
        case defBuiltin = "def:builtin"
        /// A preprocessor directive.
        case defPreprocessor = "def:preprocessor"
        /// A statement.
        case defStatement = "def:statement"
        /// An identifier.
        case defIdentifier = "def:identifier"
        /// A string.
        case defString = "def:string"
        /// A character literal.
        case defCharacter = "def:character"
        /// A note inside a comment, like `TODO` or `FIXME`.
        case defNote = "def:note"
        /// A network address, like a URL or an email address.
        case defNetAddress = "def:net-address"
        /// Underlined text.
        case defUnderlined = "def:underlined"
        /// An error.
        case defError = "def:error"
        /// A warning.
        case defWarning = "def:warning"
        /// A heading.
        case defHeading = "def:heading"
        /// Emphasized text.
        case defEmphasis = "def:emphasis"
        /// Strongly emphasized text.
        case defStrongEmphasis = "def:strong-emphasis"
        /// Inline code.
        case defInlineCode = "def:inline-code"
        /// An inserted line, as in a diff.
        case defInsertion = "def:insertion"
        /// A deleted line, as in a diff.
        case defDeletion = "def:deletion"
        /// A number.
        case defNumber = "def:number"
        /// A decimal number.
        case defDecimal = "def:decimal"
        /// An integer in another base, like hexadecimal or binary.
        case defBaseNInteger = "def:base-n-integer"
        /// A floating point number.
        case defFloatingPoint = "def:floating-point"
        /// A complex number.
        case defComplex = "def:complex"
        /// A boolean value.
        case defBoolean = "def:boolean"
        /// An operator.
        case defOperator = "def:operator"
        /// A link symbol.
        case defLinkSymbol = "def:link-symbol"
        /// A list marker.
        case defListMarker = "def:list-marker"
        /// A horizontal rule.
        case defRule = "def:rule"
        /// A keyword.
        case defKeyword = "def:keyword"

        /// MARK: Custom styles.

        /// The accent color.
        case accent

        // MARK: ChordPro styles.

        /// A chord, as rendered in the UI.
        case chordProChordRender = "chordpro:chord-render"
    }
}
