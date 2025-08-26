//
//  File.swift
//  ChordProviderHTML
//
//  Created by Nick Berendsen on 23/08/2025.
//

import Foundation

let style: String = """

<style>
:root {
 color-scheme: light dark;
}

/* General stuff */

::-webkit-scrollbar {
    display: none;
}

body {
    font-size: 1em;
    margin: 0;
    padding: 0;
    padding-top: 1em;
}

#container {
    text-align: center;
    margin: 0 auto;
    padding: 0 1em 2em;
}

#grid {
    display: grid;
    grid-template-columns: auto auto;
}

#grid > div.label {
    text-align: right;
    margin-right: 1em;
}

.section {
    text-align: left;
    clear: left;
    border-left: 1px solid;
    padding-left: 1em;
    margin-bottom: 1em;
}

.section.no-label {
    border: 0;
}

.section.repeat_chorus {
    border: 0;
}

.section.tab {
    font-family: monospace;
    overflow: visible;
    white-space: nowrap;
}

.section.grid .part {
    padding-right: 0.5em;
}

.comment-inline {
    background: #00ff00;
    padding: 0.2em;
    border-radius: 0.4em;
    margin: 0.5em 0 0.5em 0;
}

.comment-section {
    background: yellow;
    padding: 0.2em;
    border-radius: 0.4em;
    display: inline-block;
}

.repeat-chorus {
    background: #00ff00;
    padding: 0.2em;
    border-radius: 0.4em;
    display: inline-block;
}


/*
    Lines
*/

.line {
    float: left;
    clear: left;
}

/*
    Parts
*/

.part {
    float: left;
}

.part .lyric {
    white-space: nowrap;
}

/*
    Chord Diagrams
*/

#chord-diagrams {
    margin-bottom: 1em;
}

.chord-diagram {
position: relative;
    display: inline-block;
}

.chord-diagram .nut {
    position: relative;
    top: 1px;
    border: 1px solid;
    margin: 0 14px;
}

.chord-diagram .base-fret {
    position: absolute;
    font-size: 6px;
    top: 31px;
    width: 10px;
    text-align: right;
}

.chord-diagram .diagram {
    position: relative;
}

.chord-diagram .grid {
    display: grid;
    border-top: 1px solid;
    border-left: 1px solid;
    position: relative;
    margin-left: 15px;
    margin-right: 15px;
}

.chord-diagram.guitar .grid, .chord-diagram.guitalele .grid {
    grid-template-columns: repeat(5, 10px);
    grid-template-rows: repeat(5, 13px);
}

.chord-diagram.ukulele .grid {
    grid-template-columns: repeat(3, 10px);
    grid-template-rows: repeat(5, 13px);
}

.chord-diagram .grid div {

      border-bottom: 1px solid;
      border-right: 1px solid;
      display: flex;
      align-items: center;
      justify-content: center;
    }



.chord-diagram .top-bar {
    display: grid;
    margin-left: 11px;
    margin-right: 11px;
}

.chord-diagram.guitar .top-bar, .chord-diagram.guitalele .top-bar {
    grid-template-columns: repeat(6, 10px);
    grid-template-rows: repeat(1, 10px);
}

.chord-diagram.ukulele .top-bar {
    grid-template-columns: repeat(4, 10px);
    grid-template-rows: repeat(1, 10px);
}

.chord-diagram .top-bar div {
      display: flex;
      align-items: center;
      justify-content: center;
font-size: 6px;
    }



.chord-diagram .fingers {
    display: grid;
    position: absolute;
    top: 2px;
    left: 11px;
}

.chord-diagram.guitar .fingers, .chord-diagram.guitalele .fingers {
    grid-template-columns: repeat(6, 10px);
    grid-template-rows: repeat(6, 13px);
}

.chord-diagram.ukulele .fingers {
    grid-template-columns: repeat(4, 10px);
    grid-template-rows: repeat(6, 13px);
}

.chord-diagram .fingers div {
      display: flex;
      align-items: center;
      justify-content: center;
    }

.chord-diagram .fingers div.circle {
    width: 10px;
      height: 10px;
      background-color: blue;
      border-radius: 50%;
    color: white;
      font-size: 6px;
}

.chord-diagram .fingers div.barre {
        width: 10px;
      height: 10px;
      background-color: blue;
    color: white;
      font-size: 6px;
}

.chord-diagram .fingers div.barre.start {
    border-radius: 50% 0 0 50%;
}

.chord-diagram .fingers div.barre.end {
    border-radius: 0 50% 50% 0;
}

</style>
"""
