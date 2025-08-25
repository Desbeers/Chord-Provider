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
    font: -apple-system-body;
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

.comment-inline {
    background: #00ff00;
    padding: 0.2em;
    border-radius: 0.4em;
margin: 0.5em 0 0.5em 0;
}

.comment-section, .repeat-chorus {
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

/* A line with tablature */
.lines .tablature {
    font-family: monospace;
    overflow: visible;
    white-space: nowrap;
    text-align: left;
}

/* A line with a comment */
.lines .comment {
    font: -apple-system-caption1;
    text-align: left;
    background-color:  var(--commentBackground);
    float: left;
    padding: 0.25em 0.5em;
    border-radius: 0.5em;
    margin: 0 0.5em 0.5em 0;
}

.lines .measures {
    display: flex;
    max-width: 25em;
}

.lines .measure {
    width: 8em;
    border-left: 1px solid var(--sectionColor);
    padding-left: 0.5em;
    padding-right: 0.5em;
    margin-bottom: 0.5em;
}

.lines .measure .chord {
    padding-right: 0.2em;
    float: left;
    color: var(--accentColor);
}

/* A line without any type; I use it as 'intro' text for a song */
.lines .plain {
    font-style: italic;
    text-align: left;
}

/* A line with a song part */
.lines .line {
    clear: both;
}

/*
 Parts
 */

.part {
    float: left;
}

.part .chord {
    text-align: left;
    color: var(--accentColor);
    padding-right: 0.5em;
}

.part .lyric {
    white-space: nowrap;
}




    .lines {
        margin-bottom: 1em;
        text-align: left;
    }

    .lines.chorus {
        border-left: 1px solid var(--highlightColor);
        padding-left: 0.5em;
    }

    .lines.chorus .line:first-child {
        margin-top: 0.5em;
    }
</style>
"""
