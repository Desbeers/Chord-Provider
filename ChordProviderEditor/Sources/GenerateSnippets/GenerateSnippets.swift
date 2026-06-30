// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Simple script to generate chordpro snippets for the `gtksourceview`

import Foundation
import ChordProviderCore

// swiftlint:disable indentation_width
// swiftlint:disable convenience_type

@main
struct Generate {
    /// The main function
    static func main() {
        var path = FileManager.default.currentDirectoryPath
        path += "/ChordProviderEditor/Sources/ChordProviderEditor/Resources/chordpro.snippets"
        var output = """
<?xml version="1.0" encoding="UTF-8"?>
<snippets _group="ChordPro">

"""
        let directives = ChordPro.Directive.allCases
        for directive in directives where !ChordPro.Directive.unsupportedDirectives.contains(directive) {
            var text = "\(directive.source.long)"
            if ChordPro.Directive.withPlainArgument.contains(directive) {
                text += ": ${1:\(directive.details.defaultValue ?? directive.details.label)}"
            }
            output += """
    <snippet _name="\(directive.details.label)" trigger="{\(directive.source.long)}" _description="\(directive.details.help)">
        <text languages="chordpro">\(text)}</text>
    </snippet>

"""
        }

        output += """
</snippets>

"""
        do {
            if let url = URL(string: path) {
                try output.write(to: url, atomically: true, encoding: .utf8)
            }
        } catch {
            print(error)
        }
    }
}

// swiftlint:enable convenience_type
// swiftlint:enable indentation_width
