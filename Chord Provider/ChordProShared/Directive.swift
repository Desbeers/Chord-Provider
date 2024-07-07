//
//  Directive.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 24/06/2024.
//

import Foundation

struct Directive {
    let directive: String
    let group: Group
    let icon: String
    let editable: Bool
    let argument: Bool
    let help: String

    var label: String {
        return self.directive.replacingOccurrences(of: "_", with: " ").capitalized
    }

    enum Group {
        case metadata
        case directive
        case abbreviation
    }
}

extension Directive {

    static func getChordProDirectives() -> [Directive] {
        var directives: [Directive] = []
        guard
            let chordProInfo = Bundle.main.url(forResource: "ChordProInfo", withExtension: "json"),
            let data = try? Data(contentsOf: chordProInfo),
            let info = try? JSONDecoder().decode(ChordProInfo.self, from: data)
        else {
            return directives
        }
        directives.append(
            contentsOf: info.metadata.map { item in
                Directive(
                    directive: item,
                    group: .metadata,
                    icon: "info.bubble",
                    editable: true,
                    argument: true,
                    help: "Help Me!!!"
                )
            }
        )
        directives.append(
            contentsOf: info.directives.map { item in
                let icon = item.starts(with: "start_") ? "increase.indent" : item.starts(with: "end_") ? "decrease.quotelevel" : "tag"
                return Directive(
                    directive: item,
                    group: .directive,
                    icon: icon,
                    editable: false,
                    argument: true,
                    help: "Help Me!!!"
                )
            }
        )
        directives.append(
            contentsOf: info.directiveAbbreviations.map(\.key).map { item in
                Directive(
                    directive: item,
                    group: .abbreviation,
                    icon: "tag",
                    editable: false,
                    argument: false,
                    help: "Help Me!!!"
                )
            }
        )
        return directives
    }
}
