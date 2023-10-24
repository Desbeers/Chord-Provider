//
//  ChordPro+Directive.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension ChordPro {

    // MARK: 'ChordPro' directives

    /// The directives Chord Provider supports
    enum Directive: String, CaseIterable {

        // swiftlint:disable identifier_name

        /// # Meta-data directives

        /// This directive defines the title of the song
        case t, title
        /// This directive defines a subtitle of the song
        /// - Note: It will be used as artist
        case st, subtitle
        /// This directive defines an artist
        case artist
        /// This directive defines an album this song occurs on
        case album
        /// The year this song was first published, as a four-digit number
        case year
        /// This directive specifies the key the song is written in
        case key
        /// This directive specifies a time signature
        case time
        /// This directive specifies the tempo in number of beats per minute for the song
        case tempo
        /// This directive specifies the capo setting for the song
        case capo

        /// # Formatting directives

        /// This directive introduce a comment line
        case c, comment

        /// # Environment directives

        /// ## Chorus

        /// This directive indicates that the lines that follow form the song’s chorus
        case startOfChorus = "start_of_chorus"
        /// This directive indicates that the lines that follow form the song’s chorus
        case soc
        /// This directive indicates the end of the chorus
        case endOfChorus = "end_of_chorus"
        /// This directive indicates the end of the chorus
        case eoc
        /// This directive indicates that the song chorus must be played here
        case chorus

        /// ## Verse

        /// Specifies that the following lines form a verse of the song
        case startOfVerse = "start_of_verse"
        /// Specifies that the following lines form a verse of the song
        case sov
        /// Specifies the end of the verse
        case endOfVerse = "end_of_verse"
        /// Specifies the end of the verse
        case eov

        /// ## Bridge

        /// Specifies that the following lines form a bridge of the song
        case startOfBridge = "start_of_bridge"
        /// Specifies that the following lines form a bridge of the song
        case sob
        /// Specifies the end of the bridge
        case endOfBridge = "end_of_bridge"
        /// Specifies the end of the bridge
        case eob

        /// ## Tab

        /// This directive indicates that the lines that follow form a section of guitar TAB instructions
        case startOfTab = "start_of_tab"
        /// This directive indicates that the lines that follow form a section of guitar TAB instructions
        case sot
        /// This directive indicates the end of the tab
        case endOfTab = "end_of_tab"
        /// This directive indicates the end of the tab
        case eot

        /// ## Grid

        /// This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles
        case startOfGrid = "start_of_grid"
        /// This directive indicates that the lines that follow define a chord grid in the style of Jazz Grilles
        case sog
        /// This directive indicates the end of the grid
        case endOfGrid = "end_of_grid"
        /// This directive indicates the end of the grid
        case eog

        /// # Chord diagrams

        /// This directive defines a chord in terms of fret/string positions and, optionally, finger settings
        case define

        /// # Custom directives

        /// This directive has the path to the music file
        case musicPath = "musicpath"

        /// Tag(s) for the music file
        case tag

        // swiftlint:enable identifier_name
    }
}
