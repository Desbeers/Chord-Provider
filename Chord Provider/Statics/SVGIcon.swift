//
//  SVGIcon.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 15/03/2025.
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
        data.replacingOccurrences(of: "#000000", with: color.toHex).data(using: .utf8) ?? Data()
    }
}

// swiftlint:disable indentation_width
// swiftlint:disable line_length

extension SVGIcon {

    static let instrumentData =
"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   version="1.1"
   id="_x32_"
   viewBox="0 0 7 7"
   xml:space="preserve"
   sodipodi:docname="instrument.svg"
   width="7"
   height="7"
   inkscape:version="1.4 (e7c3feb1, 2024-10-09)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"><defs
   id="defs7" /><sodipodi:namedview
   id="namedview7"
   pagecolor="#ffffff"
   bordercolor="#000000"
   borderopacity="0.25"
   inkscape:showpageshadow="2"
   inkscape:pageopacity="0.0"
   inkscape:pagecheckerboard="0"
   inkscape:deskcolor="#d1d1d1"
   inkscape:zoom="49.349416"
   inkscape:cx="2.5633536"
   inkscape:cy="4.650511"
   inkscape:window-width="1224"
   inkscape:window-height="896"
   inkscape:window-x="0"
   inkscape:window-y="38"
   inkscape:window-maximized="0"
   inkscape:current-layer="_x32_" />
<style
   type="text/css"
   id="style1">
    .st0{fill:#000000;}
</style>
<g
   id="g7"
   transform="matrix(0.01357823,0,0,0.01359972,0.04180082,0.01188963)"
   style="stroke-width:23.10697445;stroke-dasharray:none">
    <path
   class="st0"
   d="m 207.882,304.111 c 18.384,18.392 48.197,18.392 66.589,0 18.384,-18.384 18.384,-48.196 0,-66.581 -18.392,-18.392 -48.206,-18.392 -66.589,0 -18.393,18.385 -18.393,48.198 0,66.581 z"
   id="path1"
   style="stroke-width:23.10697445;stroke-dasharray:none" />
    <path
   class="st0"
   d="m 364.346,218.42 -18.136,19.034 7.674,7.665 c 8.708,8.708 13.002,20.001 13.011,31.404 -0.009,11.404 -4.312,22.696 -13.011,31.414 -6.802,6.954 -19.317,12.994 -30.139,16.801 -11.839,4.268 -22.652,10.471 -31.215,19.017 -7.324,7.297 -12.953,16.493 -15.382,27.093 -3.533,15.544 -5.056,32.825 -9.008,49.121 -3.91,16.331 -9.95,31.08 -21.232,42.346 -1.48,1.48 -3.055,2.908 -4.748,4.286 -9.384,7.648 -19.137,13.122 -29.42,16.219 -15.433,4.552 -32.388,4.192 -53.27,-4.14 -20.814,-8.35 -45.245,-25.082 -73.151,-53.005 -37.281,-37.23 -54.433,-68.181 -58.788,-92.81 -2.207,-12.371 -1.42,-23.294 1.652,-33.603 3.088,-10.291 8.572,-20.044 16.219,-29.428 1.386,-1.702 2.815,-3.276 4.303,-4.764 11.258,-11.275 25.989,-17.315 42.32,-21.224 16.305,-3.943 33.577,-5.466 49.121,-8.999 10.6,-2.438 19.805,-8.058 27.102,-15.373 8.538,-8.572 14.731,-19.368 19.008,-31.224 3.815,-10.831 9.83,-23.338 16.793,-30.147 8.708,-8.7 20.001,-13.003 31.412,-13.012 11.412,0.009 22.696,4.303 31.404,13.012 l 7.682,7.682 19.026,-18.136 -8.127,-8.127 c -27.615,-27.615 -72.364,-27.615 -99.978,0 -11.831,11.977 -18.392,27.434 -22.944,39.822 -3.216,8.974 -7.734,16.433 -12.866,21.54 -4.414,4.406 -9.119,7.118 -14.432,8.359 -12.789,2.993 -30.668,4.61 -49.318,9.051 -18.615,4.465 -38.598,12.01 -54.792,28.196 -2.105,2.104 -4.141,4.346 -6.091,6.75 -9.377,11.506 -16.776,24.304 -21.02,38.488 -6.441,21.266 -5.337,45.305 4.928,70.61 10.249,25.382 29.232,52.338 58.805,81.92 39.42,39.377 74.28,60.164 106.746,66.076 16.185,2.926 31.635,1.916 45.793,-2.344 14.175,-4.243 26.973,-11.635 38.496,-21.027 2.387,-1.933 4.62,-3.969 6.715,-6.066 16.186,-16.202 23.748,-36.178 28.206,-54.793 4.44,-18.658 6.065,-36.546 9.068,-49.352 1.24,-5.295 3.944,-9.983 8.35,-14.414 5.115,-5.132 12.575,-9.649 21.532,-12.874 12.413,-4.543 27.845,-11.121 39.822,-22.944 27.614,-27.623 27.614,-72.363 0,-99.978 z"
   id="path2"
   style="stroke-width:23.10697445;stroke-dasharray:none" />
    <polygon
   class="st0"
   points="426.547,115.071 396.923,85.437 268.021,208.308 303.694,243.972 "
   id="polygon2"
   style="fill:#000000;fill-opacity:1;stroke:none;stroke-width:23.107;stroke-linejoin:round;stroke-dasharray:none;stroke-opacity:1"
   transform="matrix(1,-0.06791069,0,1,0,23.584297)" />
    <polygon
   class="st0"
   points="403.732,66.446 445.547,108.261 496.652,57.155 454.838,15.349 "
   id="polygon3"
   style="stroke-width:23.10697445;stroke-dasharray:none" />
    <polygon
   class="st0"
   points="436.753,0.002 420.114,16.64 430.312,26.838 446.959,10.199 "
   id="polygon4"
   style="stroke-width:23.10697445;stroke-dasharray:none" />
    <polygon
   class="st0"
   points="405.032,31.722 388.393,48.361 398.591,58.558 415.238,41.92 "
   id="polygon5"
   style="stroke-width:23.10697445;stroke-dasharray:none" />
    <polygon
   class="st0"
   points="485.155,81.682 495.352,91.879 512,75.24 501.794,65.043 "
   id="polygon6"
   style="stroke-width:23.10697445;stroke-dasharray:none" />

        <rect
   x="459.642"
   y="98.416"
   transform="matrix(-0.7071,-0.7071,0.7071,-0.7071,719.0573,518.2056)"
   class="st0"
   width="14.422"
   height="23.531"
   id="rect6"
   style="stroke-width:23.10719605;stroke-dasharray:none" />
    <polygon
   class="st0"
   points="168.154,396.493 182.089,382.558 129.444,329.904 115.5,343.84 "
   id="polygon7"
   style="stroke-width:23.10697445;stroke-dasharray:none;fill:none;stroke:#000000;stroke-opacity:1;stroke-linejoin:round;fill-opacity:1" />
</g>
</svg>
"""
}

extension SVGIcon {
    static let keyData =
"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   version="1.1"
   id="_x32_"
   viewBox="0 0 7 7"
   xml:space="preserve"
   sodipodi:docname="key.svg"
   width="7"
   height="7"
   inkscape:version="1.4 (e7c3feb1, 2024-10-09)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"><sodipodi:namedview
   id="namedview1"
   pagecolor="#ffffff"
   bordercolor="#000000"
   borderopacity="0.25"
   inkscape:showpageshadow="2"
   inkscape:pageopacity="0.0"
   inkscape:pagecheckerboard="0"
   inkscape:deskcolor="#d1d1d1"
   inkscape:zoom="88.676066"
   inkscape:cx="1.6408035"
   inkscape:cy="4.273983"
   inkscape:window-width="1536"
   inkscape:window-height="993"
   inkscape:window-x="0"
   inkscape:window-y="38"
   inkscape:window-maximized="0"
   inkscape:current-layer="_x32_" /><defs
   id="defs7" />
<path
   d="M 3.638349,3.0555325 0.4261529,5.9019458 1.1982035,6.5866086 M 1.5842296,4.8749534 2.3562809,5.5596172 M 6.6025622,1.9651387 c 0,0.8507884 -0.7777266,1.5404903 -1.737118,1.5404903 -0.9593913,0 -1.7371152,-0.6897019 -1.7371152,-1.5404903 0,-0.8507883 0.7777261,-1.5404902 1.7371152,-1.5404902 0.9593914,0 1.737118,0.6897019 1.737118,1.5404902 z"
   stroke="#000000"
   stroke-width="0.4"
   stroke-linecap="round"
   stroke-linejoin="round"
   id="path1-8"
   style="fill:none;fill-opacity:1;stroke:#000000;stroke-width:0.110849;stroke-dasharray:none;stroke-opacity:1" />/&gt;
</svg>
"""
}

extension SVGIcon {

    static let capoData =
"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   width="7"
   height="7"
   viewBox="0 0 7 7"
   fill="none"
   version="1.1"
   id="svg1"
   sodipodi:docname="capo.svg"
   inkscape:version="1.4 (e7c3feb1, 2024-10-09)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <sodipodi:namedview
     id="namedview1"
     pagecolor="#ffffff"
     bordercolor="#000000"
     borderopacity="0.25"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#d1d1d1"
     inkscape:zoom="88.574404"
     inkscape:cx="2.0942845"
     inkscape:cy="3.6466517"
     inkscape:window-width="1432"
     inkscape:window-height="1051"
     inkscape:window-x="0"
     inkscape:window-y="38"
     inkscape:window-maximized="0"
     inkscape:current-layer="svg1" />
  <defs
     id="defs1" />
  <path
     d="m 6.8140117,3.3255775 -3.011266,2.8734973 c -0.8257681,0.787988 -2.1646233,0.787988 -2.99039981,0 -0.82577646,-0.7880288 -0.82577646,-2.0656139 0,-2.8536017 L 3.7030665,0.58700225 c 0.55054,-0.5253281 1.4430853,-0.5253281 1.9936254,0 0.5504976,0.52533195 0.5504976,1.37706215 0,1.90239405 L 2.8106061,5.2434487 c -0.2752785,0.2626762 -0.7215636,0.2626762 -0.9968209,0 -0.2752618,-0.2626766 -0.2752618,-0.6885516 0,-0.9511876 L 4.4448873,1.781531"
     stroke="#000000"
     stroke-width="0.4"
     stroke-linecap="round"
     stroke-linejoin="round"
     id="path1"
     style="fill:none;fill-opacity:1;stroke-width:0.0987548;stroke-dasharray:none" />
</svg>
"""
}

extension SVGIcon {

    static let tempoData =
"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   version="1.1"
   id="Icons"
   viewBox="0 0 7 7"
   xml:space="preserve"
   sodipodi:docname="tempo.svg"
   width="7"
   height="7"
   inkscape:version="1.4 (e7c3feb1, 2024-10-09)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"><defs
   id="defs5" /><sodipodi:namedview
   id="namedview5"
   pagecolor="#ffffff"
   bordercolor="#000000"
   borderopacity="0.25"
   inkscape:showpageshadow="2"
   inkscape:pageopacity="0.0"
   inkscape:pagecheckerboard="0"
   inkscape:deskcolor="#d1d1d1"
   inkscape:zoom="58.82313"
   inkscape:cx="4.1905285"
   inkscape:cy="4.9555337"
   inkscape:window-width="1104"
   inkscape:window-height="890"
   inkscape:window-x="163"
   inkscape:window-y="38"
   inkscape:window-maximized="0"
   inkscape:current-layer="Icons" />
<style
   type="text/css"
   id="style1">
    .st0{fill:none;stroke:#000000;stroke-width:2;stroke-linejoin:round;stroke-miterlimit:10;}
    .st1{fill:none;stroke:#000000;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;}
</style>
<line
   class="st1"
   x1="2.9942"
   y1="4.5341144"
   x2="6.8231831"
   y2="0.21039675"
   id="line1"
   style="stroke-width:0.337055;stroke-dasharray:none;stroke:#000000;stroke-opacity:1" />
<line
   class="st1"
   x1="2.6996627"
   y1="1.2277421"
   x2="3.2887368"
   y2="1.2277421"
   id="line2"
   style="stroke-width:0.337055;stroke-dasharray:none;stroke:#000000;stroke-opacity:1" />
<line
   class="st1"
   x1="2.6996627"
   y1="1.990751"
   x2="3.2887368"
   y2="1.990751"
   id="line3"
   style="stroke-width:0.337055;stroke-dasharray:none;stroke:#000000;stroke-opacity:1" />
<line
   class="st1"
   x1="2.6996627"
   y1="2.7537603"
   x2="3.2887368"
   y2="2.7537603"
   id="line4"
   style="stroke-width:0.337055;stroke-dasharray:none;stroke:#000000;stroke-opacity:1" />
<path
   class="st1"
   d="M 4.9675987,3.5167691 5.7039415,5.9838319 C 5.8217564,6.4162035 5.4683117,6.8231417 4.9381449,6.8231417 h -3.917344 c -0.50071304,0 -0.88361131,-0.4069382 -0.76579645,-0.8138762 L 1.639329,0.79537033 C 1.7571438,0.43929945 2.1105884,0.21039676 2.4934866,0.21039676 h 1.0014262 c 0.4123521,0 0.7363431,0.25433633 0.824704,0.58497357 L 4.731969,2.5757248"
   id="path4"
   style="stroke-width:0.337055;stroke-dasharray:none;stroke:#000000;stroke-opacity:1" />
<line
   class="st1"
   x1="0.46118045"
   y1="5.2971239"
   x2="5.3504972"
   y2="5.2971239"
   id="line5"
   style="stroke-width:0.337055;stroke-dasharray:none;stroke:#000000;stroke-opacity:1" />
</svg>

"""
}

extension SVGIcon {

    static let timeData =
"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
   width="7"
   height="7"
   viewBox="0 0 7 7"
   fill="none"
   version="1.1"
   id="svg3"
   sodipodi:docname="time-svgrepo-com.svg"
   inkscape:version="1.4 (e7c3feb1, 2024-10-09)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <defs
     id="defs3" />
  <sodipodi:namedview
     id="namedview3"
     pagecolor="#ffffff"
     bordercolor="#000000"
     borderopacity="0.25"
     inkscape:showpageshadow="2"
     inkscape:pageopacity="0.0"
     inkscape:pagecheckerboard="0"
     inkscape:deskcolor="#d1d1d1"
     inkscape:zoom="53.753428"
     inkscape:cx="4.1950813"
     inkscape:cy="4.7717887"
     inkscape:window-width="1576"
     inkscape:window-height="920"
     inkscape:window-x="0"
     inkscape:window-y="38"
     inkscape:window-maximized="0"
     inkscape:current-layer="svg3" />
  <path
     d="m 3.511852,6.7141653 c 1.7686016,0 3.2023128,-1.4347681 3.2023128,-3.2046736 0,-1.7698912 -1.4337112,-3.20467321 -3.2023128,-3.20467321 -1.7685876,0 -3.20231288,1.43478201 -3.20231288,3.20467321 0,1.7699055 1.43372528,3.2046736 3.20231288,3.2046736 z"
     stroke="#000000"
     stroke-width="0.4"
     stroke-linecap="round"
     stroke-linejoin="round"
     id="path1"
     style="stroke-width:0.1;stroke-dasharray:none" />
  <path
     d="M 3.511852,1.3730429 V 3.5094917"
     stroke="#000000"
     stroke-width="0.4"
     stroke-linecap="round"
     stroke-linejoin="round"
     id="path2"
     style="stroke-width:0.1;stroke-dasharray:none" />
  <path
     d="M 5.020497,5.0192491 3.511852,3.5094917"
     stroke="#000000"
     stroke-width="0.4"
     stroke-linecap="round"
     stroke-linejoin="round"
     id="path3"
     style="stroke-width:0.1;stroke-dasharray:none" />
</svg>

"""
}

// swiftlint:enable indentation_width
// swiftlint:enable line_length
