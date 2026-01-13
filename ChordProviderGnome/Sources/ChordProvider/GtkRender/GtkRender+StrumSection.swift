//
//  GtkRender+StrumSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for a strum section
    struct StrumSection: View {
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings
        /// The body of the `View`
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let strums = line.strums {
                            HStack {
                                ForEach(strums, horizontal: true) {strumPart in
                                    HStack(spacing: 0) {
                                        ForEach(strumPart.strums, horizontal: true) { strum in
                                            let dash = strum.action == .upArpeggio || strum.action == .downArpeggio ? true : false
                                            VStack(spacing: 2) {
                                                Text(strum.topSymbol)
                                                    .style(.sectionStrum)
                                                switch strum.action {
                                                case .down, .downAccent, .downMuted, .downArpeggio:
                                                    Widgets.Arrow(direction: .down, length: Int(settings.app.zoom * 50), dash: dash)
                                                        .id("\(strum.action.rawValue)-\(dash)")
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                case .up, .upAccent, .upMuted, .upArpeggio:
                                                    Widgets.Arrow(direction: .up, length: Int(settings.app.zoom * 50), dash: dash)
                                                        .id("\(strum.action.rawValue)-\(dash)")
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                case .none:
                                                    Text("x")
                                                        .style(.sectionStrum)
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                default:
                                                    Text(" ")
                                                        .style(.sectionStrum)
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                }
                                                Text(
                                                    strum.beat.isEmpty ? strum.tuplet : strum.beat
                                                )
                                                .style(.sectionStrum)
                                            }
                                            .frame(minWidth: Int(settings.app.zoom * 20))
                                        }
                                        Text(" ")
                                    }
                                    .padding(.trailing)
                                }
                            }
                        }
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                    default:
                        Views.Empty()
                    }
                }
            }
            .padding()
        }
    }
}
