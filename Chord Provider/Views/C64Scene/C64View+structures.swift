//
//  C64View+structures.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension C64View {

    // MARK: Structures

    struct Output: Identifiable, Equatable {
        var id: Int
        var command: Command
        var text: String
        var code: String
        var color: C64Color?
    }

    enum Command {
        case print
        case poke
        case rem
        case scroller
        case clear
        case goto
        case ifThen
        case raw
    }

    enum C64Color: String {
        case black = "#000000"
        case white = "#ffffff"
        case red = "#be3057"
        case cyan = "#42f6d5"
        case purple = "#b836fe"
        case green = "#00d800"
        case blue = "#273ef5"
        case yellow = "#ffff00"
        case orange = "#c45d00"
        case brown = "#7d5100"
        case pink = "#ff7394"
        case darkGray = "#626262"
        case grey = "#949494"
        case lightGreen = "#a1ff74"
        case lightBlue = "#6e86ff"
        case lightGrey = "#cdcdcd"

        var swiftColor: Color {
            Color(hex: self.rawValue) ?? Color.primary
        }

        var code: Int {
            switch self {
            case .black: 0
            case .white: 1
            case .red: 2
            case .cyan: 3
            case .purple: 4
            case .green: 5
            case .blue: 6
            case .yellow: 7
            case .orange: 8
            case .brown: 9
            case .pink: 10
            case .darkGray: 11
            case .grey: 12
            case .lightGreen: 13
            case .lightBlue: 14
            case .lightGrey: 15
            }
        }
    }
}
