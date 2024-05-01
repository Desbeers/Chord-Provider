//
//  PDFBuild+Chords+Diagram.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import SwiftlyChordUtilities

extension PDFBuild.Chords {

    /// A PDF **chord diagram** element
    /// 
    /// Display a single chord diagram
    class Diagram: PDFElement {

        // MARK: Variables

        /// The chord to display in a diagram
        let chord: ChordDefinition
        /// The chord display options
        let options: ChordDefinition.DisplayOptions

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

        // MARK: Fixed constants

        /// The size of the grid
        let gridSize = CGSize(width: 50, height: 60)

        /// Init the **chord diagram** element
        /// - Parameters:
        ///   - chord: The chord to display in a diagram
        ///   - options: The chord display options
        init(chord: ChordDefinition, options: ChordDefinition.DisplayOptions) {
            self.chord = chord
            self.options = options
            self.columns = (chord.instrument.strings.count) - 1
            self.width = gridSize.width
            self.height = gridSize.height
            self.xSpacing = width / Double(columns)
            self.ySpacing = height / 5
            self.frets = options.mirrorDiagram ? chord.frets.reversed() : chord.frets
            self.fingers = options.mirrorDiagram ? chord.fingers.reversed() : chord.fingers
        }

        /// Draw the **chords** element as a `Section` element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        // swiftlint:disable:next function_body_length
        func draw(rect: inout CGRect, calculationOnly: Bool) {
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
            if options.showNotes {
                drawNotesBar(rect: &rect)
                rect.origin.y = initialRect.origin.y + currentDiagramHeight
                rect.size.height = initialRect.size.height - currentDiagramHeight
            }
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            rect.origin.x += gridSize.width + 3 * xSpacing
            rect.size.width -= gridSize.width + 3 * xSpacing

            // MARK: Chord Name

            func drawChordName(rect: inout CGRect) {
                var nameRect = CGRect(
                    x: rect.origin.x,
                    y: rect.origin.y,
                    width: gridSize.width + 3 * xSpacing,
                    height: rect.height
                )
                let chord = chord.displayName(options: .init(rootDisplay: .symbol, qualityDisplay: .symbolized))
                let name = PDFBuild.Text(chord, attributes: .diagramChordName + .alignment(.center))
                name.draw(rect: &nameRect, calculationOnly: calculationOnly)
                /// Add this item to the total height
                currentDiagramHeight += (nameRect.origin.y - rect.origin.y) * 0.8
            }

            // MARK: Top Bar

            func drawTopBar(rect: inout CGRect) {
                var topBarRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y,
                    width: xSpacing,
                    height: ySpacing
                )
                var string = ""
                var height: CGFloat = 0
                for index in chord.frets.indices {
                    let fret = frets[index]
                    switch fret {
                    case -1:
                        string = "􀆄"
                    case 0:
                        string = "􀀀"
                    default:
                        string = " "
                    }
                    let symbol = PDFBuild.Text(string, attributes: .diagramTopBar)
                    var tmpRect = topBarRect
                    symbol.draw(rect: &tmpRect, calculationOnly: calculationOnly)
                    height = tmpRect.origin.y - rect.origin.y
                    topBarRect.origin.x += xSpacing
                }
                /// Add this item to the total height
                currentDiagramHeight += height
            }

            // MARK: Nut

            func drawNut(rect: inout CGRect, calculationOnly: Bool) {
                if !calculationOnly {
                    let nutRect = CGRect(
                        x: rect.origin.x + xSpacing * 1.25,
                        y: rect.origin.y,
                        width: gridSize.width + xSpacing * 0.55,
                        height: ySpacing / 5
                    )
                    if chord.baseFret == 1, let context = UIGraphicsGetCurrentContext() {
                        context.setFillColor(SWIFTColor.black.cgColor)
                        context.fill(nutRect)
                    }
                }
                /// Add this item to the total height
                currentDiagramHeight += ySpacing / 5
            }

            // MARK: Base Fret

            func drawBaseFret(rect: inout CGRect) {
                var baseFretRect = CGRect(
                    x: rect.origin.x + xSpacing / 2.5,
                    y: rect.origin.y + ySpacing / 8,
                    width: gridSize.width,
                    height: rect.height
                )
                let name = PDFBuild.Text("\(chord.baseFret)", attributes: .diagramBaseFret + .alignment(.left))
                name.draw(rect: &baseFretRect, calculationOnly: calculationOnly)
            }

            // MARK: Grid

            func drawGrid(rect: inout CGRect, calculationOnly: Bool) {
                if !calculationOnly {
                    let gridPoint = CGPoint(
                        x: rect.origin.x + (xSpacing * 1.5),
                        y: rect.origin.y
                    )
                    var start = gridPoint
                    if let context = UIGraphicsGetCurrentContext() {
                        /// Draw the strings
                        for _ in 0...columns {
                            context.move(to: start)
                            context.addLine(to: CGPoint(x: start.x, y: start.y + gridSize.height))
                            start.x += xSpacing
                        }
                        /// Move start back to the gridpoint
                        start = gridPoint
                        /// Draw the frets
                        for _ in 0...5 {
                            context.move(to: start)
                            context.addLine(to: CGPoint(x: start.x + gridSize.width, y: start.y))
                            start.y += ySpacing
                        }
                        context.setStrokeColor(SWIFTColor.black.cgColor)
                        context.setLineWidth(0.2)
                        context.setLineCap(.round)
                        context.strokePath()
                    }
                }
                /// Add this item to the total height
                currentDiagramHeight += gridSize.height
            }

            // MARK: Frets

            func drawFrets(rect: inout CGRect) {
                var dotRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y,
                    width: xSpacing,
                    height: ySpacing
                )
                for fret in 1...5 {
                    for string in chord.instrument.strings {
                        if frets[string] == fret && !chord.barres.map(\.fret).contains(fret) {
                            let finger = options.showFingers && fingers[string] != 0 ? "\(fingers[string])" : " "
                            let text = PDFBuild.Text(finger, attributes: .diagramFinger)
                            let background = PDFBuild.Background(color: .gray, text)
                            let shape = PDFBuild.Clip(.circle, background)
                            var tmpRect = dotRect
                            shape.draw(rect: &tmpRect, calculationOnly: calculationOnly)
                        }
                        /// Move X one string to the right
                        dotRect.origin.x += xSpacing
                    }
                    /// Move X back to the left
                    dotRect.origin.x = rect.origin.x + xSpacing
                    /// Move Y one fret down
                    dotRect.origin.y += ySpacing
                }
            }

            // MARK: Barres

            func drawBarres(rect: inout CGRect) {
                var barresRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y,
                    width: xSpacing,
                    height: ySpacing
                )
                for fret in 1...5 {
                    if var barre = chord.barres.first(where: { $0.fret == fret }) {
                        /// Mirror for left-handed if needed
                        barre = options.mirrorDiagram ? chord.mirrorBarre(barre) : barre
                        let finger = options.showFingers ? "\(barre.finger)" : " "
                        let text = PDFBuild.Text(finger, attributes: .diagramFinger)
                        let background = PDFBuild.Background(color: .gray, text)
                        let shape = PDFBuild.Clip(.roundedRect(radius: xSpacing / 2), background)
                        var tmpRect = CGRect(
                            x: barresRect.origin.x + (CGFloat(barre.startIndex) * xSpacing),
                            y: barresRect.origin.y,
                            width: CGFloat(barre.length) * xSpacing,
                            height: ySpacing
                        )
                        shape.draw(rect: &tmpRect, calculationOnly: calculationOnly)
                    }
                    /// Move Y one fret down
                    barresRect.origin.y += ySpacing
                }
            }

            // MARK: Notes Bar

            func drawNotesBar(rect: inout CGRect) {
                let notes = options.mirrorDiagram ? chord.components.reversed() : chord.components
                var notesBarRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y,
                    width: xSpacing,
                    height: ySpacing
                )
                var height: CGFloat = 0
                for note in notes {
                    switch note.note {
                    case .none:
                        break
                    default:
                        let string = ("\(note.note.display.symbol)")
                        let note = PDFBuild.Text(string, attributes: .diagramBottomBar)
                        var tmpRect = notesBarRect
                        note.draw(rect: &tmpRect, calculationOnly: calculationOnly)
                        height = tmpRect.origin.y - rect.origin.y
                    }
                    notesBarRect.origin.x += xSpacing
                }
                /// Add this item to the total height
                currentDiagramHeight += height
            }
        }
    }
}

// MARK: Diagram string styling

public extension StringAttributes {

    /// Style atributes for the diagram chord name
    static var diagramChordName: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    /// Style atributes for the diagram finger
    static var diagramFinger: StringAttributes {
        [
            .foregroundColor: SWIFTColor.white,
            .font: SWIFTFont.systemFont(ofSize: 6, weight: .regular)
        ] + .alignment(.center)
    }

    /// Style atributes for the diagram top bar
    static var diagramTopBar: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 4, weight: .regular)
        ] + .alignment(.center)
    }

    /// Style atributes for the diagram base fret
    static var diagramBaseFret: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 4, weight: .regular)
        ] + .alignment(.left)
    }

    /// Style atributes for the diagram top bar
    static var diagramBottomBar: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 4, weight: .regular)
        ] + .alignment(.center)
    }
}
