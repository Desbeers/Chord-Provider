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

    struct StrumSection: View {
        let section: Song.Section
        let settings: AppSettings
        var view: Body {
            VStack {
                ForEach(section.lines) { line in
                    switch line.type {
                    case .songLine:
                        if let strums = line.strumGroup {
                            HStack {
                                ForEach(strums, horizontal: true) {strumPart in
                                    HStack(spacing: 0) {
                                        ForEach(strumPart.strums, horizontal: true) { strum in
                                            let dash = strum.action == .slowUp || strum.action == .slowDown ? true : false
                                            VStack(spacing: 2) {
                                                Text(strum.topSymbol, font: .standard, zoom: settings.app.zoom)
                                                    .useMarkup()
                                                switch strum.action {
                                                case .down, .accentedDown, .mutedDown, .slowDown:
                                                    ArrowView(direction: .down, length: Int(settings.app.zoom * 50), dash: dash)
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                case .up, .accentedUp, .mutedUp, .slowUp:
                                                    ArrowView(direction: .up, length: Int(settings.app.zoom * 50), dash: dash)
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                case .palmMute:
                                                    Text("x", font: .standard, zoom: settings.app.zoom)
                                                        .useMarkup()
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                default:
                                                    Text(" ", font: .standard, zoom: settings.app.zoom)
                                                        .useMarkup()
                                                        .frame(minHeight: Int(settings.app.zoom * 50))
                                                }
                                                Text(
                                                    strum.beat.isEmpty ? strum.tuplet : strum.beat,
                                                    font: .standard,
                                                    zoom: settings.app.zoom
                                                )
                                                    .useMarkup()
                                            }
                                            .frame(minWidth: Int(settings.app.zoom * 20))
                                        }
                                        Text(" ")
                                    }
                                    .padding(10, .trailing)
                                }
                            }
                        }
                    case .comment:
                        CommentLabel(comment: line.plain ?? "Empty Comment", settings: settings)
                    default:
                        EmptyView()
                    }
                }
            }
            .padding(10)
        }
    }
}
