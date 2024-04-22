//
//  PdfBuild+Chords+Diagram.swift
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

extension PdfBuild.Chords {

    /// A PDF chord diagram item
    open class Diagram: PdfElement {

        let chord: ChordDefinition

        let options: ChordDefinition.DisplayOptions

        let columns: Int
        let width: CGFloat
        let height: CGFloat
        let xSpacing: CGFloat
        let ySpacing: CGFloat

        let frets: [Int]
        let fingers: [Int]

        var chordNameHeight: CGFloat = 0

        init(chord: ChordDefinition, options: ChordDefinition.DisplayOptions) {
            self.chord = chord
            self.options = options

            self.columns = (chord.instrument.strings.count) - 1
            self.width = chordSize.width
            self.height = chordSize.height
            self.xSpacing = width / Double(columns)
            self.ySpacing = height / 5

            self.frets = options.mirrorDiagram ? chord.frets.reversed() : chord.frets
            self.fingers = options.mirrorDiagram ? chord.fingers.reversed() : chord.fingers
        }

        let chordSize = CGSize(width: 50, height: 60)


        /// Draw the Chord Diagram
        /// - Parameter rect: The location and dimensions for the drawing
        // swiftlint:disable:next function_body_length
        open override func draw(rect: inout CGRect) {

            let initialRect = rect

            var currentDiagramHeight: CGFloat = 0

            drawChordName(rect: &rect)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            drawTopBar(rect: &rect)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            drawNut(rect: &rect)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            if chord.baseFret != 1 {
                drawBaseFret(rect: &rect)
            }
            drawGrid(rect: &rect)
            drawDots(rect: &rect)
            drawBarres(rect: &rect)
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            if options.showNotes {
                drawNotesBar(rect: &rect)
                rect.origin.y = initialRect.origin.y + currentDiagramHeight
                rect.size.height = initialRect.size.height - currentDiagramHeight
            }
            rect.origin.y = initialRect.origin.y + currentDiagramHeight
            rect.size.height = initialRect.size.height - currentDiagramHeight
            rect.origin.x += chordSize.width + 3 * xSpacing
            rect.size.width -= chordSize.width + 3 * xSpacing

            // MARK: Chord Name

            func drawChordName(rect: inout CGRect) {
                var nameRect = CGRect(
                    x: rect.origin.x,
                    y: rect.origin.y,
                    width: chordSize.width + 3 * xSpacing,
                    height: rect.height
                )
                let chord = chord.displayName(options: .init(rootDisplay: .symbol, qualityDisplay: .symbolized))
                let name = PdfBuild.Text(chord, attributes: .diagramChordName + .alignment(.center))
                name.draw(rect: &nameRect)
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
                    let symbol = PdfBuild.Text(string, attributes: .diagramTopBar)
                    var tmpRect = topBarRect
                    symbol.draw(rect: &tmpRect)
                    height = tmpRect.origin.y - rect.origin.y
                    topBarRect.origin.x += xSpacing
                }
                /// Add this item to the total height
                currentDiagramHeight += height
            }

            // MARK: Nut

            func drawNut(rect: inout CGRect) {
                let nutRect = CGRect(
                    x: rect.origin.x + xSpacing * 1.25,
                    y: rect.origin.y,
                    width: chordSize.width + xSpacing * 0.55,
                    height: ySpacing / 5
                )
                if chord.baseFret == 1, let context = UIGraphicsGetCurrentContext() {
                    context.setFillColor(SWIFTColor.black.cgColor)
                    context.fill(nutRect)
                }
                /// Add this item to the total height
                currentDiagramHeight += ySpacing / 5
            }

            // MARK: Base Fret

            func drawBaseFret(rect: inout CGRect) {
                var baseFretRect = CGRect(
                    x: rect.origin.x + xSpacing / 2.5,
                    y: rect.origin.y + ySpacing / 8,
                    width: chordSize.width,
                    height: rect.height
                )
                let name = PdfBuild.Text("\(chord.baseFret)", attributes: .diagramBaseFret + .alignment(.left))
                name.draw(rect: &baseFretRect)
            }

            // MARK: Grid

            func drawGrid(rect: inout CGRect) {
                let gridPoint = CGPoint(
                    x: rect.origin.x + (xSpacing * 1.5),
                    y: rect.origin.y
                )

                var start = gridPoint

                if let context = UIGraphicsGetCurrentContext() {

                    // MARK: Strings
                    for _ in 0...columns {
                        context.move(to: start)
                        context.addLine(to: CGPoint(x: start.x, y: start.y + chordSize.height))
                        start.x += xSpacing
                    }
                    /// Move start back to the gridpoint
                    start = gridPoint

                    // MARK: Frets
                    for _ in 0...5 {
                        context.move(to: start)
                        context.addLine(to: CGPoint(x: start.x + chordSize.width, y: start.y))
                        start.y += ySpacing
                    }
                    context.setStrokeColor(SWIFTColor.black.cgColor)
                    context.setLineWidth(0.2)
                    context.setLineCap(.round)
                    context.strokePath()
                    /// Add this item to the total height
                    currentDiagramHeight += chordSize.height
                }
            }

            // MARK: Dots

            func drawDots(rect: inout CGRect) {

                var dotRect = CGRect(
                    x: rect.origin.x + xSpacing,
                    y: rect.origin.y,
                    width: xSpacing,
                    height: ySpacing
                )
                for row in 1...5 {
                    for column in chord.instrument.strings {
                        if frets[column] == row && !chord.barres.contains(fingers[column]) {
                            let finger = options.showFingers ? "\(fingers[column])" : " "
                            let text = PdfBuild.Text(finger, attributes: .diagramFinger)
                            let background = PdfBuild.Background(color: .gray, text)
                            let shape = PdfBuild.ClipShape(.circle, background)
                            var tmpRect = dotRect
                            shape.draw(rect: &tmpRect)
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
                for row in 1...5 {
                    if let barre = checkBarre(barre: row) {
                        let finger = options.showFingers ? "\(barre.finger)" : " "
                        let text = PdfBuild.Text(finger, attributes: .diagramFinger)
                        let background = PdfBuild.Background(color: .gray, text)
                        let shape = PdfBuild.ClipShape(.roundedRect(radius: xSpacing / 2), background)
                        var tmpRect = CGRect(
                            x: barresRect.origin.x + (CGFloat(barre.startIndex) * xSpacing),
                            y: barresRect.origin.y,
                            width: CGFloat(barre.length) * xSpacing,
                            height: ySpacing
                        )
                        shape.draw(rect: &tmpRect)
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
                        let note = PdfBuild.Text(string, attributes: .diagramBottomBar)
                        var tmpRect = notesBarRect
                        note.draw(rect: &tmpRect)
                        height = tmpRect.origin.y - rect.origin.y
                    }
                    notesBarRect.origin.x += xSpacing
                }
                /// Add this item to the total height
                currentDiagramHeight += height
            }
        }


        // MARK: Helper functions

        // swiftlint:disable:next large_tuple
        func checkBarre(barre: Int) -> (finger: Int, startIndex: Int, length: Int)? {
            var isBarre: Bool = false
            var finger: Int = 0
            for column in chord.frets.indices {
                if chord.frets[column] == barre && chord.barres.contains(chord.fingers[column]) {
                    isBarre = true
                    finger = chord.fingers[column]
                }
            }
            switch isBarre {
            case true:
                let bar = calculateBar(barre: barre, finger: finger)
                return (finger, bar.startIndex, bar.length)
            case false:
                return nil
            }
        }

        private func calculateBar(barre: Int, finger: Int) -> (startIndex: Int, length: Int) {
            /// Draw barre behind all frets that are above the barre chord
            var startIndex = (frets.firstIndex { $0 == barre } ?? 0)
            let barreFretCount = frets.filter { $0 == barre }.count
            var length = 0

            for index in startIndex..<frets.count {
                let dot = frets[index]
                if dot >= barre {
                    length += 1
                } else if dot < barre && length < barreFretCount {
                    length = 0
                    startIndex = index + 1
                } else {
                    break
                }
            }
            return (startIndex, length)
        }
    }
}

// MARK: Diagram string styling

public extension StringAttributes {

    static var diagramChordName: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    static var diagamDot: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ]
    }
    static var diagramFinger: StringAttributes {
        [
            .foregroundColor: SWIFTColor.white,
            .font: SWIFTFont.systemFont(ofSize: 6, weight: .regular)
        ] + .alignment(.center)
    }
    static var diagramTopBar: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 4, weight: .regular)
        ] + .alignment(.center)
    }

    static var diagramBaseFret: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 4, weight: .regular)
        ] + .alignment(.left)
    }

    static var diagramBottomBar: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 4, weight: .regular)
        ] + .alignment(.center)
    }
}
