//
//  PDFBuild+TabSection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **tab section** element

    /// A PDF **tab section** element
    class TabSection: PDFElement {

        /// The section with tabs
        let section: Song.Section
        /// The application settings
        let settings: AppSettings

        /// Init the **tab section** element
        /// - Parameters:
        ///    - section: The section with tabs
        ///    - settings: The PDF settings
        init(_ section: Song.Section, settings: AppSettings) {
            self.section = section
            self.settings = settings
        }

        /// Draw the **lyrics section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for line in section.lines {
                switch line.directive {
                case .environmentLine:
                    let line = PDFBuild.TabSection.Line(line.label, settings: settings)
                    line.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                case .comment:
                    let comment = PDFBuild.Comment(line.label, settings: settings).padding(6)
                    comment.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
                default:
                    break
                }
            }
        }
    }
}
