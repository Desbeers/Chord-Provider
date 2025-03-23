//
//  SVGIcon.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

enum SVGIcon {
    case capo
    case instrument
    case key
    case tempo
    case time

    func data(color: Color) -> Data {
        switch self {
        case .instrument:
            return process(data: SVGIcon.instrumentData, color: color)
        case .key:
            return process(data: SVGIcon.keyData, color: color)
        case .capo:
            return process(data: SVGIcon.capoData, color: color)
        case .tempo:
            return process(data: SVGIcon.tempoData, color: color)
        case .time:
            return process(data: SVGIcon.timeData, color: color)
        }
    }

    private func process(data: String, color: Color) -> Data {
        data.replacingOccurrences(of: "#000", with: color.toHex).data(using: .utf8) ?? Data()
    }
}

// swiftlint:disable line_length

extension SVGIcon {

    static let instrumentData =
"""
<svg version="1.1" id="_x32_" xml:space="preserve" width="7" height="7" xmlns="http://www.w3.org/2000/svg">
    <style type="text/css" id="style1">
        .st0{fill:#000}
    </style>
    <g id="g7" transform="matrix(.01358 0 0 .0136 .042 .012)" style="stroke-width:23.10697445;stroke-dasharray:none">
        <path class="st0" d="M207.882 304.111c18.384 18.392 48.197 18.392 66.589 0 18.384-18.384 18.384-48.196 0-66.581-18.392-18.392-48.206-18.392-66.589 0-18.393 18.385-18.393 48.198 0 66.581z" id="path1" style="stroke-width:23.10697445;stroke-dasharray:none"/>
        <path class="st0" d="m364.346 218.42-18.136 19.034 7.674 7.665c8.708 8.708 13.002 20.001 13.011 31.404-.009 11.404-4.312 22.696-13.011 31.414-6.802 6.954-19.317 12.994-30.139 16.801-11.839 4.268-22.652 10.471-31.215 19.017-7.324 7.297-12.953 16.493-15.382 27.093-3.533 15.544-5.056 32.825-9.008 49.121-3.91 16.331-9.95 31.08-21.232 42.346a62.467 62.467 0 0 1-4.748 4.286c-9.384 7.648-19.137 13.122-29.42 16.219-15.433 4.552-32.388 4.192-53.27-4.14-20.814-8.35-45.245-25.082-73.151-53.005-37.281-37.23-54.433-68.181-58.788-92.81-2.207-12.371-1.42-23.294 1.652-33.603 3.088-10.291 8.572-20.044 16.219-29.428a62.722 62.722 0 0 1 4.303-4.764c11.258-11.275 25.989-17.315 42.32-21.224 16.305-3.943 33.577-5.466 49.121-8.999 10.6-2.438 19.805-8.058 27.102-15.373 8.538-8.572 14.731-19.368 19.008-31.224 3.815-10.831 9.83-23.338 16.793-30.147 8.708-8.7 20.001-13.003 31.412-13.012 11.412.009 22.696 4.303 31.404 13.012l7.682 7.682 19.026-18.136-8.127-8.127c-27.615-27.615-72.364-27.615-99.978 0-11.831 11.977-18.392 27.434-22.944 39.822-3.216 8.974-7.734 16.433-12.866 21.54-4.414 4.406-9.119 7.118-14.432 8.359-12.789 2.993-30.668 4.61-49.318 9.051-18.615 4.465-38.598 12.01-54.792 28.196a87.233 87.233 0 0 0-6.091 6.75c-9.377 11.506-16.776 24.304-21.02 38.488-6.441 21.266-5.337 45.305 4.928 70.61 10.249 25.382 29.232 52.338 58.805 81.92 39.42 39.377 74.28 60.164 106.746 66.076 16.185 2.926 31.635 1.916 45.793-2.344 14.175-4.243 26.973-11.635 38.496-21.027a86.041 86.041 0 0 0 6.715-6.066c16.186-16.202 23.748-36.178 28.206-54.793 4.44-18.658 6.065-36.546 9.068-49.352 1.24-5.295 3.944-9.983 8.35-14.414 5.115-5.132 12.575-9.649 21.532-12.874 12.413-4.543 27.845-11.121 39.822-22.944 27.614-27.623 27.614-72.363 0-99.978z" id="path2" style="stroke-width:23.10697445;stroke-dasharray:none"/>
        <path class="st0" id="polygon2" style="fill:#000;fill-opacity:1;stroke:none;stroke-width:23.107;stroke-linejoin:round;stroke-dasharray:none;stroke-opacity:1" transform="matrix(1 -.06791 0 1 0 23.584)" d="m426.547 115.071-29.624-29.634-128.902 122.871 35.673 35.664z"/>
        <path class="st0" id="polygon3" style="stroke-width:23.10697445;stroke-dasharray:none" d="m403.732 66.446 41.815 41.815 51.105-51.106-41.814-41.806z"/>
        <path class="st0" id="polygon4" style="stroke-width:23.10697445;stroke-dasharray:none" d="M436.753.002 420.114 16.64l10.198 10.198 16.647-16.639z"/>
        <path class="st0" id="polygon5" style="stroke-width:23.10697445;stroke-dasharray:none" d="m405.032 31.722-16.639 16.639 10.198 10.197 16.647-16.638z"/>
        <path class="st0" id="polygon6" style="stroke-width:23.10697445;stroke-dasharray:none" d="m485.155 81.682 10.197 10.197L512 75.24l-10.206-10.197z"/>
        <path transform="rotate(-134.999 466.855 110.183)" class="st0" id="rect6" style="stroke-width:23.10719605;stroke-dasharray:none" d="M459.642 98.416h14.422v23.531h-14.422z"/>
        <path class="st0" id="polygon7" style="stroke-width:23.10697445;stroke-dasharray:none;fill:none;stroke:#000;stroke-opacity:1;stroke-linejoin:round;fill-opacity:1" d="m168.154 396.493 13.935-13.935-52.645-52.654L115.5 343.84z"/>
    </g>
</svg>
"""
}

extension SVGIcon {
    static let keyData =
"""
<svg xml:space="preserve" width="7" height="7" xmlns="http://www.w3.org/2000/svg">
    <path d="M3.638 3.056.426 5.902l.772.685m.386-1.712.772.685m4.247-3.595c0 .85-.778 1.54-1.738 1.54-.959 0-1.737-.69-1.737-1.54 0-.85.778-1.54 1.737-1.54.96 0 1.738.69 1.738 1.54z" stroke="#000" stroke-width=".4" stroke-linecap="round" stroke-linejoin="round" style="fill:none;fill-opacity:1;stroke:#000;stroke-width:.110849;stroke-dasharray:none;stroke-opacity:1"/>
    /&gt;
</svg>
"""
}

extension SVGIcon {

    static let capoData =
"""
<svg width="7" height="7" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M6.814 3.326 3.803 6.199a2.187 2.187 0 0 1-2.99 0 1.953 1.953 0 0 1 0-2.854L3.702.587a1.458 1.458 0 0 1 1.994 0c.55.525.55 1.377 0 1.902L2.81 5.243a.729.729 0 0 1-.997 0 .651.651 0 0 1 0-.95l2.63-2.511" stroke="#000" stroke-width=".4" stroke-linecap="round" stroke-linejoin="round" style="fill:none;fill-opacity:1;stroke-width:.0987548;stroke-dasharray:none"/>
</svg>
"""
}

extension SVGIcon {

    static let tempoData =
"""
<svg version="1.1" id="Icons" xml:space="preserve" width="7" height="7" xmlns="http://www.w3.org/2000/svg">
    <style type="text/css" id="style1">
        .st1{fill:none;stroke:#000;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10}
    </style>
    <path class="st1" id="line1" style="stroke-width:.337055;stroke-dasharray:none;stroke:#000;stroke-opacity:1" d="M2.994 4.534 6.823.21"/>
    <path class="st1" id="line2" style="stroke-width:.337055;stroke-dasharray:none;stroke:#000;stroke-opacity:1" d="M2.7 1.228h.589"/>
    <path class="st1" id="line3" style="stroke-width:.337055;stroke-dasharray:none;stroke:#000;stroke-opacity:1" d="M2.7 1.991h.589"/>
    <path class="st1" id="line4" style="stroke-width:.337055;stroke-dasharray:none;stroke:#000;stroke-opacity:1" d="M2.7 2.754h.589"/>
    <path class="st1" d="m4.968 3.517.736 2.467c.118.432-.236.84-.766.84H1.021c-.5 0-.884-.408-.766-.815L1.639.795C1.757.44 2.111.21 2.493.21h1.002c.412 0 .736.255.825.585l.412 1.78" id="path4" style="stroke-width:.337055;stroke-dasharray:none;stroke:#000;stroke-opacity:1"/>
    <path class="st1" id="line5" style="stroke-width:.337055;stroke-dasharray:none;stroke:#000;stroke-opacity:1" d="M.461 5.297H5.35"/>
</svg>
"""
}

extension SVGIcon {

    static let timeData =
"""
<svg width="7" height="7" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M3.512 6.714A3.203 3.203 0 0 0 6.714 3.51a3.203 3.203 0 1 0-3.202 3.205zM3.512 1.373v2.136M5.02 5.02 3.512 3.51" stroke="#000" stroke-width=".4" stroke-linecap="round" stroke-linejoin="round" style="stroke-width:.1;stroke-dasharray:none"/>
</svg>
"""
}

// swiftlint:enable line_length
