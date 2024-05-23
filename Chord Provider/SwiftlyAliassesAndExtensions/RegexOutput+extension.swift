//
//  RegexOutput+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import RegexBuilder

extension ChoiceOf where RegexOutput == Substring {

    /// Use an array of elements for a `ChoiceOf` regex part
    /// - Parameter components: The choices components
    init<S: Sequence<String>>(_ components: S) {
        let exps = components.map { AlternationBuilder.buildExpression($0) }

        guard !exps.isEmpty else {
            fatalError("Empty choice!")
        }

        self = exps.dropFirst().reduce(AlternationBuilder.buildPartialBlock(first: exps[0])) { acc, next in
            AlternationBuilder.buildPartialBlock(accumulated: acc, next: next)
        }
    }
}
