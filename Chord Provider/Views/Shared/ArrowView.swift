//
//  ArrowView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//
//  Modified from https://gist.github.com/ken-itakura/8939d79aad062999b062752ae6b38e09

import SwiftUI

/// SwiftUI `View` to draw an arrow
struct ArrowView: View {
    /// The start of the arrow
    var start: CGPoint
    /// The end of the arrow
    var end: CGPoint
    /// Bool if the arrow should be dashed
    var dash: Bool
    /// The color of the arrow
    var color: Color = Color.black
    /// The line width of the arrow
    var lineWidth: Double = 1.0
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The calculated length of the arrow
    var vlen: Double {
        sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
    }
    /// The calculated width of the arrow
    var tipWidth: Double {
        vlen / 10
    }
    /// The calculated height of the arrow
    var tipHeight: Double {
        vlen / 4
    }
    /// The body of the `View`
    var body: some View {
        let eShorten = (x: end.x - lineWidth * (end.x - start.x) / vlen, y: end.y - lineWidth * (end.y - start.y) / vlen)
        let tipBase = (x: end.x - tipHeight * (end.x - start.x) / vlen, y: end.y - tipHeight * (end.y - start.y) / vlen)
        let vTip = (x: (start.y - end.y) / vlen, y: (end.x - start.x) / vlen)
        let tip1vert = (x: tipBase.x + tipWidth * vTip.x, y: tipBase.y + tipWidth * vTip.y)
        let tip2vert = (x: tipBase.x - tipWidth * vTip.x, y: tipBase.y - tipWidth * vTip.y)
        let dash: [CGFloat] = dash ? [2 * sceneState.song.settings.scale] : []
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: start.x, y: start.y))
                /// Prevents the end of the line from protruding from the tip
                path.addLine(to: CGPoint(x: eShorten.x, y: eShorten.y))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, dash: dash))
            Path { path in
                path.move(to: CGPoint(x: end.x, y: end.y))
                path.addLine(to: CGPoint(x: tip1vert.x, y: tip1vert.y))
                path.addLine(to: CGPoint(x: tip2vert.x, y: tip2vert.y))
                path.closeSubpath()
            }.fill(color)
        }
    }
}
