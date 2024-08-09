//
//  ColumnsLayout.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// A `Layout` that arranges its `subviews` in columns
public struct ColumnsLayout: Layout {
    /// The spacing between the columns or `nil` to use the default
    public var columnSpacing: Double?
    /// The spacing between the subviews in the column row or`nil` to use the default
    public var rowSpacing: Double?

    /// Init the `ColumnLayout`
    /// - Parameters:
    ///   - columnSpacing: The spacing between the columns or `nil` to use the default
    ///   - rowSpacing: The spacing between the subviews in the column row or`nil` to use the default
    public init(
        columnSpacing: Double? = nil,
        rowSpacing: Double? = nil
    ) {
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
    }

    /// The layout properties
    public static var layoutProperties: LayoutProperties {
        var properties = LayoutProperties()
        properties.stackOrientation = .vertical
        return properties
    }

    /// A shared computation between `sizeThatFits` and `placeSubviews`.
    public struct Cache {

        /// The minimal size of the view.
        var minSize: CGSize

        /// The cached columns
        var columns: (Int, [Column])?
    }

    /// Make a cache
    /// - Parameter subviews: The subviews
    /// - Returns: The cache
    public func makeCache(subviews: Subviews) -> Cache {
        Cache(minSize: minSize(subviews: subviews))
    }

    /// Update the cache
    /// - Parameters:
    ///   - cache: The cache
    ///   - subviews: The subviews
    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.minSize = minSize(subviews: subviews)
    }

    /// Returns the size of the composite view, given a proposed size and the view’s subviews
    /// - Note: Protocol requirement
    /// - Parameters:
    ///   - proposal: A size proposal for the container
    ///   - subviews: A collection of proxies that represent the views that the container arranges
    ///   - cache: Optional storage for calculated data
    /// - Returns: A size that indicates how much space the container needs to arrange its subviews
    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> CGSize {
        let columns = arrangeColumns(proposal: proposal, subviews: subviews, cache: &cache)

        if columns.isEmpty { return cache.minSize }

        let height = proposal.height ?? columns.map { $0.height }.reduce(.zero) { max($0, $1) }

        var width: Double = .zero
        if let lastColumn = columns.last {
            width = lastColumn.xOffset + lastColumn.width
        }

        return CGSize(width: width, height: height)
    }

    /// Assigns positions to each of the layout’s subviews
    /// - Note: Protocol requirement
    /// - Parameters:
    ///   - bounds: The region that the container view’s parent allocates to the container view,
    ///             specified in the parent’s coordinate space
    ///   - proposal: The size proposal from which the container generated the size that the parent
    ///               used to create the bounds parameter
    ///   - subviews: A collection of proxies that represent the views that the container arranges
    ///   - cache: Optional storage for calculated data
    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        let columns = arrangeColumns(proposal: proposal, subviews: subviews, cache: &cache)

        let anchor = UnitPoint.topLeading

        for column in columns {
            for element in column.elements {
                let xValue: Double = column.xOffset + anchor.x * (column.width - element.size.width)
                let yValue: Double = element.yOffset + anchor.y * (bounds.height - column.height)
                let point = CGPoint(x: xValue + bounds.minX, y: yValue + bounds.minY)

                subviews[element.index].place(at: point, anchor: .topLeading, proposal: proposal)
            }
        }
    }
}

extension ColumnsLayout {

    /// The structure of a column
    struct Column {
        /// The elements
        var elements: [Element] = []
        /// The x-offset
        var xOffset: Double = .zero
        /// The width
        var width: Double = .zero
        /// The height
        var height: Double = .zero
    }

    /// The structure of an element
    struct Element {
        /// The index
        var index: Int
        /// The size
        var size: CGSize
        /// The y-offset
        var yOffset: Double
    }

    /// Arrange columns
    /// - Parameters:
    ///   - proposal: The proposed view size
    ///   - subviews: The subviews
    ///   - cache: The cache
    /// - Returns: Thew columns
    private func arrangeColumns(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) -> [Column] {
        if subviews.isEmpty {
            return []
        }

        if cache.minSize.height > proposal.height ?? .infinity, cache.minSize.width > proposal.width ?? .infinity {
            return []
        }

        let sizes = subviews.map { $0.sizeThatFits(proposal) }

        let hash = computeHash(proposal: proposal, sizes: sizes)
        if let (oldHash, oldRows) = cache.columns, oldHash == hash {
            return oldRows
        }

        var currentY = Double.zero
        var currentColumn = Column()
        var columns = [Column]()

        for index in subviews.indices {
            var spacing = Double.zero
            if let previousIndex = currentColumn.elements.last?.index {
                spacing = rowSpacing(subviews[previousIndex], subviews[index])
            }

            let size = sizes[index]

            if currentY + size.height + spacing > proposal.height ?? .infinity, !currentColumn.elements.isEmpty {
                currentColumn.height = currentY
                columns.append(currentColumn)
                currentColumn = Column()
                spacing = .zero
                currentY = .zero
            }
            let element = Element(index: index, size: sizes[index], yOffset: currentY + spacing)
            currentColumn.elements.append(element)
            currentY += size.height + spacing
        }

        if !currentColumn.elements.isEmpty {
            currentColumn.height = currentY
            columns.append(currentColumn)
        }

        var currentX = Double.zero
        var previousMaxWidthIndex: Int?

        for index in columns.indices {
            let maxWidthIndex = columns[index].elements
                .max { $0.size.width < $1.size.width }?
                .index ?? 0

            let size = sizes[maxWidthIndex]

            var spacing = Double.zero
            if let previousMaxWidthIndex {
                spacing = columnSpacing(subviews[previousMaxWidthIndex], subviews[maxWidthIndex])
            }

            columns[index].xOffset = currentX + spacing
            currentX += size.width + spacing
            columns[index].width = size.width
            previousMaxWidthIndex = maxWidthIndex
        }

        cache.columns = (hash, columns)

        return columns
    }

    /// Compute hash
    /// - Parameters:
    ///   - proposal: The proposed view size
    ///   - sizes: The array of sizes
    /// - Returns: A hash as `Int` value
    private func computeHash(proposal: ProposedViewSize, sizes: [CGSize]) -> Int {
        let proposal = proposal.replacingUnspecifiedDimensions(
            by: CGSize(
                width: Double.infinity,
                height: Double.infinity
            )
        )

        var hasher = Hasher()

        for size in [proposal] + sizes {
            hasher.combine(size.height)
            hasher.combine(size.width)
        }

        return hasher.finalize()
    }

    /// Calculate the minimum size
    /// - Parameter subviews: The subviews
    /// - Returns: The size
    private func minSize(subviews: Subviews) -> CGSize {
        subviews
            .map { $0.sizeThatFits(.zero) }
            .reduce(CGSize.zero) { CGSize(width: max($0.width, $1.width), height: max($0.height, $1.height)) }
    }

    /// Calculate the column spacing
    /// - Parameters:
    ///   - lhs: The left layout subview
    ///   - rhs: The right layout subview
    /// - Returns: The spacing as `Double`
    private func columnSpacing(_ lhs: LayoutSubview, _ rhs: LayoutSubview) -> Double {
        if let columnSpacing {
            return columnSpacing
        }
        return lhs.spacing.distance(to: rhs.spacing, along: .horizontal)
    }

    /// Calculate the row spacing
    /// - Parameters:
    ///   - lhs: The left layout subview
    ///   - rhs: The right layout subview
    /// - Returns: The spacing as `Double`
    private func rowSpacing(_ lhs: LayoutSubview, _ rhs: LayoutSubview) -> Double {
        if let rowSpacing {
            return rowSpacing
        }
        return lhs.spacing.distance(to: rhs.spacing, along: .vertical)
    }
}
