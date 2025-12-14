// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Simple script to generate chordpro snippets for the `gtksourceview`

import Foundation
import ChordProviderCore

@main
struct Generate {

    /// The main function
    static func main() {
        var output = """
<?xml version="1.0" encoding="UTF-8"?>
<snippets _group="ChordPro">

"""

        let directives = ChordPro.Directive.allCases

        for directive in directives where !ChordPro.Directive.customDirectives.contains(directive) {

            var text = "\(directive.rawValue.long)"

            if ChordPro.Directive.directivesWithArgument.contains(directive) {
                text += " ${1:\(directive.details.defaultValue ?? directive.details.label)}"
            }

            output += """
    <snippet _name="\(directive.details.label)" trigger="{\(directive.rawValue.long)}" _description="\(directive.details.help)">
        <text languages="chordpro">\(text)}</text>
    </snippet>

"""
        }

        output += """
</snippets>

"""

        print(output)
        do {
            try output.write(to: URL(string: "/Users/Desbeers/Desktop/chordpro.snippets")!, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }

}
