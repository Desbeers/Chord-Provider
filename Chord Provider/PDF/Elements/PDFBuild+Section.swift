//
//  PDFBuild+Section.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// Width definition options that can be used with a `Section`
    public enum SectionColumnWidth {
        /// A flexable width
        case flexible
        /// A relative width between 0 and 1
        case relative(fraction: CGFloat)
        /// A fixed width
        case fixed(width: CGFloat)
    }

    /// A PDF **section** element
    class Section: PDFElement {

        /// The columns of the section
        let columns: [SectionColumnWidth]
        /// The ``PDFElement`` array that will be drawn into the columns
        let items: [PDFElement]

        /// Init the **section** element
        /// - Parameters:
        ///   - columns: The columns of the section
        ///   - items: The ``PDFElement`` array that will be drawn into the columns
        init(columns: [SectionColumnWidth], items: [PDFElement] ) {
            self.columns = columns
            self.items = items
        }

        /// Draw the **page background color** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            /// Calculate the width of the columns
            let columnsWidth = calculateColumnsWidth(rect: rect)
            /// Calculate the total rows
            let rowsCount = Int(ceil( Float(items.count) / Float(columns.count)))
            var rowOffsetY: CGFloat = 0
            for index in 0..<rowsCount {
                let row = items[(index * columns.count)..<min(items.count, (index * columns.count + columns.count))]
                let rowHeight: CGFloat = calculateSectionHeight(
                    rowElements: [PDFElement](row),
                    columnsWidth: columnsWidth
                )
                var cellOffset: CGFloat = 0
                for (index, cell) in row.enumerated() {
                    var cellRect = CGRect(
                        x: rect.minX + cellOffset,
                        y: rect.minY + rowOffsetY,
                        width: columnsWidth[index],
                        height: rowHeight
                    )
                    cellOffset += columnsWidth[index]
                    cell.draw(rect: &cellRect, calculationOnly: calculationOnly)
                }
                rowOffsetY += rowHeight
            }
            let height: CGFloat = rowOffsetY
            rect.origin.y += height
            if height > rect.size.height {
                rect.size.height = 0
            } else {
                rect.size.height -= height
            }
        }

        // MARK: Private functions

        /// Calculate the width of the columns
        /// - Parameter rect: The available rectangle
        /// - Returns: An `CGFloat` array with the width for each column
        private func calculateColumnsWidth(rect: CGRect) -> [CGFloat] {
            var fixedWidth: CGFloat = 0
            var flexibleCount: CGFloat = 0
            for column in columns {
                switch column {
                case .flexible:
                    flexibleCount += 1
                case .relative(let width):
                    fixedWidth += rect.width * width
                case .fixed(let width):
                    fixedWidth += width
                }
            }
            var result: [CGFloat] = []
            for column in columns {
                switch column {
                case .flexible:
                    result.append( (rect.width - fixedWidth) / flexibleCount)
                case .relative(let width):
                    result.append(rect.width * width)
                case .fixed(let width):
                    result.append(width)
                }
            }
            return result
        }

        /// Calculate the height of the section
        /// - Parameters:
        ///   - rowElements: The ``PDFElement`` array in a row
        ///   - columnWidth: The width of the column
        /// - Returns: A `CGFloat` with the calculated height of the section
        private func calculateSectionHeight(rowElements: [PDFElement], columnsWidth: [CGFloat]) -> CGFloat {
            var rowHeight: CGFloat = 5
            let maxHeight: Double = 10_000
            for (index, cell) in rowElements.enumerated() {
                var cellRect = CGRect(
                    x: 0,
                    y: 0,
                    width: columnsWidth[index],
                    height: maxHeight
                )
                cell.draw(rect: &cellRect, calculationOnly: true)
                let tempHeight = maxHeight - cellRect.height
                if tempHeight > rowHeight {
                    rowHeight = tempHeight
                }
            }
            return rowHeight
        }
    }
}
