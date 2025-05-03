//
//  PDFBuild+Chords+Diagram.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension PDFBuild.Chords {

    // MARK: A PDF **chord diagram** element

    /// A PDF **chord diagram** element
    ///
    /// Display a single chord diagram
    class Diagram: PDFElement {

        // MARK: Variables

        /// The chord to display in a diagram
        let chord: ChordDefinition
        /// The application settings
        let settings: AppSettings

        // MARK: Calculated constants

        /// Total amount of columns of the diagram
        let columns: Int
        /// The width of the grid
        let width: CGFloat
        /// The height of the grid
        let height: CGFloat
        /// The horizontal spacing between each grid cell
        let xSpacing: CGFloat
        /// The vertical spacing between each grid cell
        let ySpacing: CGFloat
        /// The frets of the chord; adjusted for left-handed if needed
        let frets: [Int]
        /// The fingers of the chord; adjusted for left-handed if needed
        let fingers: [Int]
        /// The size of the grid
        let gridSize: CGSize
        /// The height of the nut
        let nutHeight: Double

        // MARK: Frets and bars

        /// The radius of the fret circle
        let circleRadius: Double
        /// Below should be 0 for a six string instrument
        let xOffset: Double
        /// The colors for the fingers
        let fretColors: [NSColor]

        /// Init the **chord diagram** element
        /// - Parameters:
        ///   - chord: The chord to display in a diagram
        ///   - settings: The PDF settings
        init(chord: ChordDefinition, settings: AppSettings) {
            self.gridSize = CGSize(width: settings.pdf.diagramWidth / 1.2, height: settings.pdf.diagramWidth)
            self.chord = chord
            self.columns = (chord.instrument.strings.count) - 1
            self.width = gridSize.width
            self.height = gridSize.height
            self.xSpacing = width / Double(columns)
            self.ySpacing = height / 5
            self.frets = settings.diagram.mirrorDiagram ? chord.frets.reversed() : chord.frets
            self.fingers = settings.diagram.mirrorDiagram ? chord.fingers.reversed() : chord.fingers

            self.circleRadius = gridSize.width / 5.5
            self.xOffset = (xSpacing - circleRadius) / 2
            self.fretColors = [settings.style.theme.background.nsColor, settings.style.theme.foregroundMedium.nsColor]

            self.nutHeight = ySpacing / 5
            self.settings = settings
        }

        /// Draw the **chords** element as a `Section` element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        // swiftlint:disable:next function_body_length
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let initialRect = rect
            var currentDiagramHeight: CGFloat = 0
            drawChordName(rect: &rect)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            drawTopBar(rect: &rect)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            drawNut(rect: &rect, calculationOnly: calculationOnly)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            if chord.baseFret != 1 {
                drawBaseFret(rect: &rect)
            }
            drawGrid(rect: &rect, calculationOnly: calculationOnly)
            /// No need to draw dots and barres when we are calculating the size
            if !calculationOnly {
                drawFrets(rect: &rect)
                drawBarres(rect: &rect)
            }
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            if settings.diagram.showNotes {
                drawNotesBar(rect: &rect)
                rect.origin.y = initialRect.origin.y + currentDiagramHeight
                rect.size.height = initialRect.size.height - currentDiagramHeight
            }
            /// Add some padding at the bottom
            currentDiagramHeight += ySpacing * 0.5
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            rect.origin.x += gridSize.width + 3 * xSpacing
            rect.size.width -= gridSize.width + 3 * xSpacing

            // MARK: Chord Name

            /// Draw the name of the chord
            /// - Parameter rect: The available rect
            func drawChordName(rect: inout CGRect) {
                var nameRect = CGRect(
                    x: rect.origin.x,
                    y: rect.origin.y,
                    width: gridSize.width + 3 * xSpacing,
                    height: rect.height
                )
                let chord = chord.display
                let name = PDFBuild.Text(chord, attributes: .diagramChordName(settings: settings))
                name.draw(rect: &nameRect, calculationOnly: calculationOnly, pageRect: pageRect)
                /// Add this item to the total height
                currentDiagramHeight += (nameRect.origin.y - rect.origin.y)
            }

            // MARK: Top Bar

            /// Draw the top bar of the chord
            /// - Parameter rect: The available rect
            func drawTopBar(rect: inout CGRect) {
                let size = circleRadius * 0.6
                if !calculationOnly {
                    var topBarRect = CGRect(
                        x: rect.origin.x + xSpacing + ((xSpacing - size) / 2),
                        y: rect.origin.y,
                        width: size,
                        height: size
                    )
                    for index in chord.frets.indices {
                        var string: String?
                        let fret = frets[index]
                        switch fret {
                        case -1:
                            string = "xmark"
                        case 0:
                            string = "circle"
                        default:
                            break
                        }
                        if let string {
                            let symbol = PDFBuild.Image(string, fontSize: size, colors: [settings.style.theme.foregroundMedium.nsColor])
                            symbol.image.draw(in: topBarRect)
                        }
                        topBarRect.origin.x += xSpacing
                    }
                }
                /// Add this item to the total height
                currentDiagramHeight += size * 1.1
            }

            // MARK: Nut

            /// Draw the nut of the chord
            /// - Parameters:
            ///   - rect: The available rect
            ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
            func drawNut(rect: inout CGRect, calculationOnly: Bool) {
                if !calculationOnly {
                    let nutRect = CGRect(
                        x: rect.origin.x + xSpacing * 1.25,
                        y: rect.origin.y,
                        width: gridSize.width + xSpacing * 0.55,
                        height: nutHeight
                    )
                    if chord.baseFret == 1, let context = NSGraphicsContext.current?.cgContext {
                        context.setFillColor(settings.style.theme.foreground.nsColor.cgColor)
                        context.fill(nutRect)
                    }
                }
                /// Add this item to the total height
                currentDiagramHeight += nutHeight
            }

            // MARK: Base Fret

            /// Draw the base fret of the chord
            /// - Parameter rect: The available rect
            func drawBaseFret(rect: inout CGRect) {
                if !calculationOnly {
                    let baseFretRect = CGRect(
                        x: rect.origin.x + xOffset + (xSpacing * 0.2),
                        y: rect.origin.y + ((ySpacing - circleRadius) / 2),
                        width: circleRadius,
                        height: circleRadius
                    )
                    let colors = [settings.style.theme.foreground.nsColor, settings.style.theme.background.nsColor]
                    let symbol = PDFBuild.Image("\(chord.baseFret).circle.fill", fontSize: circleRadius, colors: colors)
                    symbol.image.draw(in: baseFretRect)
                }
            }

            // MARK: Grid

            /// Draw the grid of the chords
            /// - Parameters:
            ///   - rect: The available rect
            ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
            func drawGrid(rect: inout CGRect, calculationOnly: Bool) {
                if !calculationOnly {
                    let gridPoint = CGPoint(
                        x: rect.origin.x + (xSpacing * 1.5),
                        y: rect.origin.y - nutHeight
                    )
                    var start = gridPoint
                    if let context = NSGraphicsContext.current?.cgContext {
                        /// Draw the strings
                        for _ in 0...columns {
                            context.move(to: start)
                            context.addLine(to: CGPoint(x: start.x, y: start.y + gridSize.height + nutHeight))
                            start.x += xSpacing
                        }
                        /// Move start back to the gridpoint
                        start = gridPoint
                        start.y += nutHeight
                        /// Draw the frets
                        for _ in 0...5 {
                            context.move(to: start)
                            context.addLine(to: CGPoint(x: start.x + gridSize.width, y: start.y))
                            start.y += ySpacing
                        }
                        context.setStrokeColor(settings.style.theme.foreground.nsColor.cgColor)
                        context.setLineWidth(0.2)
                        context.setLineCap(.round)
                        context.strokePath()
                    }
                }
                /// Add this item to the total height
                currentDiagramHeight += gridSize.height
            }

            // MARK: Frets

            /// Draw the frets in the grid
            /// - Parameters:
            ///   - rect: The available rect
            func drawFrets(rect: inout CGRect) {
                /// Set the rect for the grid
                var dotRect = CGRect(
                    x: rect.origin.x + xSpacing + xOffset,
                    y: rect.origin.y + ((ySpacing - circleRadius) / 2),
                    width: circleRadius,
                    height: circleRadius
                )
                for fret in 1...5 {
                    for string in chord.instrument.strings {
                        if frets[string] == fret {
                            let spacer = PDFBuild.Spacer(circleRadius)
                            let background = PDFBuild.Background(color: settings.style.theme.foregroundMedium.nsColor, spacer)
                            let shape = PDFBuild.Clip(.circle, background)
                            var tmpRect = dotRect
                            shape.draw(rect: &tmpRect, calculationOnly: calculationOnly, pageRect: pageRect)
                            /// Draw the optional finger
                            if settings.diagram.showFingers && fingers[string] != 0 {
                                let symbol = PDFBuild.Image("\(fingers[string]).circle.fill", fontSize: circleRadius, colors: fretColors)
                                symbol.image.draw(in: dotRect)
                            }
                        }
                        /// Move X one string to the right
                        dotRect.origin.x += xSpacing
                    }
                    /// Move X back to the left
                    dotRect.origin.x = rect.origin.x + xSpacing + xOffset
                    /// Move Y one fret down
                    dotRect.origin.y += ySpacing
                }
            }

            // MARK: Barres

            /// Draw the barres in the grid
            /// - Parameter rect: The available rect
            func drawBarres(rect: inout CGRect) {
                /// Set the rect for the grid
                var barresRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y + ((ySpacing - circleRadius) / 2),
                    width: circleRadius,
                    height: circleRadius
                )
                for fret in 1...5 {
                    if var barre = chord.barres.first(where: { $0.fret == fret }) {
                        /// Mirror for left-handed if needed
                        barre = settings.diagram.mirrorDiagram ? chord.mirrorBarre(barre) : barre
                        let spacer = PDFBuild.Spacer(circleRadius)
                        let background = PDFBuild.Background(color: settings.style.theme.foregroundMedium.nsColor, spacer)
                        let shape = PDFBuild.Clip(.roundedRect(radius: circleRadius / 2), background)
                        var tmpRect = CGRect(
                            x: barresRect.origin.x + (CGFloat(barre.startIndex) * xSpacing) + xOffset,
                            y: barresRect.origin.y,
                            width: (CGFloat(barre.length) * xSpacing) - (2 * xOffset),
                            height: circleRadius
                        )
                        /// Preserve the rect for the optional finger
                        var symbolRect = tmpRect
                        /// Draw the bar
                        shape.draw(rect: &tmpRect, calculationOnly: calculationOnly, pageRect: pageRect)
                        /// Draw the optional finger
                        if settings.diagram.showFingers && barre.finger != 0 {
                            let symbol = PDFBuild.Image("\(barre.finger).circle.fill", fontSize: circleRadius, colors: fretColors)
                            /// Center the finger in the rect
                            symbolRect.size.width = circleRadius
                            symbolRect.origin.x += (tmpRect.width - circleRadius) / 2
                            symbol.image.draw(in: symbolRect)
                        }
                    }
                    /// Move Y one fret down
                    barresRect.origin.y += ySpacing
                }
            }

            // MARK: Notes Bar

            /// Draw the notes bar underneath the grid
            /// - Parameter rect: The available rect
            func drawNotesBar(rect: inout CGRect) {
                let notes = settings.diagram.mirrorDiagram ? chord.components.reversed() : chord.components
                var fontSize: Double {
                    settings.pdf.diagramWidth / 14
                }
                var notesBarRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y + (fontSize * 0.2),
                    width: xSpacing,
                    height: ySpacing
                )
                for note in notes {
                    switch note.note {
                    case .none:
                        break
                    default:
                        let string = NSAttributedString(string: "\(note.note.display)", attributes: .diagramBottomBar(settings: settings, fontSize: fontSize))
                        if !calculationOnly {
                            string.draw(in: notesBarRect)
                        }
                    }
                    notesBarRect.origin.x += xSpacing
                }
                /// Add this item to the total height
                currentDiagramHeight += fontSize * 1.2
            }
        }
    }
}

extension PDFStringAttribute {

    /// Style attributes for the diagram chord name
    static func diagramChordName(settings: AppSettings) -> PDFStringAttribute {
        /// Calculate the font size; it should never be bigger than the default chord size
        let defaultSize = settings.style.fonts.chord.size
        let diagramSize = settings.pdf.diagramWidth / 6
        let fontSize = diagramSize < defaultSize ? diagramSize : defaultSize
        return [
            .font: NSFont(name: settings.style.fonts.text.font.postScriptName, size: fontSize) ?? NSFont.systemFont(ofSize: fontSize),
            .foregroundColor: settings.style.fonts.chord.color.nsColor
        ] + .alignment(.center)
    }

    /// Style attributes for the diagram bottom bar
    static func diagramBottomBar(settings: AppSettings, fontSize: Double) -> PDFStringAttribute {
        [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: settings.style.theme.foreground.nsColor
        ] + .alignment(.center)
    }
}
