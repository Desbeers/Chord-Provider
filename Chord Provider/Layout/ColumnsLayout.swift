//
//  ColumnsLayout.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// A view that arranges its subviews in colums
public struct ColumnsLayout: Layout {
    /// The guide for aligning the subviews in this stack. This guide has the same screen coordinate for every subview.
    public var alignment: Alignment

    /// The distance between adjacent subviews in a row or `nil` if you want the stack to choose a default distance.
    public var horizontalSpacing: Double?

    /// The distance between consequtive rows or`nil` if you want the stack to choose a default distance.
    public var verticalSpacing: Double?

    /// Creates a wrapping horizontal stack with the given spacings and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack. This guide has the same screen coordinate for every subview.
    ///   - horizontalSpacing: The distance between adjacent subviews in a row or `nil` if you want the stack to choose a default distance.
    ///   - verticalSpacing: The distance between consequtive rows or`nil` if you want the stack to choose a default distance.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable public init(
        alignment: Alignment = .center,
        horizontalSpacing: Double? = nil,
        verticalSpacing: Double? = nil
    ) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

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

    public func makeCache(subviews: Subviews) -> Cache {
        Cache(minSize: minSize(subviews: subviews))
    }

    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.minSize = minSize(subviews: subviews)
    }

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

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Cache
    ) {
        let columns = arrangeColumns(proposal: proposal, subviews: subviews, cache: &cache)

        let anchor = UnitPoint(alignment)

        for column in columns {
            for element in column.elements {
                let x: Double = column.xOffset + anchor.x * (column.width - element.size.width)
                let y: Double = element.yOffset + anchor.y * (bounds.height - column.height)
                let point = CGPoint(x: x + bounds.minX, y: y + bounds.minY)

                subviews[element.index].place(at: point, anchor: .topLeading, proposal: proposal)
            }
        }
    }
}

extension ColumnsLayout {

    struct Column {
        var elements: [Element] = []
        var xOffset: Double = .zero
        var width: Double = .zero
        var height: Double = .zero
        // swiftlint:disable:next nesting
        struct Element {
            var index: Int
            var size: CGSize
            var yOffset: Double
        }
    }

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
                spacing = verticalSpacing(subviews[previousIndex], subviews[index])
            }

            let size = sizes[index]

            if currentY + size.height + spacing > proposal.height ?? .infinity, !currentColumn.elements.isEmpty {
                currentColumn.height = currentY
                columns.append(currentColumn)
                currentColumn = Column()
                spacing = .zero
                currentY = .zero
            }
            let element = Column.Element(index: index, size: sizes[index], yOffset: currentY + spacing)
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
                spacing = horizontalSpacing(subviews[previousMaxWidthIndex], subviews[maxWidthIndex])
            }

            columns[index].xOffset = currentX + spacing
            currentX += size.width + spacing
            columns[index].width = size.width
            previousMaxWidthIndex = maxWidthIndex
        }

        cache.columns = (hash, columns)

        return columns
    }

    private func computeHash(proposal: ProposedViewSize, sizes: [CGSize]) -> Int {
        let proposal = proposal.replacingUnspecifiedDimensions(by: .infinity)

        var hasher = Hasher()

        for size in [proposal] + sizes {
            hasher.combine(size.height)
            hasher.combine(size.width)
        }

        return hasher.finalize()
    }

    private func minSize(subviews: Subviews) -> CGSize {
        subviews
            .map { $0.sizeThatFits(.zero) }
            .reduce(CGSize.zero) { CGSize(width: max($0.width, $1.width), height: max($0.height, $1.height)) }
    }

    private func horizontalSpacing(_ lhs: LayoutSubview, _ rhs: LayoutSubview) -> Double {
        if let horizontalSpacing { return horizontalSpacing }

        return lhs.spacing.distance(to: rhs.spacing, along: .horizontal)
    }

    private func verticalSpacing(_ lhs: LayoutSubview, _ rhs: LayoutSubview) -> Double {
        if let verticalSpacing { return verticalSpacing }

        return lhs.spacing.distance(to: rhs.spacing, along: .vertical)
    }
}

private extension CGSize {
    static var infinity: Self {
        .init(width: Double.infinity, height: Double.infinity)
    }
}

private extension UnitPoint {
    init(_ alignment: Alignment) {
        switch alignment {
        case .leading:
            self = .leading
        case .topLeading:
            self = .topLeading
        case .top:
            self = .top
        case .topTrailing:
            self = .topTrailing
        case .trailing:
            self = .trailing
        case .bottomTrailing:
            self = .bottomTrailing
        case .bottom:
            self = .bottom
        case .bottomLeading:
            self = .bottomLeading
        default:
            self = .center
        }
    }
}
