//
//  ChordDefinitionView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

// swiftlint:disable indentation_width

/**
 A SwiftUI `View` for a ``ChordDefinition``

 The `View` can be styled with the passed `DisplayOptions` and further with the usual SwiftUI modifiers.

 **The color of the diagram are styled with the `.foregroundStyle` modifier**
 - The color of the diagram is the primary color.
 - The labels are the secondary color

 - Note: If you don't attach a .foregroundStyle modifier, the labels are hard to see because the primary and secondary color are not that different.

 **The height of the `View` is just as needed**

 It will calculate all the bits and pieces based on the *width* and will be not a fixed height. As always, you can set the *height* with a modifier as it pleases you.

 Best is to wrap the `View` in another `View` to attach any modifiers:
 ```swift
 /// SwiftUI `View` for a chord diagram
 struct ChordDiagramView: View {
 /// The chord
 let chord: ChordDefinition
 /// Width of the chord diagram
 var width: Double
 /// Display options
 var options: ChordDefinition.DisplayOptions
 /// The current color scheme
 @Environment(\.colorScheme) var colorScheme
 /// The body of the `View`
 var body: some View {
    ChordDefinitionView(chord: chord, width: width, options: options)
        .foregroundStyle(.primary, colorScheme == .dark ? .black : .white)
    }
 }
 ```
 If you want to render the chord for print; just set the style to 'black and white' and use `ImageRenderer` to get your image.
 */
public struct ChordDefinitionView: View {

    // swiftlint:enable indentation_width

    /// The chord to display in a diagram
    let chord: ChordDefinition
    /// The chord display options
    let options: ChordDefinition.DisplayOptions
    /// The width of the diagram
    let width: Double
    /// The height of the grid
    let gridHeight: Double
    /// The height of a line
    let lineHeight: Double
    /// The width of a cell
    let cellWidth: Double
    /// The horizontal padding
    let horizontalPadding: Double
    /// The frets of the chord; adjusted for left-handed if needed
    let frets: [Int]
    /// The fingers of the chord; adjusted for left-handed if needed
    let fingers: [Int]
    /// The offset for an instrument with less than 6 strings
    /// - Note: Used to give a barre some padding
    let xOffset: Double

    /// Init the `View`
    /// - Parameters:
    ///   - chord: The ``ChordDefinition``
    ///   - width: The width of the diagram
    ///   - options: The ``ChordDefinition/DisplayOptions`` for the diagram
    public init(chord: ChordDefinition, width: Double, options: ChordDefinition.DisplayOptions) {
        self.chord = chord
        self.options = options
        self.width = width
        self.lineHeight = width / 8
        /// This looks nice to me
        self.gridHeight = width * 0.9
        /// Calculate the cell width
        self.cellWidth = width / Double(chord.instrument.strings.count + 1)
        /// Calculate the horizontal padding
        self.horizontalPadding = cellWidth / 2
        /// The frets of the chord
        self.frets = options.general.mirrorDiagram ? chord.frets.reversed() : chord.frets
        /// The fingers of the chord
        self.fingers = options.general.mirrorDiagram ? chord.fingers.reversed() : chord.fingers
        /// The circle radius is the same for every instrument
        let circleRadius = width / 7
        /// Below should be 0 for a six string instrument
        self.xOffset = (cellWidth - circleRadius) / 2
    }


    // MARK: Body of the View

    /// The body of the `View`
    public var body: some View {
        VStack(spacing: 0) {
            if options.general.showName {
                Text(chord.displayName(options: options))
                    .font(.system(size: lineHeight, weight: .semibold, design: .default))
                    .padding(lineHeight / 4)
            }
            switch chord.status {
            case .standardChord, .transposedChord, .customChord:
                diagram
            default:
                Text(chord.status.description)
                    .multilineTextAlignment(.center)
            }
        }
        .overlay(alignment: .topLeading) {
            if options.general.showPlayButton {
                ChordDisplayOptions.PlayButton(chord: chord, instrument: options.general.midiInstrument)
                    .font(.body)
                    .padding(.top, lineHeight / 2)
                    .padding(.leading, horizontalPadding)
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
            }
        }
        .padding(.bottom, lineHeight / 2)
        /// Make the whole diagram clickable if needed
        .contentShape(Rectangle())
        .frame(width: width)
    }

    // MARK: Diagram

    /// The diagram `View`
    @ViewBuilder var diagram: some View {
        if frets.contains(-1) || frets.contains(0) {
            topBar
        }
        if chord.baseFret == 1 {
            Rectangle()
                .padding(.horizontal, cellWidth / 1.2)
                .frame(height: width / 25)
                .offset(x: 0, y: 1)
        }
        ZStack(alignment: .topLeading) {
            grid
            if chord.baseFret != 1 {
                Text("\(chord.baseFret)")
                    .font(.system(size: lineHeight * 0.6, weight: .regular, design: .default))
                    .frame(height: gridHeight / 5)
            }
            if !chord.barres.isEmpty {
                barresGrid
            }
            fretsGrid
        }
        .frame(height: gridHeight)
        if options.general.showNotes {
            notesBar
        }
    }

    // MARK: Top Bar

    /// The top bar `View`
    var topBar: some View {
        HStack(spacing: 0) {
            ForEach(frets.indices, id: \.self) { index in
                let fret = frets[index]
                VStack {
                    switch fret {
                    case -1:
                        Image(systemName: "xmark")
                            .symbolRenderingMode(.palette)
                    case 0:
                        Image(systemName: "circle")
                            .symbolRenderingMode(.palette)
                    default:
                        Color.clear
                    }
                }
                .font(.system(size: lineHeight * 0.6, weight: .semibold, design: .default))
                .frame(maxWidth: .infinity)
                .frame(height: lineHeight)
            }
        }
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: String Grid

    /// The grid `View`
    var grid: some View {
        GridShape(instrument: chord.instrument)
            .stroke(.primary, style: StrokeStyle(lineWidth: 0.4, lineCap: .round, lineJoin: .round))
            .padding(.horizontal, cellWidth)
    }

    // MARK: Frets Grid

    /// The frets grid `View`
    var fretsGrid: some View {
        return Grid(alignment: .top, horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach((1...5), id: \.self) { fret in
                GridRow {
                    ForEach(chord.instrument.strings, id: \.self) { string in
                        if frets[string] == fret && !chord.barres.map(\.fret).contains(fret) {
                            VStack(spacing: 0) {
                                switch options.general.showFingers {
                                case true:
                                    Group {
                                        switch fingers[string] {
                                        case 0:
                                            /// Hide a 'zero' finger
                                            Image(systemName: "circle.fill")
                                            .resizable()
                                        default:
                                            Image(systemName: "\(fingers[string]).circle.fill")
                                            .resizable()
                                                .foregroundStyle(.secondary, .primary)
                                        }
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .symbolRenderingMode(.palette)
                                case false:
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .symbolRenderingMode(.palette)
                                }
                            }
                            .frame(height: lineHeight)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Color.clear
                        }
                    }
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }

    // MARK: Barre Grid

    /// The barres grid `View`
    var barresGrid: some View {
        VStack(spacing: 0) {
            ForEach((1...5), id: \.self) { fret in
                if let barre = chord.barres.first(where: { $0.fret == fret }) {
                    /// Mirror for left-handed if needed
                    let barre = options.general.mirrorDiagram ? chord.mirrorBarre(barre) : barre
                    HStack(spacing: 0) {
                        if barre.startIndex != 0 {
                            Color.clear
                                .frame(width: cellWidth * Double(barre.startIndex))
                        }
                        ZStack {
                            RoundedRectangle(cornerSize: .init(width: lineHeight, height: lineHeight))
                                .padding(.horizontal, xOffset * 2)
                                .frame(height: lineHeight)
                                .frame(width: cellWidth * Double(barre.length))
                            if options.general.showFingers {
                                Image(systemName: "\(barre.finger).circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.secondary, .clear)
                                    .frame(height: lineHeight)
                            }
                        }
                        if barre.endIndex < chord.instrument.strings.count {
                            Color.clear
                                .frame(width: cellWidth * Double(chord.instrument.strings.count - barre.endIndex))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.clear
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
        .frame(width: width, height: gridHeight)
    }

    // MARK: Notes Bar

    /// The notes `View`
    var notesBar: some View {
        let notes = options.general.mirrorDiagram ? chord.components.reversed() : chord.components
        return HStack(spacing: 0) {
            ForEach(notes) { note in
                VStack {
                    switch note.note {
                    case .none:
                        Color.clear
                    default:
                        Text("\(note.note.display.symbol)")
                    }
                }
                .font(.system(size: lineHeight * 0.6, weight: .regular, design: .default))
                .frame(maxWidth: .infinity)
                .frame(height: lineHeight * 0.8)
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
}

// MARK: GridShape

extension ChordDefinitionView {

    /// The `Shape` of the grid
    struct GridShape: Shape {
        /// The ``Instrument`` to use
        let instrument: Instrument
        func path(in rect: CGRect) -> Path {
            let columns = instrument.strings.count - 1
            let width = rect.width
            let height = rect.height
            let xSpacing = width / Double(columns)
            let ySpacing = height / 5
            var path = Path()
            for index in 0...columns {
                let vOffset: CGFloat = CGFloat(index) * xSpacing
                path.move(to: CGPoint(x: vOffset, y: 0))
                path.addLine(to: CGPoint(x: vOffset, y: height))
            }
            for index in 0...5 {
                let hOffset: CGFloat = CGFloat(index) * ySpacing
                path.move(to: CGPoint(x: 0, y: hOffset))
                path.addLine(to: CGPoint(x: width, y: hOffset))
            }
            return path
        }
    }
}
