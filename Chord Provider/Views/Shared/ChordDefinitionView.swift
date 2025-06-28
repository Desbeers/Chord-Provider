//
//  ChordDefinitionView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for a ``ChordDefinition``

struct ChordDefinitionView: View {
    /// The chord to display in a diagram
    let chord: ChordDefinition
    /// The width of the diagram
    let width: Double
    /// The width of the grid
    let gridWidth: Double
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
    /// The height of the nut
    let nutHeight: Double
    /// The application settings
    var settings: AppSettings
    /// The display options for the diagram
    let diagramDisplayOptions: AppSettings.Diagram

    /// Init the `View`
    /// - Parameters:
    ///   - chord: The ``ChordDefinition``
    ///   - width: The width of the diagram
    ///   - settings: The application
    ///   - useDefaultColors: Bool to use the default colors for the diagram
    init(chord: ChordDefinition, width: Double, settings: AppSettings, useDefaultColors: Bool = false) {
        self.chord = chord
        self.settings = settings
        self.diagramDisplayOptions = settings.diagram
        self.width = width
        self.gridWidth = width * 0.8
        self.nutHeight = gridWidth / 25
        self.lineHeight = gridWidth / 8
        /// This looks nice to me
        self.gridHeight = gridWidth * 0.9
        /// Calculate the cell width
        self.cellWidth = gridWidth / Double(chord.instrument.strings.count + 1)
        /// Calculate the horizontal padding
        self.horizontalPadding = cellWidth / 2
        /// The frets of the chord
        self.frets = diagramDisplayOptions.mirrorDiagram ? chord.frets.reversed() : chord.frets
        /// The fingers of the chord
        self.fingers = diagramDisplayOptions.mirrorDiagram ? chord.fingers.reversed() : chord.fingers
        /// The circle radius is the same for every instrument
        let circleRadius = gridWidth / 7
        /// Below should be 0 for a six string instrument
        self.xOffset = (cellWidth - circleRadius) / 2
        /// Get the default colors if asked
        if useDefaultColors {
            var inDarkMode: Bool {
                let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
                return mode == "Dark"
            }
            switch inDarkMode {
            case true:
                self.settings.style = AppSettings.Style.ColorPreset.dark.presets(style: settings.style)
            case false:
                self.settings.style = AppSettings.Style.ColorPreset.light.presets(style: settings.style)
            }
        }
    }


    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            if diagramDisplayOptions.showName {
                Text(chord.display)
                    .font(.system(size: lineHeight, weight: .semibold, design: .default))
                    .padding(lineHeight / 4)
                    .foregroundStyle(settings.style.fonts.chord.color)
            }
            switch chord.status {
            case .standardChord, .transposedChord, .customChord:
                diagram
            default:
                Text(chord.status.description)
                    .multilineTextAlignment(.center)
            }
        }
        .foregroundStyle(
            settings.style.theme.foreground,
            settings.style.theme.foregroundMedium
        )
        .overlay(alignment: .topLeading) {
            if diagramDisplayOptions.showPlayButton, chord.status.knownChord {
                PlayChordButton(
                    chord: chord,
                    instrument: diagramDisplayOptions.midiInstrument
                )
                .font(.body)
                .foregroundStyle(Color.accentColor)
                .padding(.top, lineHeight / 2)
                .padding(.leading, horizontalPadding)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, (width - gridWidth) / 2)
        .padding(.bottom, lineHeight / 2)
        /// Make the whole diagram clickable if needed
        .contentShape(Rectangle())
        .frame(width: width)
    }

    // MARK: Diagram

    /// The diagram `View`
    @ViewBuilder var diagram: some View {
        topBar
        Rectangle()
            .padding(.horizontal, cellWidth / 1.2)
            .frame(height: nutHeight)
            .foregroundStyle(chord.baseFret == 1 ? settings.style.theme.foreground : Color.clear)
        ZStack(alignment: .topLeading) {
            grid
                .offset(y: -nutHeight)
            if chord.baseFret != 1 {
                let offset = (width - gridWidth) / 2
                Text("\(chord.baseFret)")
                    .font(.system(size: lineHeight * 0.6, weight: .regular, design: .default))
                    .frame(width: offset, height: gridHeight / 5, alignment: .trailing)
                    .offset(x: -(offset / 2))
            }
            fretsGrid
            if chord.barres != nil {
                barresGrid
            }
        }
        .frame(height: gridHeight)
        if diagramDisplayOptions.showNotes {
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
                .foregroundStyle(settings.style.theme.foregroundMedium)
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
            .stroke(settings.style.theme.foreground, style: StrokeStyle(lineWidth: 0.4, lineCap: .round, lineJoin: .round))
            .padding(.horizontal, cellWidth)
    }

    // MARK: Frets Grid

    /// The frets grid `View`
    var fretsGrid: some View {
        return Grid(alignment: .top, horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach((1...5), id: \.self) { fret in
                GridRow {
                    ForEach(chord.instrument.strings, id: \.self) { string in
                        if frets[string] == fret {
                            VStack(spacing: 0) {
                                switch diagramDisplayOptions.showFingers {
                                case true:
                                    Group {
                                        switch fingers[string] {
                                        case 0:
                                            /// Hide a 'zero' finger
                                            Image(systemName: "circle.fill")
                                                .resizable()
                                                .foregroundStyle(settings.style.theme.foregroundMedium)
                                        default:
                                            Image(systemName: "\(fingers[string]).circle.fill")
                                                .resizable()
                                                .foregroundStyle(
                                                    settings.style.theme.background,
                                                    settings.style.theme.foregroundMedium
                                                )
                                        }
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .symbolRenderingMode(.palette)
                                case false:
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(settings.style.theme.foregroundMedium)
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
    @ViewBuilder var barresGrid: some View {
        if let barres = chord.barres {
            VStack(spacing: 0) {
                ForEach((1...5), id: \.self) { fret in
                    if let barre = barres.first(where: { $0.fret == fret }) {
                        /// Mirror for left-handed if needed
                        let barre = diagramDisplayOptions.mirrorDiagram ? chord.mirrorBarre(barre) : barre
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
                                    .foregroundStyle(settings.style.theme.foregroundMedium)
                                if diagramDisplayOptions.showFingers {
                                    Image(systemName: "\(barre.finger).circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(settings.style.theme.background, .clear)
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
            .frame(width: gridWidth, height: gridHeight)
        }
    }

    // MARK: Notes Bar

    /// The notes `View`
    var notesBar: some View {
        let notes = diagramDisplayOptions.mirrorDiagram ? chord.components.reversed() : chord.components
        return HStack(spacing: 0) {
            ForEach(notes) { note in
                VStack {
                    switch note.note {
                    case .none:
                        Color.clear
                    default:
                        Text("\(note.note.display)")
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
        /// The ``Chord/Instrument`` to use
        let instrument: Chord.Instrument
        func path(in rect: CGRect) -> Path {
            let columns = instrument.strings.count - 1
            let width = rect.width
            let height = rect.height
            let xSpacing = width / Double(columns)
            let ySpacing = height / 5
            let nutHeight = ySpacing / 5
            var path = Path()
            /// Draw the strings
            for index in 0...columns {
                let vOffset: CGFloat = CGFloat(index) * xSpacing
                path.move(to: CGPoint(x: vOffset, y: 0))
                path.addLine(to: CGPoint(x: vOffset, y: height + nutHeight))
            }
            /// Draw the frets
            for index in 0...5 {
                let hOffset: CGFloat = CGFloat(index) * ySpacing + nutHeight
                path.move(to: CGPoint(x: 0, y: hOffset))
                path.addLine(to: CGPoint(x: width, y: hOffset))
            }
            return path
        }
    }
}
