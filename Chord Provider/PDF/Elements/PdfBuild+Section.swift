//
//  PdfBuild+Section.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild {

    public enum SectionColumnWidth {
        case flexible
        case relative(width: CGFloat)
        case fixed(width: CGFloat)
    }

    /// A PDF section item
    open class Section: PdfElement {

        let columns: [SectionColumnWidth]
        let items: [PdfElement]

        public init(
            columns: [SectionColumnWidth],
            items: [PdfElement]
        ) {
            self.columns = columns
            self.items = items
        }

        open override func draw(rect: inout CGRect) {
            PdfBuild.log("columns: \(columns.count)")

            let columnWidth = calculateColumnsWidth(rect: rect)

            let rowsCount = Int(ceil( Float(items.count) / Float(columns.count)))

            var rowOffsetY: CGFloat = 0

            for index in 0..<rowsCount {
                let row = items[(index * columns.count)..<min(items.count, (index * columns.count + columns.count))]
                let rowHeight: CGFloat = height(
                    row: [PdfElement](row),
                    columnWidth: columnWidth
                )
                var cellOffset: CGFloat = 0
                for (index, cell) in row.enumerated() {

                    var cellRect = CGRect(
                        x: rect.minX + cellOffset,
                        y: rect.minY + rowOffsetY,
                        width: columnWidth[index],
                        height: rowHeight)

                    cellOffset += columnWidth[index]
                    cell.draw(rect: &cellRect)
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
            var result = [CGFloat]()

            for column in columns {
                switch column {

                case .flexible:
                    result.append( (rect.width - fixedWidth) / flexibleCount )
                case .relative(let width):
                    result.append(rect.width * width)
                case .fixed(let width):
                    result.append(width)
                }
            }

            return result
        }

        /// Height of the row is the max height of the elements. We make rect for the cell in advance bigger then the content and measure how height was reduced by drawing it.
        private func height(row: [PdfElement], columnWidth: [CGFloat]) -> CGFloat {
            var rowHeight: CGFloat = 5
            let maxHeight: Double = 10_000
            for (index, cell) in row.enumerated() {
                var cellRect = CGRect(
                    x: 0,
                    y: 0,
                    width: columnWidth[index],
                    height: maxHeight
                )
                _ = PdfBuild.drawImage(size: cellRect.size) {
                    cell.draw(rect: &cellRect)
                }
                let tempHeight = maxHeight - cellRect.height
                if tempHeight > rowHeight {
                    rowHeight = tempHeight
                }
            }
            return rowHeight
        }
    }
}
