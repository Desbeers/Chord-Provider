import Foundation

struct ChordsData {
    static let data: Data? = """
        [{
            "key": "C",
            "baseFret": 1,
            "barres": [],
            "frets": [-1, 3, 2, 0, 1, 0],
            "suffix": "major",
            "fingers": [0, 3, 2, 0, 1, 0],
            "midi": [48, 52, 55, 60, 64]
        }, {
            "key": "C",
            "suffix": "major",
            "midi": [43, 48, 55, 60, 64, 67],
            "capo": true,
            "barres": [1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "frets": [1, 1, 3, 3, 3, 1],
            "baseFret": 3
        }, {
            "midi": [55, 60, 64, 72],
            "key": "C",
            "barres": [1],
            "fingers": [0, 0, 1, 1, 1, 4],
            "frets": [-1, -1, 1, 1, 1, 4],
            "baseFret": 5,
            "suffix": "major"
        }, {
            "fingers": [1, 3, 4, 2, 1, 1],
            "suffix": "major",
            "barres": [1],
            "frets": [1, 3, 3, 2, 1, 1],
            "midi": [48, 55, 60, 64, 67, 72],
            "baseFret": 8,
            "capo": true,
            "key": "C"
        }, {
            "baseFret": 1,
            "key": "C",
            "fingers": [0, 3, 2, 0, 1, 4],
            "midi": [48, 51, 55, 60, 67],
            "barres": [],
            "frets": [-1, 3, 1, 0, 1, 3],
            "suffix": "minor"
        }, {
            "suffix": "minor",
            "baseFret": 3,
            "fingers": [1, 1, 3, 4, 2, 1],
            "capo": true,
            "midi": [43, 48, 55, 60, 63, 67],
            "key": "C",
            "barres": [1],
            "frets": [1, 1, 3, 3, 2, 1]
        }, {
            "key": "C",
            "fingers": [4, 2, 1, 1, 0, 0],
            "suffix": "minor",
            "midi": [48, 51, 55, 60],
            "frets": [4, 2, 1, 1, -1, -1],
            "barres": [1],
            "baseFret": 5
        }, {
            "suffix": "minor",
            "barres": [1],
            "capo": true,
            "fingers": [1, 3, 4, 1, 1, 1],
            "baseFret": 8,
            "midi": [48, 55, 60, 63, 67, 72],
            "key": "C",
            "frets": [1, 3, 3, 1, 1, 1]
        }, {
            "baseFret": 1,
            "suffix": "dim",
            "frets": [-1, 3, 1, -1, 1, 2],
            "key": "C",
            "barres": [],
            "midi": [48, 51, 60, 66],
            "fingers": [0, 4, 1, 0, 2, 3]
        }, {
            "baseFret": 3,
            "suffix": "dim",
            "fingers": [0, 1, 2, 4, 3, 0],
            "midi": [48, 54, 60, 63],
            "key": "C",
            "frets": [-1, 1, 2, 3, 2, -1],
            "barres": []
        }, {
            "suffix": "dim",
            "midi": [48, 51, 63, 66],
            "key": "C",
            "baseFret": 6,
            "fingers": [3, 1, 0, 4, 2, 0],
            "frets": [3, 1, -1, 3, 2, -1],
            "barres": []
        }, {
            "midi": [60, 66, 75],
            "suffix": "dim",
            "baseFret": 10,
            "key": "C",
            "fingers": [0, 0, 1, 2, 0, 3],
            "barres": [],
            "frets": [-1, -1, 1, 2, -1, 2]
        }, {
            "frets": [-1, -1, 1, 2, 1, 2],
            "suffix": "dim7",
            "key": "C",
            "fingers": [0, 0, 1, 3, 2, 4],
            "barres": [],
            "baseFret": 1,
            "midi": [51, 57, 60, 66]
        }, {
            "key": "C",
            "midi": [48, 54, 57, 63, 66],
            "fingers": [0, 2, 3, 1, 4, 1],
            "capo": true,
            "frets": [-1, 3, 4, 2, 4, 2],
            "barres": [2],
            "suffix": "dim7",
            "baseFret": 1
        }, {
            "suffix": "dim7",
            "midi": [48, 57, 63, 66],
            "key": "C",
            "barres": [1],
            "frets": [2, -1, 1, 2, 1, -1],
            "baseFret": 7,
            "fingers": [2, 0, 1, 3, 1, 0]
        }, {
            "suffix": "dim7",
            "barres": [1],
            "midi": [60, 66, 69, 75],
            "frets": [-1, -1, 1, 2, 1, 2],
            "baseFret": 10,
            "fingers": [0, 0, 1, 3, 1, 4],
            "key": "C"
        }, {
            "baseFret": 1,
            "frets": [-1, 3, 0, 0, 1, 3],
            "key": "C",
            "fingers": [0, 3, 0, 0, 1, 4],
            "midi": [48, 50, 55, 60, 67],
            "barres": [],
            "suffix": "sus2"
        }, {
            "barres": [],
            "suffix": "sus2",
            "midi": [48, 50, 55, 62, 67],
            "fingers": [0, 1, 0, 0, 2, 3],
            "key": "C",
            "frets": [-1, 3, 0, 0, 3, 3],
            "baseFret": 1
        }, {
            "baseFret": 3,
            "midi": [43, 48, 55, 60, 62, 67],
            "frets": [1, 1, 3, 3, 1, 1],
            "key": "C",
            "capo": true,
            "suffix": "sus2",
            "fingers": [1, 1, 3, 4, 1, 1],
            "barres": [1]
        }, {
            "baseFret": 7,
            "midi": [48, 50, 62, 67, 72],
            "fingers": [2, 0, 0, 1, 3, 4],
            "frets": [2, -1, 0, 1, 2, 2],
            "key": "C",
            "suffix": "sus2",
            "barres": []
        }, {
            "barres": [1],
            "suffix": "sus4",
            "fingers": [0, 3, 4, 0, 1, 1],
            "baseFret": 1,
            "frets": [-1, 3, 3, 0, 1, 1],
            "midi": [48, 53, 55, 60, 65],
            "key": "C"
        }, {
            "capo": true,
            "midi": [43, 48, 55, 60, 65, 67],
            "frets": [1, 1, 3, 3, 4, 1],
            "baseFret": 3,
            "suffix": "sus4",
            "fingers": [1, 1, 2, 3, 4, 1],
            "barres": [1],
            "key": "C"
        }, {
            "baseFret": 6,
            "midi": [48, 53, 55, 65, 72],
            "frets": [3, 3, -1, 0, 1, 3],
            "suffix": "sus4",
            "key": "C",
            "fingers": [2, 3, 0, 0, 1, 4],
            "barres": []
        }, {
            "frets": [1, 3, 3, 3, 1, 1],
            "barres": [1],
            "suffix": "sus4",
            "capo": true,
            "fingers": [1, 2, 3, 4, 1, 1],
            "midi": [48, 55, 60, 65, 67, 72],
            "key": "C",
            "baseFret": 8
        }, {
            "frets": [-1, 3, 3, 3, 1, 1],
            "midi": [48, 53, 58, 60, 65],
            "key": "C",
            "barres": [1],
            "capo": true,
            "baseFret": 1,
            "fingers": [0, 2, 3, 4, 1, 1],
            "suffix": "7sus4"
        }, {
            "midi": [43, 48, 55, 58, 65, 67],
            "barres": [1],
            "suffix": "7sus4",
            "key": "C",
            "baseFret": 3,
            "frets": [1, 1, 3, 1, 4, 1],
            "capo": true,
            "fingers": [1, 1, 3, 1, 4, 1]
        }, {
            "barres": [1],
            "midi": [55, 60, 65, 70],
            "frets": [-1, -1, 1, 1, 2, 2],
            "key": "C",
            "suffix": "7sus4",
            "capo": true,
            "baseFret": 5,
            "fingers": [0, 0, 1, 1, 2, 3]
        }, {
            "fingers": [1, 3, 1, 4, 1, 1],
            "midi": [48, 55, 58, 65, 67, 72],
            "key": "C",
            "capo": true,
            "baseFret": 8,
            "frets": [1, 3, 1, 3, 1, 1],
            "barres": [1],
            "suffix": "7sus4"
        }, {
            "midi": [48, 52, 60, 64, 66],
            "baseFret": 2,
            "frets": [-1, 2, 1, 4, 4, 1],
            "capo": true,
            "key": "C",
            "suffix": "alt",
            "barres": [1],
            "fingers": [0, 2, 1, 3, 4, 1]
        }, {
            "suffix": "alt",
            "frets": [-1, 1, 2, 3, 3, 0],
            "key": "C",
            "fingers": [0, 1, 2, 3, 4, 0],
            "baseFret": 3,
            "barres": [],
            "midi": [48, 54, 60, 64, 64]
        }, {
            "midi": [60, 64, 66, 72],
            "key": "C",
            "barres": [],
            "frets": [-1, -1, 4, 3, 1, 2],
            "fingers": [0, 0, 4, 3, 1, 2],
            "suffix": "alt",
            "baseFret": 7
        }, {
            "baseFret": 10,
            "midi": [60, 66, 72, 76],
            "key": "C",
            "fingers": [0, 0, 1, 2, 4, 3],
            "suffix": "alt",
            "barres": [],
            "frets": [-1, -1, 1, 2, 4, 3]
        }, {
            "baseFret": 1,
            "frets": [-1, 3, 2, 1, 1, -1],
            "midi": [48, 52, 56, 60],
            "barres": [1],
            "key": "C",
            "suffix": "aug",
            "fingers": [0, 3, 2, 1, 1, 0]
        }, {
            "key": "C",
            "fingers": [0, 1, 4, 2, 3, 0],
            "suffix": "aug",
            "midi": [48, 56, 60, 64],
            "frets": [-1, 1, 4, 3, 3, -1],
            "barres": [],
            "baseFret": 3
        }, {
            "midi": [48, 52, 56, 60, 64],
            "barres": [1],
            "fingers": [4, 3, 2, 1, 1, 0],
            "frets": [4, 3, 2, 1, 1, -1],
            "key": "C",
            "suffix": "aug",
            "baseFret": 5
        }, {
            "fingers": [0, 0, 4, 2, 3, 1],
            "barres": [],
            "baseFret": 8,
            "frets": [-1, -1, 3, 2, 2, 1],
            "key": "C",
            "midi": [60, 64, 68, 72],
            "suffix": "aug"
        }, {
            "key": "C",
            "fingers": [0, 4, 2, 3, 1, 0],
            "frets": [-1, 3, 2, 2, 1, 0],
            "barres": [],
            "suffix": "6",
            "baseFret": 1,
            "midi": [48, 52, 57, 60, 64]
        }, {
            "frets": [-1, 1, 3, 3, 3, 3],
            "midi": [48, 55, 60, 64, 69],
            "fingers": [0, 1, 3, 3, 3, 4],
            "key": "C",
            "suffix": "6",
            "barres": [3],
            "baseFret": 3
        }, {
            "fingers": [2, 0, 1, 4, 3, 0],
            "baseFret": 7,
            "suffix": "6",
            "midi": [48, 57, 64, 67],
            "barres": [],
            "frets": [2, -1, 1, 3, 2, -1],
            "key": "C"
        }, {
            "frets": [1, -1, 3, 2, 3, 1],
            "baseFret": 8,
            "suffix": "6",
            "fingers": [1, 0, 3, 2, 4, 1],
            "midi": [48, 60, 64, 69, 72],
            "capo": true,
            "key": "C",
            "barres": [1]
        }, {
            "capo": true,
            "key": "C",
            "suffix": "6/9",
            "baseFret": 1,
            "fingers": [0, 3, 1, 1, 3, 4],
            "midi": [48, 52, 57, 62, 67],
            "frets": [-1, 3, 2, 2, 3, 3],
            "barres": [2]
        }, {
            "frets": [-1, 1, 0, 0, 3, 3],
            "baseFret": 3,
            "midi": [48, 50, 55, 64, 69],
            "fingers": [0, 1, 0, 0, 3, 4],
            "barres": [],
            "suffix": "6/9",
            "key": "C"
        }, {
            "capo": true,
            "midi": [48, 52, 57, 62, 67, 72],
            "key": "C",
            "fingers": [2, 1, 1, 1, 3, 4],
            "frets": [2, 1, 1, 1, 2, 2],
            "suffix": "6/9",
            "barres": [1],
            "baseFret": 7
        }, {
            "fingers": [0, 2, 2, 1, 3, 4],
            "barres": [2],
            "baseFret": 9,
            "key": "C",
            "midi": [55, 60, 64, 69, 74],
            "suffix": "6/9",
            "frets": [-1, 2, 2, 1, 2, 2]
        }, {
            "frets": [-1, 3, 2, 3, 1, 0],
            "barres": [],
            "key": "C",
            "suffix": "7",
            "fingers": [0, 3, 2, 4, 1, 0],
            "baseFret": 1,
            "midi": [48, 52, 58, 60, 64]
        }, {
            "capo": true,
            "midi": [43, 48, 55, 58, 64, 67],
            "baseFret": 3,
            "frets": [1, 1, 3, 1, 3, 1],
            "suffix": "7",
            "barres": [1],
            "key": "C",
            "fingers": [1, 1, 3, 1, 4, 1]
        }, {
            "frets": [-1, -1, 1, 1, 1, 2],
            "key": "C",
            "barres": [1],
            "baseFret": 5,
            "midi": [55, 60, 64, 70],
            "fingers": [0, 0, 1, 1, 1, 2],
            "capo": true,
            "suffix": "7"
        }, {
            "barres": [1],
            "capo": true,
            "midi": [48, 55, 58, 64, 67, 72],
            "baseFret": 8,
            "suffix": "7",
            "key": "C",
            "fingers": [1, 3, 1, 2, 1, 1],
            "frets": [1, 3, 1, 2, 1, 1]
        }, {
            "key": "C",
            "suffix": "7b5",
            "barres": [],
            "midi": [52, 58, 60, 66],
            "frets": [-1, -1, 2, 3, 1, 2],
            "fingers": [0, 0, 2, 4, 1, 3],
            "baseFret": 1
        }, {
            "midi": [48, 54, 58, 64],
            "baseFret": 3,
            "suffix": "7b5",
            "barres": [1],
            "fingers": [0, 1, 2, 1, 3, 0],
            "frets": [-1, 1, 2, 1, 3, -1],
            "key": "C"
        }, {
            "fingers": [2, 0, 3, 4, 1, 0],
            "frets": [2, -1, 2, 3, 1, 0],
            "barres": [],
            "baseFret": 7,
            "midi": [48, 58, 64, 66, 64],
            "key": "C",
            "suffix": "7b5"
        }, {
            "frets": [-1, -1, 1, 2, 2, 3],
            "suffix": "7b5",
            "fingers": [0, 0, 1, 2, 3, 4],
            "baseFret": 10,
            "midi": [60, 66, 70, 76],
            "barres": [],
            "key": "C"
        }, {
            "fingers": [0, 2, 1, 3, 0, 4],
            "key": "C",
            "suffix": "aug7",
            "barres": [],
            "frets": [-1, 3, 2, 3, -1, 4],
            "baseFret": 1,
            "midi": [48, 52, 58, 68]
        }, {
            "midi": [48, 56, 58, 64, 68],
            "baseFret": 3,
            "capo": true,
            "fingers": [0, 1, 4, 1, 3, 2],
            "key": "C",
            "suffix": "aug7",
            "frets": [-1, 1, 4, 1, 3, 2],
            "barres": [1]
        }, {
            "baseFret": 8,
            "frets": [1, -1, 1, 2, 2, 0],
            "suffix": "aug7",
            "key": "C",
            "barres": [],
            "fingers": [1, 0, 2, 3, 4, 0],
            "midi": [48, 58, 64, 68, 64]
        }, {
            "suffix": "aug7",
            "midi": [60, 68, 70, 76],
            "barres": [],
            "key": "C",
            "baseFret": 10,
            "fingers": [0, 0, 1, 4, 2, 3],
            "frets": [-1, -1, 1, 4, 2, 3]
        }, {
            "suffix": "9",
            "midi": [40, 48, 52, 55, 62, 64],
            "barres": [],
            "fingers": [0, 2, 1, 3, 4, 0],
            "baseFret": 1,
            "key": "C",
            "frets": [-1, 3, 2, 3, 3, -1]
        }, {
            "midi": [43, 48, 52, 58, 62, 67],
            "key": "C",
            "suffix": "9",
            "frets": [-1, 3, 2, 3, 3, 3],
            "fingers": [0, 2, 1, 3, 3, 3],
            "barres": [3],
            "baseFret": 1
        }, {
            "fingers": [2, 1, 3, 1, 4, 4],
            "barres": [1],
            "frets": [2, 1, 2, 1, 2, 2],
            "key": "C",
            "capo": true,
            "suffix": "9",
            "midi": [48, 52, 58, 62, 67, 72],
            "baseFret": 7
        }, {
            "barres": [2],
            "key": "C",
            "fingers": [1, 3, 1, 2, 1, 4],
            "capo": true,
            "midi": [48, 55, 58, 62, 67, 74],
            "baseFret": 7,
            "frets": [2, 4, 2, 3, 2, 4],
            "suffix": "9"
        }, {
            "barres": [],
            "suffix": "9",
            "frets": [-1, -1, 2, 1, 3, 2],
            "baseFret": 9,
            "key": "C",
            "midi": [60, 64, 70, 74],
            "fingers": [0, 0, 2, 1, 4, 3]
        }, {
            "key": "C",
            "barres": [2],
            "capo": true,
            "frets": [-1, 3, 2, 3, 3, 2],
            "suffix": "9b5",
            "baseFret": 1,
            "midi": [48, 52, 58, 62, 66],
            "fingers": [0, 2, 1, 3, 4, 1]
        }, {
            "baseFret": 1,
            "barres": [],
            "midi": [48, 54, 58, 62, 64],
            "fingers": [0, 1, 4, 2, 3, 0],
            "suffix": "9b5",
            "frets": [-1, 3, 4, 3, 3, 0],
            "key": "C"
        }, {
            "baseFret": 7,
            "midi": [48, 52, 58, 62, 66, 72],
            "suffix": "9b5",
            "frets": [2, 1, 2, 1, 1, 2],
            "barres": [1],
            "fingers": [2, 1, 3, 1, 1, 4],
            "capo": true,
            "key": "C"
        }, {
            "baseFret": 8,
            "fingers": [1, 2, 1, 3, 0, 4],
            "frets": [1, 2, 1, 2, -1, 3],
            "barres": [1],
            "suffix": "9b5",
            "key": "C",
            "midi": [48, 54, 58, 64, 74]
        }, {
            "barres": [3],
            "fingers": [0, 2, 1, 3, 3, 4],
            "midi": [48, 52, 58, 62, 68],
            "baseFret": 1,
            "key": "C",
            "suffix": "aug9",
            "frets": [-1, 3, 2, 3, 3, 4]
        }, {
            "fingers": [0, 1, 0, 2, 4, 3],
            "suffix": "aug9",
            "barres": [],
            "midi": [48, 50, 58, 64, 68],
            "baseFret": 3,
            "key": "C",
            "frets": [-1, 1, 0, 1, 3, 2]
        }, {
            "capo": true,
            "midi": [46, 50, 56, 60, 64, 70],
            "suffix": "aug9",
            "fingers": [2, 1, 3, 1, 1, 4],
            "baseFret": 5,
            "key": "C",
            "barres": [1],
            "frets": [2, 1, 2, 1, 1, 2]
        }, {
            "baseFret": 7,
            "barres": [1],
            "fingers": [2, 1, 3, 1, 4, 0],
            "capo": true,
            "frets": [2, 1, 2, 1, 3, -1],
            "midi": [48, 52, 58, 62, 68],
            "key": "C",
            "suffix": "aug9"
        }, {
            "suffix": "7b9",
            "key": "C",
            "midi": [48, 52, 58, 61, 67],
            "frets": [-1, 3, 2, 3, 2, 3],
            "capo": true,
            "fingers": [0, 2, 1, 3, 1, 4],
            "barres": [2],
            "baseFret": 1
        }, {
            "baseFret": 6,
            "barres": [],
            "suffix": "7b9",
            "fingers": [3, 2, 4, 1, 0, 0],
            "frets": [3, 2, 3, 1, -1, -1],
            "midi": [48, 52, 58, 61],
            "key": "C"
        }, {
            "capo": true,
            "key": "C",
            "suffix": "7b9",
            "fingers": [1, 0, 1, 2, 1, 3],
            "barres": [1],
            "midi": [48, 58, 64, 67, 73],
            "baseFret": 8,
            "frets": [1, -1, 1, 2, 1, 2]
        }, {
            "midi": [60, 64, 70, 73],
            "baseFret": 9,
            "fingers": [0, 0, 3, 1, 4, 2],
            "frets": [-1, -1, 2, 1, 3, 1],
            "barres": [],
            "key": "C",
            "suffix": "7b9"
        }, {
            "frets": [-1, 3, 2, 3, 4, -1],
            "suffix": "7#9",
            "fingers": [0, 2, 1, 3, 4, 0],
            "barres": [],
            "midi": [48, 52, 58, 63],
            "baseFret": 1,
            "key": "C"
        }, {
            "key": "C",
            "barres": [1],
            "frets": [-1, 1, 3, 1, 2, 0],
            "baseFret": 3,
            "suffix": "7#9",
            "fingers": [0, 1, 3, 1, 2, 0],
            "midi": [48, 55, 58, 63, 64]
        }, {
            "capo": true,
            "fingers": [1, 3, 1, 2, 1, 4],
            "suffix": "7#9",
            "midi": [48, 55, 58, 64, 67, 75],
            "baseFret": 8,
            "key": "C",
            "frets": [1, 3, 1, 2, 1, 4],
            "barres": [1]
        }, {
            "key": "C",
            "fingers": [0, 0, 2, 1, 3, 4],
            "baseFret": 9,
            "barres": [],
            "suffix": "7#9",
            "frets": [-1, -1, 2, 1, 3, 3],
            "midi": [60, 64, 70, 75]
        }, {
            "barres": [1],
            "frets": [-1, 3, 2, 3, 1, 1],
            "midi": [48, 52, 58, 60, 65],
            "suffix": "11",
            "key": "C",
            "capo": true,
            "baseFret": 1,
            "fingers": [0, 3, 2, 4, 1, 1]
        }, {
            "frets": [-1, 1, 1, 1, 3, 1],
            "midi": [48, 53, 58, 64, 67],
            "barres": [1],
            "capo": true,
            "fingers": [0, 1, 1, 1, 3, 1],
            "baseFret": 3,
            "key": "C",
            "suffix": "11"
        }, {
            "barres": [1],
            "baseFret": 6,
            "suffix": "11",
            "key": "C",
            "fingers": [3, 2, 0, 0, 1, 1],
            "frets": [3, 2, 0, 0, 1, 1],
            "midi": [48, 52, 50, 55, 65, 70]
        }, {
            "barres": [1],
            "baseFret": 8,
            "midi": [48, 53, 58, 64, 67, 72],
            "fingers": [1, 1, 1, 2, 1, 1],
            "capo": true,
            "key": "C",
            "suffix": "11",
            "frets": [1, 1, 1, 2, 1, 1]
        }, {
            "suffix": "9#11",
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [48, 52, 58, 62, 66],
            "baseFret": 1,
            "capo": true,
            "frets": [-1, 3, 2, 3, 3, 2],
            "key": "C",
            "barres": [2]
        }, {
            "frets": [-1, 1, 2, 1, 3, 1],
            "midi": [48, 54, 58, 64, 67],
            "barres": [1],
            "key": "C",
            "fingers": [0, 1, 2, 1, 3, 1],
            "suffix": "9#11",
            "baseFret": 3,
            "capo": true
        }, {
            "barres": [1],
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "fingers": [2, 1, 3, 1, 1, 4],
            "baseFret": 7,
            "midi": [48, 52, 58, 62, 66, 72],
            "suffix": "9#11",
            "key": "C"
        }, {
            "suffix": "9#11",
            "barres": [],
            "frets": [-1, -1, 1, 2, 2, 3],
            "baseFret": 10,
            "midi": [60, 66, 70, 76],
            "key": "C",
            "fingers": [0, 0, 1, 2, 3, 4]
        }, {
            "midi": [48, 52, 58, 64, 69],
            "frets": [-1, 2, 1, 2, 4, 4],
            "key": "C",
            "barres": [4],
            "baseFret": 2,
            "fingers": [0, 2, 1, 3, 4, 4],
            "suffix": "13"
        }, {
            "barres": [1],
            "midi": [43, 48, 53, 58, 64, 69],
            "frets": [1, 1, 1, 1, 3, 3],
            "capo": true,
            "key": "C",
            "baseFret": 3,
            "fingers": [1, 1, 1, 1, 3, 4],
            "suffix": "13"
        }, {
            "suffix": "13",
            "key": "C",
            "frets": [3, 2, 2, 2, 3, 1],
            "baseFret": 6,
            "midi": [48, 52, 57, 62, 67, 70],
            "fingers": [3, 2, 2, 2, 4, 1],
            "barres": [2]
        }, {
            "frets": [1, 3, 1, 2, 3, 1],
            "midi": [48, 55, 58, 64, 69, 72],
            "capo": true,
            "suffix": "13",
            "fingers": [1, 3, 1, 2, 4, 1],
            "baseFret": 8,
            "key": "C",
            "barres": [1]
        }, {
            "baseFret": 1,
            "barres": [],
            "key": "C",
            "midi": [43, 48, 52, 55, 59, 64],
            "fingers": [2, 3, 1, 0, 0, 0],
            "frets": [3, 3, 2, 0, 0, 0],
            "suffix": "maj7"
        }, {
            "barres": [1],
            "fingers": [1, 1, 3, 2, 4, 1],
            "baseFret": 3,
            "key": "C",
            "capo": true,
            "midi": [43, 48, 55, 59, 64, 67],
            "frets": [1, 1, 3, 2, 3, 1],
            "suffix": "maj7"
        }, {
            "key": "C",
            "suffix": "maj7",
            "fingers": [0, 0, 1, 1, 1, 4],
            "capo": true,
            "baseFret": 5,
            "midi": [55, 60, 64, 71],
            "barres": [1],
            "frets": [-1, -1, 1, 1, 1, 3]
        }, {
            "midi": [60, 67, 71, 76],
            "fingers": [0, 0, 1, 3, 3, 3],
            "baseFret": 10,
            "frets": [-1, -1, 1, 3, 3, 3],
            "key": "C",
            "suffix": "maj7",
            "barres": [3]
        }, {
            "baseFret": 1,
            "barres": [],
            "fingers": [0, 3, 1, 4, 0, 2],
            "frets": [-1, 3, 2, 4, 0, 2],
            "suffix": "maj7b5",
            "key": "C",
            "midi": [48, 52, 59, 59, 66]
        }, {
            "frets": [-1, 1, 2, 2, 3, -1],
            "midi": [48, 54, 59, 64],
            "baseFret": 3,
            "key": "C",
            "suffix": "maj7b5",
            "fingers": [0, 1, 2, 3, 4, 0],
            "barres": []
        }, {
            "fingers": [2, 1, 3, 4, 1, 1],
            "midi": [48, 52, 59, 64, 66, 71],
            "barres": [1],
            "suffix": "maj7b5",
            "frets": [2, 1, 3, 3, 1, 1],
            "baseFret": 7,
            "capo": true,
            "key": "C"
        }, {
            "suffix": "maj7b5",
            "baseFret": 10,
            "barres": [],
            "frets": [-1, -1, 1, 2, 3, 3],
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "C",
            "midi": [60, 66, 71, 76]
        }, {
            "key": "C",
            "barres": [],
            "suffix": "maj7#5",
            "fingers": [0, 3, 2, 1, 0, 0],
            "frets": [-1, 3, 2, 1, 0, 0],
            "midi": [48, 52, 56, 59, 64],
            "baseFret": 1
        }, {
            "barres": [],
            "frets": [-1, 1, 4, 2, 3, 0],
            "fingers": [0, 1, 4, 2, 3, 0],
            "key": "C",
            "suffix": "maj7#5",
            "midi": [48, 56, 59, 64, 64],
            "baseFret": 3
        }, {
            "key": "C",
            "midi": [48, 52, 56, 60, 59, 64],
            "frets": [4, 3, 2, 1, 0, 0],
            "fingers": [4, 3, 2, 1, 0, 0],
            "suffix": "maj7#5",
            "barres": [],
            "baseFret": 5
        }, {
            "barres": [],
            "frets": [1, 4, 3, 2, 0, 0],
            "fingers": [1, 4, 3, 2, 0, 0],
            "key": "C",
            "baseFret": 8,
            "suffix": "maj7#5",
            "midi": [48, 56, 60, 64, 59, 64]
        }, {
            "fingers": [0, 3, 0, 0, 0, 0],
            "midi": [48, 50, 55, 59, 64],
            "suffix": "maj9",
            "key": "C",
            "barres": [],
            "baseFret": 1,
            "frets": [-1, 3, 0, 0, 0, 0]
        }, {
            "key": "C",
            "midi": [43, 48, 52, 59, 62],
            "baseFret": 1,
            "barres": [],
            "fingers": [0, 2, 1, 4, 3, 0],
            "suffix": "maj9",
            "frets": [-1, 3, 2, 4, 3, -1]
        }, {
            "suffix": "maj9",
            "barres": [1],
            "midi": [40, 50, 55, 60, 64, 71],
            "baseFret": 5,
            "frets": [0, 1, 1, 1, 1, 3],
            "fingers": [0, 1, 1, 1, 1, 3],
            "capo": true,
            "key": "C"
        }, {
            "midi": [48, 59, 64, 67, 74],
            "capo": true,
            "barres": [1],
            "fingers": [1, 0, 2, 3, 1, 4],
            "baseFret": 8,
            "suffix": "maj9",
            "key": "C",
            "frets": [1, -1, 2, 2, 1, 3]
        }, {
            "baseFret": 1,
            "frets": [-1, 3, 2, 0, 0, 1],
            "barres": [],
            "fingers": [0, 3, 2, 0, 0, 1],
            "suffix": "maj11",
            "key": "C",
            "midi": [48, 52, 55, 59, 65]
        }, {
            "baseFret": 1,
            "fingers": [0, 1, 1, 0, 0, 0],
            "midi": [48, 53, 55, 59, 64],
            "barres": [3],
            "frets": [-1, 3, 3, 0, 0, 0],
            "suffix": "maj11",
            "key": "C"
        }, {
            "key": "C",
            "suffix": "maj11",
            "baseFret": 6,
            "barres": [],
            "fingers": [3, 2, 4, 0, 1, 0],
            "frets": [3, 2, 4, 0, 1, 0],
            "midi": [48, 52, 59, 55, 65, 64]
        }, {
            "suffix": "maj11",
            "frets": [1, 1, 2, 2, 1, 1],
            "baseFret": 8,
            "fingers": [1, 1, 2, 3, 1, 1],
            "key": "C",
            "barres": [1],
            "capo": true,
            "midi": [48, 53, 59, 64, 67, 72]
        }, {
            "suffix": "maj13",
            "barres": [],
            "fingers": [0, 4, 2, 3, 0, 1],
            "baseFret": 1,
            "midi": [48, 52, 57, 59, 65],
            "frets": [-1, 3, 2, 2, 0, 1],
            "key": "C"
        }, {
            "baseFret": 3,
            "barres": [1],
            "midi": [48, 53, 59, 64, 69],
            "fingers": [0, 1, 1, 2, 3, 4],
            "frets": [-1, 1, 1, 2, 3, 3],
            "key": "C",
            "suffix": "maj13"
        }, {
            "suffix": "maj13",
            "baseFret": 7,
            "capo": true,
            "key": "C",
            "fingers": [2, 1, 1, 1, 3, 1],
            "frets": [2, 1, 1, 1, 2, 1],
            "barres": [1],
            "midi": [48, 52, 57, 62, 67, 71]
        }, {
            "suffix": "maj13",
            "key": "C",
            "frets": [1, 1, 2, 2, 3, 1],
            "midi": [48, 53, 59, 64, 69, 72],
            "fingers": [1, 1, 2, 3, 4, 1],
            "barres": [1],
            "baseFret": 8,
            "capo": true
        }, {
            "midi": [48, 51, 57, 60, 67],
            "barres": [1],
            "baseFret": 1,
            "key": "C",
            "fingers": [0, 3, 1, 2, 1, 4],
            "frets": [-1, 3, 1, 2, 1, 3],
            "suffix": "m6",
            "capo": true
        }, {
            "suffix": "m6",
            "barres": [],
            "frets": [-1, 1, 3, -1, 2, 3],
            "midi": [48, 55, 63, 69],
            "baseFret": 3,
            "key": "C",
            "fingers": [0, 1, 3, 0, 2, 4]
        }, {
            "fingers": [2, 0, 1, 3, 3, 4],
            "baseFret": 7,
            "barres": [2],
            "frets": [2, -1, 1, 2, 2, 2],
            "key": "C",
            "midi": [48, 57, 63, 67, 72],
            "suffix": "m6"
        }, {
            "capo": true,
            "key": "C",
            "barres": [1],
            "frets": [1, 3, 3, 1, 3, 1],
            "suffix": "m6",
            "baseFret": 8,
            "midi": [48, 55, 60, 63, 69, 72],
            "fingers": [1, 2, 3, 1, 4, 1]
        }, {
            "baseFret": 1,
            "suffix": "m7",
            "key": "C",
            "midi": [48, 51, 58, 63],
            "fingers": [0, 2, 1, 3, 4, 0],
            "barres": [],
            "frets": [-1, 3, 1, 3, 4, -1]
        }, {
            "midi": [43, 48, 55, 58, 63, 67],
            "frets": [1, 1, 3, 1, 2, 1],
            "suffix": "m7",
            "baseFret": 3,
            "barres": [1],
            "capo": true,
            "key": "C",
            "fingers": [1, 1, 3, 1, 2, 1]
        }, {
            "midi": [55, 60, 63, 70],
            "fingers": [0, 0, 2, 3, 1, 4],
            "barres": [],
            "baseFret": 4,
            "frets": [-1, -1, 2, 2, 1, 3],
            "key": "C",
            "suffix": "m7"
        }, {
            "key": "C",
            "midi": [48, 55, 58, 63, 67, 72],
            "baseFret": 8,
            "suffix": "m7",
            "frets": [1, 3, 1, 1, 1, 1],
            "capo": true,
            "barres": [1],
            "fingers": [1, 3, 1, 1, 1, 1]
        }, {
            "baseFret": 1,
            "fingers": [0, 1, 3, 2, 4, 0],
            "key": "C",
            "frets": [-1, 3, 4, 3, 4, -1],
            "suffix": "m7b5",
            "midi": [48, 54, 58, 63],
            "barres": []
        }, {
            "suffix": "m7b5",
            "midi": [54, 60, 63, 70],
            "key": "C",
            "barres": [1],
            "frets": [-1, -1, 1, 2, 1, 3],
            "fingers": [0, 0, 1, 2, 1, 4],
            "baseFret": 4,
            "capo": true
        }, {
            "frets": [1, 2, 3, 1, 4, 1],
            "baseFret": 8,
            "fingers": [1, 2, 3, 1, 4, 1],
            "barres": [1],
            "capo": true,
            "midi": [48, 54, 60, 63, 70, 72],
            "key": "C",
            "suffix": "m7b5"
        }, {
            "baseFret": 10,
            "key": "C",
            "barres": [2],
            "suffix": "m7b5",
            "frets": [-1, -1, 1, 2, 2, 2],
            "midi": [60, 66, 70, 75],
            "fingers": [0, 0, 1, 3, 3, 3]
        }, {
            "baseFret": 1,
            "key": "C",
            "suffix": "m9",
            "fingers": [0, 2, 1, 3, 4, 4],
            "frets": [-1, 3, 1, 3, 3, 3],
            "midi": [48, 51, 58, 62, 67],
            "barres": [3]
        }, {
            "key": "C",
            "barres": [],
            "midi": [48, 50, 58, 63, 67],
            "suffix": "m9",
            "frets": [-1, 3, 0, 3, 4, 3],
            "fingers": [0, 1, 0, 2, 4, 3],
            "baseFret": 1
        }, {
            "frets": [-1, 1, 3, 2, 3, 3],
            "fingers": [0, 1, 3, 2, 4, 4],
            "midi": [51, 58, 62, 67, 72],
            "key": "C",
            "barres": [3],
            "baseFret": 6,
            "suffix": "m9"
        }, {
            "key": "C",
            "frets": [1, 3, 1, 1, 1, 3],
            "barres": [1],
            "midi": [48, 55, 58, 63, 67, 74],
            "baseFret": 8,
            "capo": true,
            "fingers": [1, 3, 1, 1, 1, 4],
            "suffix": "m9"
        }, {
            "suffix": "m6/9",
            "midi": [48, 51, 57, 62, 67],
            "barres": [3],
            "fingers": [0, 3, 1, 2, 4, 4],
            "key": "C",
            "frets": [-1, 3, 1, 2, 3, 3],
            "baseFret": 1
        }, {
            "midi": [48, 50, 55, 63, 69],
            "barres": [],
            "fingers": [0, 1, 0, 0, 2, 4],
            "suffix": "m6/9",
            "frets": [-1, 1, 0, 0, 2, 3],
            "key": "C",
            "baseFret": 3
        }, {
            "midi": [48, 51, 57, 62],
            "fingers": [4, 1, 2, 3, 0, 0],
            "key": "C",
            "suffix": "m6/9",
            "barres": [],
            "frets": [3, 1, 2, 2, -1, -1],
            "baseFret": 6
        }, {
            "frets": [-1, 3, 3, 1, 3, 3],
            "barres": [3],
            "suffix": "m6/9",
            "fingers": [0, 2, 2, 1, 3, 4],
            "key": "C",
            "baseFret": 8,
            "midi": [55, 60, 63, 69, 74]
        }, {
            "barres": [1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "suffix": "m11",
            "baseFret": 1,
            "key": "C",
            "capo": true,
            "frets": [-1, 3, 1, 3, 3, 1],
            "midi": [48, 51, 58, 62, 65]
        }, {
            "capo": true,
            "key": "C",
            "suffix": "m11",
            "barres": [3],
            "frets": [-1, 3, 3, 3, 4, 3],
            "fingers": [0, 1, 1, 1, 2, 1],
            "midi": [48, 53, 58, 63, 67],
            "baseFret": 1
        }, {
            "suffix": "m11",
            "midi": [48, 51, 58, 62, 65, 70],
            "barres": [1],
            "capo": true,
            "frets": [3, 1, 3, 2, 1, 1],
            "baseFret": 6,
            "fingers": [3, 1, 4, 2, 1, 1],
            "key": "C"
        }, {
            "suffix": "m11",
            "baseFret": 8,
            "fingers": [1, 1, 1, 1, 1, 4],
            "key": "C",
            "frets": [1, 1, 1, 1, 1, 3],
            "capo": true,
            "barres": [1],
            "midi": [48, 53, 58, 63, 67, 74]
        }, {
            "key": "C",
            "midi": [48, 51, 55, 59],
            "barres": [],
            "fingers": [0, 3, 1, 0, 0, 0],
            "baseFret": 1,
            "frets": [-1, 3, 1, 0, 0, -1],
            "suffix": "mmaj7"
        }, {
            "midi": [43, 48, 55, 59, 63, 67],
            "baseFret": 3,
            "key": "C",
            "fingers": [1, 1, 4, 2, 3, 1],
            "suffix": "mmaj7",
            "frets": [1, 1, 3, 2, 2, 1],
            "barres": [1],
            "capo": true
        }, {
            "midi": [48, 55, 59, 63, 67, 72],
            "capo": true,
            "fingers": [1, 3, 2, 1, 1, 1],
            "key": "C",
            "baseFret": 8,
            "barres": [1],
            "frets": [1, 3, 2, 1, 1, 1],
            "suffix": "mmaj7"
        }, {
            "key": "C",
            "baseFret": 10,
            "suffix": "mmaj7",
            "midi": [60, 67, 71, 75],
            "frets": [-1, -1, 1, 3, 3, 2],
            "fingers": [0, 0, 1, 3, 4, 2],
            "barres": []
        }, {
            "midi": [48, 59, 63, 66],
            "fingers": [0, 2, 0, 3, 4, 1],
            "frets": [-1, 3, -1, 4, 4, 2],
            "key": "C",
            "baseFret": 1,
            "barres": [],
            "suffix": "mmaj7b5"
        }, {
            "midi": [48, 54, 59, 63],
            "baseFret": 1,
            "key": "C",
            "barres": [],
            "frets": [-1, 3, 4, 4, 4, -1],
            "suffix": "mmaj7b5",
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "barres": [1],
            "capo": true,
            "key": "C",
            "baseFret": 8,
            "midi": [48, 54, 59, 63, 72],
            "suffix": "mmaj7b5",
            "frets": [1, 2, 2, 1, -1, 1],
            "fingers": [1, 2, 3, 1, 0, 1]
        }, {
            "fingers": [0, 0, 1, 2, 4, 3],
            "suffix": "mmaj7b5",
            "midi": [60, 66, 71, 75],
            "frets": [-1, -1, 1, 2, 3, 2],
            "baseFret": 10,
            "barres": [],
            "key": "C"
        }, {
            "midi": [48, 51, 59, 62],
            "frets": [-1, 3, 1, 4, 3, -1],
            "baseFret": 1,
            "key": "C",
            "fingers": [0, 2, 1, 4, 3, 0],
            "barres": [],
            "suffix": "mmaj9"
        }, {
            "midi": [48, 50, 59, 63, 67],
            "key": "C",
            "barres": [],
            "frets": [-1, 3, 0, 4, 4, 3],
            "fingers": [0, 1, 0, 3, 4, 2],
            "baseFret": 1,
            "suffix": "mmaj9"
        }, {
            "key": "C",
            "frets": [3, 1, -1, 2, 0, 3],
            "barres": [],
            "baseFret": 6,
            "fingers": [3, 1, 0, 2, 0, 4],
            "suffix": "mmaj9",
            "midi": [48, 51, 62, 59, 72]
        }, {
            "suffix": "mmaj9",
            "baseFret": 8,
            "fingers": [1, 3, 2, 1, 1, 4],
            "barres": [1],
            "midi": [48, 55, 59, 63, 67, 74],
            "frets": [1, 3, 2, 1, 1, 3],
            "key": "C",
            "capo": true
        }, {
            "fingers": [0, 3, 1, 0, 0, 2],
            "frets": [-1, 3, 1, 0, 0, 1],
            "baseFret": 1,
            "key": "C",
            "midi": [48, 51, 55, 59, 65],
            "barres": [],
            "suffix": "mmaj11"
        }, {
            "barres": [3],
            "baseFret": 1,
            "capo": true,
            "suffix": "mmaj11",
            "key": "C",
            "midi": [43, 48, 53, 59, 63, 67],
            "fingers": [1, 1, 1, 2, 3, 1],
            "frets": [3, 3, 3, 4, 4, 3]
        }, {
            "capo": true,
            "midi": [48, 53, 59, 63, 67, 74],
            "barres": [1],
            "baseFret": 8,
            "suffix": "mmaj11",
            "frets": [1, 1, 2, 1, 1, 3],
            "key": "C",
            "fingers": [1, 1, 2, 1, 1, 4]
        }, {
            "barres": [1],
            "key": "C",
            "midi": [60, 65, 71, 75],
            "capo": true,
            "frets": [-1, -1, 1, 1, 3, 2],
            "fingers": [0, 0, 1, 1, 3, 2],
            "baseFret": 10,
            "suffix": "mmaj11"
        }, {
            "midi": [48, 52, 55, 62, 64],
            "frets": [-1, 3, 2, 0, 3, 0],
            "baseFret": 1,
            "suffix": "add9",
            "key": "C",
            "fingers": [0, 2, 1, 0, 3, 0],
            "barres": []
        }, {
            "fingers": [0, 1, 0, 0, 3, 0],
            "barres": [],
            "midi": [48, 50, 55, 62, 64],
            "key": "C",
            "suffix": "add9",
            "frets": [-1, 3, 0, 0, 3, 0],
            "baseFret": 1
        }, {
            "barres": [],
            "baseFret": 7,
            "frets": [2, 1, 0, 0, 2, 0],
            "midi": [48, 52, 50, 55, 67, 64],
            "key": "C",
            "fingers": [2, 1, 0, 0, 3, 0],
            "suffix": "add9"
        }, {
            "key": "C",
            "baseFret": 8,
            "barres": [],
            "frets": [-1, -1, 3, 2, 1, 3],
            "midi": [60, 64, 67, 74],
            "suffix": "add9",
            "fingers": [0, 0, 3, 2, 1, 4]
        }, {
            "key": "C",
            "barres": [],
            "baseFret": 1,
            "midi": [48, 51, 55, 62, 67],
            "frets": [-1, 3, 1, 0, 3, 3],
            "suffix": "madd9",
            "fingers": [0, 2, 1, 0, 3, 4]
        }, {
            "fingers": [0, 1, 0, 4, 3, 2],
            "barres": [],
            "frets": [-1, 1, 0, 3, 2, 1],
            "key": "C",
            "suffix": "madd9",
            "midi": [48, 50, 60, 63, 67],
            "baseFret": 3
        }, {
            "baseFret": 6,
            "fingers": [3, 1, 0, 2, 4, 4],
            "frets": [3, 1, 0, 2, 3, 3],
            "barres": [3],
            "midi": [48, 51, 50, 62, 67, 72],
            "key": "C",
            "suffix": "madd9"
        }, {
            "midi": [60, 63, 67, 74],
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 3, 1, 1, 4],
            "frets": [-1, -1, 3, 1, 1, 3],
            "baseFret": 8,
            "key": "C",
            "suffix": "madd9"
        }, {
            "fingers": [0, 3, 2, 0, 1, 0],
            "suffix": "/E",
            "baseFret": 1,
            "midi": [40, 48, 52, 55, 60, 64],
            "frets": [0, 3, 2, 0, 1, 0],
            "key": "C",
            "barres": []
        }, {
            "key": "C",
            "baseFret": 1,
            "barres": [],
            "fingers": [0, 3, 2, 0, 1, 4],
            "midi": [40, 48, 52, 55, 60, 67],
            "suffix": "/E",
            "frets": [0, 3, 2, 0, 1, 3]
        }, {
            "key": "C",
            "midi": [52, 55, 60, 67, 72],
            "fingers": [0, 3, 1, 1, 4, 4],
            "barres": [1],
            "suffix": "/E",
            "baseFret": 5,
            "frets": [-1, 3, 1, 1, 4, 4]
        }, {
            "frets": [-1, -1, 3, 0, 1, 0],
            "fingers": [0, 0, 3, 0, 1, 0],
            "barres": [],
            "midi": [53, 55, 60, 64],
            "key": "C",
            "suffix": "/F",
            "baseFret": 1
        }, {
            "suffix": "/F",
            "midi": [41, 48, 52, 55, 60, 64],
            "baseFret": 1,
            "key": "C",
            "frets": [1, 3, 2, 0, 1, 0],
            "fingers": [1, 4, 3, 0, 2, 0],
            "barres": []
        }, {
            "key": "C",
            "midi": [53, 60, 64, 67],
            "barres": [],
            "fingers": [0, 0, 1, 3, 4, 2],
            "frets": [-1, -1, 1, 3, 3, 1],
            "suffix": "/F",
            "baseFret": 3
        }, {
            "baseFret": 1,
            "frets": [3, 3, 2, 0, 1, 0],
            "midi": [43, 48, 52, 55, 60, 64],
            "fingers": [3, 4, 2, 0, 1, 0],
            "barres": [],
            "key": "C",
            "suffix": "/G"
        }, {
            "baseFret": 3,
            "key": "C",
            "barres": [1],
            "frets": [1, 1, 3, 3, 3, 1],
            "midi": [43, 48, 55, 60, 64, 67],
            "fingers": [1, 1, 2, 3, 4, 1],
            "suffix": "/G"
        }, {
            "fingers": [2, 3, 1, 4, 4, 0],
            "barres": [4],
            "frets": [2, 2, 1, 4, 4, -1],
            "key": "C",
            "midi": [43, 48, 52, 60, 64],
            "baseFret": 2,
            "suffix": "/G"
        }, {
            "frets": [-1, 4, 3, 1, 2, 1],
            "suffix": "major",
            "midi": [49, 53, 56, 61, 65],
            "fingers": [0, 4, 3, 1, 2, 1],
            "baseFret": 1,
            "key": "C#",
            "barres": [1]
        }, {
            "midi": [44, 49, 56, 61, 65, 68],
            "barres": [1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "baseFret": 4,
            "suffix": "major",
            "key": "C#",
            "capo": true,
            "frets": [1, 1, 3, 3, 3, 1]
        }, {
            "key": "C#",
            "frets": [4, 3, 1, 1, 1, 4],
            "barres": [1],
            "fingers": [3, 2, 1, 1, 1, 4],
            "midi": [49, 53, 56, 61, 65, 73],
            "baseFret": 6,
            "suffix": "major"
        }, {
            "key": "C#",
            "barres": [1],
            "frets": [1, 3, 3, 2, 1, 1],
            "suffix": "major",
            "baseFret": 9,
            "capo": true,
            "fingers": [1, 3, 4, 2, 1, 1],
            "midi": [49, 56, 61, 65, 68, 73]
        }, {
            "suffix": "minor",
            "baseFret": 1,
            "barres": [],
            "midi": [49, 52, 56, 61],
            "fingers": [0, 4, 2, 1, 3, 0],
            "key": "C#",
            "frets": [-1, 4, 2, 1, 2, -1]
        }, {
            "suffix": "minor",
            "capo": true,
            "key": "C#",
            "midi": [44, 49, 56, 61, 64, 68],
            "barres": [1],
            "baseFret": 4,
            "fingers": [1, 1, 3, 4, 2, 1],
            "frets": [1, 1, 3, 3, 2, 1]
        }, {
            "frets": [4, 2, 1, 1, -1, 4],
            "fingers": [3, 2, 1, 1, 0, 4],
            "key": "C#",
            "barres": [1],
            "suffix": "minor",
            "baseFret": 6,
            "midi": [49, 52, 56, 61, 73]
        }, {
            "midi": [49, 56, 61, 64, 68, 73],
            "fingers": [1, 3, 4, 1, 1, 1],
            "barres": [1],
            "baseFret": 9,
            "key": "C#",
            "suffix": "minor",
            "capo": true,
            "frets": [1, 3, 3, 1, 1, 1]
        }, {
            "baseFret": 1,
            "fingers": [0, 4, 1, 0, 2, 3],
            "frets": [-1, 4, 2, -1, 2, 3],
            "midi": [49, 52, 61, 67],
            "barres": [],
            "key": "C#",
            "suffix": "dim"
        }, {
            "barres": [],
            "frets": [-1, 1, 2, 3, 2, -1],
            "suffix": "dim",
            "baseFret": 4,
            "fingers": [0, 1, 2, 4, 3, 0],
            "key": "C#",
            "midi": [49, 55, 61, 64]
        }, {
            "baseFret": 7,
            "suffix": "dim",
            "barres": [],
            "fingers": [3, 1, 0, 4, 2, 0],
            "key": "C#",
            "midi": [49, 52, 64, 67],
            "frets": [3, 1, -1, 3, 2, -1]
        }, {
            "fingers": [0, 0, 1, 2, 0, 3],
            "key": "C#",
            "suffix": "dim",
            "frets": [-1, -1, 1, 2, -1, 2],
            "midi": [61, 67, 76],
            "barres": [],
            "baseFret": 11
        }, {
            "key": "C#",
            "suffix": "dim7",
            "barres": [],
            "frets": [-1, -1, 2, 3, 2, 3],
            "midi": [52, 58, 61, 67],
            "fingers": [0, 0, 1, 3, 2, 4],
            "baseFret": 1
        }, {
            "key": "C#",
            "midi": [49, 55, 58, 64, 67],
            "capo": true,
            "baseFret": 3,
            "barres": [1],
            "frets": [-1, 2, 3, 1, 3, 1],
            "suffix": "dim7",
            "fingers": [0, 2, 3, 1, 4, 1]
        }, {
            "suffix": "dim7",
            "frets": [2, -1, 1, 2, 1, -1],
            "midi": [49, 58, 64, 67],
            "barres": [1],
            "key": "C#",
            "fingers": [2, 0, 1, 3, 1, 0],
            "baseFret": 8
        }, {
            "frets": [-1, -1, 1, 2, 1, 2],
            "key": "C#",
            "fingers": [0, 0, 1, 3, 2, 4],
            "barres": [],
            "midi": [61, 67, 70, 76],
            "baseFret": 11,
            "suffix": "dim7"
        }, {
            "barres": [1],
            "fingers": [1, 1, 3, 4, 1, 1],
            "frets": [1, 1, 3, 3, 1, 1],
            "suffix": "sus2",
            "capo": true,
            "baseFret": 4,
            "midi": [44, 49, 56, 61, 63, 68],
            "key": "C#"
        }, {
            "key": "C#",
            "frets": [4, 1, 1, 3, 4, -1],
            "baseFret": 6,
            "fingers": [0, 1, 0, 0, 2, 3],
            "suffix": "sus2",
            "midi": [49, 51, 56, 63, 68],
            "barres": [1],
            "capo": true
        }, {
            "frets": [1, 3, 3, -1, 1, 3],
            "key": "C#",
            "baseFret": 9,
            "midi": [49, 56, 61, 68, 75],
            "capo": true,
            "suffix": "sus2",
            "barres": [1],
            "fingers": [1, 2, 3, 0, 1, 4]
        }, {
            "midi": [51, 56, 61, 68, 73, 75],
            "frets": [1, 1, 1, 3, 4, 1],
            "barres": [1],
            "capo": true,
            "key": "C#",
            "suffix": "sus2",
            "baseFret": 11,
            "fingers": [1, 1, 1, 3, 4, 1]
        }, {
            "barres": [],
            "frets": [-1, 4, 4, 1, 2, -1],
            "key": "C#",
            "suffix": "sus4",
            "midi": [49, 54, 56, 61],
            "baseFret": 1,
            "fingers": [0, 3, 4, 1, 2, 0]
        }, {
            "key": "C#",
            "capo": true,
            "barres": [1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "baseFret": 4,
            "suffix": "sus4",
            "frets": [1, 1, 3, 3, 4, 1],
            "midi": [44, 49, 56, 61, 66, 68]
        }, {
            "frets": [4, -1, 1, 1, 2, 4],
            "midi": [49, 56, 61, 66, 73],
            "fingers": [2, 3, 0, 0, 1, 4],
            "barres": [],
            "suffix": "sus4",
            "key": "C#",
            "baseFret": 6
        }, {
            "key": "C#",
            "capo": true,
            "fingers": [1, 2, 3, 4, 1, 1],
            "suffix": "sus4",
            "frets": [1, 3, 3, 3, 1, 1],
            "midi": [49, 56, 61, 66, 68, 73],
            "barres": [1],
            "baseFret": 9
        }, {
            "baseFret": 1,
            "barres": [2],
            "suffix": "7sus4",
            "midi": [49, 54, 59, 61, 66],
            "capo": true,
            "fingers": [0, 2, 3, 4, 1, 1],
            "key": "C#",
            "frets": [-1, 4, 4, 4, 2, 2]
        }, {
            "frets": [1, 1, 3, 1, 4, 1],
            "capo": true,
            "baseFret": 4,
            "fingers": [1, 1, 3, 1, 4, 1],
            "suffix": "7sus4",
            "barres": [1],
            "midi": [44, 49, 56, 59, 66, 68],
            "key": "C#"
        }, {
            "key": "C#",
            "midi": [61, 66, 71],
            "fingers": [0, 0, 0, 1, 2, 3],
            "barres": [],
            "frets": [-1, -1, -1, 1, 2, 2],
            "suffix": "7sus4",
            "baseFret": 6
        }, {
            "midi": [49, 56, 59, 66, 68, 73],
            "key": "C#",
            "baseFret": 9,
            "barres": [1],
            "capo": true,
            "fingers": [1, 3, 1, 4, 1, 1],
            "suffix": "7sus4",
            "frets": [1, 3, 1, 3, 1, 1]
        }, {
            "baseFret": 1,
            "key": "C#",
            "fingers": [0, 4, 3, 0, 2, 1],
            "barres": [],
            "frets": [-1, 4, 3, 0, 2, 1],
            "suffix": "alt",
            "midi": [49, 53, 55, 61, 65]
        }, {
            "frets": [-1, 2, 3, 0, 4, 1],
            "barres": [],
            "fingers": [0, 2, 3, 0, 4, 1],
            "key": "C#",
            "baseFret": 3,
            "midi": [49, 55, 55, 65, 67],
            "suffix": "alt"
        }, {
            "frets": [-1, 1, 2, 3, 3, -1],
            "baseFret": 4,
            "fingers": [0, 1, 2, 3, 4, 0],
            "suffix": "alt",
            "key": "C#",
            "barres": [],
            "midi": [49, 55, 61, 65]
        }, {
            "baseFret": 8,
            "barres": [],
            "suffix": "alt",
            "key": "C#",
            "midi": [61, 65, 67, 73],
            "frets": [-1, -1, 4, 3, 1, 2],
            "fingers": [0, 0, 4, 3, 1, 2]
        }, {
            "key": "C#",
            "capo": true,
            "midi": [49, 54, 59, 61, 66],
            "barres": [2],
            "fingers": [0, 2, 3, 4, 1, 1],
            "frets": [-1, 4, 4, 4, 2, 2],
            "baseFret": 1,
            "suffix": "aug"
        }, {
            "baseFret": 4,
            "frets": [1, 1, 3, 1, 4, 1],
            "key": "C#",
            "midi": [44, 49, 56, 59, 66, 68],
            "fingers": [1, 1, 3, 1, 4, 1],
            "barres": [1],
            "capo": true,
            "suffix": "aug"
        }, {
            "frets": [4, 3, 2, 1, 1, -1],
            "capo": true,
            "baseFret": 6,
            "barres": [1],
            "key": "C#",
            "suffix": "aug",
            "midi": [49, 53, 57, 61, 65],
            "fingers": [4, 3, 2, 1, 1, 0]
        }, {
            "barres": [1],
            "suffix": "aug",
            "capo": true,
            "fingers": [1, 0, 4, 2, 3, 1],
            "baseFret": 9,
            "frets": [1, -1, 3, 2, 2, 1],
            "midi": [49, 61, 65, 69, 73],
            "key": "C#"
        }, {
            "suffix": "6",
            "midi": [49, 53, 58, 61],
            "fingers": [0, 4, 2, 3, 1, 0],
            "barres": [],
            "frets": [-1, 4, 3, 3, 2, -1],
            "key": "C#",
            "baseFret": 1
        }, {
            "barres": [3],
            "frets": [-1, 1, 3, 3, 3, 3],
            "suffix": "6",
            "fingers": [0, 1, 3, 3, 3, 3],
            "baseFret": 4,
            "midi": [49, 56, 61, 65, 70],
            "key": "C#"
        }, {
            "key": "C#",
            "fingers": [4, 2, 3, 1, 1, 1],
            "suffix": "6",
            "capo": true,
            "baseFret": 6,
            "barres": [1],
            "midi": [49, 53, 58, 61, 65, 70],
            "frets": [4, 3, 3, 1, 1, 1]
        }, {
            "capo": true,
            "midi": [49, 61, 65, 70, 73],
            "baseFret": 9,
            "frets": [1, -1, 3, 2, 3, 1],
            "fingers": [1, 0, 3, 2, 4, 1],
            "key": "C#",
            "barres": [1],
            "suffix": "6"
        }, {
            "fingers": [0, 4, 1, 3, 2, 1],
            "midi": [49, 51, 58, 61, 65],
            "capo": true,
            "frets": [-1, 4, 1, 3, 2, 1],
            "baseFret": 1,
            "key": "C#",
            "suffix": "6/9",
            "barres": [1]
        }, {
            "barres": [3],
            "fingers": [0, 2, 1, 1, 3, 4],
            "midi": [49, 53, 58, 63, 68],
            "baseFret": 1,
            "frets": [-1, 4, 3, 3, 4, 4],
            "capo": true,
            "key": "C#",
            "suffix": "6/9"
        }, {
            "suffix": "6/9",
            "frets": [2, 1, 1, 1, 2, 2],
            "capo": true,
            "fingers": [2, 1, 1, 1, 3, 4],
            "baseFret": 8,
            "midi": [49, 53, 58, 63, 68, 73],
            "barres": [1],
            "key": "C#"
        }, {
            "key": "C#",
            "fingers": [0, 0, 2, 1, 3, 4],
            "baseFret": 10,
            "midi": [61, 65, 70, 75],
            "barres": [],
            "suffix": "6/9",
            "frets": [-1, -1, 2, 1, 2, 2]
        }, {
            "barres": [],
            "suffix": "7",
            "midi": [49, 53, 59, 61],
            "fingers": [0, 3, 2, 4, 1, 0],
            "key": "C#",
            "frets": [-1, 4, 3, 4, 2, -1],
            "baseFret": 1
        }, {
            "barres": [1],
            "suffix": "7",
            "capo": true,
            "baseFret": 4,
            "key": "C#",
            "frets": [-1, 1, 3, 1, 3, 1],
            "midi": [49, 56, 59, 65, 68],
            "fingers": [0, 1, 3, 1, 4, 1]
        }, {
            "midi": [49, 53, 56, 61, 65, 71],
            "capo": true,
            "fingers": [4, 3, 1, 1, 1, 2],
            "key": "C#",
            "frets": [4, 3, 1, 1, 1, 2],
            "baseFret": 6,
            "suffix": "7",
            "barres": [1]
        }, {
            "midi": [49, 56, 59, 65, 68, 73],
            "barres": [1],
            "suffix": "7",
            "frets": [1, 3, 1, 2, 1, 1],
            "fingers": [1, 3, 1, 2, 1, 1],
            "key": "C#",
            "baseFret": 9,
            "capo": true
        }, {
            "baseFret": 1,
            "suffix": "7b5",
            "midi": [49, 53, 55, 59, 65],
            "key": "C#",
            "fingers": [0, 4, 3, 0, 0, 1],
            "barres": [],
            "frets": [-1, 4, 3, 0, 0, 1]
        }, {
            "suffix": "7b5",
            "baseFret": 4,
            "fingers": [0, 1, 2, 1, 3, 0],
            "barres": [1],
            "midi": [49, 55, 59, 65],
            "capo": true,
            "key": "C#",
            "frets": [-1, 1, 2, 1, 3, -1]
        }, {
            "fingers": [2, 0, 3, 4, 1, 0],
            "baseFret": 8,
            "frets": [2, -1, 2, 3, 1, -1],
            "suffix": "7b5",
            "key": "C#",
            "midi": [49, 59, 65, 67],
            "barres": []
        }, {
            "suffix": "7b5",
            "barres": [],
            "baseFret": 12,
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [62, 68, 72, 78],
            "frets": [-1, -1, 1, 2, 2, 3],
            "key": "C#"
        }, {
            "fingers": [0, 4, 3, 2, 0, 1],
            "suffix": "aug7",
            "midi": [49, 53, 57, 59, 65],
            "frets": [-1, 4, 3, 2, 0, 1],
            "barres": [],
            "key": "C#",
            "baseFret": 1
        }, {
            "midi": [49, 57, 59, 65, 69],
            "frets": [-1, 1, 4, 1, 3, 2],
            "capo": true,
            "key": "C#",
            "fingers": [0, 1, 4, 1, 3, 2],
            "suffix": "aug7",
            "barres": [1],
            "baseFret": 4
        }, {
            "frets": [3, 2, 1, -1, 0, 1],
            "midi": [49, 53, 57, 59, 71],
            "key": "C#",
            "barres": [],
            "baseFret": 7,
            "fingers": [4, 3, 1, 0, 0, 2],
            "suffix": "aug7"
        }, {
            "fingers": [1, 0, 2, 3, 4, 0],
            "barres": [],
            "baseFret": 9,
            "suffix": "aug7",
            "frets": [1, -1, 1, 2, 2, -1],
            "key": "C#",
            "midi": [49, 59, 65, 69]
        }, {
            "key": "C#",
            "frets": [4, 4, 3, 4, 4, 4],
            "suffix": "9",
            "midi": [44, 49, 53, 59, 63, 68],
            "fingers": [2, 2, 1, 3, 3, 4],
            "barres": [4],
            "baseFret": 1
        }, {
            "frets": [2, 1, 2, 1, -1, -1],
            "baseFret": 8,
            "fingers": [3, 1, 4, 2, 0, 0],
            "midi": [49, 53, 59, 63],
            "suffix": "9",
            "barres": [],
            "key": "C#"
        }, {
            "key": "C#",
            "capo": true,
            "barres": [1],
            "suffix": "9",
            "frets": [1, 3, 1, 2, 1, 3],
            "fingers": [1, 3, 1, 2, 1, 4],
            "midi": [49, 56, 59, 65, 68, 75],
            "baseFret": 9
        }, {
            "baseFret": 10,
            "barres": [],
            "midi": [61, 65, 71, 75],
            "fingers": [0, 0, 2, 1, 4, 3],
            "key": "C#",
            "frets": [-1, -1, 2, 1, 3, 2],
            "suffix": "9"
        }, {
            "baseFret": 1,
            "capo": true,
            "key": "C#",
            "suffix": "9b5",
            "midi": [49, 53, 59, 63, 67],
            "frets": [-1, 4, 3, 4, 4, 3],
            "barres": [3],
            "fingers": [0, 2, 1, 3, 4, 1]
        }, {
            "capo": true,
            "barres": [1],
            "midi": [49, 53, 59, 63, 67, 73],
            "key": "C#",
            "suffix": "9b5",
            "baseFret": 8,
            "frets": [2, 1, 2, 1, 1, 2],
            "fingers": [2, 1, 3, 1, 1, 4]
        }, {
            "barres": [],
            "key": "C#",
            "fingers": [1, 2, 0, 3, 0, 4],
            "midi": [49, 55, 65, 59, 75],
            "frets": [1, 2, -1, 2, 0, 3],
            "baseFret": 9,
            "suffix": "9b5"
        }, {
            "fingers": [0, 2, 1, 3, 3, 4],
            "baseFret": 3,
            "frets": [-1, 2, 1, 2, 2, 3],
            "key": "C#",
            "barres": [2],
            "suffix": "aug9",
            "midi": [49, 53, 59, 63, 69]
        }, {
            "frets": [3, 2, 1, 2, 0, -1],
            "midi": [49, 53, 57, 63, 59],
            "baseFret": 7,
            "fingers": [4, 2, 1, 3, 0, 0],
            "barres": [],
            "key": "C#",
            "suffix": "aug9"
        }, {
            "frets": [2, 1, 2, 1, 3, -1],
            "fingers": [2, 1, 3, 1, 4, 0],
            "suffix": "aug9",
            "barres": [1],
            "key": "C#",
            "midi": [49, 53, 59, 63, 69],
            "baseFret": 8,
            "capo": true
        }, {
            "suffix": "aug9",
            "capo": true,
            "frets": [1, 4, 1, 2, 0, 3],
            "fingers": [1, 4, 1, 2, 0, 3],
            "key": "C#",
            "baseFret": 9,
            "midi": [49, 57, 59, 65, 59, 75],
            "barres": [1]
        }, {
            "midi": [49, 53, 59, 62, 68],
            "capo": true,
            "suffix": "7b9",
            "barres": [3],
            "baseFret": 1,
            "key": "C#",
            "frets": [-1, 4, 3, 4, 3, 4],
            "fingers": [0, 2, 1, 3, 1, 4]
        }, {
            "baseFret": 4,
            "frets": [-1, 1, 0, 1, 3, 4],
            "fingers": [0, 1, 0, 2, 3, 4],
            "key": "C#",
            "midi": [49, 50, 59, 65, 71],
            "barres": [],
            "suffix": "7b9"
        }, {
            "key": "C#",
            "barres": [],
            "midi": [49, 53, 59, 62, 59],
            "frets": [3, 2, 3, 1, 0, -1],
            "baseFret": 7,
            "fingers": [3, 2, 4, 1, 0, 0],
            "suffix": "7b9"
        }, {
            "frets": [-1, -1, 1, 2, 1, 2],
            "key": "C#",
            "baseFret": 9,
            "suffix": "7b9",
            "barres": [],
            "midi": [59, 65, 68, 74],
            "fingers": [0, 0, 1, 3, 2, 4]
        }, {
            "baseFret": 1,
            "barres": [],
            "suffix": "7#9",
            "fingers": [0, 3, 2, 4, 1, 0],
            "key": "C#",
            "frets": [-1, 4, 3, 4, 2, 0],
            "midi": [49, 53, 59, 61, 64]
        }, {
            "suffix": "7#9",
            "baseFret": 3,
            "fingers": [0, 2, 1, 3, 4, 0],
            "frets": [-1, 2, 1, 2, 3, -1],
            "midi": [49, 53, 59, 64],
            "barres": [],
            "key": "C#"
        }, {
            "barres": [2],
            "frets": [-1, 1, 2, 2, 2, 2],
            "key": "C#",
            "suffix": "7#9",
            "fingers": [0, 1, 2, 2, 3, 4],
            "baseFret": 8,
            "midi": [53, 59, 64, 68, 73]
        }, {
            "suffix": "7#9",
            "baseFret": 9,
            "capo": true,
            "midi": [49, 56, 59, 65, 68, 76],
            "fingers": [1, 3, 1, 2, 1, 4],
            "barres": [1],
            "frets": [1, 3, 1, 2, 1, 4],
            "key": "C#"
        }, {
            "midi": [49, 53, 55, 59, 68],
            "frets": [-1, 4, 3, 0, 0, 4],
            "baseFret": 1,
            "suffix": "11",
            "key": "C#",
            "barres": [],
            "fingers": [0, 2, 1, 0, 0, 3]
        }, {
            "baseFret": 4,
            "suffix": "11",
            "barres": [1],
            "capo": true,
            "midi": [49, 55, 59, 65, 68],
            "key": "C#",
            "fingers": [0, 1, 2, 1, 3, 1],
            "frets": [-1, 1, 2, 1, 3, 1]
        }, {
            "baseFret": 8,
            "midi": [49, 53, 59, 63, 67, 73],
            "key": "C#",
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "barres": [1],
            "fingers": [2, 1, 3, 1, 1, 4],
            "suffix": "11"
        }, {
            "frets": [1, 2, 1, 2, 1, 1],
            "barres": [1],
            "capo": true,
            "fingers": [1, 2, 1, 3, 1, 1],
            "baseFret": 9,
            "midi": [49, 55, 59, 65, 68, 73],
            "key": "C#",
            "suffix": "11"
        }, {
            "frets": [-1, 3, 2, 0, 0, 3],
            "barres": [],
            "suffix": "9#11",
            "midi": [48, 52, 55, 59, 67],
            "fingers": [0, 2, 1, 0, 0, 3],
            "key": "C#",
            "baseFret": 1
        }, {
            "midi": [49, 55, 59, 65, 68],
            "frets": [-1, 1, 2, 1, 3, 1],
            "barres": [1],
            "fingers": [0, 1, 2, 1, 3, 1],
            "baseFret": 4,
            "suffix": "9#11",
            "key": "C#",
            "capo": true
        }, {
            "barres": [1],
            "suffix": "9#11",
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "fingers": [2, 1, 3, 1, 1, 4],
            "baseFret": 8,
            "midi": [49, 53, 59, 63, 67, 73],
            "key": "C#"
        }, {
            "frets": [1, 2, 1, 2, 1, 1],
            "midi": [49, 55, 59, 65, 68, 73],
            "suffix": "9#11",
            "key": "C#",
            "fingers": [1, 2, 1, 3, 1, 1],
            "baseFret": 9,
            "capo": true,
            "barres": [1]
        }, {
            "midi": [49, 53, 58, 59, 66],
            "frets": [-1, 4, 3, 3, 0, 2],
            "suffix": "13",
            "fingers": [0, 4, 2, 3, 0, 1],
            "baseFret": 1,
            "key": "C#",
            "barres": []
        }, {
            "fingers": [1, 1, 1, 1, 3, 4],
            "midi": [44, 49, 54, 59, 65, 70],
            "baseFret": 4,
            "frets": [1, 1, 1, 1, 3, 3],
            "capo": true,
            "suffix": "13",
            "key": "C#",
            "barres": [1]
        }, {
            "frets": [3, 2, 2, 2, 3, 1],
            "barres": [2],
            "midi": [49, 53, 58, 63, 68, 71],
            "baseFret": 7,
            "key": "C#",
            "fingers": [3, 2, 2, 2, 4, 1],
            "suffix": "13"
        }, {
            "suffix": "13",
            "capo": true,
            "barres": [1],
            "fingers": [1, 1, 1, 2, 3, 4],
            "key": "C#",
            "baseFret": 9,
            "midi": [49, 54, 59, 65, 70, 75],
            "frets": [1, 1, 1, 2, 3, 3]
        }, {
            "key": "C#",
            "suffix": "maj7",
            "frets": [-1, 4, 3, 1, 1, 1],
            "capo": true,
            "baseFret": 1,
            "fingers": [0, 4, 3, 1, 1, 1],
            "midi": [49, 53, 56, 60, 65],
            "barres": [1]
        }, {
            "key": "C#",
            "fingers": [1, 1, 3, 2, 4, 1],
            "baseFret": 4,
            "capo": true,
            "frets": [1, 1, 3, 2, 3, 1],
            "barres": [1],
            "suffix": "maj7",
            "midi": [44, 49, 56, 60, 65, 68]
        }, {
            "fingers": [0, 0, 0, 1, 1, 3],
            "key": "C#",
            "suffix": "maj7",
            "frets": [-1, -1, -1, 1, 1, 3],
            "barres": [1],
            "midi": [61, 65, 72],
            "baseFret": 6
        }, {
            "barres": [],
            "baseFret": 9,
            "fingers": [1, 0, 3, 4, 2, 0],
            "key": "C#",
            "midi": [49, 60, 65, 68],
            "frets": [1, -1, 2, 2, 1, -1],
            "suffix": "maj7"
        }, {
            "key": "C#",
            "suffix": "maj7b5",
            "frets": [-1, 2, 1, 3, 4, 1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "capo": true,
            "baseFret": 3,
            "midi": [49, 53, 60, 65, 67],
            "barres": [1]
        }, {
            "key": "C#",
            "midi": [49, 55, 60, 65],
            "barres": [],
            "baseFret": 4,
            "frets": [-1, 1, 2, 2, 3, -1],
            "suffix": "maj7b5",
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "baseFret": 8,
            "capo": true,
            "midi": [49, 53, 60, 65, 67, 72],
            "key": "C#",
            "frets": [2, 1, 3, 3, 1, 1],
            "suffix": "maj7b5",
            "fingers": [2, 1, 3, 4, 1, 1],
            "barres": [1]
        }, {
            "barres": [],
            "key": "C#",
            "baseFret": 11,
            "suffix": "maj7b5",
            "frets": [-1, -1, 1, 2, 3, 3],
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [61, 67, 72, 77]
        }, {
            "midi": [41, 49, 53, 57, 60, 65],
            "frets": [1, 4, 3, 2, 1, 1],
            "barres": [1],
            "capo": true,
            "suffix": "maj7#5",
            "fingers": [1, 4, 3, 2, 1, 1],
            "baseFret": 1,
            "key": "C#"
        }, {
            "baseFret": 4,
            "frets": [-1, 1, 4, 2, 3, -1],
            "fingers": [0, 1, 4, 2, 3, 0],
            "barres": [],
            "midi": [49, 57, 60, 65],
            "key": "C#",
            "suffix": "maj7#5"
        }, {
            "fingers": [0, 0, 4, 2, 3, 1],
            "suffix": "maj7#5",
            "barres": [],
            "key": "C#",
            "baseFret": 8,
            "frets": [-1, -1, 4, 3, 3, 1],
            "midi": [61, 65, 69, 72]
        }, {
            "frets": [-1, -1, 1, 4, 3, 3],
            "baseFret": 11,
            "fingers": [0, 0, 1, 4, 2, 3],
            "key": "C#",
            "midi": [61, 69, 72, 77],
            "suffix": "maj7#5",
            "barres": []
        }, {
            "midi": [49, 51, 56, 60, 65],
            "barres": [1],
            "capo": true,
            "fingers": [0, 4, 1, 1, 1, 1],
            "key": "C#",
            "suffix": "maj9",
            "frets": [-1, 4, 1, 1, 1, 1],
            "baseFret": 1
        }, {
            "baseFret": 3,
            "key": "C#",
            "suffix": "maj9",
            "midi": [49, 53, 60, 63],
            "barres": [],
            "frets": [-1, 2, 1, 3, 2, -1],
            "fingers": [0, 2, 1, 4, 3, 0]
        }, {
            "baseFret": 8,
            "fingers": [2, 1, 4, 1, 3, 1],
            "midi": [49, 53, 60, 63, 68, 72],
            "suffix": "maj9",
            "frets": [2, 1, 3, 1, 2, 1],
            "barres": [1],
            "key": "C#",
            "capo": true
        }, {
            "key": "C#",
            "fingers": [0, 0, 2, 1, 4, 3],
            "frets": [-1, -1, 2, 1, 4, 2],
            "suffix": "maj9",
            "baseFret": 10,
            "barres": [],
            "midi": [61, 65, 72, 75]
        }, {
            "barres": [1],
            "baseFret": 2,
            "capo": true,
            "key": "C#",
            "frets": [-1, 3, 2, 4, 1, 1],
            "fingers": [0, 3, 2, 4, 1, 1],
            "midi": [49, 53, 60, 61, 66],
            "suffix": "maj11"
        }, {
            "barres": [1],
            "capo": true,
            "baseFret": 4,
            "key": "C#",
            "suffix": "maj11",
            "fingers": [1, 1, 1, 2, 3, 1],
            "midi": [44, 49, 54, 60, 65, 68],
            "frets": [1, 1, 1, 2, 3, 1]
        }, {
            "midi": [49, 53, 66, 72],
            "fingers": [4, 2, 0, 0, 1, 3],
            "barres": [],
            "baseFret": 7,
            "frets": [3, 2, -1, -1, 1, 2],
            "key": "C#",
            "suffix": "maj11"
        }, {
            "fingers": [1, 1, 2, 3, 1, 1],
            "capo": true,
            "frets": [1, 1, 2, 2, 1, 1],
            "key": "C#",
            "suffix": "maj11",
            "baseFret": 9,
            "midi": [49, 54, 60, 65, 68, 73],
            "barres": [1]
        }, {
            "frets": [-1, 4, 1, 3, 1, 1],
            "fingers": [0, 4, 2, 3, 0, 1],
            "barres": [],
            "midi": [49, 51, 58, 60, 65],
            "suffix": "maj13",
            "baseFret": 1,
            "key": "C#"
        }, {
            "midi": [49, 54, 60, 65, 70],
            "barres": [1],
            "frets": [-1, 1, 1, 2, 3, 3],
            "baseFret": 4,
            "fingers": [0, 1, 1, 2, 3, 4],
            "suffix": "maj13",
            "key": "C#",
            "capo": true
        }, {
            "baseFret": 8,
            "fingers": [2, 1, 1, 1, 3, 1],
            "capo": true,
            "midi": [49, 53, 58, 63, 68, 72],
            "key": "C#",
            "suffix": "maj13",
            "barres": [1],
            "frets": [2, 1, 1, 1, 2, 1]
        }, {
            "fingers": [1, 1, 2, 3, 4, 1],
            "suffix": "maj13",
            "baseFret": 9,
            "midi": [49, 54, 60, 65, 70, 73],
            "capo": true,
            "barres": [1],
            "key": "C#",
            "frets": [1, 1, 2, 2, 3, 1]
        }, {
            "suffix": "m6",
            "key": "C#",
            "fingers": [0, 3, 1, 2, 1, 4],
            "baseFret": 1,
            "capo": true,
            "barres": [2],
            "midi": [49, 52, 58, 61, 68],
            "frets": [-1, 4, 2, 3, 2, 4]
        }, {
            "midi": [56, 61, 64, 70],
            "barres": [],
            "baseFret": 5,
            "frets": [-1, -1, 2, 2, 1, 2],
            "suffix": "m6",
            "key": "C#",
            "fingers": [0, 0, 2, 3, 1, 4]
        }, {
            "frets": [2, -1, 1, 2, 2, -1],
            "barres": [],
            "suffix": "m6",
            "baseFret": 8,
            "fingers": [2, 0, 1, 3, 4, 0],
            "midi": [49, 58, 64, 68],
            "key": "C#"
        }, {
            "midi": [49, 56, 61, 64, 70, 73],
            "capo": true,
            "key": "C#",
            "suffix": "m6",
            "frets": [1, 3, 3, 1, 3, 1],
            "barres": [1],
            "fingers": [1, 2, 3, 1, 4, 1],
            "baseFret": 9
        }, {
            "capo": true,
            "baseFret": 4,
            "key": "C#",
            "frets": [-1, 1, 3, 1, 2, 1],
            "midi": [49, 56, 59, 64, 68],
            "suffix": "m7",
            "fingers": [0, 1, 3, 1, 2, 1],
            "barres": [1]
        }, {
            "frets": [-1, -1, 2, 2, 1, 3],
            "suffix": "m7",
            "fingers": [0, 0, 2, 3, 1, 4],
            "barres": [],
            "midi": [56, 61, 64, 71],
            "key": "C#",
            "baseFret": 5
        }, {
            "capo": true,
            "barres": [1],
            "fingers": [1, 4, 1, 1, 1, 1],
            "baseFret": 9,
            "key": "C#",
            "midi": [49, 56, 59, 64, 68, 73],
            "frets": [1, 3, 1, 1, 1, 1],
            "suffix": "m7"
        }, {
            "midi": [61, 68, 71, 76],
            "suffix": "m7",
            "key": "C#",
            "fingers": [0, 0, 1, 4, 2, 3],
            "barres": [],
            "frets": [-1, -1, 1, 3, 2, 2],
            "baseFret": 11
        }, {
            "baseFret": 4,
            "key": "C#",
            "suffix": "m7b5",
            "fingers": [0, 1, 3, 2, 4, 0],
            "midi": [49, 55, 59, 64],
            "frets": [-1, 1, 2, 1, 2, -1],
            "barres": []
        }, {
            "midi": [55, 61, 64, 71],
            "frets": [-1, -1, 1, 2, 1, 3],
            "fingers": [0, 0, 1, 2, 1, 4],
            "barres": [1],
            "baseFret": 5,
            "capo": true,
            "key": "C#",
            "suffix": "m7b5"
        }, {
            "barres": [],
            "key": "C#",
            "suffix": "m7b5",
            "fingers": [2, 0, 3, 4, 1, 0],
            "baseFret": 8,
            "midi": [49, 59, 64, 67],
            "frets": [2, -1, 2, 2, 1, -1]
        }, {
            "frets": [-1, -1, 1, 2, 2, 2],
            "key": "C#",
            "baseFret": 11,
            "fingers": [0, 0, 1, 2, 2, 2],
            "midi": [61, 67, 71, 76],
            "suffix": "m7b5",
            "barres": [2]
        }, {
            "key": "C#",
            "midi": [49, 52, 59, 63, 68],
            "suffix": "m9",
            "fingers": [0, 2, 1, 3, 4, 4],
            "baseFret": 1,
            "frets": [-1, 4, 2, 4, 4, 4],
            "barres": [4]
        }, {
            "midi": [51, 56, 61, 64, 71],
            "barres": [2],
            "frets": [-1, 2, 2, 2, 1, 3],
            "fingers": [0, 2, 2, 3, 1, 4],
            "baseFret": 5,
            "key": "C#",
            "suffix": "m9"
        }, {
            "key": "C#",
            "midi": [52, 59, 63, 68, 73],
            "barres": [3],
            "fingers": [0, 1, 3, 2, 4, 4],
            "frets": [-1, 1, 3, 2, 3, 3],
            "suffix": "m9",
            "baseFret": 7
        }, {
            "key": "C#",
            "midi": [49, 56, 59, 64, 68, 75],
            "baseFret": 9,
            "barres": [1],
            "frets": [1, 3, 1, 1, 1, 3],
            "capo": true,
            "fingers": [1, 3, 1, 1, 1, 4],
            "suffix": "m9"
        }, {
            "suffix": "m6/9",
            "key": "C#",
            "midi": [49, 51, 58, 61, 64],
            "barres": [],
            "baseFret": 1,
            "frets": [-1, 4, 1, 3, 2, 0],
            "fingers": [0, 4, 1, 3, 2, 0]
        }, {
            "barres": [],
            "midi": [49, 52, 58, 63],
            "frets": [-1, 4, 2, 3, 4, -1],
            "suffix": "m6/9",
            "key": "C#",
            "baseFret": 1,
            "fingers": [0, 3, 1, 2, 4, 0]
        }, {
            "frets": [3, 1, 2, 2, -1, 0],
            "midi": [49, 52, 58, 63, 64],
            "suffix": "m6/9",
            "fingers": [4, 1, 2, 3, 0, 0],
            "key": "C#",
            "barres": [],
            "baseFret": 7
        }, {
            "fingers": [0, 2, 2, 1, 3, 4],
            "suffix": "m6/9",
            "midi": [56, 61, 64, 70, 75],
            "barres": [3],
            "frets": [-1, 3, 3, 1, 3, 3],
            "key": "C#",
            "baseFret": 9
        }, {
            "fingers": [0, 2, 1, 3, 1, 1],
            "key": "C#",
            "frets": [-1, 4, 2, 4, 2, 2],
            "capo": true,
            "suffix": "m11",
            "baseFret": 1,
            "barres": [2],
            "midi": [49, 52, 59, 61, 66]
        }, {
            "frets": [3, 1, 3, 2, 1, 1],
            "key": "C#",
            "barres": [1],
            "capo": true,
            "fingers": [3, 1, 4, 2, 1, 1],
            "suffix": "m11",
            "midi": [49, 52, 59, 63, 66, 71],
            "baseFret": 7
        }, {
            "key": "C#",
            "fingers": [1, 1, 1, 1, 1, 4],
            "frets": [1, 1, 1, 1, 1, 3],
            "midi": [49, 54, 59, 64, 68, 75],
            "capo": true,
            "suffix": "m11",
            "barres": [1],
            "baseFret": 9
        }, {
            "baseFret": 11,
            "key": "C#",
            "barres": [1],
            "frets": [-1, -1, 1, 1, 2, 2],
            "suffix": "m11",
            "midi": [61, 66, 71, 76],
            "fingers": [0, 0, 1, 1, 2, 3]
        }, {
            "barres": [1],
            "midi": [49, 52, 56, 60],
            "frets": [-1, 4, 2, 1, 1, -1],
            "fingers": [0, 4, 2, 1, 1, 0],
            "key": "C#",
            "suffix": "mmaj7",
            "baseFret": 1
        }, {
            "capo": true,
            "frets": [1, 1, 3, 2, 2, 1],
            "barres": [1],
            "suffix": "mmaj7",
            "fingers": [1, 1, 4, 2, 3, 1],
            "baseFret": 4,
            "midi": [44, 49, 56, 60, 64, 68],
            "key": "C#"
        }, {
            "fingers": [1, 3, 2, 1, 1, 1],
            "frets": [1, 3, 2, 1, 1, 1],
            "barres": [1],
            "midi": [49, 56, 60, 64, 68, 73],
            "baseFret": 9,
            "capo": true,
            "key": "C#",
            "suffix": "mmaj7"
        }, {
            "capo": true,
            "midi": [56, 61, 68, 72, 76],
            "baseFret": 11,
            "frets": [-1, 1, 1, 3, 3, 2],
            "key": "C#",
            "suffix": "mmaj7",
            "fingers": [0, 1, 1, 3, 4, 2],
            "barres": [1]
        }, {
            "baseFret": 1,
            "barres": [],
            "midi": [49, 52, 55, 60, 64],
            "key": "C#",
            "suffix": "mmaj7b5",
            "fingers": [0, 4, 2, 0, 1, 0],
            "frets": [-1, 4, 2, 0, 1, 0]
        }, {
            "suffix": "mmaj7b5",
            "frets": [-1, 1, 2, 2, 2, -1],
            "key": "C#",
            "barres": [],
            "baseFret": 4,
            "midi": [49, 55, 60, 64],
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "key": "C#",
            "capo": true,
            "suffix": "mmaj7b5",
            "fingers": [1, 2, 2, 1, 0, 1],
            "frets": [1, 2, 2, 1, -1, 1],
            "barres": [1],
            "midi": [49, 55, 60, 64, 73],
            "baseFret": 9
        }, {
            "frets": [-1, -1, 1, 2, 3, 2],
            "baseFret": 11,
            "key": "C#",
            "barres": [],
            "midi": [61, 67, 72, 76],
            "fingers": [0, 0, 1, 2, 4, 3],
            "suffix": "mmaj7b5"
        }, {
            "baseFret": 1,
            "midi": [49, 51, 56, 60, 64],
            "barres": [1],
            "key": "C#",
            "capo": true,
            "fingers": [0, 4, 1, 1, 1, 0],
            "suffix": "mmaj9",
            "frets": [-1, 4, 1, 1, 1, 0]
        }, {
            "midi": [49, 52, 60, 63, 64],
            "key": "C#",
            "fingers": [0, 2, 1, 4, 3, 0],
            "frets": [-1, 3, 1, 4, 3, 0],
            "barres": [],
            "suffix": "mmaj9",
            "baseFret": 2
        }, {
            "barres": [1],
            "key": "C#",
            "baseFret": 4,
            "frets": [1, 1, 3, 2, 1, 0],
            "suffix": "mmaj9",
            "fingers": [1, 1, 4, 3, 2, 0],
            "midi": [44, 49, 56, 60, 63, 64]
        }, {
            "midi": [49, 56, 60, 64, 68, 75],
            "barres": [1],
            "capo": true,
            "key": "C#",
            "frets": [1, 3, 2, 1, 1, 3],
            "suffix": "mmaj9",
            "fingers": [1, 3, 2, 1, 1, 4],
            "baseFret": 9
        }, {
            "midi": [49, 52, 60, 63, 66],
            "barres": [1],
            "baseFret": 2,
            "suffix": "mmaj11",
            "capo": true,
            "key": "C#",
            "fingers": [0, 3, 1, 4, 3, 1],
            "frets": [-1, 3, 1, 4, 3, 1]
        }, {
            "fingers": [1, 1, 1, 2, 3, 1],
            "midi": [44, 49, 54, 60, 64, 68],
            "key": "C#",
            "frets": [1, 1, 1, 2, 2, 1],
            "capo": true,
            "barres": [1],
            "suffix": "mmaj11",
            "baseFret": 4
        }, {
            "midi": [49, 54, 60, 64, 68, 75],
            "suffix": "mmaj11",
            "baseFret": 9,
            "key": "C#",
            "frets": [1, 1, 2, 1, 1, 3],
            "fingers": [1, 1, 2, 1, 1, 4],
            "barres": [1],
            "capo": true
        }, {
            "suffix": "mmaj11",
            "capo": true,
            "baseFret": 11,
            "midi": [61, 66, 72, 76],
            "frets": [-1, -1, 1, 1, 3, 2],
            "barres": [1],
            "fingers": [0, 0, 1, 1, 3, 2],
            "key": "C#"
        }, {
            "baseFret": 1,
            "capo": true,
            "key": "C#",
            "suffix": "add9",
            "frets": [-1, 4, 3, 1, 4, 1],
            "midi": [49, 53, 56, 63, 65],
            "barres": [1],
            "fingers": [0, 3, 2, 1, 4, 1]
        }, {
            "key": "C#",
            "frets": [-1, 4, 3, -1, 4, 4],
            "baseFret": 1,
            "barres": [],
            "suffix": "add9",
            "fingers": [0, 2, 1, 0, 3, 4],
            "midi": [49, 53, 63, 68]
        }, {
            "frets": [2, 1, -1, 1, 2, -1],
            "midi": [49, 53, 63, 68],
            "baseFret": 8,
            "barres": [],
            "fingers": [3, 1, 0, 2, 4, 0],
            "suffix": "add9",
            "key": "C#"
        }, {
            "barres": [],
            "midi": [61, 65, 68, 75],
            "suffix": "add9",
            "frets": [-1, -1, 3, 2, 1, 3],
            "baseFret": 9,
            "key": "C#",
            "fingers": [0, 0, 3, 2, 1, 4]
        }, {
            "frets": [-1, 4, 2, 1, 4, -1],
            "fingers": [0, 3, 2, 1, 4, 0],
            "suffix": "madd9",
            "barres": [],
            "key": "C#",
            "midi": [49, 52, 56, 63],
            "baseFret": 1
        }, {
            "suffix": "madd9",
            "barres": [],
            "midi": [49, 56, 61, 63, 64],
            "key": "C#",
            "baseFret": 4,
            "frets": [-1, 1, 3, 3, 1, 0],
            "fingers": [0, 1, 3, 4, 2, 0]
        }, {
            "frets": [3, 1, -1, 2, 3, 0],
            "suffix": "madd9",
            "fingers": [3, 1, 0, 2, 4, 0],
            "midi": [49, 52, 63, 68, 64],
            "key": "C#",
            "barres": [],
            "baseFret": 7
        }, {
            "fingers": [0, 0, 3, 1, 1, 4],
            "key": "C#",
            "midi": [61, 64, 68, 75],
            "barres": [1],
            "capo": true,
            "suffix": "madd9",
            "baseFret": 9,
            "frets": [-1, -1, 3, 1, 1, 3]
        }, {
            "suffix": "major",
            "barres": [],
            "fingers": [0, 0, 0, 1, 3, 2],
            "frets": [-1, -1, 0, 2, 3, 2],
            "baseFret": 1,
            "midi": [50, 57, 62, 66],
            "key": "D"
        }, {
            "barres": [1],
            "key": "D",
            "fingers": [1, 4, 3, 1, 2, 1],
            "midi": [42, 50, 54, 57, 62, 66],
            "baseFret": 2,
            "frets": [1, 4, 3, 1, 2, 1],
            "capo": true,
            "suffix": "major"
        }, {
            "suffix": "major",
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [45, 50, 57, 62, 66, 69],
            "frets": [1, 1, 3, 3, 3, 1],
            "barres": [1],
            "capo": true,
            "baseFret": 5,
            "key": "D"
        }, {
            "key": "D",
            "fingers": [1, 3, 4, 2, 1, 1],
            "barres": [1],
            "suffix": "major",
            "baseFret": 10,
            "frets": [1, 3, 3, 2, 1, 1],
            "midi": [50, 57, 62, 66, 69, 74],
            "capo": true
        }, {
            "frets": [-1, -1, 0, 2, 3, 1],
            "baseFret": 1,
            "key": "D",
            "suffix": "minor",
            "midi": [50, 57, 62, 65],
            "barres": [],
            "fingers": [0, 0, 0, 2, 3, 1]
        }, {
            "capo": true,
            "midi": [45, 50, 57, 62, 65, 69],
            "frets": [1, 1, 3, 3, 2, 1],
            "baseFret": 5,
            "suffix": "minor",
            "barres": [1],
            "key": "D",
            "fingers": [1, 1, 3, 4, 2, 1]
        }, {
            "midi": [53, 57, 62, 65],
            "fingers": [0, 4, 2, 3, 1, 0],
            "suffix": "minor",
            "frets": [-1, 3, 2, 2, 1, -1],
            "key": "D",
            "barres": [],
            "baseFret": 6
        }, {
            "fingers": [1, 3, 4, 1, 1, 1],
            "key": "D",
            "frets": [1, 3, 3, 1, 1, 1],
            "midi": [50, 57, 62, 65, 69, 74],
            "barres": [1],
            "capo": true,
            "suffix": "minor",
            "baseFret": 10
        }, {
            "key": "D",
            "fingers": [0, 0, 0, 1, 0, 2],
            "baseFret": 1,
            "barres": [],
            "suffix": "dim",
            "frets": [-1, -1, 0, 1, -1, 1],
            "midi": [50, 56, 65]
        }, {
            "midi": [50, 53, 62, 68],
            "barres": [],
            "baseFret": 3,
            "fingers": [0, 4, 1, 0, 2, 3],
            "frets": [-1, 3, 1, -1, 1, 2],
            "key": "D",
            "suffix": "dim"
        }, {
            "baseFret": 5,
            "barres": [],
            "frets": [-1, 1, 2, 3, 2, -1],
            "midi": [50, 56, 62, 65],
            "key": "D",
            "fingers": [0, 1, 2, 4, 3, 0],
            "suffix": "dim"
        }, {
            "barres": [],
            "fingers": [3, 1, 0, 4, 2, 0],
            "baseFret": 8,
            "frets": [3, 1, -1, 3, 2, -1],
            "suffix": "dim",
            "key": "D",
            "midi": [50, 53, 65, 68]
        }, {
            "suffix": "dim7",
            "midi": [50, 56, 59, 65],
            "fingers": [0, 0, 0, 2, 0, 3],
            "barres": [],
            "baseFret": 1,
            "key": "D",
            "frets": [-1, -1, 0, 1, 0, 1]
        }, {
            "midi": [50, 56, 59, 65, 68],
            "fingers": [0, 2, 3, 1, 4, 1],
            "capo": true,
            "key": "D",
            "frets": [-1, 2, 3, 1, 3, 1],
            "baseFret": 4,
            "barres": [1],
            "suffix": "dim7"
        }, {
            "key": "D",
            "fingers": [0, 2, 0, 4, 3, 1],
            "midi": [53, 50, 65, 68, 71],
            "barres": [],
            "frets": [-1, 2, 0, 4, 3, 1],
            "suffix": "dim7",
            "baseFret": 7
        }, {
            "barres": [1],
            "capo": true,
            "suffix": "dim7",
            "baseFret": 10,
            "fingers": [1, 2, 3, 1, 4, 1],
            "key": "D",
            "frets": [1, 2, 3, 1, 3, 1],
            "midi": [50, 56, 62, 65, 71, 74]
        }, {
            "frets": [-1, -1, 0, 2, 3, 0],
            "suffix": "sus2",
            "baseFret": 1,
            "midi": [50, 57, 62, 64],
            "fingers": [0, 0, 0, 2, 3, 0],
            "key": "D",
            "barres": []
        }, {
            "fingers": [0, 0, 1, 1, 2, 4],
            "suffix": "sus2",
            "key": "D",
            "midi": [52, 57, 62, 69],
            "barres": [1],
            "frets": [-1, -1, 1, 1, 2, 4],
            "baseFret": 2
        }, {
            "baseFret": 5,
            "suffix": "sus2",
            "key": "D",
            "fingers": [1, 1, 3, 4, 1, 1],
            "frets": [1, 1, 3, 3, 1, 1],
            "midi": [45, 50, 57, 62, 64, 69],
            "barres": [1],
            "capo": true
        }, {
            "suffix": "sus2",
            "fingers": [0, 1, 1, 1, 4, 4],
            "key": "D",
            "baseFret": 7,
            "frets": [-1, 1, 1, 1, 4, 4],
            "barres": [1, 4],
            "capo": true,
            "midi": [52, 57, 62, 69, 74]
        }, {
            "baseFret": 1,
            "key": "D",
            "frets": [-1, -1, 0, 2, 3, 3],
            "suffix": "sus4",
            "fingers": [0, 0, 0, 1, 2, 3],
            "midi": [50, 57, 62, 67],
            "barres": []
        }, {
            "suffix": "sus4",
            "midi": [50, 50, 55, 62, 69],
            "barres": [],
            "frets": [-1, 3, 0, 0, 1, 3],
            "baseFret": 3,
            "fingers": [0, 3, 0, 0, 1, 4],
            "key": "D"
        }, {
            "baseFret": 5,
            "frets": [1, 1, 3, 3, 4, 1],
            "midi": [45, 50, 57, 62, 67, 69],
            "barres": [1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "capo": true,
            "suffix": "sus4",
            "key": "D"
        }, {
            "frets": [1, 3, 3, 3, 1, 1],
            "barres": [1],
            "key": "D",
            "suffix": "sus4",
            "baseFret": 10,
            "midi": [50, 57, 62, 67, 69, 74],
            "capo": true,
            "fingers": [1, 2, 3, 4, 1, 1]
        }, {
            "baseFret": 1,
            "midi": [50, 57, 60, 67],
            "fingers": [0, 0, 0, 2, 1, 4],
            "frets": [-1, -1, 0, 2, 1, 3],
            "suffix": "7sus4",
            "barres": [],
            "key": "D"
        }, {
            "key": "D",
            "suffix": "7sus4",
            "baseFret": 3,
            "frets": [-1, 3, 3, 3, 1, -1],
            "fingers": [0, 2, 3, 4, 1, 0],
            "midi": [50, 55, 60, 62],
            "barres": []
        }, {
            "suffix": "7sus4",
            "fingers": [1, 1, 3, 1, 4, 1],
            "key": "D",
            "capo": true,
            "frets": [1, 1, 3, 1, 4, 1],
            "barres": [1],
            "baseFret": 5,
            "midi": [45, 50, 57, 60, 67, 69]
        }, {
            "fingers": [1, 3, 1, 4, 1, 1],
            "key": "D",
            "barres": [1],
            "baseFret": 10,
            "midi": [50, 57, 60, 67, 69, 74],
            "suffix": "7sus4",
            "capo": true,
            "frets": [1, 3, 1, 3, 1, 1]
        }, {
            "key": "D",
            "fingers": [0, 0, 0, 1, 3, 2],
            "suffix": "alt",
            "midi": [50, 56, 62, 66],
            "frets": [-1, -1, 0, 1, 3, 2],
            "baseFret": 1,
            "barres": []
        }, {
            "barres": [],
            "fingers": [0, 4, 2, 0, 1, 3],
            "midi": [50, 54, 62, 68],
            "suffix": "alt",
            "baseFret": 3,
            "key": "D",
            "frets": [-1, 3, 2, -1, 1, 2]
        }, {
            "key": "D",
            "barres": [],
            "midi": [50, 56, 62, 66],
            "frets": [-1, 1, 2, 3, 3, -1],
            "suffix": "alt",
            "fingers": [0, 1, 2, 3, 4, 0],
            "baseFret": 5
        }, {
            "suffix": "alt",
            "frets": [-1, 3, 0, 3, 1, 2],
            "barres": [],
            "fingers": [0, 3, 0, 4, 1, 2],
            "midi": [56, 50, 66, 68, 74],
            "baseFret": 9,
            "key": "D"
        }, {
            "baseFret": 1,
            "frets": [-1, -1, 0, 3, 3, 2],
            "barres": [],
            "fingers": [0, 0, 0, 2, 3, 1],
            "key": "D",
            "midi": [50, 58, 62, 66],
            "suffix": "aug"
        }, {
            "baseFret": 3,
            "midi": [50, 54, 58, 62],
            "suffix": "aug",
            "frets": [-1, 3, 2, 1, 1, -1],
            "key": "D",
            "barres": [1],
            "fingers": [0, 3, 2, 1, 1, 0]
        }, {
            "frets": [4, 3, 2, 1, 1, -1],
            "midi": [50, 54, 58, 62, 66],
            "baseFret": 7,
            "key": "D",
            "suffix": "aug",
            "fingers": [4, 3, 2, 1, 1, 0],
            "barres": [1]
        }, {
            "barres": [],
            "baseFret": 10,
            "midi": [50, 62, 66, 70],
            "key": "D",
            "fingers": [1, 0, 4, 2, 3, 0],
            "frets": [1, -1, 3, 2, 2, -1],
            "suffix": "aug"
        }, {
            "fingers": [0, 0, 0, 2, 0, 3],
            "barres": [],
            "frets": [-1, -1, 0, 2, 0, 2],
            "midi": [50, 57, 59, 66],
            "key": "D",
            "baseFret": 1,
            "suffix": "6"
        }, {
            "midi": [50, 54, 59, 62],
            "baseFret": 3,
            "fingers": [0, 4, 2, 3, 1, 0],
            "key": "D",
            "suffix": "6",
            "frets": [-1, 3, 2, 2, 1, -1],
            "barres": []
        }, {
            "barres": [3],
            "key": "D",
            "fingers": [0, 1, 3, 3, 3, 4],
            "baseFret": 5,
            "frets": [-1, 1, 3, 3, 3, 3],
            "suffix": "6",
            "midi": [50, 57, 62, 66, 71]
        }, {
            "midi": [47, 54, 57, 62, 69, 71],
            "frets": [1, 3, 1, 1, 4, 1],
            "fingers": [1, 3, 1, 1, 4, 1],
            "baseFret": 7,
            "key": "D",
            "barres": [1],
            "suffix": "6",
            "capo": true
        }, {
            "barres": [],
            "key": "D",
            "baseFret": 2,
            "suffix": "6/9",
            "fingers": [0, 4, 3, 1, 0, 0],
            "midi": [50, 54, 57, 59, 64],
            "frets": [-1, 4, 3, 1, 0, 0]
        }, {
            "barres": [1],
            "midi": [50, 54, 59, 64, 69],
            "fingers": [0, 2, 1, 1, 3, 4],
            "suffix": "6/9",
            "frets": [-1, 2, 1, 1, 2, 2],
            "key": "D",
            "baseFret": 4
        }, {
            "baseFret": 9,
            "key": "D",
            "midi": [50, 54, 59, 64, 69, 74],
            "barres": [1],
            "frets": [2, 1, 1, 1, 2, 2],
            "capo": true,
            "fingers": [2, 1, 1, 1, 3, 4],
            "suffix": "6/9"
        }, {
            "baseFret": 11,
            "key": "D",
            "suffix": "6/9",
            "barres": [2],
            "frets": [-1, 2, 2, 1, 2, 2],
            "fingers": [0, 2, 2, 1, 3, 4],
            "midi": [57, 62, 66, 71, 76]
        }, {
            "fingers": [0, 0, 0, 2, 1, 3],
            "barres": [],
            "frets": [-1, -1, 0, 2, 1, 2],
            "baseFret": 1,
            "suffix": "7",
            "key": "D",
            "midi": [50, 57, 60, 66]
        }, {
            "frets": [-1, 3, 2, 3, 1, -1],
            "midi": [50, 54, 60, 62],
            "suffix": "7",
            "key": "D",
            "baseFret": 3,
            "fingers": [0, 3, 2, 4, 1, 0],
            "barres": []
        }, {
            "capo": true,
            "baseFret": 5,
            "barres": [1],
            "midi": [45, 50, 57, 60, 66, 69],
            "key": "D",
            "fingers": [1, 1, 3, 1, 4, 1],
            "suffix": "7",
            "frets": [1, 1, 3, 1, 3, 1]
        }, {
            "midi": [50, 57, 60, 66, 69, 74],
            "barres": [1],
            "fingers": [1, 3, 1, 2, 1, 1],
            "key": "D",
            "suffix": "7",
            "frets": [1, 3, 1, 2, 1, 1],
            "capo": true,
            "baseFret": 10
        }, {
            "fingers": [0, 0, 0, 1, 1, 2],
            "key": "D",
            "suffix": "7b5",
            "baseFret": 1,
            "barres": [1],
            "midi": [50, 56, 60, 66],
            "frets": [-1, -1, 0, 1, 1, 2]
        }, {
            "suffix": "7b5",
            "fingers": [0, 0, 2, 4, 1, 3],
            "barres": [],
            "baseFret": 3,
            "midi": [54, 60, 62, 68],
            "frets": [-1, -1, 2, 3, 1, 2],
            "key": "D"
        }, {
            "baseFret": 5,
            "key": "D",
            "suffix": "7b5",
            "frets": [-1, 1, 2, 1, 3, -1],
            "midi": [50, 56, 60, 66],
            "barres": [1],
            "fingers": [0, 1, 2, 1, 3, 0]
        }, {
            "midi": [50, 60, 66, 68],
            "suffix": "7b5",
            "frets": [2, -1, 2, 3, 1, -1],
            "baseFret": 9,
            "key": "D",
            "fingers": [2, 0, 3, 4, 1, 0],
            "barres": []
        }, {
            "barres": [],
            "key": "D",
            "baseFret": 1,
            "suffix": "aug7",
            "fingers": [0, 0, 0, 4, 1, 2],
            "midi": [50, 58, 60, 66],
            "frets": [-1, -1, 0, 3, 1, 2]
        }, {
            "barres": [],
            "midi": [50, 54, 60, 70],
            "key": "D",
            "suffix": "aug7",
            "fingers": [0, 2, 1, 3, 0, 4],
            "frets": [-1, 2, 1, 2, -1, 3],
            "baseFret": 4
        }, {
            "key": "D",
            "barres": [1],
            "capo": true,
            "suffix": "aug7",
            "frets": [-1, 1, 4, 1, 3, 2],
            "fingers": [0, 1, 4, 1, 3, 2],
            "baseFret": 5,
            "midi": [50, 58, 60, 66, 70]
        }, {
            "fingers": [1, 0, 2, 3, 4, 0],
            "key": "D",
            "midi": [50, 60, 66, 70],
            "suffix": "aug7",
            "barres": [],
            "frets": [1, -1, 1, 2, 2, -1],
            "baseFret": 10
        }, {
            "key": "D",
            "barres": [2],
            "frets": [2, 2, 1, 2, 2, 2],
            "fingers": [2, 2, 1, 3, 3, 4],
            "baseFret": 4,
            "midi": [45, 50, 54, 60, 64, 69],
            "suffix": "9"
        }, {
            "suffix": "9",
            "fingers": [0, 1, 0, 2, 3, 4],
            "midi": [52, 50, 62, 66, 72],
            "frets": [-1, 1, 0, 1, 1, 2],
            "baseFret": 7,
            "barres": [],
            "key": "D"
        }, {
            "fingers": [2, 1, 3, 1, 4, 0],
            "suffix": "9",
            "capo": true,
            "frets": [2, 1, 2, 1, 2, -1],
            "key": "D",
            "barres": [1],
            "baseFret": 9,
            "midi": [50, 54, 60, 64, 69]
        }, {
            "frets": [1, 3, 1, 2, 1, 3],
            "fingers": [1, 3, 1, 2, 1, 4],
            "capo": true,
            "midi": [50, 57, 60, 66, 69, 76],
            "suffix": "9",
            "key": "D",
            "baseFret": 10,
            "barres": [1]
        }, {
            "capo": true,
            "frets": [-1, 2, 1, 2, 2, 1],
            "key": "D",
            "suffix": "9b5",
            "barres": [1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 4,
            "midi": [50, 54, 60, 64, 68]
        }, {
            "key": "D",
            "barres": [],
            "fingers": [0, 1, 3, 2, 4, 0],
            "frets": [-1, 1, 2, 1, 3, 0],
            "baseFret": 5,
            "suffix": "9b5",
            "midi": [50, 56, 60, 66, 64]
        }, {
            "baseFret": 9,
            "fingers": [2, 1, 3, 1, 1, 4],
            "frets": [2, 1, 2, 1, 1, 2],
            "key": "D",
            "barres": [1],
            "suffix": "9b5",
            "midi": [50, 54, 60, 64, 68, 74],
            "capo": true
        }, {
            "midi": [50, 56, 60, 66, 76],
            "fingers": [1, 2, 1, 3, 0, 4],
            "suffix": "9b5",
            "frets": [1, 2, 1, 2, -1, 3],
            "key": "D",
            "baseFret": 10,
            "barres": [1]
        }, {
            "fingers": [0, 2, 1, 3, 3, 4],
            "barres": [2],
            "baseFret": 4,
            "suffix": "aug9",
            "midi": [50, 54, 60, 64, 70],
            "key": "D",
            "frets": [-1, 2, 1, 2, 2, 3]
        }, {
            "fingers": [0, 3, 0, 1, 4, 2],
            "barres": [],
            "key": "D",
            "suffix": "aug9",
            "frets": [-1, 3, 0, 1, 3, 2],
            "baseFret": 5,
            "midi": [52, 50, 60, 66, 70]
        }, {
            "baseFret": 9,
            "capo": true,
            "key": "D",
            "suffix": "aug9",
            "fingers": [2, 1, 3, 1, 4, 0],
            "frets": [2, 1, 2, 1, 3, -1],
            "midi": [50, 54, 60, 64, 70],
            "barres": [1]
        }, {
            "key": "D",
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 10,
            "barres": [],
            "suffix": "aug9",
            "frets": [1, -1, 1, 2, 2, 0],
            "midi": [50, 60, 66, 70, 64]
        }, {
            "barres": [],
            "key": "D",
            "suffix": "7b9",
            "baseFret": 2,
            "midi": [50, 60, 63, 66],
            "fingers": [0, 0, 0, 4, 3, 1],
            "frets": [-1, -1, 0, 4, 3, 1]
        }, {
            "baseFret": 4,
            "capo": true,
            "barres": [1],
            "fingers": [0, 2, 1, 3, 1, 4],
            "midi": [50, 54, 60, 63, 69],
            "frets": [-1, 2, 1, 2, 1, 2],
            "key": "D",
            "suffix": "7b9"
        }, {
            "fingers": [0, 2, 0, 1, 4, 1],
            "suffix": "7b9",
            "key": "D",
            "frets": [-1, 2, 0, 1, 3, 1],
            "baseFret": 5,
            "barres": [1],
            "midi": [51, 50, 60, 66, 69]
        }, {
            "frets": [3, 2, 3, 1, -1, -1],
            "midi": [50, 54, 60, 63],
            "key": "D",
            "barres": [],
            "fingers": [3, 2, 4, 1, 0, 0],
            "baseFret": 8,
            "suffix": "7b9"
        }, {
            "fingers": [0, 2, 1, 3, 4, 0],
            "midi": [50, 54, 60, 65],
            "frets": [-1, 2, 1, 2, 3, -1],
            "suffix": "7#9",
            "baseFret": 4,
            "key": "D",
            "barres": []
        }, {
            "fingers": [0, 0, 0, 4, 1, 2],
            "frets": [0, 0, 0, 4, 1, 2],
            "midi": [40, 45, 50, 65, 66, 72],
            "suffix": "7#9",
            "barres": [],
            "baseFret": 7,
            "key": "D"
        }, {
            "capo": true,
            "midi": [53, 57, 62, 66, 72],
            "frets": [-1, 2, 1, 1, 1, 2],
            "suffix": "7#9",
            "key": "D",
            "barres": [1],
            "fingers": [0, 2, 1, 1, 1, 3],
            "baseFret": 7
        }, {
            "fingers": [1, 3, 1, 2, 1, 4],
            "key": "D",
            "suffix": "7#9",
            "barres": [1],
            "midi": [50, 57, 60, 66, 69, 77],
            "frets": [1, 3, 1, 2, 1, 4],
            "capo": true,
            "baseFret": 10
        }, {
            "key": "D",
            "baseFret": 1,
            "frets": [-1, -1, 0, 0, 1, 2],
            "midi": [50, 55, 60, 66],
            "fingers": [0, 0, 0, 0, 1, 2],
            "barres": [],
            "suffix": "11"
        }, {
            "midi": [50, 54, 60, 62, 67],
            "barres": [1],
            "capo": true,
            "frets": [-1, 3, 2, 3, 1, 1],
            "baseFret": 3,
            "fingers": [0, 3, 2, 4, 1, 1],
            "key": "D",
            "suffix": "11"
        }, {
            "key": "D",
            "suffix": "11",
            "baseFret": 5,
            "barres": [1],
            "capo": true,
            "midi": [50, 55, 60, 66, 69],
            "frets": [-1, 1, 1, 1, 3, 1],
            "fingers": [0, 1, 1, 1, 3, 1]
        }, {
            "baseFret": 7,
            "frets": [-1, 3, 1, 1, 2, 2],
            "barres": [2],
            "suffix": "11",
            "fingers": [1, 1, 1, 2, 1, 1],
            "capo": true,
            "key": "D",
            "midi": [54, 57, 62, 67, 72]
        }, {
            "barres": [],
            "key": "D",
            "suffix": "9#11",
            "fingers": [0, 0, 0, 1, 2, 3],
            "midi": [50, 56, 60, 66],
            "baseFret": 1,
            "frets": [-1, -1, 0, 1, 1, 2]
        }, {
            "key": "D",
            "suffix": "9#11",
            "capo": true,
            "frets": [-1, 2, 1, 2, 2, 1],
            "baseFret": 4,
            "midi": [50, 54, 60, 64, 68],
            "fingers": [0, 2, 1, 3, 4, 1],
            "barres": [1]
        }, {
            "barres": [],
            "key": "D",
            "frets": [-1, 3, 0, 1, 3, 2],
            "baseFret": 7,
            "suffix": "9#11",
            "midi": [54, 50, 62, 68, 72],
            "fingers": [0, 3, 0, 1, 4, 2]
        }, {
            "fingers": [2, 1, 3, 1, 1, 4],
            "key": "D",
            "suffix": "9#11",
            "barres": [1],
            "capo": true,
            "frets": [2, 1, 2, 1, 1, 2],
            "baseFret": 9,
            "midi": [50, 54, 60, 64, 68, 74]
        }, {
            "suffix": "13",
            "midi": [50, 59, 60, 66],
            "key": "D",
            "fingers": [0, 0, 0, 4, 1, 2],
            "baseFret": 1,
            "barres": [],
            "frets": [-1, -1, 0, 4, 1, 2]
        }, {
            "frets": [1, 1, 1, 1, 3, 3],
            "key": "D",
            "suffix": "13",
            "barres": [1],
            "fingers": [1, 1, 1, 1, 3, 4],
            "capo": true,
            "midi": [45, 50, 55, 60, 66, 71],
            "baseFret": 5
        }, {
            "baseFret": 8,
            "suffix": "13",
            "key": "D",
            "midi": [50, 54, 50, 64, 59, 72],
            "fingers": [4, 2, 0, 3, 0, 1],
            "barres": [],
            "frets": [3, 2, 0, 2, 0, 1]
        }, {
            "baseFret": 10,
            "fingers": [1, 0, 2, 3, 4, 0],
            "suffix": "13",
            "frets": [1, -1, 1, 2, 3, -1],
            "key": "D",
            "midi": [50, 60, 66, 71],
            "barres": []
        }, {
            "capo": true,
            "key": "D",
            "fingers": [0, 0, 0, 1, 1, 1],
            "suffix": "maj7",
            "baseFret": 1,
            "midi": [50, 57, 61, 66],
            "barres": [2],
            "frets": [-1, -1, 0, 2, 2, 2]
        }, {
            "suffix": "maj7",
            "barres": [1],
            "midi": [50, 54, 57, 61, 66],
            "frets": [-1, 4, 3, 1, 1, 1],
            "baseFret": 2,
            "fingers": [0, 4, 3, 1, 1, 1],
            "capo": true,
            "key": "D"
        }, {
            "key": "D",
            "barres": [1],
            "frets": [1, 1, 3, 2, 3, 1],
            "baseFret": 5,
            "capo": true,
            "fingers": [1, 1, 3, 2, 4, 1],
            "suffix": "maj7",
            "midi": [45, 50, 57, 61, 66, 69]
        }, {
            "capo": true,
            "midi": [57, 62, 66, 73],
            "key": "D",
            "frets": [-1, -1, 1, 1, 1, 3],
            "barres": [1],
            "baseFret": 7,
            "fingers": [0, 0, 1, 1, 1, 4],
            "suffix": "maj7"
        }, {
            "fingers": [0, 0, 0, 1, 2, 3],
            "frets": [-1, -1, 0, 1, 2, 2],
            "suffix": "maj7b5",
            "midi": [50, 56, 61, 66],
            "baseFret": 1,
            "key": "D",
            "barres": []
        }, {
            "baseFret": 5,
            "fingers": [0, 1, 2, 3, 4, 0],
            "midi": [50, 56, 61, 66],
            "barres": [],
            "key": "D",
            "frets": [-1, 1, 2, 2, 3, -1],
            "suffix": "maj7b5"
        }, {
            "barres": [1],
            "suffix": "maj7b5",
            "baseFret": 9,
            "midi": [50, 54, 61, 66, 68, 73],
            "fingers": [2, 1, 3, 4, 1, 1],
            "capo": true,
            "key": "D",
            "frets": [2, 1, 3, 3, 1, 1]
        }, {
            "capo": true,
            "suffix": "maj7b5",
            "barres": [1],
            "fingers": [1, 2, 3, 4, 0, 1],
            "key": "D",
            "midi": [50, 56, 61, 66, 74],
            "baseFret": 10,
            "frets": [1, 2, 2, 2, -1, 1]
        }, {
            "fingers": [0, 0, 0, 4, 2, 3],
            "frets": [-1, -1, 0, 3, 2, 2],
            "baseFret": 1,
            "suffix": "maj7#5",
            "key": "D",
            "midi": [50, 58, 61, 66],
            "barres": []
        }, {
            "key": "D",
            "fingers": [1, 4, 3, 2, 1, 1],
            "baseFret": 2,
            "suffix": "maj7#5",
            "midi": [42, 50, 54, 58, 61, 66],
            "capo": true,
            "frets": [1, 4, 3, 2, 1, 1],
            "barres": [1]
        }, {
            "key": "D",
            "barres": [],
            "baseFret": 5,
            "suffix": "maj7#5",
            "midi": [50, 50, 61, 66, 70],
            "fingers": [0, 1, 0, 2, 4, 3],
            "frets": [-1, 1, 0, 2, 3, 2]
        }, {
            "key": "D",
            "baseFret": 9,
            "barres": [],
            "suffix": "maj7#5",
            "midi": [50, 66, 70, 73],
            "fingers": [0, 0, 0, 2, 3, 1],
            "frets": [-1, -1, 0, 3, 3, 1]
        }, {
            "fingers": [0, 4, 1, 1, 1, 1],
            "baseFret": 2,
            "frets": [-1, 4, 1, 1, 1, 1],
            "key": "D",
            "suffix": "maj9",
            "midi": [50, 52, 57, 61, 66],
            "capo": true,
            "barres": [1]
        }, {
            "fingers": [0, 2, 1, 4, 3, 0],
            "frets": [-1, 2, 1, 3, 1, -1],
            "midi": [50, 54, 61, 63],
            "key": "D",
            "baseFret": 4,
            "suffix": "maj9",
            "barres": []
        }, {
            "midi": [54, 50, 64, 66, 73],
            "fingers": [0, 2, 0, 3, 1, 4],
            "barres": [],
            "suffix": "maj9",
            "key": "D",
            "frets": [-1, 3, 0, 3, 1, 3],
            "baseFret": 7
        }, {
            "suffix": "maj9",
            "barres": [1],
            "frets": [1, -1, 2, 2, 1, 3],
            "midi": [50, 61, 66, 69, 76],
            "fingers": [1, 0, 2, 3, 1, 4],
            "key": "D",
            "baseFret": 10,
            "capo": true
        }, {
            "midi": [50, 55, 61, 66],
            "barres": [2],
            "fingers": [0, 0, 0, 0, 1, 1],
            "baseFret": 1,
            "key": "D",
            "frets": [-1, -1, 0, 0, 2, 2],
            "suffix": "maj11"
        }, {
            "suffix": "maj11",
            "fingers": [1, 1, 1, 2, 3, 1],
            "key": "D",
            "frets": [1, 1, 1, 2, 3, 1],
            "barres": [1],
            "midi": [45, 50, 55, 61, 66, 69],
            "baseFret": 5,
            "capo": true
        }, {
            "baseFret": 7,
            "barres": [],
            "fingers": [0, 3, 0, 1, 2, 4],
            "midi": [54, 50, 62, 67, 73],
            "key": "D",
            "suffix": "maj11",
            "frets": [-1, 3, 0, 1, 2, 3]
        }, {
            "midi": [50, 55, 61, 66, 69, 74],
            "barres": [1],
            "key": "D",
            "frets": [1, 1, 2, 2, 1, 1],
            "baseFret": 10,
            "capo": true,
            "suffix": "maj11",
            "fingers": [1, 1, 2, 3, 1, 1]
        }, {
            "key": "D",
            "fingers": [0, 0, 0, 3, 1, 1],
            "midi": [50, 59, 61, 66],
            "barres": [2],
            "frets": [-1, -1, 0, 4, 2, 2],
            "baseFret": 1,
            "suffix": "maj13"
        }, {
            "suffix": "maj13",
            "barres": [],
            "frets": [-1, 4, 3, 3, 1, 0],
            "midi": [50, 54, 59, 61, 64],
            "fingers": [0, 4, 2, 3, 1, 0],
            "baseFret": 2,
            "key": "D"
        }, {
            "key": "D",
            "barres": [1],
            "suffix": "maj13",
            "frets": [-1, 1, 1, 2, 3, 3],
            "midi": [50, 55, 61, 66, 71],
            "fingers": [0, 1, 1, 2, 3, 4],
            "baseFret": 5
        }, {
            "capo": true,
            "key": "D",
            "midi": [50, 54, 59, 64, 69, 73],
            "barres": [1],
            "fingers": [2, 1, 1, 1, 3, 1],
            "suffix": "maj13",
            "frets": [2, 1, 1, 1, 2, 1],
            "baseFret": 9
        }, {
            "midi": [50, 57, 59, 65],
            "barres": [],
            "fingers": [0, 0, 0, 2, 0, 1],
            "key": "D",
            "baseFret": 1,
            "suffix": "m6",
            "frets": [-1, -1, 0, 2, 0, 1]
        }, {
            "frets": [-1, 3, 1, 2, 1, 3],
            "key": "D",
            "baseFret": 3,
            "capo": true,
            "barres": [1],
            "midi": [50, 53, 59, 62, 69],
            "fingers": [0, 3, 1, 2, 1, 4],
            "suffix": "m6"
        }, {
            "midi": [50, 57, 65, 71],
            "key": "D",
            "baseFret": 5,
            "suffix": "m6",
            "frets": [-1, 1, 3, -1, 2, 3],
            "barres": [],
            "fingers": [0, 1, 3, 0, 2, 4]
        }, {
            "suffix": "m6",
            "fingers": [2, 0, 1, 3, 3, 3],
            "midi": [50, 59, 65, 69, 74],
            "baseFret": 9,
            "key": "D",
            "barres": [2],
            "frets": [2, -1, 1, 2, 2, 2]
        }, {
            "fingers": [0, 0, 0, 3, 1, 2],
            "baseFret": 1,
            "barres": [],
            "midi": [50, 57, 60, 65],
            "key": "D",
            "suffix": "m7",
            "frets": [-1, -1, 0, 2, 1, 1]
        }, {
            "key": "D",
            "suffix": "m7",
            "fingers": [1, 1, 3, 1, 2, 1],
            "barres": [1],
            "midi": [45, 50, 57, 60, 65, 69],
            "frets": [1, 1, 3, 1, 2, 1],
            "baseFret": 5,
            "capo": true
        }, {
            "key": "D",
            "frets": [-1, -1, 2, 2, 1, 3],
            "fingers": [0, 0, 2, 3, 1, 4],
            "suffix": "m7",
            "baseFret": 6,
            "midi": [57, 62, 65, 72],
            "barres": []
        }, {
            "key": "D",
            "baseFret": 10,
            "midi": [50, 57, 60, 65, 69, 74],
            "barres": [1],
            "fingers": [1, 3, 1, 1, 1, 1],
            "capo": true,
            "suffix": "m7",
            "frets": [1, 3, 1, 1, 1, 1]
        }, {
            "baseFret": 1,
            "barres": [1],
            "key": "D",
            "frets": [-1, -1, 0, 1, 1, 1],
            "fingers": [0, 0, 0, 1, 1, 1],
            "midi": [50, 56, 60, 65],
            "suffix": "m7b5"
        }, {
            "baseFret": 3,
            "fingers": [0, 3, 1, 4, 1, 2],
            "frets": [-1, 3, 1, 3, 1, 2],
            "midi": [50, 53, 60, 62, 68],
            "key": "D",
            "barres": [1],
            "suffix": "m7b5"
        }, {
            "baseFret": 5,
            "key": "D",
            "midi": [50, 56, 60, 65],
            "frets": [-1, 1, 2, 1, 2, -1],
            "barres": [],
            "fingers": [0, 1, 3, 2, 4, 0],
            "suffix": "m7b5"
        }, {
            "baseFret": 8,
            "suffix": "m7b5",
            "key": "D",
            "barres": [],
            "fingers": [0, 1, 0, 4, 3, 2],
            "frets": [-1, 1, 0, 3, 2, 1],
            "midi": [53, 50, 65, 68, 72]
        }, {
            "frets": [1, 0, 0, 2, 1, 0],
            "barres": [],
            "midi": [41, 45, 50, 57, 60, 64],
            "fingers": [1, 0, 0, 3, 2, 0],
            "suffix": "m9",
            "baseFret": 1,
            "key": "D"
        }, {
            "baseFret": 3,
            "midi": [50, 53, 60, 64, 69],
            "fingers": [0, 2, 1, 3, 4, 4],
            "barres": [3],
            "frets": [-1, 3, 1, 3, 3, 3],
            "key": "D",
            "suffix": "m9"
        }, {
            "barres": [],
            "key": "D",
            "baseFret": 5,
            "fingers": [0, 1, 4, 2, 3, 0],
            "midi": [50, 57, 60, 65, 64],
            "suffix": "m9",
            "frets": [-1, 1, 3, 1, 2, 0]
        }, {
            "key": "D",
            "midi": [50, 57, 60, 65, 69, 76],
            "suffix": "m9",
            "barres": [1],
            "frets": [1, 3, 1, 1, 1, 3],
            "baseFret": 10,
            "fingers": [1, 3, 1, 1, 1, 4],
            "capo": true
        }, {
            "key": "D",
            "baseFret": 2,
            "frets": [-1, 4, 2, 1, 0, 0],
            "midi": [50, 53, 57, 59, 64],
            "barres": [],
            "fingers": [0, 4, 2, 1, 0, 0],
            "suffix": "m6/9"
        }, {
            "frets": [-1, 3, 1, 2, 3, 0],
            "fingers": [0, 3, 1, 2, 4, 0],
            "baseFret": 3,
            "suffix": "m6/9",
            "key": "D",
            "barres": [],
            "midi": [50, 53, 59, 64, 64]
        }, {
            "key": "D",
            "fingers": [0, 2, 0, 3, 1, 4],
            "barres": [],
            "baseFret": 6,
            "suffix": "m6/9",
            "frets": [-1, 2, 0, 2, 1, 2],
            "midi": [52, 50, 62, 65, 71]
        }, {
            "baseFret": 10,
            "key": "D",
            "suffix": "m6/9",
            "frets": [-1, 3, 3, 1, 3, 3],
            "barres": [3],
            "fingers": [0, 2, 2, 1, 3, 4],
            "midi": [57, 62, 65, 71, 76]
        }, {
            "key": "D",
            "capo": true,
            "frets": [-1, -1, 0, 0, 1, 1],
            "suffix": "m11",
            "midi": [50, 55, 60, 65],
            "barres": [1],
            "baseFret": 1,
            "fingers": [0, 0, 0, 0, 1, 1]
        }, {
            "midi": [50, 53, 60, 64, 67],
            "barres": [1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "frets": [-1, 3, 1, 3, 3, 1],
            "baseFret": 3,
            "capo": true,
            "suffix": "m11",
            "key": "D"
        }, {
            "barres": [1],
            "capo": true,
            "key": "D",
            "frets": [3, 1, 3, 2, 1, 1],
            "suffix": "m11",
            "fingers": [3, 1, 4, 2, 1, 1],
            "baseFret": 8,
            "midi": [50, 53, 60, 64, 67, 72]
        }, {
            "baseFret": 10,
            "fingers": [1, 1, 1, 1, 1, 4],
            "frets": [1, 1, 1, 1, 1, 3],
            "midi": [50, 55, 60, 65, 69, 76],
            "barres": [1],
            "capo": true,
            "key": "D",
            "suffix": "m11"
        }, {
            "fingers": [0, 0, 0, 2, 3, 1],
            "barres": [],
            "key": "D",
            "suffix": "mmaj7",
            "midi": [50, 57, 61, 65],
            "baseFret": 1,
            "frets": [-1, -1, 0, 2, 2, 1]
        }, {
            "midi": [50, 53, 57, 61, 64],
            "key": "D",
            "suffix": "mmaj7",
            "baseFret": 2,
            "barres": [1],
            "frets": [-1, 4, 2, 1, 1, 0],
            "fingers": [0, 4, 2, 1, 1, 0]
        }, {
            "fingers": [1, 1, 4, 2, 3, 1],
            "midi": [45, 50, 57, 61, 65, 69],
            "key": "D",
            "capo": true,
            "suffix": "mmaj7",
            "baseFret": 5,
            "frets": [1, 1, 3, 2, 2, 1],
            "barres": [1]
        }, {
            "baseFret": 10,
            "midi": [50, 57, 61, 65, 69, 74],
            "capo": true,
            "key": "D",
            "barres": [1],
            "suffix": "mmaj7",
            "frets": [1, 3, 2, 1, 1, 1],
            "fingers": [1, 3, 2, 1, 1, 1]
        }, {
            "suffix": "mmaj7b5",
            "baseFret": 1,
            "barres": [],
            "frets": [-1, -1, 0, 1, 2, 1],
            "midi": [50, 56, 61, 65],
            "fingers": [0, 0, 0, 1, 3, 2],
            "key": "D"
        }, {
            "barres": [3],
            "frets": [1, 2, 3, 3, 3, -1],
            "baseFret": 4,
            "key": "D",
            "fingers": [1, 2, 3, 3, 3, 0],
            "midi": [44, 50, 56, 61, 65],
            "suffix": "mmaj7b5"
        }, {
            "baseFret": 5,
            "frets": [-1, 1, 2, 2, 2, -1],
            "midi": [50, 56, 61, 65],
            "barres": [],
            "key": "D",
            "suffix": "mmaj7b5",
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "key": "D",
            "barres": [1],
            "suffix": "mmaj7b5",
            "fingers": [1, 2, 2, 1, 0, 1],
            "midi": [50, 56, 61, 65, 74],
            "capo": true,
            "frets": [1, 2, 2, 1, -1, 1],
            "baseFret": 10
        }, {
            "suffix": "mmaj9",
            "fingers": [0, 2, 1, 4, 3, 0],
            "key": "D",
            "baseFret": 3,
            "midi": [50, 53, 61, 64, 64],
            "barres": [],
            "frets": [-1, 3, 1, 4, 3, 0]
        }, {
            "midi": [52, 50, 61, 65, 69],
            "barres": [],
            "frets": [-1, 3, 0, 2, 2, 1],
            "fingers": [0, 4, 0, 2, 3, 1],
            "key": "D",
            "suffix": "mmaj9",
            "baseFret": 5
        }, {
            "suffix": "mmaj9",
            "midi": [53, 50, 64, 69, 73],
            "barres": [],
            "fingers": [0, 1, 0, 2, 4, 3],
            "baseFret": 8,
            "frets": [-1, 1, 0, 2, 3, 2],
            "key": "D"
        }, {
            "fingers": [1, 3, 2, 1, 1, 4],
            "key": "D",
            "suffix": "mmaj9",
            "barres": [1],
            "midi": [50, 57, 61, 65, 69, 76],
            "baseFret": 10,
            "frets": [1, 3, 2, 1, 1, 3],
            "capo": true
        }, {
            "suffix": "mmaj11",
            "barres": [],
            "baseFret": 1,
            "fingers": [0, 0, 0, 0, 2, 1],
            "midi": [50, 55, 61, 65],
            "frets": [-1, -1, 0, 0, 2, 1],
            "key": "D"
        }, {
            "key": "D",
            "suffix": "mmaj11",
            "capo": true,
            "fingers": [0, 2, 1, 4, 3, 1],
            "midi": [50, 53, 61, 64, 67],
            "barres": [1],
            "baseFret": 3,
            "frets": [-1, 3, 1, 4, 3, 1]
        }, {
            "frets": [1, 1, 1, 3, 3, 1],
            "midi": [45, 50, 55, 62, 66, 69],
            "capo": true,
            "barres": [1],
            "suffix": "mmaj11",
            "fingers": [1, 1, 1, 2, 3, 1],
            "key": "D",
            "baseFret": 5
        }, {
            "capo": true,
            "baseFret": 10,
            "frets": [1, 1, 2, 1, 1, 3],
            "midi": [50, 55, 61, 65, 69, 76],
            "barres": [1],
            "fingers": [1, 1, 2, 1, 1, 4],
            "key": "D",
            "suffix": "mmaj11"
        }, {
            "baseFret": 2,
            "fingers": [0, 3, 2, 1, 4, 1],
            "key": "D",
            "midi": [50, 54, 57, 64, 66],
            "frets": [-1, 4, 3, 1, 4, 1],
            "suffix": "add9",
            "barres": [1]
        }, {
            "suffix": "add9",
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0],
            "frets": [-1, 1, 3, 3, 3, 0],
            "key": "D",
            "baseFret": 5,
            "midi": [50, 57, 62, 66, 64]
        }, {
            "barres": [],
            "suffix": "add9",
            "fingers": [0, 0, 0, 3, 1, 4],
            "midi": [50, 64, 66, 74],
            "key": "D",
            "frets": [-1, -1, 0, 3, 1, 4],
            "baseFret": 7
        }, {
            "baseFret": 10,
            "barres": [],
            "suffix": "add9",
            "key": "D",
            "fingers": [0, 0, 3, 2, 1, 4],
            "frets": [-1, -1, 3, 2, 1, 3],
            "midi": [62, 66, 69, 76]
        }, {
            "key": "D",
            "barres": [],
            "frets": [-1, 4, 2, 1, 2, 0],
            "baseFret": 2,
            "suffix": "madd9",
            "fingers": [0, 4, 2, 1, 3, 0],
            "midi": [50, 53, 57, 62, 64]
        }, {
            "key": "D",
            "barres": [],
            "frets": [-1, 4, 2, 1, 4, -1],
            "suffix": "madd9",
            "baseFret": 2,
            "fingers": [0, 3, 2, 1, 4, 0],
            "midi": [50, 53, 57, 64]
        }, {
            "key": "D",
            "fingers": [0, 1, 3, 4, 2, 0],
            "frets": [-1, 1, 3, 3, 2, 0],
            "midi": [50, 57, 62, 65, 64],
            "suffix": "madd9",
            "barres": [],
            "baseFret": 5
        }, {
            "suffix": "madd9",
            "midi": [62, 65, 69, 76],
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 3, 1, 1, 4],
            "frets": [-1, -1, 3, 1, 1, 3],
            "baseFret": 10,
            "key": "D"
        }, {
            "fingers": [1, 0, 0, 2, 4, 3],
            "suffix": "/F#",
            "midi": [42, 45, 50, 57, 62, 66],
            "barres": [],
            "frets": [2, 0, 0, 2, 3, 2],
            "baseFret": 1,
            "key": "D"
        }, {
            "midi": [42, 50, 54, 57, 62, 66],
            "suffix": "/F#",
            "baseFret": 2,
            "barres": [1],
            "frets": [1, 4, 3, 1, 2, 1],
            "fingers": [1, 4, 3, 1, 2, 1],
            "key": "D"
        }, {
            "baseFret": 2,
            "frets": [-1, -1, 3, 1, 2, 4],
            "midi": [54, 57, 62, 69],
            "barres": [],
            "suffix": "/F#",
            "key": "D",
            "fingers": [0, 0, 3, 1, 2, 4]
        }, {
            "fingers": [0, 0, 0, 1, 3, 2],
            "midi": [45, 50, 57, 62, 66],
            "baseFret": 1,
            "suffix": "/A",
            "key": "D",
            "frets": [-1, 0, 0, 2, 3, 2],
            "barres": []
        }, {
            "suffix": "/A",
            "barres": [1],
            "frets": [1, 1, 3, 3, 3, 1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [45, 50, 57, 62, 66, 69],
            "key": "D",
            "baseFret": 5
        }, {
            "baseFret": 4,
            "frets": [2, 2, 1, 4, 4, -1],
            "key": "D",
            "fingers": [2, 3, 1, 4, 4, 0],
            "midi": [45, 50, 54, 62, 66],
            "barres": [4],
            "suffix": "/A"
        }, {
            "frets": [-1, 1, 0, 2, 3, 2],
            "key": "D",
            "midi": [46, 50, 57, 62, 66],
            "barres": [],
            "baseFret": 1,
            "suffix": "/Bb",
            "fingers": [0, 1, 0, 2, 4, 3]
        }, {
            "key": "D",
            "midi": [46, 54, 57, 62, 66],
            "baseFret": 1,
            "frets": [-1, 1, 4, 2, 3, 2],
            "fingers": [0, 1, 4, 2, 3, 2],
            "barres": [2],
            "suffix": "/Bb"
        }, {
            "barres": [3],
            "frets": [2, 1, 3, 3, 3, -1],
            "baseFret": 5,
            "midi": [46, 50, 57, 62, 66],
            "fingers": [2, 1, 3, 3, 3, 0],
            "suffix": "/Bb",
            "key": "D"
        }, {
            "barres": [],
            "frets": [-1, 2, 0, 2, 3, 2],
            "fingers": [0, 1, 0, 2, 4, 3],
            "baseFret": 1,
            "suffix": "/B",
            "midi": [47, 50, 57, 62, 66],
            "key": "D"
        }, {
            "midi": [47, 54, 57, 62, 66],
            "fingers": [0, 1, 3, 1, 2, 1],
            "frets": [-1, 2, 4, 2, 3, 2],
            "baseFret": 1,
            "key": "D",
            "barres": [2],
            "suffix": "/B"
        }, {
            "frets": [-1, 1, 3, 1, 2, 4],
            "suffix": "/B",
            "midi": [47, 54, 57, 62, 69],
            "key": "D",
            "barres": [1],
            "fingers": [0, 1, 3, 1, 2, 4],
            "baseFret": 2
        }, {
            "fingers": [0, 3, 0, 1, 4, 2],
            "suffix": "/C",
            "barres": [],
            "key": "D",
            "frets": [-1, 3, 0, 2, 3, 2],
            "baseFret": 1,
            "midi": [48, 50, 57, 62, 66]
        }, {
            "baseFret": 1,
            "key": "D",
            "fingers": [0, 2, 4, 1, 3, 1],
            "midi": [48, 54, 57, 62, 66],
            "barres": [2],
            "suffix": "/C",
            "frets": [-1, 3, 4, 2, 3, 2]
        }, {
            "barres": [3],
            "midi": [48, 50, 57, 62, 66],
            "key": "D",
            "fingers": [4, 1, 3, 3, 3, 0],
            "frets": [4, 1, 3, 3, 3, -1],
            "suffix": "/C",
            "baseFret": 5
        }, {
            "baseFret": 1,
            "suffix": "major",
            "key": "Eb",
            "midi": [51, 58, 63, 67],
            "frets": [-1, -1, 1, 3, 4, 3],
            "barres": [],
            "fingers": [0, 0, 1, 2, 4, 3]
        }, {
            "barres": [1],
            "suffix": "major",
            "midi": [51, 55, 58, 63, 67],
            "baseFret": 3,
            "fingers": [0, 4, 3, 1, 2, 1],
            "frets": [-1, 4, 3, 1, 2, 1],
            "key": "Eb"
        }, {
            "barres": [1],
            "capo": true,
            "fingers": [0, 1, 2, 3, 4, 1],
            "frets": [-1, 1, 3, 3, 3, 1],
            "baseFret": 6,
            "suffix": "major",
            "midi": [51, 58, 63, 67, 70],
            "key": "Eb"
        }, {
            "suffix": "major",
            "fingers": [0, 0, 1, 1, 1, 4],
            "midi": [58, 63, 67, 75],
            "barres": [1],
            "baseFret": 8,
            "capo": true,
            "frets": [-1, -1, 1, 1, 1, 4],
            "key": "Eb"
        }, {
            "midi": [51, 58, 63, 66],
            "suffix": "minor",
            "key": "Eb",
            "baseFret": 1,
            "frets": [-1, -1, 1, 3, 4, 2],
            "fingers": [0, 0, 1, 3, 4, 2],
            "barres": []
        }, {
            "key": "Eb",
            "midi": [54, 58, 63, 66],
            "frets": [-1, -1, 4, 3, 4, 2],
            "suffix": "minor",
            "fingers": [0, 0, 3, 2, 4, 1],
            "baseFret": 1,
            "barres": []
        }, {
            "frets": [1, 1, 3, 3, 2, 1],
            "fingers": [1, 1, 3, 4, 2, 1],
            "midi": [46, 51, 58, 63, 66, 70],
            "barres": [1],
            "baseFret": 6,
            "capo": true,
            "suffix": "minor",
            "key": "Eb"
        }, {
            "frets": [1, 3, 3, 1, 1, 1],
            "baseFret": 11,
            "fingers": [1, 3, 4, 1, 1, 1],
            "key": "Eb",
            "midi": [51, 58, 63, 66, 70, 75],
            "suffix": "minor",
            "barres": [1],
            "capo": true
        }, {
            "midi": [51, 57, 66],
            "key": "Eb",
            "barres": [],
            "frets": [-1, -1, 1, 2, -1, 2],
            "fingers": [0, 0, 1, 2, 0, 3],
            "baseFret": 1,
            "suffix": "dim"
        }, {
            "barres": [],
            "suffix": "dim",
            "fingers": [0, 4, 1, 0, 2, 3],
            "frets": [-1, 3, 1, -1, 1, 2],
            "midi": [51, 54, 63, 69],
            "baseFret": 4,
            "key": "Eb"
        }, {
            "suffix": "dim",
            "frets": [-1, 1, 2, 3, 2, -1],
            "fingers": [0, 1, 2, 4, 3, 0],
            "midi": [51, 57, 63, 66],
            "key": "Eb",
            "barres": [],
            "baseFret": 6
        }, {
            "midi": [51, 54, 66, 69],
            "barres": [],
            "fingers": [3, 1, 0, 4, 2, 0],
            "frets": [3, 1, -1, 3, 2, -1],
            "baseFret": 9,
            "suffix": "dim",
            "key": "Eb"
        }, {
            "midi": [51, 57, 60, 66],
            "key": "Eb",
            "baseFret": 1,
            "fingers": [0, 0, 1, 3, 2, 4],
            "barres": [],
            "suffix": "dim7",
            "frets": [-1, -1, 1, 2, 1, 2]
        }, {
            "frets": [-1, 2, 3, 1, 3, 1],
            "baseFret": 5,
            "capo": true,
            "fingers": [0, 2, 3, 1, 4, 1],
            "midi": [51, 57, 60, 66, 69],
            "suffix": "dim7",
            "barres": [1],
            "key": "Eb"
        }, {
            "suffix": "dim7",
            "midi": [57, 63, 66, 72],
            "key": "Eb",
            "barres": [],
            "baseFret": 7,
            "fingers": [0, 0, 1, 3, 2, 4],
            "frets": [-1, -1, 1, 2, 1, 2]
        }, {
            "midi": [51, 60, 66, 69],
            "suffix": "dim7",
            "baseFret": 10,
            "fingers": [2, 0, 1, 3, 1, 0],
            "frets": [2, -1, 1, 2, 1, -1],
            "barres": [1],
            "key": "Eb"
        }, {
            "capo": true,
            "baseFret": 1,
            "key": "Eb",
            "barres": [1],
            "frets": [1, 1, 1, 3, 4, 1],
            "midi": [41, 46, 51, 58, 63, 65],
            "suffix": "sus2",
            "fingers": [1, 1, 1, 3, 4, 1]
        }, {
            "baseFret": 6,
            "key": "Eb",
            "fingers": [1, 1, 3, 4, 1, 1],
            "suffix": "sus2",
            "barres": [1],
            "frets": [1, 1, 3, 3, 1, 1],
            "capo": true,
            "midi": [46, 51, 58, 63, 65, 70]
        }, {
            "key": "Eb",
            "frets": [4, 1, 1, 3, 4, -1],
            "capo": true,
            "midi": [51, 53, 58, 65, 70],
            "fingers": [3, 1, 1, 2, 4, 0],
            "baseFret": 8,
            "suffix": "sus2",
            "barres": [1]
        }, {
            "capo": true,
            "midi": [51, 58, 63, 70, 77],
            "fingers": [1, 2, 3, 0, 1, 4],
            "barres": [1],
            "suffix": "sus2",
            "frets": [1, 3, 3, -1, 1, 3],
            "key": "Eb",
            "baseFret": 11
        }, {
            "fingers": [0, 0, 1, 2, 3, 4],
            "baseFret": 1,
            "suffix": "sus4",
            "key": "Eb",
            "midi": [51, 58, 63, 68],
            "frets": [-1, -1, 1, 3, 4, 4],
            "barres": []
        }, {
            "suffix": "sus4",
            "key": "Eb",
            "barres": [1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [46, 51, 58, 63, 68, 70],
            "frets": [1, 1, 3, 3, 4, 1],
            "capo": true,
            "baseFret": 6
        }, {
            "suffix": "sus4",
            "frets": [-1, -1, 1, 1, 2, -1],
            "fingers": [0, 0, 1, 1, 2, 0],
            "key": "Eb",
            "barres": [1],
            "baseFret": 8,
            "midi": [58, 63, 68]
        }, {
            "frets": [1, 3, 3, 3, 1, 1],
            "baseFret": 11,
            "fingers": [1, 2, 3, 4, 1, 1],
            "key": "Eb",
            "suffix": "sus4",
            "barres": [1],
            "capo": true,
            "midi": [51, 58, 63, 68, 70, 75]
        }, {
            "barres": [],
            "baseFret": 1,
            "midi": [51, 58, 61, 68],
            "key": "Eb",
            "frets": [-1, -1, 1, 3, 2, 4],
            "suffix": "7sus4",
            "fingers": [0, 0, 1, 3, 2, 4]
        }, {
            "baseFret": 4,
            "frets": [-1, 3, 3, 3, 1, 1],
            "barres": [1],
            "fingers": [0, 2, 3, 4, 1, 1],
            "suffix": "7sus4",
            "midi": [51, 56, 61, 63, 68],
            "key": "Eb",
            "capo": true
        }, {
            "capo": true,
            "frets": [1, 1, 3, 1, 4, 1],
            "barres": [1],
            "suffix": "7sus4",
            "baseFret": 6,
            "fingers": [1, 1, 3, 1, 4, 1],
            "midi": [46, 51, 58, 61, 68, 70],
            "key": "Eb"
        }, {
            "baseFret": 11,
            "suffix": "7sus4",
            "capo": true,
            "frets": [1, 3, 1, 3, 1, 1],
            "fingers": [1, 3, 1, 4, 1, 1],
            "midi": [51, 58, 61, 68, 70, 75],
            "key": "Eb",
            "barres": [1]
        }, {
            "fingers": [0, 0, 1, 2, 4, 3],
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 1, 2, 4, 3],
            "key": "Eb",
            "suffix": "alt",
            "midi": [51, 57, 63, 67]
        }, {
            "suffix": "alt",
            "barres": [],
            "fingers": [0, 4, 2, 0, 1, 3],
            "midi": [51, 55, 55, 63, 69],
            "key": "Eb",
            "frets": [-1, 3, 2, 0, 1, 2],
            "baseFret": 4
        }, {
            "baseFret": 6,
            "fingers": [0, 1, 2, 0, 3, 0],
            "barres": [],
            "suffix": "alt",
            "frets": [-1, 1, 2, 0, 3, -1],
            "midi": [51, 57, 55, 67],
            "key": "Eb"
        }, {
            "midi": [51, 55, 67, 69, 75],
            "fingers": [2, 1, 0, 4, 1, 3],
            "key": "Eb",
            "capo": true,
            "barres": [1],
            "baseFret": 10,
            "suffix": "alt",
            "frets": [2, 1, -1, 3, 1, 2]
        }, {
            "barres": [],
            "fingers": [0, 0, 4, 2, 3, 1],
            "baseFret": 3,
            "key": "Eb",
            "midi": [55, 59, 63, 67],
            "frets": [-1, -1, 3, 2, 2, 1],
            "suffix": "aug"
        }, {
            "capo": true,
            "midi": [51, 55, 59, 63],
            "barres": [1],
            "key": "Eb",
            "fingers": [0, 3, 2, 1, 1, 0],
            "frets": [-1, 3, 2, 1, 1, -1],
            "baseFret": 4,
            "suffix": "aug"
        }, {
            "baseFret": 8,
            "fingers": [4, 3, 2, 1, 1, 0],
            "key": "Eb",
            "suffix": "aug",
            "frets": [4, 3, 2, 1, 1, -1],
            "barres": [1],
            "capo": true,
            "midi": [51, 55, 59, 63, 67]
        }, {
            "barres": [],
            "fingers": [1, 0, 4, 2, 3, 0],
            "suffix": "aug",
            "baseFret": 11,
            "midi": [51, 63, 67, 71],
            "frets": [1, -1, 3, 2, 2, -1],
            "key": "Eb"
        }, {
            "frets": [-1, -1, 1, 3, 1, 3],
            "suffix": "6",
            "fingers": [0, 0, 1, 3, 1, 4],
            "key": "Eb",
            "baseFret": 1,
            "barres": [1],
            "midi": [51, 58, 60, 67]
        }, {
            "barres": [],
            "frets": [-1, 3, 2, 2, 1, -1],
            "fingers": [0, 4, 2, 3, 1, 0],
            "midi": [51, 55, 60, 63],
            "key": "Eb",
            "suffix": "6",
            "baseFret": 4
        }, {
            "frets": [-1, 1, 3, 3, 3, 3],
            "key": "Eb",
            "suffix": "6",
            "barres": [3],
            "fingers": [0, 1, 3, 3, 3, 3],
            "baseFret": 6,
            "midi": [51, 58, 63, 67, 72]
        }, {
            "baseFret": 10,
            "barres": [],
            "suffix": "6",
            "midi": [51, 60, 67, 70],
            "frets": [2, -1, 1, 3, 2, -1],
            "fingers": [2, 0, 1, 4, 3, 0],
            "key": "Eb"
        }, {
            "midi": [51, 55, 60, 65],
            "fingers": [0, 0, 2, 0, 3, 4],
            "key": "Eb",
            "baseFret": 1,
            "frets": [-1, -1, 1, 0, 1, 1],
            "barres": [],
            "suffix": "6/9"
        }, {
            "key": "Eb",
            "capo": true,
            "fingers": [0, 1, 1, 1, 2, 1],
            "midi": [48, 53, 58, 63, 67],
            "frets": [-1, 3, 3, 3, 4, 3],
            "barres": [3],
            "baseFret": 1,
            "suffix": "6/9"
        }, {
            "barres": [1],
            "capo": true,
            "midi": [51, 55, 60, 65, 70],
            "baseFret": 5,
            "fingers": [0, 2, 1, 1, 3, 4],
            "suffix": "6/9",
            "key": "Eb",
            "frets": [-1, 2, 1, 1, 2, 2]
        }, {
            "fingers": [2, 1, 1, 1, 3, 4],
            "barres": [1],
            "frets": [2, 1, 1, 1, 2, 2],
            "key": "Eb",
            "suffix": "6/9",
            "midi": [51, 55, 60, 65, 70, 75],
            "baseFret": 10,
            "capo": true
        }, {
            "barres": [],
            "key": "Eb",
            "fingers": [0, 0, 1, 3, 2, 4],
            "midi": [51, 58, 61, 67],
            "baseFret": 1,
            "frets": [-1, -1, 1, 3, 2, 3],
            "suffix": "7"
        }, {
            "capo": true,
            "suffix": "7",
            "midi": [51, 58, 61, 67, 70],
            "baseFret": 6,
            "frets": [-1, 1, 3, 1, 3, 1],
            "barres": [1],
            "key": "Eb",
            "fingers": [0, 1, 3, 1, 4, 1]
        }, {
            "suffix": "7",
            "frets": [-1, -1, 1, 1, 1, 2],
            "barres": [1],
            "key": "Eb",
            "fingers": [0, 0, 1, 1, 1, 2],
            "baseFret": 8,
            "capo": true,
            "midi": [58, 63, 67, 73]
        }, {
            "frets": [1, 3, 1, 2, 1, 1],
            "baseFret": 11,
            "fingers": [1, 3, 1, 2, 1, 1],
            "capo": true,
            "barres": [1],
            "key": "Eb",
            "suffix": "7",
            "midi": [51, 58, 61, 67, 70, 75]
        }, {
            "key": "Eb",
            "suffix": "7b5",
            "fingers": [0, 0, 1, 2, 3, 4],
            "barres": [],
            "frets": [-1, -1, 1, 2, 2, 3],
            "midi": [51, 57, 61, 67],
            "baseFret": 1
        }, {
            "barres": [],
            "fingers": [0, 0, 2, 4, 1, 3],
            "baseFret": 4,
            "frets": [-1, -1, 2, 3, 1, 2],
            "suffix": "7b5",
            "midi": [55, 61, 63, 69],
            "key": "Eb"
        }, {
            "midi": [51, 57, 61, 67, 70],
            "capo": true,
            "baseFret": 6,
            "key": "Eb",
            "suffix": "7b5",
            "barres": [1],
            "frets": [-1, 1, 2, 1, 3, 1],
            "fingers": [0, 1, 2, 1, 3, 0]
        }, {
            "suffix": "7b5",
            "barres": [],
            "frets": [2, -1, 2, 3, 1, -1],
            "key": "Eb",
            "midi": [51, 61, 67, 69],
            "fingers": [2, 0, 3, 4, 1, 0],
            "baseFret": 10
        }, {
            "fingers": [0, 0, 1, 4, 2, 3],
            "frets": [-1, -1, 1, 4, 2, 3],
            "suffix": "aug7",
            "midi": [51, 59, 61, 67],
            "key": "Eb",
            "baseFret": 1,
            "barres": []
        }, {
            "midi": [51, 59, 61, 67, 71],
            "suffix": "aug7",
            "fingers": [0, 1, 4, 1, 3, 2],
            "baseFret": 6,
            "barres": [1],
            "capo": true,
            "key": "Eb",
            "frets": [-1, 1, 4, 1, 3, 2]
        }, {
            "barres": [],
            "midi": [51, 55, 61, 55, 59, 73],
            "frets": [3, 2, 3, 0, 0, 1],
            "fingers": [3, 2, 4, 0, 0, 1],
            "baseFret": 9,
            "key": "Eb",
            "suffix": "aug7"
        }, {
            "midi": [51, 61, 67, 71],
            "fingers": [1, 0, 2, 3, 4, 0],
            "suffix": "aug7",
            "baseFret": 11,
            "barres": [],
            "frets": [1, -1, 1, 2, 2, -1],
            "key": "Eb"
        }, {
            "midi": [51, 55, 61, 65],
            "fingers": [0, 0, 1, 0, 3, 2],
            "barres": [],
            "frets": [-1, -1, 1, 0, 2, 1],
            "key": "Eb",
            "baseFret": 1,
            "suffix": "9"
        }, {
            "frets": [-1, 2, 1, 2, 2, 2],
            "baseFret": 5,
            "key": "Eb",
            "suffix": "9",
            "fingers": [0, 2, 1, 3, 3, 4],
            "midi": [51, 55, 61, 65, 70],
            "barres": [2]
        }, {
            "fingers": [3, 1, 4, 2, 0, 0],
            "midi": [51, 55, 61, 65],
            "barres": [],
            "suffix": "9",
            "key": "Eb",
            "frets": [2, 1, 2, 1, -1, -1],
            "baseFret": 10
        }, {
            "fingers": [1, 3, 1, 2, 1, 4],
            "suffix": "9",
            "barres": [1],
            "capo": true,
            "baseFret": 11,
            "midi": [51, 58, 61, 67, 70, 77],
            "key": "Eb",
            "frets": [1, 3, 1, 2, 1, 3]
        }, {
            "fingers": [0, 2, 1, 3, 4, 1],
            "suffix": "9b5",
            "midi": [51, 55, 61, 65, 69],
            "key": "Eb",
            "barres": [1],
            "capo": true,
            "baseFret": 5,
            "frets": [-1, 2, 1, 2, 2, 1]
        }, {
            "key": "Eb",
            "baseFret": 6,
            "suffix": "9b5",
            "barres": [],
            "midi": [51, 57, 55, 65, 73],
            "frets": [-1, 1, 2, 0, 1, 4],
            "fingers": [0, 1, 3, 0, 2, 4]
        }, {
            "suffix": "9b5",
            "midi": [51, 55, 61, 65, 69, 75],
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "key": "Eb",
            "baseFret": 10,
            "barres": [1],
            "fingers": [1, 2, 0, 3, 0, 4]
        }, {
            "key": "Eb",
            "suffix": "9b5",
            "frets": [1, 2, 1, 2, -1, 3],
            "capo": true,
            "fingers": [1, 2, 1, 3, 0, 4],
            "baseFret": 11,
            "midi": [51, 57, 61, 67, 77],
            "barres": [1]
        }, {
            "frets": [3, 4, 3, 4, 4, 3],
            "capo": true,
            "baseFret": 1,
            "fingers": [1, 2, 1, 3, 4, 1],
            "barres": [3],
            "key": "Eb",
            "midi": [43, 49, 53, 59, 63, 67],
            "suffix": "aug9"
        }, {
            "barres": [2],
            "fingers": [0, 2, 1, 3, 3, 4],
            "suffix": "aug9",
            "midi": [51, 55, 61, 65, 71],
            "baseFret": 5,
            "key": "Eb",
            "frets": [-1, 2, 1, 2, 2, 3]
        }, {
            "key": "Eb",
            "baseFret": 9,
            "midi": [51, 55, 65, 59, 73],
            "suffix": "aug9",
            "frets": [3, 2, -1, 2, 0, 1],
            "fingers": [4, 2, 0, 3, 0, 1],
            "barres": []
        }, {
            "suffix": "aug9",
            "baseFret": 10,
            "fingers": [2, 1, 3, 1, 4, 0],
            "frets": [2, 1, 2, 1, 3, -1],
            "midi": [51, 55, 61, 65, 71],
            "key": "Eb",
            "barres": [1]
        }, {
            "fingers": [0, 0, 2, 0, 4, 0],
            "barres": [],
            "midi": [51, 55, 61, 64],
            "baseFret": 1,
            "frets": [-1, -1, 1, 0, 2, 0],
            "key": "Eb",
            "suffix": "7b9"
        }, {
            "midi": [51, 55, 61, 64, 70],
            "key": "Eb",
            "capo": true,
            "baseFret": 5,
            "barres": [1],
            "suffix": "7b9",
            "fingers": [0, 2, 1, 3, 1, 4],
            "frets": [-1, 2, 1, 2, 1, 2]
        }, {
            "key": "Eb",
            "suffix": "7b9",
            "frets": [-1, 1, 3, 1, 3, 0],
            "midi": [51, 58, 61, 67, 64],
            "barres": [1],
            "fingers": [0, 1, 3, 1, 4, 0],
            "baseFret": 6
        }, {
            "barres": [],
            "frets": [3, 2, 3, 1, -1, -1],
            "key": "Eb",
            "suffix": "7b9",
            "fingers": [3, 2, 4, 1, 0, 0],
            "baseFret": 9,
            "midi": [51, 55, 61, 64]
        }, {
            "barres": [],
            "fingers": [0, 0, 2, 0, 3, 4],
            "frets": [-1, -1, 1, 0, 2, 2],
            "baseFret": 1,
            "key": "Eb",
            "midi": [51, 55, 61, 66],
            "suffix": "7#9"
        }, {
            "frets": [-1, 2, 1, 2, 3, -1],
            "barres": [],
            "baseFret": 5,
            "fingers": [0, 2, 1, 3, 4, 0],
            "midi": [51, 55, 61, 66],
            "key": "Eb",
            "suffix": "7#9"
        }, {
            "suffix": "7#9",
            "fingers": [0, 2, 1, 1, 1, 3],
            "frets": [-1, 2, 1, 1, 1, 2],
            "key": "Eb",
            "midi": [54, 58, 63, 67, 73],
            "baseFret": 8,
            "barres": [1],
            "capo": true
        }, {
            "suffix": "7#9",
            "key": "Eb",
            "fingers": [2, 1, 3, 4, 0, 0],
            "frets": [2, 1, 2, 2, -1, -1],
            "barres": [],
            "midi": [51, 55, 61, 66],
            "baseFret": 10
        }, {
            "baseFret": 1,
            "suffix": "11",
            "fingers": [1, 1, 1, 1, 2, 3],
            "barres": [1],
            "key": "Eb",
            "capo": true,
            "midi": [41, 46, 51, 56, 61, 67],
            "frets": [1, 1, 1, 1, 2, 3]
        }, {
            "key": "Eb",
            "capo": true,
            "suffix": "11",
            "fingers": [0, 3, 2, 4, 1, 1],
            "barres": [1],
            "midi": [51, 55, 61, 63, 68],
            "baseFret": 4,
            "frets": [-1, 3, 2, 3, 1, 1]
        }, {
            "barres": [1],
            "capo": true,
            "suffix": "11",
            "fingers": [0, 1, 1, 1, 3, 1],
            "baseFret": 6,
            "key": "Eb",
            "frets": [0, 1, 1, 1, 3, 1],
            "midi": [40, 51, 56, 61, 67, 70]
        }, {
            "frets": [1, 1, 1, 2, 1, 1],
            "barres": [1],
            "fingers": [1, 1, 1, 2, 1, 1],
            "capo": true,
            "midi": [51, 56, 61, 67, 70, 75],
            "key": "Eb",
            "suffix": "11",
            "baseFret": 11
        }, {
            "suffix": "9#11",
            "midi": [51, 57, 61, 67],
            "fingers": [0, 0, 1, 2, 3, 4],
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 1, 2, 2, 3],
            "key": "Eb"
        }, {
            "fingers": [0, 2, 1, 3, 4, 1],
            "key": "Eb",
            "capo": true,
            "midi": [51, 55, 61, 65, 69],
            "frets": [-1, 2, 1, 2, 2, 1],
            "baseFret": 5,
            "barres": [1],
            "suffix": "9#11"
        }, {
            "baseFret": 6,
            "midi": [51, 57, 61, 67],
            "barres": [1],
            "suffix": "9#11",
            "frets": [-1, 1, 2, 1, 3, -1],
            "fingers": [0, 1, 2, 1, 3, 0],
            "capo": true,
            "key": "Eb"
        }, {
            "baseFret": 10,
            "midi": [51, 55, 61, 65, 69, 75],
            "fingers": [2, 1, 3, 1, 1, 4],
            "barres": [1],
            "suffix": "9#11",
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "key": "Eb"
        }, {
            "fingers": [0, 2, 1, 3, 4, 4],
            "baseFret": 5,
            "suffix": "13",
            "frets": [-1, 2, 1, 2, 4, 4],
            "midi": [51, 55, 61, 67, 72],
            "barres": [4],
            "key": "Eb"
        }, {
            "midi": [46, 51, 56, 61, 67, 72],
            "baseFret": 6,
            "key": "Eb",
            "barres": [1],
            "fingers": [1, 1, 1, 1, 3, 4],
            "capo": true,
            "frets": [1, 1, 1, 1, 3, 3],
            "suffix": "13"
        }, {
            "baseFret": 9,
            "midi": [51, 55, 60, 55, 68, 73],
            "frets": [3, 2, 2, 0, 1, 1],
            "suffix": "13",
            "key": "Eb",
            "barres": [1],
            "fingers": [4, 2, 3, 0, 1, 1]
        }, {
            "suffix": "13",
            "barres": [1],
            "key": "Eb",
            "capo": true,
            "frets": [1, 1, 1, 2, 3, 3],
            "midi": [51, 56, 61, 67, 72, 77],
            "fingers": [1, 1, 1, 2, 3, 4],
            "baseFret": 11
        }, {
            "frets": [-1, 1, 1, 3, 3, 3],
            "suffix": "maj7",
            "key": "Eb",
            "baseFret": 1,
            "fingers": [0, 1, 1, 3, 3, 3],
            "barres": [1, 3],
            "capo": true,
            "midi": [46, 51, 58, 62, 67]
        }, {
            "baseFret": 3,
            "midi": [51, 55, 58, 62, 67],
            "fingers": [0, 4, 3, 1, 1, 1],
            "frets": [-1, 4, 3, 1, 1, 1],
            "key": "Eb",
            "suffix": "maj7",
            "barres": [1]
        }, {
            "barres": [1],
            "key": "Eb",
            "frets": [1, 1, 3, 2, 3, 1],
            "fingers": [1, 1, 3, 2, 4, 1],
            "baseFret": 6,
            "suffix": "maj7",
            "midi": [46, 51, 58, 62, 67, 70],
            "capo": true
        }, {
            "frets": [-1, -1, 1, 1, 1, 3],
            "midi": [58, 63, 67, 74],
            "baseFret": 8,
            "fingers": [0, 0, 1, 1, 1, 4],
            "key": "Eb",
            "suffix": "maj7",
            "barres": [1]
        }, {
            "suffix": "maj7b5",
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [51, 57, 62, 67],
            "frets": [-1, -1, 1, 2, 3, 3],
            "baseFret": 1,
            "barres": [],
            "key": "Eb"
        }, {
            "baseFret": 6,
            "midi": [51, 57, 62, 67, 70],
            "barres": [1],
            "key": "Eb",
            "suffix": "maj7b5",
            "fingers": [0, 1, 2, 2, 4, 0],
            "frets": [-1, 1, 2, 2, 3, 1],
            "capo": true
        }, {
            "baseFret": 10,
            "midi": [51, 55, 62, 67, 69, 74],
            "frets": [2, 1, 3, 3, 1, 1],
            "fingers": [2, 1, 3, 4, 1, 1],
            "suffix": "maj7b5",
            "key": "Eb",
            "capo": true,
            "barres": [1]
        }, {
            "barres": [1, 2],
            "fingers": [1, 2, 2, 2, 0, 1],
            "capo": true,
            "key": "Eb",
            "midi": [51, 57, 62, 67, 75],
            "suffix": "maj7b5",
            "baseFret": 11,
            "frets": [1, 2, 2, 2, -1, 1]
        }, {
            "suffix": "maj7#5",
            "fingers": [1, 4, 3, 2, 1, 1],
            "midi": [43, 51, 55, 59, 62, 67],
            "frets": [1, 4, 3, 2, 1, 1],
            "baseFret": 3,
            "key": "Eb",
            "barres": [1]
        }, {
            "midi": [51, 55, 62, 71],
            "barres": [],
            "baseFret": 5,
            "frets": [-1, 2, 1, 3, -1, 3],
            "key": "Eb",
            "fingers": [0, 2, 1, 3, 0, 4],
            "suffix": "maj7#5"
        }, {
            "barres": [],
            "key": "Eb",
            "fingers": [0, 1, 4, 2, 3, 0],
            "frets": [-1, 1, 4, 2, 3, -1],
            "baseFret": 6,
            "midi": [51, 59, 62, 67],
            "suffix": "maj7#5"
        }, {
            "frets": [1, -1, 2, 2, 2, 1],
            "baseFret": 11,
            "capo": true,
            "barres": [1],
            "fingers": [1, 0, 2, 3, 4, 1],
            "midi": [51, 62, 67, 71, 75],
            "key": "Eb",
            "suffix": "maj7#5"
        }, {
            "midi": [51, 53, 58, 62, 67],
            "fingers": [0, 4, 1, 1, 1, 1],
            "frets": [-1, 4, 1, 1, 1, 1],
            "key": "Eb",
            "suffix": "maj9",
            "barres": [1],
            "baseFret": 3
        }, {
            "barres": [],
            "baseFret": 5,
            "frets": [-1, 2, 1, 3, 2, -1],
            "fingers": [0, 2, 1, 4, 3, 0],
            "suffix": "maj9",
            "key": "Eb",
            "midi": [51, 55, 62, 65]
        }, {
            "baseFret": 8,
            "fingers": [0, 1, 1, 1, 1, 4],
            "suffix": "maj9",
            "capo": true,
            "key": "Eb",
            "barres": [1],
            "midi": [53, 58, 63, 67, 74],
            "frets": [-1, 1, 1, 1, 1, 3]
        }, {
            "barres": [],
            "fingers": [0, 0, 2, 3, 1, 4],
            "suffix": "maj9",
            "baseFret": 11,
            "key": "Eb",
            "frets": [-1, -1, 2, 2, 1, 3],
            "midi": [62, 67, 70, 77]
        }, {
            "midi": [51, 56, 62, 67],
            "barres": [1],
            "frets": [-1, -1, 1, 1, 3, 3],
            "baseFret": 1,
            "fingers": [0, 0, 1, 1, 3, 4],
            "suffix": "maj11",
            "key": "Eb"
        }, {
            "key": "Eb",
            "suffix": "maj11",
            "capo": true,
            "baseFret": 4,
            "midi": [51, 55, 62, 63, 68],
            "frets": [-1, 3, 2, 4, 1, 1],
            "barres": [1],
            "fingers": [0, 3, 2, 4, 1, 1]
        }, {
            "midi": [46, 51, 56, 62, 67, 70],
            "baseFret": 6,
            "fingers": [1, 1, 1, 2, 3, 1],
            "suffix": "maj11",
            "frets": [1, 1, 1, 2, 3, 1],
            "capo": true,
            "barres": [1],
            "key": "Eb"
        }, {
            "fingers": [1, 1, 2, 3, 1, 1],
            "capo": true,
            "midi": [51, 56, 62, 67, 70, 75],
            "key": "Eb",
            "suffix": "maj11",
            "baseFret": 11,
            "frets": [1, 1, 2, 2, 1, 1],
            "barres": [1]
        }, {
            "fingers": [0, 3, 1, 0, 4, 0],
            "frets": [-1, 3, 1, 0, 3, -1],
            "midi": [48, 51, 55, 62],
            "key": "Eb",
            "suffix": "maj13",
            "baseFret": 1,
            "barres": []
        }, {
            "suffix": "maj13",
            "baseFret": 3,
            "midi": [51, 55, 60, 62, 67],
            "key": "Eb",
            "barres": [1],
            "frets": [-1, 4, 3, 3, 1, 1],
            "fingers": [0, 4, 2, 3, 1, 1]
        }, {
            "capo": true,
            "suffix": "maj13",
            "fingers": [0, 1, 1, 2, 3, 4],
            "frets": [-1, 1, 1, 2, 3, 3],
            "baseFret": 6,
            "midi": [51, 56, 62, 67, 72],
            "key": "Eb",
            "barres": [1]
        }, {
            "suffix": "maj13",
            "barres": [1],
            "baseFret": 10,
            "midi": [51, 55, 60, 65, 70, 74],
            "key": "Eb",
            "fingers": [2, 1, 1, 1, 3, 1],
            "frets": [2, 1, 1, 1, 2, 1],
            "capo": true
        }, {
            "baseFret": 1,
            "barres": [1],
            "frets": [-1, 1, 1, 3, 1, 2],
            "key": "Eb",
            "suffix": "m6",
            "fingers": [0, 1, 1, 3, 1, 2],
            "capo": true,
            "midi": [46, 51, 58, 60, 66]
        }, {
            "midi": [51, 54, 60, 63, 70],
            "capo": true,
            "key": "Eb",
            "suffix": "m6",
            "fingers": [0, 3, 1, 2, 1, 4],
            "barres": [1],
            "baseFret": 4,
            "frets": [-1, 3, 1, 2, 1, 3]
        }, {
            "baseFret": 7,
            "suffix": "m6",
            "frets": [-1, -1, 2, 2, 1, 2],
            "barres": [],
            "fingers": [0, 0, 2, 3, 1, 4],
            "midi": [58, 63, 66, 72],
            "key": "Eb"
        }, {
            "suffix": "m6",
            "midi": [51, 58, 63, 66, 72, 75],
            "baseFret": 11,
            "barres": [1],
            "capo": true,
            "fingers": [1, 2, 3, 1, 4, 1],
            "key": "Eb",
            "frets": [1, 3, 3, 1, 3, 1]
        }, {
            "midi": [51, 58, 61, 66],
            "suffix": "m7",
            "frets": [-1, -1, 1, 3, 2, 2],
            "baseFret": 1,
            "barres": [],
            "key": "Eb",
            "fingers": [0, 0, 1, 4, 2, 3]
        }, {
            "frets": [1, 1, 3, 1, 2, 1],
            "baseFret": 6,
            "midi": [46, 51, 58, 61, 66, 70],
            "barres": [1],
            "key": "Eb",
            "suffix": "m7",
            "fingers": [1, 1, 3, 1, 2, 1],
            "capo": true
        }, {
            "baseFret": 7,
            "midi": [58, 63, 66, 73],
            "frets": [-1, -1, 2, 2, 1, 3],
            "key": "Eb",
            "suffix": "m7",
            "barres": [],
            "fingers": [0, 0, 2, 3, 1, 4]
        }, {
            "key": "Eb",
            "baseFret": 11,
            "suffix": "m7",
            "frets": [1, 3, 1, 1, 1, 1],
            "midi": [51, 58, 61, 66, 70, 75],
            "fingers": [1, 4, 1, 1, 1, 1],
            "barres": [1],
            "capo": true
        }, {
            "midi": [51, 57, 61, 66],
            "fingers": [0, 0, 1, 2, 2, 2],
            "baseFret": 1,
            "key": "Eb",
            "barres": [2],
            "frets": [-1, -1, 1, 2, 2, 2],
            "suffix": "m7b5"
        }, {
            "baseFret": 6,
            "fingers": [0, 1, 3, 2, 4, 0],
            "suffix": "m7b5",
            "midi": [51, 57, 61, 66],
            "key": "Eb",
            "barres": [],
            "frets": [-1, 1, 2, 1, 2, -1]
        }, {
            "frets": [-1, -1, 1, 2, 1, 3],
            "key": "Eb",
            "baseFret": 7,
            "suffix": "m7b5",
            "midi": [57, 63, 66, 73],
            "barres": [1],
            "fingers": [0, 0, 1, 2, 1, 4]
        }, {
            "frets": [2, -1, 2, 2, 1, -1],
            "barres": [],
            "midi": [51, 61, 66, 69],
            "key": "Eb",
            "fingers": [2, 0, 3, 4, 1, 0],
            "baseFret": 10,
            "suffix": "m7b5"
        }, {
            "baseFret": 4,
            "fingers": [0, 2, 1, 3, 4, 4],
            "barres": [3],
            "frets": [-1, 3, 1, 3, 3, 3],
            "midi": [51, 54, 61, 65, 70],
            "key": "Eb",
            "suffix": "m9"
        }, {
            "frets": [-1, -1, 2, 4, 1, 3],
            "fingers": [0, 0, 2, 4, 1, 3],
            "barres": [],
            "baseFret": 7,
            "suffix": "m9",
            "midi": [58, 65, 66, 73],
            "key": "Eb"
        }, {
            "suffix": "m9",
            "midi": [54, 61, 65, 70, 75],
            "barres": [3],
            "baseFret": 9,
            "key": "Eb",
            "fingers": [0, 1, 3, 2, 4, 4],
            "frets": [-1, 1, 3, 2, 3, 3]
        }, {
            "baseFret": 11,
            "key": "Eb",
            "frets": [1, 3, 1, 1, 1, 3],
            "barres": [1],
            "suffix": "m9",
            "midi": [51, 58, 61, 66, 70, 77],
            "fingers": [1, 3, 1, 1, 1, 4],
            "capo": true
        }, {
            "baseFret": 1,
            "midi": [42, 51, 58, 60, 65],
            "frets": [2, -1, 1, 3, 1, 1],
            "fingers": [2, 0, 1, 3, 1, 1],
            "key": "Eb",
            "barres": [1],
            "suffix": "m6/9"
        }, {
            "frets": [-1, 3, 1, 2, 3, -1],
            "midi": [51, 54, 60, 65],
            "barres": [],
            "key": "Eb",
            "fingers": [0, 3, 1, 2, 4, 0],
            "baseFret": 4,
            "suffix": "m6/9"
        }, {
            "key": "Eb",
            "frets": [3, 1, 2, 2, 1, 1],
            "baseFret": 9,
            "capo": true,
            "fingers": [4, 1, 2, 3, 0, 0],
            "suffix": "m6/9",
            "barres": [1],
            "midi": [51, 54, 60, 65, 68, 73]
        }, {
            "fingers": [0, 0, 2, 1, 3, 4],
            "key": "Eb",
            "baseFret": 11,
            "midi": [63, 66, 72, 77],
            "frets": [-1, -1, 3, 1, 3, 3],
            "barres": [],
            "suffix": "m6/9"
        }, {
            "baseFret": 1,
            "frets": [-1, -1, 1, 1, 2, 2],
            "fingers": [0, 0, 1, 1, 3, 4],
            "key": "Eb",
            "suffix": "m11",
            "barres": [1],
            "midi": [51, 56, 61, 66],
            "capo": true
        }, {
            "midi": [51, 54, 61, 65, 68],
            "key": "Eb",
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 4,
            "frets": [-1, 3, 1, 3, 3, 1],
            "barres": [1],
            "capo": true,
            "suffix": "m11"
        }, {
            "frets": [3, 1, 3, 2, 1, 1],
            "midi": [51, 54, 61, 65, 68, 73],
            "key": "Eb",
            "barres": [1],
            "fingers": [3, 1, 4, 2, 1, 1],
            "suffix": "m11",
            "capo": true,
            "baseFret": 9
        }, {
            "baseFret": 11,
            "barres": [1],
            "frets": [1, 1, 1, 1, 1, 3],
            "midi": [51, 56, 61, 66, 70, 77],
            "suffix": "m11",
            "key": "Eb",
            "fingers": [1, 1, 1, 1, 1, 4],
            "capo": true
        }, {
            "fingers": [0, 0, 1, 3, 4, 2],
            "baseFret": 1,
            "barres": [],
            "key": "Eb",
            "frets": [-1, -1, 1, 3, 3, 2],
            "suffix": "mmaj7",
            "midi": [51, 58, 62, 66]
        }, {
            "barres": [],
            "key": "Eb",
            "baseFret": 3,
            "midi": [51, 54, 58, 62],
            "suffix": "mmaj7",
            "frets": [-1, 4, 2, 1, 1, -1],
            "fingers": [0, 4, 3, 1, 2, 0]
        }, {
            "capo": true,
            "frets": [-1, 1, 3, 2, 2, 1],
            "suffix": "mmaj7",
            "key": "Eb",
            "midi": [51, 58, 62, 66, 70],
            "fingers": [0, 1, 4, 2, 3, 1],
            "baseFret": 6,
            "barres": [1]
        }, {
            "fingers": [1, 3, 2, 1, 1, 1],
            "key": "Eb",
            "baseFret": 11,
            "capo": true,
            "midi": [51, 58, 62, 66, 70, 75],
            "barres": [1],
            "frets": [1, 3, 2, 1, 1, 1],
            "suffix": "mmaj7"
        }, {
            "frets": [-1, -1, 1, 2, 3, 2],
            "key": "Eb",
            "suffix": "mmaj7b5",
            "fingers": [0, 0, 1, 2, 4, 3],
            "barres": [],
            "baseFret": 1,
            "midi": [51, 57, 62, 66]
        }, {
            "baseFret": 5,
            "barres": [3],
            "fingers": [1, 2, 3, 3, 3, 0],
            "key": "Eb",
            "midi": [45, 51, 57, 62, 66],
            "suffix": "mmaj7b5",
            "frets": [1, 2, 3, 3, 3, -1]
        }, {
            "fingers": [0, 1, 2, 3, 4, 0],
            "baseFret": 6,
            "midi": [51, 57, 62, 66],
            "frets": [-1, 1, 2, 2, 2, -1],
            "barres": [],
            "suffix": "mmaj7b5",
            "key": "Eb"
        }, {
            "key": "Eb",
            "barres": [1, 2],
            "frets": [1, 2, 2, 1, -1, 1],
            "baseFret": 11,
            "suffix": "mmaj7b5",
            "capo": true,
            "fingers": [1, 2, 2, 1, 0, 1],
            "midi": [51, 57, 62, 66, 75]
        }, {
            "baseFret": 4,
            "fingers": [0, 2, 1, 4, 3, 0],
            "barres": [],
            "key": "Eb",
            "suffix": "mmaj9",
            "frets": [-1, 3, 1, 4, 3, -1],
            "midi": [51, 54, 62, 65]
        }, {
            "barres": [1],
            "midi": [46, 54, 58, 62, 65, 70],
            "key": "Eb",
            "fingers": [1, 4, 3, 2, 1, 1],
            "frets": [1, 4, 3, 2, 1, 1],
            "suffix": "mmaj9",
            "capo": true,
            "baseFret": 6
        }, {
            "baseFret": 9,
            "fingers": [3, 1, 4, 2, 0, 0],
            "midi": [51, 54, 62, 65],
            "frets": [3, 1, 4, 2, -1, -1],
            "barres": [],
            "key": "Eb",
            "suffix": "mmaj9"
        }, {
            "fingers": [1, 3, 2, 1, 1, 4],
            "key": "Eb",
            "capo": true,
            "frets": [1, 3, 2, 1, 1, 3],
            "barres": [1],
            "midi": [51, 58, 62, 66, 70, 77],
            "suffix": "mmaj9",
            "baseFret": 11
        }, {
            "midi": [46, 51, 56, 62, 66],
            "fingers": [0, 1, 1, 1, 3, 2],
            "barres": [1],
            "frets": [-1, 1, 1, 1, 3, 2],
            "baseFret": 1,
            "suffix": "mmaj11",
            "capo": true,
            "key": "Eb"
        }, {
            "capo": true,
            "midi": [51, 54, 62, 65, 68],
            "key": "Eb",
            "suffix": "mmaj11",
            "barres": [1],
            "fingers": [0, 3, 1, 4, 3, 1],
            "frets": [-1, 3, 1, 4, 3, 1],
            "baseFret": 4
        }, {
            "baseFret": 6,
            "capo": true,
            "midi": [46, 51, 56, 62, 66, 70],
            "frets": [1, 1, 1, 2, 2, 1],
            "key": "Eb",
            "fingers": [1, 1, 1, 2, 3, 1],
            "barres": [1],
            "suffix": "mmaj11"
        }, {
            "barres": [1],
            "frets": [1, 1, 2, 1, 1, 3],
            "baseFret": 11,
            "suffix": "mmaj11",
            "fingers": [1, 1, 2, 1, 1, 4],
            "key": "Eb",
            "capo": true,
            "midi": [51, 56, 62, 66, 70, 77]
        }, {
            "baseFret": 3,
            "midi": [51, 55, 58, 65, 67],
            "fingers": [0, 3, 2, 1, 4, 1],
            "frets": [-1, 4, 3, 1, 4, 1],
            "capo": true,
            "suffix": "add9",
            "barres": [1],
            "key": "Eb"
        }, {
            "barres": [],
            "fingers": [0, 2, 1, 0, 3, 4],
            "baseFret": 5,
            "key": "Eb",
            "suffix": "add9",
            "midi": [51, 55, 55, 65, 70],
            "frets": [-1, 2, 1, 0, 2, 2]
        }, {
            "barres": [],
            "key": "Eb",
            "baseFret": 10,
            "frets": [2, 1, -1, 1, 2, -1],
            "midi": [51, 55, 65, 70],
            "suffix": "add9",
            "fingers": [3, 1, 0, 2, 4, 0]
        }, {
            "frets": [-1, -1, 3, 2, 1, 3],
            "key": "Eb",
            "barres": [],
            "fingers": [0, 0, 3, 2, 1, 4],
            "midi": [63, 67, 70, 77],
            "suffix": "add9",
            "baseFret": 11
        }, {
            "baseFret": 1,
            "suffix": "madd9",
            "fingers": [0, 0, 3, 2, 4, 1],
            "key": "Eb",
            "frets": [-1, -1, 4, 3, 4, 1],
            "midi": [54, 58, 63, 65],
            "barres": []
        }, {
            "key": "Eb",
            "midi": [51, 54, 58, 65],
            "baseFret": 3,
            "barres": [],
            "frets": [-1, 4, 2, 1, 4, -1],
            "fingers": [0, 3, 2, 1, 4, 0],
            "suffix": "madd9"
        }, {
            "fingers": [0, 2, 1, 0, 3, 4],
            "key": "Eb",
            "midi": [51, 54, 65, 70],
            "baseFret": 4,
            "barres": [],
            "frets": [-1, 3, 1, -1, 3, 3],
            "suffix": "madd9"
        }, {
            "fingers": [0, 0, 3, 1, 1, 4],
            "key": "Eb",
            "suffix": "madd9",
            "midi": [63, 66, 70, 77],
            "capo": true,
            "frets": [-1, -1, 3, 1, 1, 3],
            "baseFret": 11,
            "barres": [1]
        }, {
            "frets": [0, 2, 2, 1, 0, 0],
            "barres": [],
            "midi": [40, 47, 52, 56, 59, 64],
            "fingers": [0, 2, 3, 1, 0, 0],
            "baseFret": 1,
            "key": "E",
            "suffix": "major"
        }, {
            "key": "E",
            "fingers": [0, 0, 1, 2, 4, 3],
            "baseFret": 2,
            "midi": [52, 59, 64, 68],
            "barres": [],
            "frets": [-1, -1, 1, 3, 4, 3],
            "suffix": "major"
        }, {
            "midi": [44, 52, 56, 59, 64, 68],
            "barres": [1],
            "fingers": [1, 4, 3, 1, 2, 1],
            "baseFret": 4,
            "key": "E",
            "capo": true,
            "suffix": "major",
            "frets": [1, 4, 3, 1, 2, 1]
        }, {
            "baseFret": 7,
            "key": "E",
            "suffix": "major",
            "fingers": [1, 1, 2, 3, 4, 1],
            "capo": true,
            "barres": [1],
            "midi": [47, 52, 59, 64, 68, 71],
            "frets": [1, 1, 3, 3, 3, 1]
        }, {
            "baseFret": 1,
            "key": "E",
            "suffix": "minor",
            "midi": [40, 47, 52, 55, 59, 64],
            "fingers": [0, 2, 3, 0, 0, 0],
            "barres": [],
            "frets": [0, 2, 2, 0, 0, 0]
        }, {
            "frets": [0, 1, 1, 3, 4, 2],
            "fingers": [0, 1, 1, 3, 4, 2],
            "suffix": "minor",
            "barres": [1],
            "capo": true,
            "baseFret": 2,
            "midi": [40, 47, 52, 59, 64, 67],
            "key": "E"
        }, {
            "fingers": [1, 1, 3, 4, 2, 1],
            "suffix": "minor",
            "frets": [1, 1, 3, 3, 2, 1],
            "capo": true,
            "barres": [1],
            "key": "E",
            "baseFret": 7,
            "midi": [47, 52, 59, 64, 67, 71]
        }, {
            "key": "E",
            "fingers": [4, 3, 1, 2, 0, 0],
            "baseFret": 9,
            "frets": [4, 2, 1, 1, -1, -1],
            "midi": [52, 55, 59, 64],
            "suffix": "minor",
            "barres": []
        }, {
            "key": "E",
            "frets": [-1, -1, 2, 3, -1, 3],
            "fingers": [0, 0, 1, 2, 0, 3],
            "baseFret": 1,
            "barres": [],
            "suffix": "dim",
            "midi": [52, 58, 67]
        }, {
            "frets": [-1, 3, 1, -1, 1, 2],
            "suffix": "dim",
            "key": "E",
            "barres": [],
            "midi": [52, 55, 64, 70],
            "baseFret": 5,
            "fingers": [0, 4, 1, 0, 2, 3]
        }, {
            "fingers": [0, 1, 2, 4, 3, 0],
            "suffix": "dim",
            "key": "E",
            "barres": [],
            "frets": [-1, 1, 2, 3, 2, -1],
            "baseFret": 7,
            "midi": [52, 58, 64, 67]
        }, {
            "suffix": "dim",
            "baseFret": 10,
            "key": "E",
            "midi": [52, 55, 67, 70],
            "frets": [3, 1, -1, 3, 2, -1],
            "fingers": [3, 1, 0, 4, 2, 0],
            "barres": []
        }, {
            "suffix": "dim7",
            "key": "E",
            "baseFret": 1,
            "midi": [40, 46, 52, 55, 61, 64],
            "fingers": [0, 1, 2, 0, 3, 0],
            "barres": [],
            "frets": [0, 1, 2, 0, 2, 0]
        }, {
            "baseFret": 1,
            "midi": [52, 58, 61, 67],
            "key": "E",
            "suffix": "dim7",
            "fingers": [0, 0, 1, 3, 2, 4],
            "frets": [-1, -1, 2, 3, 2, 3],
            "barres": []
        }, {
            "frets": [-1, 2, 3, 1, 3, -1],
            "suffix": "dim7",
            "midi": [52, 58, 61, 67],
            "barres": [],
            "fingers": [0, 2, 3, 1, 4, 0],
            "key": "E",
            "baseFret": 6
        }, {
            "frets": [2, -1, 1, 2, 1, -1],
            "key": "E",
            "baseFret": 11,
            "capo": true,
            "suffix": "dim7",
            "midi": [52, 61, 67, 70],
            "barres": [1],
            "fingers": [2, 0, 1, 3, 1, 0]
        }, {
            "capo": true,
            "frets": [1, 1, 1, 3, 4, 1],
            "fingers": [1, 1, 1, 3, 4, 1],
            "barres": [1],
            "key": "E",
            "suffix": "sus2",
            "baseFret": 2,
            "midi": [42, 47, 52, 59, 64, 66]
        }, {
            "suffix": "sus2",
            "fingers": [0, 1, 3, 4, 1, 1],
            "baseFret": 7,
            "midi": [40, 52, 59, 64, 66, 71],
            "barres": [1],
            "capo": true,
            "key": "E",
            "frets": [0, 1, 3, 3, 1, 1]
        }, {
            "suffix": "sus2",
            "midi": [40, 54, 59, 64, 59, 64],
            "key": "E",
            "frets": [0, 1, 1, 1, 0, 0],
            "fingers": [0, 1, 2, 3, 0, 0],
            "baseFret": 9,
            "barres": []
        }, {
            "suffix": "sus2",
            "midi": [52, 59, 64, 71, 78],
            "key": "E",
            "baseFret": 12,
            "frets": [1, 3, 3, -1, 1, 3],
            "barres": [1],
            "capo": true,
            "fingers": [1, 3, 4, 0, 1, 4]
        }, {
            "fingers": [0, 2, 3, 4, 0, 0],
            "suffix": "sus4",
            "baseFret": 1,
            "barres": [],
            "frets": [0, 2, 2, 2, 0, 0],
            "key": "E",
            "midi": [40, 47, 52, 57, 59, 64]
        }, {
            "fingers": [0, 1, 1, 2, 3, 4],
            "baseFret": 2,
            "key": "E",
            "frets": [0, 1, 1, 3, 4, 4],
            "suffix": "sus4",
            "barres": [1],
            "midi": [40, 47, 52, 59, 64, 69]
        }, {
            "baseFret": 7,
            "fingers": [1, 1, 2, 3, 4, 1],
            "barres": [1],
            "key": "E",
            "suffix": "sus4",
            "midi": [47, 52, 59, 64, 69, 71],
            "capo": true,
            "frets": [1, 1, 3, 3, 4, 1]
        }, {
            "suffix": "sus4",
            "frets": [-1, -1, 1, 1, 2, 0],
            "key": "E",
            "barres": [1],
            "midi": [59, 64, 69, 64],
            "fingers": [0, 0, 1, 1, 2, 0],
            "baseFret": 9
        }, {
            "midi": [40, 47, 50, 57, 59, 64],
            "key": "E",
            "baseFret": 1,
            "fingers": [0, 2, 0, 3, 0, 0],
            "barres": [],
            "suffix": "7sus4",
            "frets": [0, 2, 0, 2, 0, 0]
        }, {
            "barres": [1],
            "suffix": "7sus4",
            "frets": [-1, 3, 3, 3, 1, 1],
            "key": "E",
            "capo": true,
            "fingers": [0, 2, 3, 4, 1, 1],
            "midi": [52, 57, 62, 64, 69],
            "baseFret": 5
        }, {
            "baseFret": 7,
            "suffix": "7sus4",
            "key": "E",
            "midi": [47, 52, 59, 62, 69, 71],
            "capo": true,
            "fingers": [1, 1, 3, 1, 4, 1],
            "frets": [1, 1, 3, 1, 4, 1],
            "barres": [1]
        }, {
            "key": "E",
            "suffix": "7sus4",
            "baseFret": 9,
            "barres": [1],
            "fingers": [0, 0, 1, 1, 2, 3],
            "frets": [-1, -1, 1, 1, 2, 2],
            "midi": [59, 64, 69, 74],
            "capo": true
        }, {
            "baseFret": 1,
            "fingers": [0, 1, 3, 2, 0, 0],
            "frets": [0, 1, 2, 1, -1, -1],
            "suffix": "alt",
            "key": "E",
            "barres": [],
            "midi": [40, 46, 52, 56]
        }, {
            "barres": [],
            "key": "E",
            "midi": [52, 58, 64, 68],
            "baseFret": 2,
            "frets": [-1, -1, 1, 2, 4, 3],
            "suffix": "alt",
            "fingers": [0, 0, 1, 2, 4, 3]
        }, {
            "baseFret": 5,
            "midi": [40, 52, 56, 64, 70],
            "suffix": "alt",
            "frets": [0, 3, 2, -1, 1, 2],
            "barres": [],
            "key": "E",
            "fingers": [0, 4, 2, 0, 1, 3]
        }, {
            "frets": [0, 1, 2, 3, 3, 0],
            "fingers": [0, 1, 2, 3, 4, 0],
            "barres": [],
            "key": "E",
            "suffix": "alt",
            "baseFret": 7,
            "midi": [40, 52, 58, 64, 68, 64]
        }, {
            "midi": [40, 48, 52, 56, 60, 64],
            "fingers": [0, 4, 3, 1, 2, 0],
            "suffix": "aug",
            "key": "E",
            "barres": [],
            "baseFret": 1,
            "frets": [0, 3, 2, 1, 1, 0]
        }, {
            "barres": [1],
            "fingers": [0, 3, 2, 1, 1, 0],
            "capo": true,
            "suffix": "aug",
            "frets": [-1, 3, 2, 1, 1, -1],
            "key": "E",
            "midi": [52, 56, 60, 64],
            "baseFret": 5
        }, {
            "baseFret": 7,
            "fingers": [4, 3, 2, 1, 1, 0],
            "frets": [-1, 1, 4, 3, 3, -1],
            "midi": [52, 60, 64, 68],
            "key": "E",
            "suffix": "aug",
            "barres": []
        }, {
            "frets": [4, 3, 2, 1, 1, 0],
            "midi": [52, 56, 60, 64, 68, 64],
            "key": "E",
            "baseFret": 9,
            "barres": [1],
            "fingers": [4, 3, 2, 1, 1, 0],
            "suffix": "aug"
        }, {
            "suffix": "6",
            "fingers": [0, 2, 3, 1, 4, 0],
            "key": "E",
            "baseFret": 1,
            "barres": [],
            "frets": [0, 2, 2, 1, 2, 0],
            "midi": [40, 47, 52, 56, 61, 64]
        }, {
            "frets": [0, 2, 2, 4, 2, 4],
            "capo": true,
            "fingers": [0, 1, 1, 3, 1, 4],
            "barres": [2],
            "key": "E",
            "suffix": "6",
            "baseFret": 1,
            "midi": [40, 47, 52, 59, 61, 68]
        }, {
            "suffix": "6",
            "fingers": [0, 4, 2, 3, 1, 0],
            "barres": [],
            "midi": [52, 56, 61, 64],
            "baseFret": 5,
            "frets": [-1, 3, 2, 2, 1, -1],
            "key": "E"
        }, {
            "barres": [3],
            "midi": [52, 59, 64, 68, 73],
            "key": "E",
            "frets": [-1, 1, 3, 3, 3, 3],
            "fingers": [0, 1, 3, 3, 3, 3],
            "baseFret": 7,
            "suffix": "6"
        }, {
            "suffix": "6/9",
            "midi": [40, 47, 52, 56, 61, 66],
            "barres": [2],
            "fingers": [0, 2, 2, 1, 3, 4],
            "baseFret": 1,
            "frets": [0, 2, 2, 1, 2, 2],
            "key": "E"
        }, {
            "barres": [1],
            "fingers": [0, 2, 1, 1, 3, 4],
            "midi": [52, 56, 61, 66, 71],
            "frets": [-1, 2, 1, 1, 2, 2],
            "capo": true,
            "baseFret": 6,
            "key": "E",
            "suffix": "6/9"
        }, {
            "barres": [1],
            "capo": true,
            "midi": [54, 59, 64, 68, 73],
            "fingers": [0, 1, 1, 1, 1, 1],
            "key": "E",
            "suffix": "6/9",
            "frets": [-1, 1, 1, 1, 1, 1],
            "baseFret": 9
        }, {
            "key": "E",
            "barres": [1],
            "baseFret": 11,
            "midi": [40, 56, 61, 66, 71, 76],
            "suffix": "6/9",
            "fingers": [0, 1, 1, 1, 3, 4],
            "frets": [0, 1, 1, 1, 2, 2]
        }, {
            "key": "E",
            "barres": [],
            "suffix": "7",
            "baseFret": 1,
            "midi": [40, 47, 50, 56, 59, 64],
            "fingers": [0, 2, 0, 1, 0, 0],
            "frets": [0, 2, 0, 1, 0, 0]
        }, {
            "key": "E",
            "suffix": "7",
            "baseFret": 5,
            "frets": [-1, 3, 2, 3, 1, -1],
            "midi": [52, 56, 62, 64],
            "barres": [],
            "fingers": [0, 3, 2, 4, 1, 0]
        }, {
            "midi": [47, 52, 59, 62, 68, 71],
            "capo": true,
            "barres": [1],
            "baseFret": 7,
            "frets": [1, 1, 3, 1, 3, 1],
            "key": "E",
            "suffix": "7",
            "fingers": [1, 1, 3, 1, 4, 1]
        }, {
            "baseFret": 9,
            "suffix": "7",
            "key": "E",
            "fingers": [0, 0, 1, 1, 1, 2],
            "midi": [59, 64, 68, 74],
            "barres": [1],
            "capo": true,
            "frets": [-1, -1, 1, 1, 1, 2]
        }, {
            "fingers": [0, 1, 0, 2, 4, 0],
            "barres": [],
            "frets": [0, 1, 0, 1, 3, 0],
            "baseFret": 1,
            "key": "E",
            "suffix": "7b5",
            "midi": [40, 46, 50, 56, 62, 64]
        }, {
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [52, 58, 62, 68],
            "frets": [-1, -1, 2, 3, 3, 4],
            "baseFret": 1,
            "barres": [],
            "suffix": "7b5",
            "key": "E"
        }, {
            "midi": [56, 62, 64, 70],
            "baseFret": 5,
            "fingers": [0, 0, 2, 4, 1, 3],
            "key": "E",
            "suffix": "7b5",
            "frets": [-1, -1, 2, 3, 1, 2],
            "barres": []
        }, {
            "barres": [1],
            "suffix": "7b5",
            "fingers": [0, 1, 2, 1, 3, 0],
            "frets": [-1, 1, 2, 1, 3, -1],
            "key": "E",
            "midi": [52, 58, 62, 68],
            "capo": true,
            "baseFret": 7
        }, {
            "barres": [],
            "suffix": "aug7",
            "baseFret": 1,
            "fingers": [0, 4, 0, 1, 2, 0],
            "midi": [40, 48, 50, 56, 60, 64],
            "key": "E",
            "frets": [0, 3, 0, 1, 1, 0]
        }, {
            "key": "E",
            "fingers": [0, 0, 1, 4, 2, 3],
            "suffix": "aug7",
            "baseFret": 2,
            "midi": [52, 60, 62, 68],
            "barres": [],
            "frets": [-1, -1, 1, 4, 2, 3]
        }, {
            "frets": [-1, 1, 4, 1, 3, 2],
            "suffix": "aug7",
            "midi": [52, 60, 62, 68, 72],
            "key": "E",
            "capo": true,
            "barres": [1],
            "fingers": [0, 1, 4, 1, 3, 2],
            "baseFret": 7
        }, {
            "fingers": [1, 0, 2, 3, 4, 0],
            "frets": [1, -1, 1, 2, 2, -1],
            "suffix": "aug7",
            "midi": [52, 62, 68, 72],
            "key": "E",
            "baseFret": 12,
            "barres": []
        }, {
            "suffix": "9",
            "barres": [],
            "baseFret": 1,
            "key": "E",
            "frets": [0, 2, 0, 1, 0, 2],
            "midi": [40, 47, 50, 56, 59, 66],
            "fingers": [0, 2, 0, 1, 0, 3]
        }, {
            "baseFret": 1,
            "frets": [4, -1, 2, 4, 3, 2],
            "fingers": [3, 0, 1, 4, 2, 1],
            "key": "E",
            "suffix": "9",
            "barres": [2],
            "midi": [44, 52, 59, 62, 66]
        }, {
            "fingers": [2, 2, 1, 3, 3, 4],
            "key": "E",
            "baseFret": 6,
            "suffix": "9",
            "midi": [47, 52, 56, 62, 66, 71],
            "barres": [2],
            "frets": [2, 2, 1, 2, 2, 2]
        }, {
            "frets": [0, 1, 1, 1, 1, 2],
            "suffix": "9",
            "fingers": [0, 1, 1, 1, 1, 2],
            "midi": [40, 54, 59, 64, 68, 74],
            "key": "E",
            "barres": [1],
            "baseFret": 9
        }, {
            "frets": [0, 1, 2, 1, 3, 2],
            "suffix": "9b5",
            "fingers": [0, 1, 2, 1, 4, 3],
            "barres": [1],
            "baseFret": 1,
            "key": "E",
            "midi": [40, 46, 52, 56, 62, 66]
        }, {
            "frets": [0, 3, 2, 1, 1, 2],
            "barres": [1],
            "fingers": [0, 4, 2, 1, 1, 3],
            "midi": [40, 50, 54, 58, 62, 68],
            "key": "E",
            "suffix": "9b5",
            "baseFret": 3
        }, {
            "frets": [-1, 2, 1, 2, 2, 1],
            "key": "E",
            "suffix": "9b5",
            "midi": [52, 56, 62, 66, 70],
            "fingers": [0, 2, 1, 3, 4, 1],
            "barres": [1],
            "capo": true,
            "baseFret": 6
        }, {
            "key": "E",
            "midi": [40, 54, 58, 62, 68, 64],
            "fingers": [0, 3, 2, 1, 4, 0],
            "barres": [],
            "baseFret": 7,
            "suffix": "9b5",
            "frets": [0, 3, 2, 1, 3, 0]
        }, {
            "frets": [0, 3, 0, 1, 3, 2],
            "baseFret": 1,
            "midi": [40, 48, 50, 56, 62, 66],
            "suffix": "aug9",
            "fingers": [0, 3, 0, 1, 4, 2],
            "key": "E",
            "barres": []
        }, {
            "midi": [40, 50, 54, 60, 64, 68],
            "frets": [0, 2, 1, 2, 2, 1],
            "key": "E",
            "barres": [1],
            "baseFret": 4,
            "suffix": "aug9",
            "fingers": [0, 2, 1, 3, 4, 1]
        }, {
            "key": "E",
            "barres": [2],
            "frets": [-1, 2, 1, 2, 2, 3],
            "baseFret": 6,
            "fingers": [0, 2, 1, 3, 3, 4],
            "midi": [52, 56, 62, 66, 72],
            "suffix": "aug9"
        }, {
            "frets": [0, 1, 2, 1, 1, 2],
            "key": "E",
            "suffix": "aug9",
            "midi": [40, 54, 60, 64, 68, 74],
            "fingers": [0, 1, 2, 1, 1, 3],
            "baseFret": 9,
            "barres": [1]
        }, {
            "key": "E",
            "frets": [0, 2, 0, 1, 0, 1],
            "midi": [40, 47, 50, 56, 59, 65],
            "fingers": [0, 3, 0, 1, 0, 2],
            "suffix": "7b9",
            "barres": [],
            "baseFret": 1
        }, {
            "suffix": "7b9",
            "barres": [1],
            "midi": [40, 50, 50, 59, 65, 68],
            "fingers": [0, 3, 0, 1, 4, 1],
            "frets": [0, 2, 0, 1, 3, 1],
            "key": "E",
            "baseFret": 4
        }, {
            "suffix": "7b9",
            "barres": [1],
            "frets": [-1, 2, 1, 2, 1, 2],
            "baseFret": 6,
            "fingers": [0, 2, 1, 3, 1, 4],
            "midi": [52, 56, 62, 65, 71],
            "key": "E",
            "capo": true
        }, {
            "baseFret": 10,
            "barres": [],
            "suffix": "7b9",
            "midi": [52, 56, 62, 65],
            "frets": [3, 2, 3, 1, -1, -1],
            "key": "E",
            "fingers": [3, 2, 4, 1, 0, 0]
        }, {
            "midi": [40, 47, 50, 56, 59, 67],
            "key": "E",
            "baseFret": 1,
            "suffix": "7#9",
            "barres": [],
            "fingers": [0, 2, 0, 1, 0, 4],
            "frets": [0, 2, 0, 1, 0, 3]
        }, {
            "barres": [],
            "key": "E",
            "frets": [0, 3, 0, 0, 1, 2],
            "baseFret": 3,
            "midi": [40, 50, 50, 55, 62, 68],
            "fingers": [0, 3, 0, 0, 1, 2],
            "suffix": "7#9"
        }, {
            "baseFret": 6,
            "frets": [-1, 2, 1, 2, 3, -1],
            "key": "E",
            "midi": [52, 56, 62, 67],
            "barres": [],
            "suffix": "7#9",
            "fingers": [0, 2, 1, 3, 4, 0]
        }, {
            "midi": [40, 55, 59, 64, 68, 74],
            "barres": [1],
            "frets": [0, 2, 1, 1, 1, 2],
            "suffix": "7#9",
            "key": "E",
            "baseFret": 9,
            "fingers": [0, 2, 1, 1, 1, 3]
        }, {
            "key": "E",
            "frets": [0, 0, 0, 1, 0, 0],
            "baseFret": 1,
            "fingers": [0, 0, 0, 1, 0, 0],
            "barres": [],
            "suffix": "11",
            "midi": [40, 45, 50, 56, 59, 64]
        }, {
            "barres": [],
            "suffix": "11",
            "frets": [0, 0, 4, 4, 3, 4],
            "fingers": [0, 0, 2, 3, 1, 4],
            "midi": [40, 45, 54, 59, 62, 68],
            "baseFret": 1,
            "key": "E"
        }, {
            "baseFret": 5,
            "capo": true,
            "suffix": "11",
            "fingers": [0, 3, 2, 4, 1, 1],
            "frets": [-1, 3, 2, 3, 1, 1],
            "midi": [52, 56, 62, 64, 69],
            "barres": [1],
            "key": "E"
        }, {
            "frets": [-1, 1, 1, 1, 3, 1],
            "baseFret": 7,
            "key": "E",
            "barres": [1],
            "capo": true,
            "suffix": "11",
            "fingers": [0, 1, 1, 1, 3, 1],
            "midi": [52, 57, 62, 68, 71]
        }, {
            "midi": [40, 46, 50, 56, 59, 64],
            "fingers": [0, 1, 0, 2, 0, 0],
            "barres": [],
            "baseFret": 1,
            "key": "E",
            "frets": [0, 1, 0, 1, 0, 0],
            "suffix": "9#11"
        }, {
            "barres": [],
            "baseFret": 3,
            "frets": [0, 3, 0, 1, 3, 2],
            "key": "E",
            "midi": [40, 50, 50, 58, 64, 68],
            "fingers": [0, 3, 0, 1, 4, 2],
            "suffix": "9#11"
        }, {
            "baseFret": 6,
            "key": "E",
            "capo": true,
            "barres": [1],
            "midi": [52, 56, 62, 66, 70],
            "frets": [-1, 2, 1, 2, 2, 1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "suffix": "9#11"
        }, {
            "baseFret": 11,
            "key": "E",
            "capo": true,
            "midi": [52, 56, 62, 66, 70, 76],
            "barres": [1],
            "fingers": [2, 1, 3, 1, 1, 4],
            "frets": [2, 1, 2, 1, 1, 2],
            "suffix": "9#11"
        }, {
            "key": "E",
            "frets": [0, 2, 0, 1, 2, 0],
            "suffix": "13",
            "midi": [40, 47, 50, 56, 61, 64],
            "fingers": [0, 2, 0, 1, 3, 0],
            "barres": [],
            "baseFret": 1
        }, {
            "key": "E",
            "frets": [0, 0, 0, 1, 2, 2],
            "suffix": "13",
            "midi": [40, 45, 50, 56, 61, 66],
            "baseFret": 1,
            "barres": [],
            "fingers": [0, 0, 0, 1, 2, 3]
        }, {
            "frets": [0, 1, 2, 2, 1, 0],
            "midi": [40, 50, 56, 61, 64, 64],
            "barres": [],
            "key": "E",
            "suffix": "13",
            "fingers": [0, 1, 3, 4, 2, 0],
            "baseFret": 5
        }, {
            "barres": [1],
            "key": "E",
            "frets": [1, 1, 1, 1, 3, 3],
            "baseFret": 7,
            "midi": [47, 52, 57, 62, 68, 73],
            "capo": true,
            "suffix": "13",
            "fingers": [1, 1, 1, 1, 3, 4]
        }, {
            "baseFret": 1,
            "key": "E",
            "suffix": "maj7",
            "barres": [],
            "frets": [0, 2, 1, 1, 0, 0],
            "fingers": [0, 3, 1, 2, 0, 0],
            "midi": [40, 47, 51, 56, 59, 64]
        }, {
            "barres": [4],
            "frets": [-1, -1, 2, 4, 4, 4],
            "midi": [52, 59, 63, 68],
            "key": "E",
            "baseFret": 1,
            "fingers": [0, 0, 1, 3, 3, 3],
            "suffix": "maj7"
        }, {
            "key": "E",
            "suffix": "maj7",
            "frets": [-1, 4, 3, 1, 1, 1],
            "fingers": [0, 4, 3, 1, 1, 1],
            "baseFret": 4,
            "barres": [1],
            "capo": true,
            "midi": [52, 56, 59, 63, 68]
        }, {
            "frets": [1, 1, 3, 2, 3, 1],
            "baseFret": 7,
            "capo": true,
            "midi": [47, 52, 59, 63, 68, 71],
            "fingers": [1, 1, 3, 2, 4, 1],
            "suffix": "maj7",
            "barres": [1],
            "key": "E"
        }, {
            "midi": [40, 46, 51, 56, 63, 64],
            "barres": [1],
            "key": "E",
            "suffix": "maj7b5",
            "baseFret": 1,
            "frets": [0, 1, 1, 1, 4, 0],
            "fingers": [0, 1, 1, 1, 4, 0]
        }, {
            "baseFret": 1,
            "barres": [],
            "frets": [-1, -1, 2, 3, 4, 4],
            "key": "E",
            "suffix": "maj7b5",
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [52, 58, 63, 68]
        }, {
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0],
            "baseFret": 7,
            "key": "E",
            "suffix": "maj7b5",
            "midi": [52, 58, 63, 68],
            "frets": [-1, 1, 2, 2, 3, -1]
        }, {
            "midi": [40, 56, 63, 68, 70, 75],
            "frets": [0, 1, 3, 3, 1, 1],
            "fingers": [0, 1, 3, 4, 1, 1],
            "baseFret": 11,
            "barres": [1],
            "key": "E",
            "suffix": "maj7b5"
        }, {
            "baseFret": 1,
            "barres": [4],
            "frets": [0, 3, 2, 1, 4, 4],
            "key": "E",
            "suffix": "maj7#5",
            "midi": [40, 48, 52, 56, 63, 68],
            "fingers": [0, 3, 2, 1, 4, 4]
        }, {
            "fingers": [1, 4, 3, 2, 1, 1],
            "capo": true,
            "barres": [1],
            "frets": [1, 4, 3, 2, 1, 1],
            "key": "E",
            "suffix": "maj7#5",
            "midi": [44, 52, 56, 60, 63, 68],
            "baseFret": 4
        }, {
            "midi": [52, 60, 63, 68],
            "baseFret": 7,
            "suffix": "maj7#5",
            "frets": [-1, 1, 4, 2, 3, -1],
            "key": "E",
            "barres": [],
            "fingers": [0, 1, 4, 2, 3, 0]
        }, {
            "barres": [1],
            "frets": [0, 3, 2, 1, 1, 3],
            "key": "E",
            "suffix": "maj7#5",
            "fingers": [0, 3, 2, 1, 1, 4],
            "baseFret": 9,
            "midi": [40, 56, 60, 64, 68, 75]
        }, {
            "barres": [],
            "midi": [40, 47, 51, 56, 59, 66],
            "baseFret": 1,
            "suffix": "maj9",
            "fingers": [0, 3, 1, 2, 0, 4],
            "frets": [0, 2, 1, 1, 0, 2],
            "key": "E"
        }, {
            "frets": [4, 2, 2, 4, 4, 2],
            "barres": [2],
            "midi": [44, 47, 52, 59, 63, 66],
            "baseFret": 1,
            "suffix": "maj9",
            "capo": true,
            "key": "E",
            "fingers": [2, 1, 1, 3, 4, 1]
        }, {
            "midi": [52, 56, 63, 66],
            "barres": [],
            "key": "E",
            "baseFret": 6,
            "frets": [-1, 2, 1, 3, 2, -1],
            "fingers": [0, 2, 1, 4, 3, 0],
            "suffix": "maj9"
        }, {
            "fingers": [0, 0, 1, 3, 1, 4],
            "frets": [-1, -1, 1, 3, 1, 3],
            "key": "E",
            "midi": [59, 66, 68, 75],
            "baseFret": 9,
            "barres": [1],
            "capo": true,
            "suffix": "maj9"
        }, {
            "barres": [],
            "fingers": [0, 0, 1, 2, 0, 0],
            "frets": [0, 0, 1, 1, 0, 0],
            "suffix": "maj11",
            "midi": [40, 45, 51, 56, 59, 64],
            "key": "E",
            "baseFret": 1
        }, {
            "baseFret": 4,
            "suffix": "maj11",
            "midi": [40, 45, 56, 59, 63, 69],
            "frets": [0, 0, 3, 1, 1, 2],
            "key": "E",
            "barres": [1],
            "fingers": [0, 0, 3, 1, 1, 2]
        }, {
            "suffix": "maj11",
            "baseFret": 7,
            "barres": [1],
            "capo": true,
            "frets": [1, 1, 1, 2, 3, 1],
            "fingers": [1, 1, 1, 2, 3, 1],
            "midi": [47, 52, 57, 63, 68, 71],
            "key": "E"
        }, {
            "midi": [40, 56, 59, 64, 69, 75],
            "baseFret": 9,
            "frets": [0, 3, 1, 1, 2, 3],
            "fingers": [0, 3, 1, 1, 2, 4],
            "key": "E",
            "suffix": "maj11",
            "barres": [1]
        }, {
            "frets": [0, 2, 1, 1, 2, 2],
            "baseFret": 1,
            "key": "E",
            "fingers": [0, 2, 1, 1, 3, 4],
            "suffix": "maj13",
            "midi": [40, 47, 51, 56, 61, 66],
            "barres": [1]
        }, {
            "fingers": [0, 4, 2, 3, 1, 1],
            "midi": [52, 56, 61, 63, 68],
            "key": "E",
            "baseFret": 4,
            "suffix": "maj13",
            "barres": [1],
            "frets": [-1, 4, 3, 3, 1, 1]
        }, {
            "key": "E",
            "baseFret": 7,
            "suffix": "maj13",
            "frets": [-1, 1, 1, 2, 3, 3],
            "barres": [1],
            "capo": true,
            "midi": [52, 57, 63, 68, 73],
            "fingers": [0, 1, 1, 2, 3, 4]
        }, {
            "baseFret": 11,
            "midi": [52, 56, 61, 66, 71, 75],
            "fingers": [2, 1, 1, 1, 3, 1],
            "barres": [1],
            "capo": true,
            "key": "E",
            "suffix": "maj13",
            "frets": [2, 1, 1, 1, 2, 1]
        }, {
            "midi": [40, 47, 52, 55, 61, 64],
            "baseFret": 1,
            "barres": [],
            "suffix": "m6",
            "frets": [0, 2, 2, 0, 2, 0],
            "fingers": [0, 1, 2, 0, 3, 0],
            "key": "E"
        }, {
            "barres": [2],
            "fingers": [0, 1, 1, 3, 1, 2],
            "frets": [0, 2, 2, 4, 2, 3],
            "midi": [40, 47, 52, 59, 61, 67],
            "suffix": "m6",
            "baseFret": 1,
            "key": "E"
        }, {
            "barres": [1],
            "baseFret": 5,
            "capo": true,
            "suffix": "m6",
            "frets": [-1, 3, 1, 2, 1, 3],
            "fingers": [0, 3, 1, 2, 1, 4],
            "key": "E",
            "midi": [52, 55, 61, 64, 71]
        }, {
            "suffix": "m6",
            "fingers": [0, 0, 2, 3, 1, 4],
            "baseFret": 8,
            "barres": [],
            "frets": [-1, -1, 2, 2, 1, 2],
            "midi": [59, 64, 67, 73],
            "key": "E"
        }, {
            "frets": [0, 2, 2, 0, 3, 0],
            "barres": [],
            "suffix": "m7",
            "fingers": [0, 2, 3, 0, 4, 0],
            "midi": [40, 47, 52, 55, 62, 64],
            "baseFret": 1,
            "key": "E"
        }, {
            "suffix": "m7",
            "baseFret": 1,
            "barres": [],
            "midi": [40, 47, 50, 55, 59, 64],
            "fingers": [0, 2, 0, 0, 0, 0],
            "frets": [0, 2, 0, 0, 0, 0],
            "key": "E"
        }, {
            "frets": [0, 2, 2, 4, 3, 3],
            "barres": [2],
            "midi": [40, 47, 52, 59, 62, 67],
            "suffix": "m7",
            "baseFret": 1,
            "key": "E",
            "fingers": [0, 1, 1, 4, 2, 3]
        }, {
            "frets": [1, 1, 3, 1, 2, 1],
            "midi": [47, 52, 59, 62, 67, 71],
            "baseFret": 7,
            "suffix": "m7",
            "fingers": [1, 1, 3, 1, 2, 1],
            "capo": true,
            "barres": [1],
            "key": "E"
        }, {
            "frets": [-1, -1, 2, 2, 1, 3],
            "midi": [59, 64, 67, 74],
            "fingers": [0, 0, 2, 3, 1, 4],
            "key": "E",
            "suffix": "m7",
            "barres": [],
            "baseFret": 8
        }, {
            "key": "E",
            "fingers": [0, 1, 2, 3, 3, 3],
            "baseFret": 1,
            "midi": [40, 46, 52, 58, 62, 67],
            "frets": [0, 1, 2, 3, 3, 3],
            "suffix": "m7b5",
            "barres": [3]
        }, {
            "baseFret": 7,
            "fingers": [0, 1, 3, 2, 4, 0],
            "midi": [52, 58, 62, 67],
            "suffix": "m7b5",
            "frets": [-1, 1, 2, 1, 2, -1],
            "key": "E",
            "barres": []
        }, {
            "suffix": "m7b5",
            "barres": [1],
            "key": "E",
            "fingers": [0, 0, 1, 2, 1, 4],
            "midi": [58, 64, 67, 74],
            "baseFret": 8,
            "frets": [-1, -1, 1, 2, 1, 3],
            "capo": true
        }, {
            "frets": [2, -1, 2, 2, 1, -1],
            "fingers": [2, 0, 3, 4, 1, 0],
            "midi": [52, 62, 67, 70],
            "key": "E",
            "barres": [],
            "suffix": "m7b5",
            "baseFret": 11
        }, {
            "midi": [40, 47, 50, 55, 59, 66],
            "barres": [],
            "suffix": "m9",
            "frets": [0, 2, 0, 0, 0, 2],
            "baseFret": 1,
            "fingers": [0, 2, 0, 0, 0, 4],
            "key": "E"
        }, {
            "midi": [40, 47, 52, 55, 62, 66],
            "frets": [0, 2, 2, 0, 3, 2],
            "baseFret": 1,
            "fingers": [0, 1, 2, 0, 4, 3],
            "key": "E",
            "barres": [],
            "suffix": "m9"
        }, {
            "key": "E",
            "suffix": "m9",
            "barres": [3],
            "baseFret": 5,
            "fingers": [0, 2, 1, 3, 4, 4],
            "midi": [52, 55, 62, 66, 71],
            "frets": [-1, 3, 1, 3, 3, 3]
        }, {
            "baseFret": 10,
            "key": "E",
            "suffix": "m9",
            "fingers": [0, 1, 3, 2, 4, 1],
            "barres": [1],
            "midi": [40, 55, 62, 66, 71, 74],
            "frets": [0, 1, 3, 2, 3, 1]
        }, {
            "baseFret": 1,
            "barres": [2],
            "suffix": "m6/9",
            "frets": [0, 2, 2, 0, 2, 2],
            "midi": [40, 47, 52, 55, 61, 66],
            "fingers": [0, 1, 1, 0, 2, 3],
            "key": "E"
        }, {
            "baseFret": 1,
            "fingers": [2, 0, 1, 3, 1, 1],
            "frets": [3, -1, 2, 4, 2, 2],
            "midi": [43, 52, 59, 61, 66],
            "key": "E",
            "suffix": "m6/9",
            "barres": [2]
        }, {
            "frets": [-1, 3, 1, 2, 3, 3],
            "suffix": "m6/9",
            "barres": [3],
            "baseFret": 5,
            "fingers": [0, 3, 1, 2, 4, 4],
            "midi": [52, 55, 61, 66, 71],
            "key": "E"
        }, {
            "baseFret": 10,
            "key": "E",
            "fingers": [0, 1, 2, 3, 4, 0],
            "barres": [],
            "frets": [0, 1, 2, 2, 3, 0],
            "midi": [40, 55, 61, 66, 71, 64],
            "suffix": "m6/9"
        }, {
            "frets": [0, 0, 0, 0, 0, 2],
            "baseFret": 1,
            "midi": [40, 45, 50, 55, 59, 66],
            "fingers": [0, 0, 0, 0, 0, 1],
            "suffix": "m11",
            "barres": [],
            "key": "E"
        }, {
            "baseFret": 3,
            "midi": [40, 45, 55, 59, 62, 64],
            "suffix": "m11",
            "barres": [],
            "frets": [0, 0, 3, 2, 1, 0],
            "fingers": [0, 0, 3, 2, 1, 0],
            "key": "E"
        }, {
            "baseFret": 5,
            "barres": [1],
            "midi": [52, 55, 62, 66, 69],
            "suffix": "m11",
            "frets": [-1, 3, 1, 3, 3, 1],
            "capo": true,
            "fingers": [0, 2, 1, 3, 4, 1],
            "key": "E"
        }, {
            "frets": [3, 1, 3, 2, 1, 1],
            "capo": true,
            "barres": [1],
            "midi": [52, 55, 62, 66, 69, 74],
            "suffix": "m11",
            "baseFret": 10,
            "key": "E",
            "fingers": [3, 1, 4, 2, 1, 1]
        }, {
            "fingers": [0, 2, 1, 0, 0, 0],
            "frets": [0, 2, 1, 0, 0, 0],
            "barres": [],
            "midi": [40, 47, 51, 55, 59, 64],
            "key": "E",
            "suffix": "mmaj7",
            "baseFret": 1
        }, {
            "key": "E",
            "suffix": "mmaj7",
            "midi": [40, 47, 52, 59, 63, 67],
            "baseFret": 1,
            "fingers": [0, 1, 1, 3, 4, 2],
            "frets": [0, 2, 2, 4, 4, 3],
            "barres": [2]
        }, {
            "key": "E",
            "suffix": "mmaj7",
            "barres": [1],
            "baseFret": 4,
            "frets": [-1, 4, 2, 1, 1, -1],
            "capo": true,
            "midi": [52, 55, 59, 63],
            "fingers": [0, 4, 2, 1, 1, 0]
        }, {
            "frets": [1, 1, 3, 2, 2, 1],
            "key": "E",
            "suffix": "mmaj7",
            "midi": [47, 52, 59, 63, 67, 71],
            "fingers": [1, 1, 4, 2, 3, 1],
            "baseFret": 7,
            "capo": true,
            "barres": [1]
        }, {
            "baseFret": 1,
            "key": "E",
            "barres": [],
            "midi": [40, 46, 51, 55, 64],
            "suffix": "mmaj7b5",
            "fingers": [0, 1, 2, 0, 0, 0],
            "frets": [0, 1, 1, 0, -1, 0]
        }, {
            "barres": [],
            "midi": [52, 58, 63, 67],
            "fingers": [0, 0, 1, 2, 4, 3],
            "key": "E",
            "baseFret": 1,
            "suffix": "mmaj7b5",
            "frets": [-1, -1, 2, 3, 4, 3]
        }, {
            "barres": [3],
            "fingers": [1, 2, 3, 3, 3, 0],
            "baseFret": 6,
            "midi": [46, 52, 58, 63, 67],
            "frets": [1, 2, 3, 3, 3, -1],
            "suffix": "mmaj7b5",
            "key": "E"
        }, {
            "key": "E",
            "barres": [],
            "baseFret": 7,
            "frets": [-1, 1, 2, 2, 2, -1],
            "suffix": "mmaj7b5",
            "fingers": [0, 1, 2, 3, 4, 0],
            "midi": [52, 58, 63, 67]
        }, {
            "fingers": [0, 2, 1, 0, 0, 3],
            "suffix": "mmaj9",
            "barres": [],
            "midi": [40, 47, 51, 55, 59, 66],
            "frets": [0, 2, 1, 0, 0, 2],
            "key": "E",
            "baseFret": 1
        }, {
            "baseFret": 1,
            "frets": [0, -1, 4, 4, 4, 3],
            "barres": [4],
            "suffix": "mmaj9",
            "fingers": [0, 0, 2, 2, 4, 1],
            "midi": [40, 54, 59, 63, 67],
            "key": "E"
        }, {
            "key": "E",
            "fingers": [0, 4, 3, 2, 1, 0],
            "suffix": "mmaj9",
            "frets": [0, 4, 3, 2, 1, 0],
            "midi": [40, 55, 59, 63, 66, 64],
            "barres": [],
            "baseFret": 7
        }, {
            "barres": [1],
            "capo": true,
            "midi": [52, 59, 63, 67, 71, 78],
            "frets": [1, 3, 2, 1, 1, 3],
            "fingers": [1, 3, 2, 1, 1, 4],
            "baseFret": 12,
            "suffix": "mmaj9",
            "key": "E"
        }, {
            "fingers": [0, 0, 1, 0, 0, 3],
            "barres": [],
            "suffix": "mmaj11",
            "key": "E",
            "midi": [40, 45, 51, 55, 59, 66],
            "baseFret": 1,
            "frets": [0, 0, 1, 0, 0, 2]
        }, {
            "capo": true,
            "key": "E",
            "suffix": "mmaj11",
            "baseFret": 1,
            "frets": [-1, 2, 2, 2, 4, 3],
            "barres": [2],
            "fingers": [0, 1, 1, 1, 3, 2],
            "midi": [47, 52, 57, 63, 67]
        }, {
            "baseFret": 5,
            "frets": [-1, 3, 1, 4, 3, 1],
            "fingers": [0, 2, 1, 4, 3, 1],
            "capo": true,
            "midi": [52, 55, 63, 66, 69],
            "key": "E",
            "suffix": "mmaj11",
            "barres": [1]
        }, {
            "baseFret": 7,
            "barres": [1],
            "frets": [1, 1, 1, 2, 2, 1],
            "key": "E",
            "midi": [47, 52, 57, 63, 67, 71],
            "fingers": [1, 1, 1, 2, 3, 1],
            "suffix": "mmaj11",
            "capo": true
        }, {
            "key": "E",
            "suffix": "add9",
            "fingers": [0, 2, 3, 1, 0, 4],
            "baseFret": 1,
            "barres": [],
            "midi": [40, 47, 52, 56, 59, 66],
            "frets": [0, 2, 2, 1, 0, 2]
        }, {
            "frets": [-1, 4, 3, 1, 4, 1],
            "capo": true,
            "barres": [1],
            "midi": [52, 56, 59, 66, 68],
            "baseFret": 4,
            "key": "E",
            "suffix": "add9",
            "fingers": [0, 3, 2, 1, 4, 1]
        }, {
            "barres": [],
            "frets": [-1, 2, 1, -1, 2, 2],
            "fingers": [0, 2, 1, 0, 3, 4],
            "baseFret": 6,
            "midi": [52, 56, 66, 71],
            "suffix": "add9",
            "key": "E"
        }, {
            "baseFret": 12,
            "suffix": "add9",
            "barres": [],
            "frets": [-1, -1, 3, 2, 1, 3],
            "key": "E",
            "midi": [64, 68, 71, 78],
            "fingers": [0, 0, 3, 2, 1, 4]
        }, {
            "capo": true,
            "suffix": "madd9",
            "barres": [1],
            "frets": [-1, -1, 3, 1, 1, 3],
            "fingers": [0, 0, 3, 1, 1, 4],
            "key": "E",
            "midi": [53, 56, 60, 67],
            "baseFret": 1
        }, {
            "midi": [53, 56, 60, 67],
            "frets": [-1, 4, 2, 1, 4, -1],
            "suffix": "madd9",
            "barres": [],
            "baseFret": 5,
            "fingers": [0, 3, 2, 1, 4, 0],
            "key": "E"
        }, {
            "midi": [53, 56, 55, 65, 72],
            "fingers": [0, 3, 1, 0, 2, 4],
            "frets": [-1, 3, 1, 0, 1, 3],
            "suffix": "madd9",
            "key": "E",
            "barres": [],
            "baseFret": 6
        }, {
            "suffix": "madd9",
            "midi": [53, 60, 55, 68, 72],
            "key": "E",
            "baseFret": 8,
            "barres": [],
            "frets": [-1, 1, 3, 0, 2, 1],
            "fingers": [0, 1, 4, 0, 3, 2]
        }, {
            "fingers": [0, 2, 3, 1, 0, 0],
            "baseFret": 1,
            "barres": [],
            "midi": [47, 52, 56, 59, 64],
            "frets": [-1, 2, 2, 1, 0, 0],
            "key": "E",
            "suffix": "/B"
        }, {
            "fingers": [0, 1, 1, 3, 4, 3],
            "barres": [1],
            "midi": [47, 52, 59, 64, 68],
            "key": "E",
            "suffix": "/B",
            "frets": [-1, 1, 1, 3, 4, 3],
            "baseFret": 2
        }, {
            "suffix": "/B",
            "baseFret": 7,
            "fingers": [1, 1, 2, 3, 4, 1],
            "barres": [1],
            "midi": [47, 52, 59, 64, 68, 71],
            "key": "E",
            "frets": [1, 1, 3, 3, 3, 1]
        }, {
            "frets": [-1, 2, 2, 0, 0, 0],
            "barres": [],
            "suffix": "m/B",
            "key": "E",
            "baseFret": 1,
            "midi": [47, 52, 55, 59, 64],
            "fingers": [0, 1, 2, 0, 0, 0]
        }, {
            "midi": [47, 52, 55, 59, 67],
            "frets": [-1, 2, 2, 0, 0, 3],
            "baseFret": 1,
            "key": "E",
            "barres": [],
            "fingers": [0, 1, 2, 0, 0, 3],
            "suffix": "m/B"
        }, {
            "frets": [-1, 1, 1, 3, 4, 2],
            "key": "E",
            "fingers": [0, 1, 1, 3, 4, 2],
            "suffix": "m/B",
            "midi": [47, 52, 59, 64, 67],
            "baseFret": 2,
            "barres": []
        }, {
            "barres": [1],
            "key": "E",
            "suffix": "/C#",
            "frets": [-1, 1, 3, 1, 2, 1],
            "midi": [49, 56, 59, 64, 68],
            "baseFret": 4,
            "fingers": [0, 1, 3, 1, 2, 1]
        }, {
            "suffix": "/C#",
            "midi": [49, 56, 59, 64, 71],
            "barres": [1],
            "fingers": [0, 1, 3, 1, 2, 4],
            "frets": [-1, 1, 3, 1, 2, 4],
            "key": "E",
            "baseFret": 4
        }, {
            "barres": [1],
            "suffix": "/C#",
            "fingers": [1, 3, 1, 1, 4, 4],
            "baseFret": 9,
            "frets": [1, 3, 1, 1, 4, 4],
            "key": "E",
            "midi": [49, 56, 59, 64, 71, 76]
        }, {
            "frets": [-1, 4, 2, 0, 0, 0],
            "baseFret": 1,
            "key": "E",
            "barres": [],
            "suffix": "m/C#",
            "fingers": [0, 3, 1, 0, 0, 0],
            "midi": [49, 52, 55, 59, 64]
        }, {
            "fingers": [0, 1, 2, 1, 3, 4],
            "midi": [49, 55, 59, 64, 71],
            "barres": [],
            "frets": [-1, 1, 2, 1, 2, 4],
            "key": "E",
            "baseFret": 4,
            "suffix": "m/C#"
        }, {
            "midi": [49, 55, 59, 67, 71, 76],
            "frets": [1, 2, 1, 4, 4, 4],
            "barres": [1],
            "key": "E",
            "fingers": [1, 2, 1, 4, 4, 4],
            "baseFret": 9,
            "suffix": "m/C#"
        }, {
            "midi": [50, 56, 59, 64],
            "frets": [-1, -1, 0, 1, 0, 0],
            "fingers": [0, 0, 0, 1, 0, 0],
            "suffix": "/D",
            "barres": [],
            "baseFret": 1,
            "key": "E"
        }, {
            "key": "E",
            "barres": [1],
            "midi": [50, 56, 59, 64, 68],
            "suffix": "/D",
            "fingers": [0, 2, 4, 1, 3, 1],
            "frets": [-1, 2, 3, 1, 2, 1],
            "baseFret": 4
        }, {
            "frets": [-1, 4, 1, 3, 4, 3],
            "fingers": [0, 3, 1, 2, 4, 2],
            "midi": [50, 52, 59, 64, 68],
            "key": "E",
            "barres": [3],
            "baseFret": 2,
            "suffix": "/D"
        }, {
            "midi": [50, 55, 59, 64],
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 0, 0, 0, 0],
            "fingers": [0, 0, 0, 0, 0, 0],
            "key": "E",
            "suffix": "m/D"
        }, {
            "midi": [50, 55, 59, 64],
            "baseFret": 4,
            "key": "E",
            "barres": [],
            "frets": [-1, 2, 2, 1, 2, -1],
            "fingers": [0, 2, 3, 1, 4, 0],
            "suffix": "m/D"
        }, {
            "baseFret": 12,
            "frets": [-1, -1, 1, 1, 1, 1],
            "midi": [62, 67, 71, 76],
            "suffix": "m/D",
            "key": "E",
            "barres": [1],
            "fingers": [0, 0, 1, 1, 1, 1]
        }, {
            "barres": [],
            "fingers": [0, 0, 1, 2, 0, 0],
            "midi": [51, 56, 59, 64],
            "key": "E",
            "suffix": "/D#",
            "frets": [-1, -1, 1, 1, 0, 0],
            "baseFret": 1
        }, {
            "fingers": [0, 3, 4, 1, 2, 1],
            "frets": [-1, 3, 3, 1, 2, 1],
            "barres": [1],
            "midi": [51, 56, 59, 64, 68],
            "key": "E",
            "suffix": "/D#",
            "baseFret": 4
        }, {
            "barres": [1],
            "baseFret": 9,
            "suffix": "/D#",
            "key": "E",
            "fingers": [2, 3, 1, 1, 4, 4],
            "frets": [3, 3, 1, 1, 4, 4],
            "midi": [51, 56, 59, 64, 71, 76]
        }, {
            "frets": [-1, -1, 1, 0, 0, 0],
            "fingers": [0, 0, 1, 0, 0, 0],
            "suffix": "m/D#",
            "midi": [51, 55, 59, 64],
            "baseFret": 1,
            "key": "E",
            "barres": []
        }, {
            "frets": [-1, 3, 2, 1, 2, -1],
            "suffix": "m/D#",
            "midi": [51, 55, 59, 64],
            "barres": [],
            "key": "E",
            "fingers": [0, 4, 2, 1, 3, 0],
            "baseFret": 4
        }, {
            "frets": [-1, 1, 4, 4, 3, -1],
            "baseFret": 6,
            "barres": [],
            "key": "E",
            "fingers": [0, 1, 3, 4, 2, 0],
            "midi": [51, 59, 64, 67],
            "suffix": "m/D#"
        }, {
            "frets": [1, 2, 2, 1, 0, 0],
            "barres": [],
            "key": "E",
            "suffix": "/F",
            "fingers": [1, 3, 4, 2, 0, 0],
            "midi": [41, 47, 52, 56, 59, 64],
            "baseFret": 1
        }, {
            "frets": [-1, -1, 3, 1, 0, 0],
            "fingers": [0, 0, 3, 1, 0, 0],
            "suffix": "/F",
            "barres": [],
            "key": "E",
            "baseFret": 1,
            "midi": [53, 56, 59, 64]
        }, {
            "key": "E",
            "fingers": [0, 0, 1, 2, 4, 3],
            "frets": [-1, -1, 1, 2, 3, 2],
            "midi": [53, 59, 64, 68],
            "baseFret": 3,
            "suffix": "/F",
            "barres": []
        }, {
            "fingers": [2, 3, 4, 1, 0, 0],
            "key": "E",
            "midi": [42, 47, 52, 56, 59, 64],
            "barres": [],
            "baseFret": 1,
            "frets": [2, 2, 2, 1, 0, 0],
            "suffix": "/F#"
        }, {
            "baseFret": 4,
            "key": "E",
            "barres": [1],
            "midi": [54, 59, 64, 68],
            "suffix": "/F#",
            "frets": [-1, -1, 1, 1, 2, 1],
            "fingers": [0, 0, 1, 1, 2, 1]
        }, {
            "frets": [1, 1, 1, 3, 4, 3],
            "key": "E",
            "baseFret": 2,
            "fingers": [1, 1, 1, 3, 4, 3],
            "suffix": "/F#",
            "midi": [42, 47, 52, 59, 64, 68],
            "barres": [1]
        }, {
            "baseFret": 1,
            "fingers": [4, 2, 3, 1, 0, 0],
            "key": "E",
            "barres": [],
            "frets": [3, 2, 2, 1, 0, 0],
            "suffix": "/G",
            "midi": [43, 47, 52, 56, 59, 64]
        }, {
            "frets": [2, 1, 1, 3, 4, 3],
            "key": "E",
            "midi": [43, 47, 52, 59, 64, 68],
            "suffix": "/G",
            "baseFret": 2,
            "fingers": [2, 1, 1, 3, 4, 3],
            "barres": [1]
        }, {
            "baseFret": 4,
            "suffix": "/G",
            "key": "E",
            "fingers": [0, 0, 3, 1, 4, 2],
            "frets": [-1, -1, 2, 1, 2, 1],
            "midi": [55, 59, 64, 68],
            "barres": []
        }, {
            "key": "E",
            "midi": [56, 59, 64],
            "fingers": [0, 0, 0, 1, 0, 0],
            "baseFret": 1,
            "suffix": "/G#",
            "barres": [],
            "frets": [-1, -1, -1, 1, 0, 0]
        }, {
            "key": "E",
            "fingers": [4, 2, 3, 1, 0, 0],
            "frets": [4, 2, 2, 1, 0, 0],
            "barres": [],
            "suffix": "/G#",
            "midi": [44, 47, 52, 56, 59, 64],
            "baseFret": 1
        }, {
            "fingers": [1, 4, 3, 1, 2, 1],
            "baseFret": 4,
            "frets": [1, 4, 3, 1, 2, 1],
            "suffix": "/G#",
            "key": "E",
            "barres": [1],
            "midi": [44, 52, 56, 59, 64, 68]
        }, {
            "fingers": [2, 1, 1, 3, 4, 0],
            "key": "E",
            "barres": [1],
            "frets": [3, 1, 1, 3, 4, -1],
            "midi": [44, 47, 52, 59, 64],
            "suffix": "/G#",
            "baseFret": 2
        }, {
            "frets": [-1, -1, 3, 0, 0, 0],
            "baseFret": 1,
            "fingers": [0, 0, 1, 0, 0, 0],
            "suffix": "m/F",
            "barres": [],
            "key": "E",
            "midi": [53, 55, 59, 64]
        }, {
            "suffix": "m/F",
            "midi": [41, 47, 52, 55, 59, 64],
            "barres": [],
            "baseFret": 1,
            "fingers": [1, 2, 3, 0, 0, 0],
            "key": "E",
            "frets": [1, 2, 2, 0, 0, 0]
        }, {
            "barres": [],
            "suffix": "m/F",
            "fingers": [1, 2, 3, 0, 0, 4],
            "key": "E",
            "baseFret": 1,
            "frets": [1, 2, 2, 0, 0, 3],
            "midi": [41, 47, 52, 55, 59, 67]
        }, {
            "barres": [],
            "midi": [42, 47, 52, 55, 59, 64],
            "fingers": [1, 2, 3, 0, 0, 0],
            "suffix": "m/F#",
            "baseFret": 1,
            "key": "E",
            "frets": [2, 2, 2, 0, 0, 0]
        }, {
            "baseFret": 1,
            "frets": [2, 2, 2, 0, 0, 3],
            "barres": [],
            "suffix": "m/F#",
            "key": "E",
            "midi": [42, 47, 52, 55, 59, 67],
            "fingers": [1, 2, 3, 0, 0, 4]
        }, {
            "fingers": [1, 1, 1, 3, 4, 2],
            "midi": [42, 47, 52, 59, 64, 67],
            "key": "E",
            "baseFret": 2,
            "frets": [1, 1, 1, 3, 4, 2],
            "suffix": "m/F#",
            "barres": [1]
        }, {
            "fingers": [3, 1, 2, 0, 0, 0],
            "frets": [3, 2, 2, 0, 0, 0],
            "baseFret": 1,
            "key": "E",
            "barres": [],
            "suffix": "m/G",
            "midi": [43, 47, 52, 55, 59, 64]
        }, {
            "baseFret": 1,
            "frets": [3, 2, 2, 0, 0, 3],
            "barres": [],
            "fingers": [3, 1, 2, 0, 0, 4],
            "suffix": "m/G",
            "midi": [43, 47, 52, 55, 59, 67],
            "key": "E"
        }, {
            "key": "E",
            "frets": [2, 1, 1, 3, 4, 0],
            "barres": [1],
            "fingers": [2, 1, 1, 3, 4, 0],
            "midi": [43, 47, 52, 59, 64, 64],
            "baseFret": 2,
            "suffix": "m/G"
        }, {
            "midi": [44, 47, 52, 55, 59, 64],
            "frets": [4, 2, 2, 0, 0, 0],
            "key": "E",
            "suffix": "m/G#",
            "barres": [],
            "baseFret": 1,
            "fingers": [4, 1, 2, 0, 0, 0]
        }, {
            "baseFret": 4,
            "barres": [1],
            "frets": [1, 4, 2, 1, 2, -1],
            "key": "E",
            "suffix": "m/G#",
            "fingers": [1, 4, 2, 1, 3, 0],
            "midi": [44, 52, 55, 59, 64]
        }, {
            "frets": [-1, -1, 4, 2, 3, 1],
            "barres": [],
            "fingers": [0, 0, 4, 2, 3, 1],
            "key": "E",
            "suffix": "m/G#",
            "midi": [56, 59, 64, 67],
            "baseFret": 3
        }, {
            "baseFret": 1,
            "fingers": [1, 3, 4, 2, 1, 1],
            "barres": [1],
            "capo": true,
            "key": "F",
            "frets": [1, 3, 3, 2, 1, 1],
            "suffix": "major",
            "midi": [41, 48, 53, 57, 60, 65]
        }, {
            "midi": [48, 53, 60, 65, 69],
            "suffix": "major",
            "capo": true,
            "barres": [1],
            "baseFret": 3,
            "frets": [-1, 1, 1, 3, 4, 3],
            "fingers": [0, 1, 1, 2, 4, 3],
            "key": "F"
        }, {
            "midi": [45, 53, 57, 60, 65, 69],
            "baseFret": 5,
            "barres": [1],
            "key": "F",
            "fingers": [1, 4, 3, 1, 2, 1],
            "capo": true,
            "frets": [1, 4, 3, 1, 2, 1],
            "suffix": "major"
        }, {
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [48, 53, 60, 65, 69, 72],
            "suffix": "major",
            "capo": true,
            "key": "F",
            "barres": [1],
            "frets": [1, 1, 3, 3, 3, 1],
            "baseFret": 8
        }, {
            "key": "F",
            "fingers": [1, 3, 4, 1, 1, 1],
            "capo": true,
            "baseFret": 1,
            "frets": [1, 3, 3, 1, 1, 1],
            "midi": [41, 48, 53, 56, 60, 65],
            "barres": [1],
            "suffix": "minor"
        }, {
            "barres": [],
            "fingers": [0, 0, 1, 3, 4, 2],
            "suffix": "minor",
            "key": "F",
            "baseFret": 3,
            "midi": [53, 60, 65, 68],
            "frets": [-1, -1, 1, 3, 4, 2]
        }, {
            "midi": [48, 53, 60, 65, 68, 72],
            "capo": true,
            "barres": [1],
            "frets": [1, 1, 3, 3, 2, 1],
            "baseFret": 8,
            "key": "F",
            "fingers": [1, 1, 3, 4, 2, 1],
            "suffix": "minor"
        }, {
            "key": "F",
            "midi": [53, 56, 60, 65],
            "fingers": [4, 2, 1, 1, 0, 0],
            "suffix": "minor",
            "baseFret": 10,
            "frets": [4, 2, 1, 1, -1, -1],
            "capo": true,
            "barres": [1]
        }, {
            "key": "F",
            "fingers": [0, 0, 1, 2, 0, 3],
            "midi": [53, 59, 68],
            "frets": [-1, -1, 3, 4, -1, 4],
            "barres": [],
            "suffix": "dim",
            "baseFret": 1
        }, {
            "suffix": "dim",
            "fingers": [0, 4, 1, 0, 2, 3],
            "frets": [-1, 3, 1, -1, 1, 2],
            "baseFret": 6,
            "key": "F",
            "midi": [53, 56, 65, 71],
            "barres": []
        }, {
            "midi": [53, 59, 65, 68],
            "baseFret": 8,
            "frets": [-1, 1, 2, 3, 2, -1],
            "barres": [],
            "suffix": "dim",
            "fingers": [0, 1, 2, 4, 3, 0],
            "key": "F"
        }, {
            "frets": [3, 1, -1, 3, 2, -1],
            "key": "F",
            "baseFret": 11,
            "fingers": [3, 1, 0, 4, 2, 0],
            "midi": [53, 56, 68, 71],
            "suffix": "dim",
            "barres": []
        }, {
            "fingers": [1, 0, 0, 2, 0, 3],
            "barres": [],
            "suffix": "dim7",
            "midi": [41, 50, 56, 59, 65],
            "baseFret": 1,
            "key": "F",
            "frets": [1, -1, 0, 1, 0, 1]
        }, {
            "baseFret": 1,
            "midi": [53, 59, 62, 68],
            "key": "F",
            "suffix": "dim7",
            "capo": true,
            "fingers": [0, 0, 1, 3, 1, 4],
            "barres": [3],
            "frets": [-1, -1, 3, 4, 3, 4]
        }, {
            "key": "F",
            "suffix": "dim7",
            "capo": true,
            "barres": [1],
            "frets": [1, 2, 3, 1, 3, 1],
            "baseFret": 7,
            "fingers": [1, 2, 3, 1, 4, 1],
            "midi": [47, 53, 59, 62, 68, 71]
        }, {
            "baseFret": 12,
            "key": "F",
            "barres": [],
            "suffix": "dim7",
            "fingers": [3, 0, 1, 4, 2, 0],
            "frets": [2, -1, 1, 2, 1, -1],
            "midi": [53, 62, 68, 71]
        }, {
            "capo": true,
            "midi": [41, 48, 53, 60, 67],
            "frets": [1, 3, 3, -1, 1, 3],
            "baseFret": 1,
            "barres": [1],
            "fingers": [1, 2, 3, 0, 1, 4],
            "key": "F",
            "suffix": "sus2"
        }, {
            "key": "F",
            "barres": [1],
            "fingers": [1, 1, 1, 3, 4, 1],
            "baseFret": 3,
            "midi": [43, 48, 53, 60, 65, 67],
            "suffix": "sus2",
            "frets": [1, 1, 1, 3, 4, 1],
            "capo": true
        }, {
            "capo": true,
            "barres": [1],
            "midi": [48, 53, 60, 65, 67, 72],
            "baseFret": 8,
            "suffix": "sus2",
            "fingers": [1, 1, 3, 4, 1, 1],
            "key": "F",
            "frets": [1, 1, 3, 3, 1, 1]
        }, {
            "midi": [53, 55, 60, 67, 72],
            "fingers": [3, 1, 1, 2, 4, 0],
            "key": "F",
            "suffix": "sus2",
            "frets": [4, 1, 1, 3, 4, -1],
            "capo": true,
            "barres": [1],
            "baseFret": 10
        }, {
            "barres": [1],
            "baseFret": 1,
            "capo": true,
            "midi": [41, 48, 53, 58, 60, 65],
            "fingers": [1, 2, 3, 4, 1, 1],
            "key": "F",
            "suffix": "sus4",
            "frets": [1, 3, 3, 3, 1, 1]
        }, {
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [53, 60, 65, 70],
            "barres": [],
            "key": "F",
            "suffix": "sus4",
            "baseFret": 3,
            "frets": [-1, -1, 1, 3, 4, 4]
        }, {
            "midi": [48, 53, 60, 65, 70, 72],
            "key": "F",
            "barres": [1],
            "baseFret": 8,
            "capo": true,
            "suffix": "sus4",
            "frets": [1, 1, 3, 3, 4, 1],
            "fingers": [1, 1, 2, 3, 4, 1]
        }, {
            "baseFret": 10,
            "key": "F",
            "frets": [-1, -1, 1, 1, 2, -1],
            "midi": [60, 65, 70],
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 1, 1, 2, 0],
            "suffix": "sus4"
        }, {
            "suffix": "7sus4",
            "baseFret": 1,
            "barres": [1],
            "midi": [41, 48, 51, 58, 60, 65],
            "fingers": [1, 3, 1, 4, 1, 1],
            "capo": true,
            "key": "F",
            "frets": [1, 3, 1, 3, 1, 1]
        }, {
            "frets": [1, 3, 3, 3, 1, 1],
            "key": "F",
            "suffix": "7sus4",
            "midi": [46, 53, 58, 63, 65, 70],
            "barres": [1],
            "baseFret": 6,
            "fingers": [1, 2, 3, 4, 1, 1],
            "capo": true
        }, {
            "key": "F",
            "fingers": [1, 1, 3, 1, 4, 1],
            "capo": true,
            "frets": [1, 1, 3, 1, 4, 1],
            "barres": [1],
            "baseFret": 8,
            "midi": [48, 53, 60, 63, 70, 72],
            "suffix": "7sus4"
        }, {
            "midi": [60, 65, 70, 75],
            "barres": [1],
            "fingers": [0, 0, 1, 1, 3, 4],
            "capo": true,
            "key": "F",
            "baseFret": 10,
            "frets": [-1, -1, 1, 1, 2, 2],
            "suffix": "7sus4"
        }, {
            "key": "F",
            "baseFret": 1,
            "barres": [],
            "frets": [1, 2, 3, 2, 0, -1],
            "fingers": [1, 2, 4, 3, 0, 0],
            "suffix": "alt",
            "midi": [41, 47, 53, 57, 59]
        }, {
            "barres": [],
            "frets": [-1, -1, 1, 2, 0, 3],
            "fingers": [0, 0, 1, 2, 0, 3],
            "suffix": "alt",
            "key": "F",
            "baseFret": 3,
            "midi": [53, 59, 59, 69]
        }, {
            "frets": [-1, 1, 2, 3, 3, -1],
            "midi": [53, 59, 65, 69],
            "key": "F",
            "fingers": [0, 1, 2, 3, 4, 0],
            "baseFret": 8,
            "barres": [],
            "suffix": "alt"
        }, {
            "barres": [1],
            "capo": true,
            "frets": [2, 1, -1, 3, 1, 2],
            "baseFret": 12,
            "midi": [53, 57, 69, 71, 77],
            "fingers": [2, 1, 0, 4, 1, 3],
            "key": "F",
            "suffix": "alt"
        }, {
            "key": "F",
            "midi": [53, 57, 61, 65],
            "baseFret": 1,
            "barres": [],
            "frets": [-1, -1, 3, 2, 2, 1],
            "suffix": "aug",
            "fingers": [0, 0, 4, 2, 3, 1]
        }, {
            "baseFret": 6,
            "key": "F",
            "barres": [1],
            "capo": true,
            "suffix": "aug",
            "midi": [53, 57, 61, 65],
            "fingers": [0, 3, 2, 1, 1, 0],
            "frets": [-1, 3, 2, 1, 1, -1]
        }, {
            "barres": [],
            "baseFret": 8,
            "key": "F",
            "midi": [53, 65, 69, 73],
            "fingers": [0, 1, 0, 3, 4, 2],
            "frets": [-1, 1, -1, 3, 3, 2],
            "suffix": "aug"
        }, {
            "suffix": "aug",
            "midi": [53, 57, 61, 65, 69],
            "frets": [4, 3, 2, 1, 1, -1],
            "barres": [1],
            "key": "F",
            "fingers": [4, 3, 2, 1, 1, 0],
            "baseFret": 10
        }, {
            "frets": [1, -1, 3, 2, 3, 1],
            "baseFret": 1,
            "barres": [1],
            "fingers": [1, 0, 3, 2, 4, 1],
            "midi": [41, 53, 57, 62, 65],
            "capo": true,
            "suffix": "6",
            "key": "F"
        }, {
            "barres": [1],
            "capo": true,
            "fingers": [0, 1, 1, 3, 1, 4],
            "frets": [-1, 1, 1, 3, 1, 3],
            "suffix": "6",
            "midi": [48, 53, 60, 62, 69],
            "key": "F",
            "baseFret": 3
        }, {
            "frets": [-1, 3, 2, 2, 1, -1],
            "suffix": "6",
            "baseFret": 6,
            "midi": [53, 57, 62, 65],
            "fingers": [0, 4, 2, 3, 1, 0],
            "key": "F",
            "barres": []
        }, {
            "midi": [48, 53, 60, 65, 69, 74],
            "barres": [1, 3],
            "key": "F",
            "baseFret": 8,
            "fingers": [1, 1, 3, 3, 3, 3],
            "frets": [1, 1, 3, 3, 3, 3],
            "suffix": "6"
        }, {
            "suffix": "6/9",
            "frets": [1, 0, 0, 0, 1, 1],
            "barres": [],
            "fingers": [1, 0, 0, 0, 2, 3],
            "key": "F",
            "midi": [41, 45, 50, 55, 60, 65],
            "baseFret": 1
        }, {
            "midi": [53, 57, 62, 67],
            "barres": [],
            "frets": [-1, -1, 3, 2, 3, 3],
            "suffix": "6/9",
            "fingers": [0, 0, 2, 1, 3, 4],
            "baseFret": 1,
            "key": "F"
        }, {
            "baseFret": 5,
            "suffix": "6/9",
            "key": "F",
            "barres": [1],
            "midi": [50, 55, 60, 65, 69],
            "frets": [-1, 1, 1, 1, 2, 1],
            "fingers": [0, 1, 1, 1, 2, 1],
            "capo": true
        }, {
            "midi": [53, 57, 62, 67, 72],
            "key": "F",
            "baseFret": 7,
            "capo": true,
            "barres": [1],
            "suffix": "6/9",
            "frets": [-1, 2, 1, 1, 2, 2],
            "fingers": [0, 2, 1, 1, 3, 4]
        }, {
            "midi": [41, 48, 51, 57, 60, 65],
            "fingers": [1, 3, 1, 2, 1, 1],
            "capo": true,
            "suffix": "7",
            "baseFret": 1,
            "key": "F",
            "frets": [1, 3, 1, 2, 1, 1],
            "barres": [1]
        }, {
            "key": "F",
            "midi": [48, 53, 60, 63, 69],
            "barres": [1],
            "frets": [-1, 1, 1, 3, 2, 3],
            "baseFret": 3,
            "suffix": "7",
            "fingers": [0, 1, 1, 3, 2, 4],
            "capo": true
        }, {
            "baseFret": 8,
            "capo": true,
            "fingers": [1, 1, 3, 1, 4, 1],
            "suffix": "7",
            "frets": [1, 1, 3, 1, 3, 1],
            "key": "F",
            "barres": [1],
            "midi": [48, 53, 60, 63, 69, 72]
        }, {
            "barres": [1],
            "capo": true,
            "key": "F",
            "frets": [-1, -1, 1, 1, 1, 2],
            "baseFret": 10,
            "fingers": [0, 0, 1, 1, 1, 2],
            "suffix": "7",
            "midi": [60, 65, 69, 75]
        }, {
            "key": "F",
            "midi": [41, 45, 51, 57, 59, 65],
            "barres": [],
            "frets": [1, 0, 1, 2, 0, 1],
            "suffix": "7b5",
            "fingers": [1, 0, 2, 4, 0, 3],
            "baseFret": 1
        }, {
            "baseFret": 3,
            "frets": [-1, -1, 1, 2, 2, 3],
            "barres": [],
            "suffix": "7b5",
            "midi": [53, 59, 63, 69],
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "F"
        }, {
            "barres": [],
            "frets": [-1, -1, 2, 3, 1, 2],
            "baseFret": 6,
            "fingers": [0, 0, 2, 4, 1, 3],
            "midi": [57, 63, 65, 71],
            "suffix": "7b5",
            "key": "F"
        }, {
            "frets": [-1, 1, 2, 1, 3, -1],
            "capo": true,
            "midi": [53, 59, 63, 69],
            "baseFret": 8,
            "fingers": [0, 1, 2, 1, 3, 0],
            "suffix": "7b5",
            "barres": [1],
            "key": "F"
        }, {
            "frets": [1, 0, 1, 2, 2, -1],
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 1,
            "key": "F",
            "suffix": "aug7",
            "midi": [41, 45, 51, 57, 61],
            "barres": []
        }, {
            "frets": [-1, -1, 1, 4, 2, 3],
            "suffix": "aug7",
            "barres": [],
            "midi": [53, 61, 63, 69],
            "baseFret": 3,
            "fingers": [0, 0, 1, 4, 2, 3],
            "key": "F"
        }, {
            "fingers": [0, 1, 4, 1, 3, 2],
            "barres": [1],
            "key": "F",
            "frets": [-1, 1, 4, 1, 3, 2],
            "suffix": "aug7",
            "midi": [53, 61, 63, 69, 73],
            "capo": true,
            "baseFret": 8
        }, {
            "barres": [],
            "fingers": [2, 1, 3, 0, 4, 0],
            "midi": [53, 57, 63, 73],
            "baseFret": 12,
            "suffix": "aug7",
            "key": "F",
            "frets": [2, 1, 2, -1, 3, -1]
        }, {
            "key": "F",
            "barres": [1],
            "suffix": "9",
            "midi": [41, 48, 51, 57, 60, 67],
            "fingers": [1, 3, 1, 2, 1, 4],
            "capo": true,
            "baseFret": 1,
            "frets": [1, 3, 1, 2, 1, 3]
        }, {
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 3, 2, 4, 3],
            "fingers": [0, 0, 2, 1, 4, 3],
            "midi": [53, 57, 63, 67],
            "key": "F",
            "suffix": "9"
        }, {
            "frets": [2, 2, 1, 2, 2, 2],
            "barres": [2],
            "key": "F",
            "fingers": [2, 2, 1, 3, 3, 4],
            "baseFret": 7,
            "suffix": "9",
            "midi": [48, 53, 57, 63, 67, 72]
        }, {
            "frets": [-1, 1, 1, 1, 1, 2],
            "midi": [55, 60, 65, 69, 75],
            "baseFret": 10,
            "fingers": [0, 1, 1, 1, 1, 2],
            "suffix": "9",
            "barres": [1],
            "key": "F"
        }, {
            "suffix": "9b5",
            "frets": [1, 0, 1, 0, 0, 1],
            "fingers": [1, 0, 2, 0, 0, 3],
            "midi": [41, 45, 51, 55, 59, 65],
            "barres": [],
            "key": "F",
            "baseFret": 1
        }, {
            "suffix": "9b5",
            "midi": [53, 57, 63, 67, 71],
            "capo": true,
            "key": "F",
            "barres": [1],
            "baseFret": 7,
            "fingers": [0, 2, 1, 3, 4, 1],
            "frets": [-1, 2, 1, 2, 2, 1]
        }, {
            "barres": [],
            "fingers": [0, 1, 2, 0, 3, 4],
            "key": "F",
            "suffix": "9b5",
            "baseFret": 8,
            "midi": [53, 59, 55, 69, 75],
            "frets": [-1, 1, 2, 0, 3, 4]
        }, {
            "key": "F",
            "barres": [2],
            "baseFret": 12,
            "fingers": [2, 1, 2, 0, 0, 3],
            "midi": [53, 57, 63, 55, 59, 77],
            "suffix": "9b5",
            "frets": [2, 1, 2, 0, 0, 2]
        }, {
            "midi": [41, 45, 51, 55, 61, 65],
            "fingers": [1, 0, 2, 0, 4, 3],
            "baseFret": 1,
            "key": "F",
            "suffix": "aug9",
            "barres": [],
            "frets": [1, 0, 1, 0, 2, 1]
        }, {
            "fingers": [1, 2, 1, 3, 4, 1],
            "baseFret": 5,
            "suffix": "aug9",
            "capo": true,
            "frets": [1, 2, 1, 2, 2, 1],
            "barres": [1],
            "key": "F",
            "midi": [45, 51, 55, 61, 65, 69]
        }, {
            "baseFret": 7,
            "key": "F",
            "frets": [-1, 2, 1, 2, 2, 3],
            "barres": [2],
            "midi": [53, 57, 63, 67, 73],
            "suffix": "aug9",
            "fingers": [0, 2, 1, 3, 3, 4]
        }, {
            "midi": [53, 57, 63, 67, 73],
            "key": "F",
            "baseFret": 12,
            "barres": [1],
            "suffix": "aug9",
            "fingers": [2, 1, 3, 1, 4, 0],
            "frets": [2, 1, 2, 1, 3, -1],
            "capo": true
        }, {
            "barres": [1],
            "frets": [1, 3, 1, 2, 1, 2],
            "baseFret": 1,
            "midi": [41, 48, 51, 57, 60, 66],
            "suffix": "7b9",
            "capo": true,
            "key": "F",
            "fingers": [1, 4, 1, 2, 1, 3]
        }, {
            "frets": [-1, -1, 3, 2, 4, 2],
            "capo": true,
            "key": "F",
            "barres": [2],
            "fingers": [0, 0, 2, 1, 3, 1],
            "midi": [53, 57, 63, 66],
            "suffix": "7b9",
            "baseFret": 1
        }, {
            "fingers": [0, 2, 1, 3, 1, 4],
            "frets": [-1, 2, 1, 2, 1, 2],
            "capo": true,
            "midi": [53, 57, 63, 66, 72],
            "suffix": "7b9",
            "barres": [1],
            "key": "F",
            "baseFret": 7
        }, {
            "baseFret": 11,
            "frets": [3, 2, 3, 1, -1, -1],
            "key": "F",
            "midi": [53, 57, 63, 66],
            "barres": [],
            "fingers": [3, 2, 4, 1, 0, 0],
            "suffix": "7b9"
        }, {
            "capo": true,
            "baseFret": 1,
            "suffix": "7#9",
            "fingers": [1, 3, 1, 2, 1, 4],
            "key": "F",
            "barres": [1],
            "frets": [1, 3, 1, 2, 1, 4],
            "midi": [41, 48, 51, 57, 60, 68]
        }, {
            "fingers": [0, 0, 2, 1, 3, 4],
            "barres": [],
            "frets": [-1, -1, 3, 2, 4, 4],
            "suffix": "7#9",
            "baseFret": 1,
            "midi": [53, 57, 63, 68],
            "key": "F"
        }, {
            "frets": [-1, 2, 1, 2, 3, -1],
            "fingers": [0, 2, 1, 3, 4, 0],
            "baseFret": 7,
            "suffix": "7#9",
            "barres": [],
            "midi": [53, 57, 63, 68],
            "key": "F"
        }, {
            "barres": [1],
            "fingers": [0, 2, 1, 1, 1, 3],
            "capo": true,
            "key": "F",
            "baseFret": 10,
            "midi": [56, 60, 65, 69, 75],
            "suffix": "7#9",
            "frets": [-1, 2, 1, 1, 1, 2]
        }, {
            "fingers": [1, 1, 1, 2, 1, 1],
            "capo": true,
            "frets": [1, 1, 1, 2, 1, 1],
            "baseFret": 1,
            "midi": [41, 46, 51, 57, 60, 65],
            "barres": [1],
            "key": "F",
            "suffix": "11"
        }, {
            "midi": [43, 48, 53, 58, 63, 69],
            "frets": [1, 1, 1, 1, 2, 3],
            "capo": true,
            "key": "F",
            "fingers": [1, 1, 1, 1, 2, 3],
            "baseFret": 3,
            "suffix": "11",
            "barres": [1]
        }, {
            "baseFret": 6,
            "fingers": [0, 3, 2, 4, 1, 1],
            "midi": [53, 57, 63, 65, 70],
            "suffix": "11",
            "capo": true,
            "key": "F",
            "barres": [1],
            "frets": [-1, 3, 2, 3, 1, 1]
        }, {
            "midi": [53, 58, 63, 69, 72],
            "fingers": [0, 1, 1, 1, 3, 1],
            "key": "F",
            "suffix": "11",
            "barres": [1],
            "frets": [-1, 1, 1, 1, 3, 1],
            "baseFret": 8,
            "capo": true
        }, {
            "key": "F",
            "frets": [1, 0, 1, 0, 0, 1],
            "barres": [],
            "midi": [41, 45, 51, 55, 59, 65],
            "fingers": [1, 0, 2, 0, 0, 3],
            "baseFret": 1,
            "suffix": "9#11"
        }, {
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "F",
            "suffix": "9#11",
            "baseFret": 3,
            "barres": [],
            "midi": [53, 59, 63, 69],
            "frets": [-1, -1, 1, 2, 2, 3]
        }, {
            "key": "F",
            "suffix": "9#11",
            "barres": [1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [53, 57, 63, 67, 71],
            "frets": [-1, 2, 1, 2, 2, 1],
            "capo": true,
            "baseFret": 7
        }, {
            "midi": [53, 59, 63, 69, 72],
            "baseFret": 8,
            "capo": true,
            "barres": [1],
            "suffix": "9#11",
            "key": "F",
            "frets": [-1, 1, 2, 1, 3, 1],
            "fingers": [0, 1, 2, 1, 3, 1]
        }, {
            "capo": true,
            "suffix": "13",
            "fingers": [1, 3, 1, 2, 4, 1],
            "baseFret": 1,
            "key": "F",
            "barres": [1],
            "midi": [41, 48, 51, 57, 62, 65],
            "frets": [1, 3, 1, 2, 3, 1]
        }, {
            "baseFret": 1,
            "barres": [1],
            "fingers": [1, 1, 1, 2, 3, 4],
            "capo": true,
            "midi": [41, 46, 51, 57, 62, 67],
            "key": "F",
            "frets": [1, 1, 1, 2, 3, 3],
            "suffix": "13"
        }, {
            "suffix": "13",
            "frets": [-1, 2, 1, 2, 4, 4],
            "fingers": [0, 2, 1, 3, 4, 4],
            "barres": [4],
            "midi": [53, 57, 63, 69, 74],
            "baseFret": 7,
            "key": "F"
        }, {
            "capo": true,
            "suffix": "13",
            "midi": [48, 53, 58, 63, 69, 74],
            "fingers": [1, 1, 1, 1, 3, 4],
            "key": "F",
            "barres": [1],
            "baseFret": 8,
            "frets": [1, 1, 1, 1, 3, 3]
        }, {
            "key": "F",
            "frets": [-1, -1, 3, 2, 1, 0],
            "baseFret": 1,
            "fingers": [0, 0, 3, 2, 1, 0],
            "suffix": "maj7",
            "barres": [],
            "midi": [53, 57, 60, 64]
        }, {
            "midi": [41, 48, 52, 57, 60, 65],
            "barres": [1],
            "fingers": [1, 4, 2, 3, 1, 1],
            "key": "F",
            "capo": true,
            "frets": [1, 3, 2, 2, 1, 1],
            "baseFret": 1,
            "suffix": "maj7"
        }, {
            "frets": [-1, 1, 1, 3, 3, 3],
            "baseFret": 3,
            "capo": true,
            "key": "F",
            "fingers": [0, 1, 1, 3, 3, 3],
            "suffix": "maj7",
            "barres": [1],
            "midi": [48, 53, 60, 64, 69]
        }, {
            "frets": [1, 1, 3, 2, 3, 1],
            "key": "F",
            "fingers": [1, 1, 3, 2, 4, 1],
            "suffix": "maj7",
            "midi": [48, 53, 60, 64, 69, 72],
            "barres": [1],
            "baseFret": 8,
            "capo": true
        }, {
            "frets": [1, 0, 2, 2, 0, 0],
            "baseFret": 1,
            "barres": [],
            "suffix": "maj7b5",
            "fingers": [1, 0, 2, 3, 0, 0],
            "key": "F",
            "midi": [41, 45, 52, 57, 59, 64]
        }, {
            "suffix": "maj7b5",
            "baseFret": 3,
            "frets": [-1, -1, 1, 2, 3, 3],
            "key": "F",
            "barres": [],
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [53, 59, 64, 69]
        }, {
            "barres": [],
            "baseFret": 8,
            "fingers": [0, 1, 2, 3, 4, 0],
            "key": "F",
            "midi": [53, 59, 64, 69],
            "suffix": "maj7b5",
            "frets": [-1, 1, 2, 2, 3, -1]
        }, {
            "baseFret": 12,
            "frets": [2, 1, 3, 3, 1, 1],
            "fingers": [2, 1, 3, 4, 1, 1],
            "key": "F",
            "suffix": "maj7b5",
            "capo": true,
            "midi": [53, 57, 64, 69, 71, 76],
            "barres": [1]
        }, {
            "suffix": "maj7#5",
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 1,
            "key": "F",
            "midi": [41, 45, 52, 57, 61, 64],
            "barres": [],
            "frets": [1, 0, 2, 2, 2, 0]
        }, {
            "frets": [1, 4, 3, 2, 1, 1],
            "key": "F",
            "barres": [1],
            "capo": true,
            "fingers": [1, 4, 3, 2, 1, 1],
            "midi": [45, 53, 57, 61, 64, 69],
            "suffix": "maj7#5",
            "baseFret": 5
        }, {
            "midi": [53, 61, 64, 69],
            "frets": [-1, 1, 4, 2, 3, -1],
            "key": "F",
            "barres": [],
            "baseFret": 8,
            "suffix": "maj7#5",
            "fingers": [0, 1, 4, 2, 3, 0]
        }, {
            "key": "F",
            "frets": [-1, -1, 4, 3, 3, 1],
            "baseFret": 12,
            "barres": [],
            "suffix": "maj7#5",
            "midi": [65, 69, 73, 76],
            "fingers": [0, 0, 4, 2, 3, 1]
        }, {
            "barres": [],
            "midi": [41, 45, 52, 55, 60, 64],
            "suffix": "maj9",
            "frets": [1, 0, 2, 0, 1, 0],
            "key": "F",
            "fingers": [1, 0, 3, 0, 2, 0],
            "baseFret": 1
        }, {
            "barres": [],
            "frets": [-1, -1, 2, 2, 1, 3],
            "suffix": "maj9",
            "baseFret": 1,
            "midi": [52, 57, 60, 67],
            "fingers": [0, 0, 2, 3, 1, 4],
            "key": "F"
        }, {
            "frets": [-1, 2, 1, 3, 2, -1],
            "key": "F",
            "midi": [53, 57, 64, 67],
            "baseFret": 7,
            "suffix": "maj9",
            "fingers": [0, 2, 1, 4, 3, 0],
            "barres": []
        }, {
            "baseFret": 10,
            "capo": true,
            "frets": [-1, -1, 1, 3, 1, 3],
            "midi": [60, 67, 69, 76],
            "fingers": [0, 0, 1, 3, 1, 4],
            "suffix": "maj9",
            "barres": [1],
            "key": "F"
        }, {
            "frets": [1, 1, 2, 2, 1, 1],
            "midi": [41, 46, 52, 57, 60, 65],
            "key": "F",
            "fingers": [1, 1, 2, 3, 1, 1],
            "capo": true,
            "suffix": "maj11",
            "baseFret": 1,
            "barres": [1]
        }, {
            "frets": [-1, -1, 1, 1, 3, 3],
            "fingers": [0, 0, 1, 1, 3, 4],
            "capo": true,
            "key": "F",
            "suffix": "maj11",
            "baseFret": 3,
            "midi": [53, 58, 64, 69],
            "barres": [1]
        }, {
            "suffix": "maj11",
            "baseFret": 8,
            "fingers": [1, 1, 1, 2, 3, 1],
            "barres": [1],
            "capo": true,
            "key": "F",
            "frets": [1, 1, 1, 2, 3, 1],
            "midi": [48, 53, 58, 64, 69, 72]
        }, {
            "suffix": "maj11",
            "key": "F",
            "barres": [],
            "fingers": [3, 2, 4, 0, 1, 0],
            "baseFret": 11,
            "frets": [3, 2, 4, 0, 1, 0],
            "midi": [53, 57, 64, 55, 70, 64]
        }, {
            "suffix": "maj13",
            "baseFret": 1,
            "fingers": [1, 0, 0, 0, 2, 0],
            "barres": [],
            "midi": [41, 45, 50, 55, 60, 64],
            "frets": [1, 0, 0, 0, 1, 0],
            "key": "F"
        }, {
            "frets": [-1, -1, 3, 2, 3, 0],
            "baseFret": 1,
            "midi": [53, 57, 62, 64],
            "fingers": [0, 0, 2, 1, 3, 0],
            "key": "F",
            "barres": [],
            "suffix": "maj13"
        }, {
            "fingers": [0, 4, 2, 3, 1, 1],
            "midi": [53, 57, 62, 64, 69],
            "key": "F",
            "baseFret": 5,
            "suffix": "maj13",
            "frets": [-1, 4, 3, 3, 1, 1],
            "barres": [1]
        }, {
            "frets": [-1, 1, 1, 2, 3, 3],
            "suffix": "maj13",
            "midi": [53, 58, 64, 69, 74],
            "baseFret": 8,
            "key": "F",
            "capo": true,
            "barres": [1],
            "fingers": [0, 1, 1, 2, 3, 4]
        }, {
            "suffix": "m6",
            "midi": [41, 50, 56, 60, 65],
            "fingers": [1, 0, 0, 2, 3, 4],
            "key": "F",
            "frets": [1, -1, 0, 1, 1, 1],
            "baseFret": 1,
            "barres": []
        }, {
            "barres": [1],
            "midi": [53, 60, 62, 68],
            "frets": [-1, -1, 1, 3, 1, 2],
            "key": "F",
            "fingers": [0, 0, 1, 3, 1, 2],
            "baseFret": 3,
            "capo": true,
            "suffix": "m6"
        }, {
            "baseFret": 6,
            "barres": [1],
            "midi": [53, 56, 62, 65, 72],
            "suffix": "m6",
            "capo": true,
            "key": "F",
            "frets": [-1, 3, 1, 2, 1, 3],
            "fingers": [0, 3, 1, 2, 1, 4]
        }, {
            "frets": [-1, -1, 2, 2, 1, 2],
            "midi": [60, 65, 68, 74],
            "baseFret": 9,
            "barres": [],
            "key": "F",
            "suffix": "m6",
            "fingers": [0, 0, 2, 3, 1, 4]
        }, {
            "midi": [41, 48, 51, 56, 60, 65],
            "barres": [1],
            "capo": true,
            "frets": [1, 3, 1, 1, 1, 1],
            "fingers": [1, 3, 1, 1, 1, 1],
            "baseFret": 1,
            "suffix": "m7",
            "key": "F"
        }, {
            "baseFret": 3,
            "barres": [],
            "frets": [-1, -1, 1, 3, 2, 2],
            "fingers": [0, 0, 1, 4, 2, 3],
            "midi": [53, 60, 63, 68],
            "suffix": "m7",
            "key": "F"
        }, {
            "midi": [48, 53, 60, 63, 68, 72],
            "key": "F",
            "frets": [1, 1, 3, 1, 2, 1],
            "barres": [1],
            "suffix": "m7",
            "baseFret": 8,
            "capo": true,
            "fingers": [1, 1, 3, 1, 2, 1]
        }, {
            "fingers": [0, 0, 2, 3, 1, 4],
            "barres": [],
            "suffix": "m7",
            "midi": [60, 65, 68, 75],
            "key": "F",
            "frets": [-1, -1, 2, 2, 1, 3],
            "baseFret": 9
        }, {
            "frets": [1, -1, 1, 1, 0, -1],
            "midi": [41, 51, 56, 59],
            "fingers": [1, 0, 2, 3, 0, 0],
            "key": "F",
            "barres": [],
            "baseFret": 1,
            "suffix": "m7b5"
        }, {
            "suffix": "m7b5",
            "fingers": [0, 0, 1, 2, 2, 2],
            "midi": [53, 59, 63, 68],
            "barres": [4],
            "frets": [-1, -1, 3, 4, 4, 4],
            "baseFret": 1,
            "key": "F"
        }, {
            "suffix": "m7b5",
            "midi": [53, 59, 63, 68],
            "key": "F",
            "baseFret": 8,
            "barres": [],
            "fingers": [0, 1, 3, 2, 4, 0],
            "frets": [-1, 1, 2, 1, 2, -1]
        }, {
            "frets": [3, 1, 3, 3, 0, -1],
            "midi": [53, 56, 63, 68, 59],
            "fingers": [2, 1, 3, 4, 0, 0],
            "key": "F",
            "barres": [],
            "baseFret": 11,
            "suffix": "m7b5"
        }, {
            "barres": [1],
            "fingers": [1, 3, 1, 1, 1, 4],
            "frets": [1, 3, 1, 1, 1, 3],
            "baseFret": 1,
            "key": "F",
            "suffix": "m9",
            "midi": [41, 48, 51, 56, 60, 67],
            "capo": true
        }, {
            "barres": [],
            "fingers": [0, 1, 2, 0, 3, 4],
            "midi": [48, 53, 55, 63, 68],
            "key": "F",
            "baseFret": 1,
            "frets": [-1, 3, 3, 0, 4, 4],
            "suffix": "m9"
        }, {
            "baseFret": 6,
            "midi": [53, 56, 63, 67, 72],
            "key": "F",
            "barres": [3],
            "frets": [-1, 3, 1, 3, 3, 3],
            "fingers": [0, 2, 1, 3, 4, 4],
            "suffix": "m9"
        }, {
            "frets": [3, 1, 3, 0, 3, 3],
            "midi": [53, 56, 63, 55, 72, 77],
            "barres": [3],
            "fingers": [2, 1, 3, 0, 4, 4],
            "baseFret": 11,
            "suffix": "m9",
            "key": "F"
        }, {
            "capo": true,
            "key": "F",
            "frets": [1, 3, 3, 1, 3, 3],
            "barres": [1, 3],
            "suffix": "m6/9",
            "midi": [41, 48, 53, 56, 62, 67],
            "fingers": [1, 2, 2, 1, 3, 4],
            "baseFret": 1
        }, {
            "barres": [1],
            "midi": [44, 53, 60, 62, 67],
            "frets": [2, -1, 1, 3, 1, 1],
            "key": "F",
            "suffix": "m6/9",
            "baseFret": 3,
            "fingers": [2, 0, 1, 3, 1, 1],
            "capo": true
        }, {
            "barres": [],
            "key": "F",
            "midi": [53, 56, 62, 67],
            "frets": [-1, 3, 1, 2, 3, -1],
            "baseFret": 6,
            "fingers": [0, 3, 1, 2, 4, 0],
            "suffix": "m6/9"
        }, {
            "suffix": "m6/9",
            "midi": [53, 56, 62, 55, 72],
            "baseFret": 11,
            "fingers": [3, 1, 2, 0, 4, 0],
            "barres": [],
            "key": "F",
            "frets": [3, 1, 2, 0, 3, -1]
        }, {
            "midi": [41, 46, 51, 56, 60, 67],
            "frets": [1, 1, 1, 1, 1, 3],
            "key": "F",
            "capo": true,
            "barres": [1],
            "fingers": [1, 1, 1, 1, 1, 4],
            "baseFret": 1,
            "suffix": "m11"
        }, {
            "fingers": [0, 0, 1, 1, 2, 3],
            "midi": [53, 58, 63, 68],
            "suffix": "m11",
            "barres": [3],
            "capo": true,
            "key": "F",
            "baseFret": 1,
            "frets": [-1, -1, 3, 3, 4, 4]
        }, {
            "capo": true,
            "fingers": [0, 2, 1, 3, 4, 1],
            "frets": [-1, 3, 1, 3, 3, 1],
            "suffix": "m11",
            "barres": [1],
            "midi": [53, 56, 63, 67, 70],
            "key": "F",
            "baseFret": 6
        }, {
            "capo": true,
            "barres": [1],
            "key": "F",
            "midi": [53, 56, 63, 67, 70, 75],
            "fingers": [3, 1, 4, 2, 1, 1],
            "suffix": "m11",
            "baseFret": 11,
            "frets": [3, 1, 3, 2, 1, 1]
        }, {
            "capo": true,
            "suffix": "mmaj7",
            "midi": [41, 48, 52, 56, 60, 65],
            "barres": [1],
            "key": "F",
            "baseFret": 1,
            "fingers": [1, 3, 2, 1, 1, 1],
            "frets": [1, 3, 2, 1, 1, 1]
        }, {
            "frets": [-1, -1, 1, 3, 3, 2],
            "barres": [],
            "baseFret": 3,
            "fingers": [0, 0, 1, 3, 4, 2],
            "midi": [53, 60, 64, 68],
            "key": "F",
            "suffix": "mmaj7"
        }, {
            "capo": true,
            "key": "F",
            "midi": [48, 53, 60, 64, 68, 72],
            "frets": [1, 1, 3, 2, 2, 1],
            "baseFret": 8,
            "suffix": "mmaj7",
            "barres": [1],
            "fingers": [1, 1, 4, 2, 3, 1]
        }, {
            "key": "F",
            "fingers": [0, 0, 4, 2, 3, 1],
            "barres": [],
            "suffix": "mmaj7",
            "midi": [65, 68, 72, 76],
            "baseFret": 12,
            "frets": [-1, -1, 4, 2, 2, 1]
        }, {
            "midi": [41, 47, 52, 56, 59, 64],
            "key": "F",
            "frets": [1, 2, 2, 1, 0, 0],
            "fingers": [1, 2, 3, 1, 0, 0],
            "baseFret": 1,
            "barres": [1],
            "suffix": "mmaj7b5"
        }, {
            "frets": [-1, -1, 1, 2, 3, 2],
            "fingers": [0, 0, 1, 2, 4, 3],
            "midi": [53, 59, 64, 68],
            "key": "F",
            "suffix": "mmaj7b5",
            "baseFret": 3,
            "barres": []
        }, {
            "suffix": "mmaj7b5",
            "fingers": [1, 2, 3, 3, 3, 0],
            "key": "F",
            "barres": [3],
            "frets": [1, 2, 3, 3, 3, -1],
            "baseFret": 7,
            "midi": [47, 53, 59, 64, 68]
        }, {
            "key": "F",
            "frets": [-1, 1, 2, 2, 2, -1],
            "barres": [],
            "midi": [53, 59, 64, 68],
            "baseFret": 8,
            "fingers": [0, 1, 2, 3, 4, 0],
            "suffix": "mmaj7b5"
        }, {
            "barres": [1],
            "baseFret": 1,
            "midi": [41, 48, 52, 56, 60, 67],
            "key": "F",
            "suffix": "mmaj9",
            "frets": [1, 3, 2, 1, 1, 3],
            "capo": true,
            "fingers": [1, 3, 2, 1, 1, 4]
        }, {
            "midi": [53, 55, 64, 68],
            "frets": [-1, -1, 1, 0, 3, 2],
            "baseFret": 3,
            "barres": [],
            "key": "F",
            "fingers": [0, 0, 1, 0, 4, 2],
            "suffix": "mmaj9"
        }, {
            "key": "F",
            "suffix": "mmaj9",
            "baseFret": 6,
            "midi": [53, 56, 64, 67],
            "frets": [-1, 3, 1, 4, 3, -1],
            "fingers": [0, 2, 1, 4, 3, 0],
            "barres": []
        }, {
            "suffix": "mmaj9",
            "key": "F",
            "baseFret": 11,
            "frets": [3, 1, -1, 2, 3, 0],
            "midi": [53, 56, 67, 72, 64],
            "barres": [],
            "fingers": [3, 1, 0, 2, 4, 0]
        }, {
            "barres": [1],
            "fingers": [1, 1, 2, 1, 1, 4],
            "suffix": "mmaj11",
            "midi": [41, 46, 52, 56, 60, 67],
            "capo": true,
            "baseFret": 1,
            "frets": [1, 1, 2, 1, 1, 3],
            "key": "F"
        }, {
            "baseFret": 3,
            "key": "F",
            "capo": true,
            "fingers": [0, 1, 1, 1, 3, 2],
            "suffix": "mmaj11",
            "frets": [-1, 1, 1, 1, 3, 2],
            "barres": [1],
            "midi": [48, 53, 58, 64, 68]
        }, {
            "key": "F",
            "baseFret": 6,
            "capo": true,
            "frets": [-1, 3, 1, 4, 3, 1],
            "midi": [53, 56, 64, 67, 70],
            "suffix": "mmaj11",
            "fingers": [0, 2, 1, 4, 3, 1],
            "barres": [1]
        }, {
            "baseFret": 8,
            "barres": [1],
            "fingers": [1, 1, 1, 2, 3, 1],
            "midi": [48, 53, 58, 64, 68, 72],
            "key": "F",
            "frets": [1, 1, 1, 2, 2, 1],
            "capo": true,
            "suffix": "mmaj11"
        }, {
            "baseFret": 1,
            "midi": [53, 57, 60, 67],
            "frets": [-1, -1, 3, 2, 1, 3],
            "suffix": "add9",
            "barres": [],
            "fingers": [0, 0, 3, 2, 1, 4],
            "key": "F"
        }, {
            "frets": [-1, -1, 1, 0, 4, 3],
            "barres": [],
            "fingers": [0, 0, 1, 0, 4, 3],
            "midi": [53, 55, 65, 69],
            "baseFret": 3,
            "suffix": "add9",
            "key": "F"
        }, {
            "barres": [1],
            "capo": true,
            "suffix": "add9",
            "frets": [-1, 4, 3, 1, 4, 1],
            "midi": [53, 57, 60, 67, 69],
            "key": "F",
            "baseFret": 5,
            "fingers": [0, 3, 2, 1, 4, 1]
        }, {
            "barres": [],
            "suffix": "add9",
            "frets": [-1, 2, 1, 0, 2, 2],
            "baseFret": 7,
            "key": "F",
            "midi": [53, 57, 55, 67, 72],
            "fingers": [0, 2, 1, 0, 3, 4]
        }, {
            "midi": [53, 56, 60, 67],
            "barres": [1],
            "frets": [-1, -1, 3, 1, 1, 3],
            "suffix": "madd9",
            "key": "F",
            "fingers": [0, 0, 3, 1, 1, 4],
            "baseFret": 1,
            "capo": true
        }, {
            "baseFret": 5,
            "key": "F",
            "fingers": [0, 3, 2, 1, 4, 0],
            "suffix": "madd9",
            "frets": [-1, 4, 2, 1, 4, -1],
            "barres": [],
            "midi": [53, 56, 60, 67]
        }, {
            "key": "F",
            "fingers": [0, 3, 1, 0, 2, 4],
            "midi": [53, 56, 55, 65, 72],
            "barres": [],
            "baseFret": 6,
            "suffix": "madd9",
            "frets": [-1, 3, 1, 0, 1, 3]
        }, {
            "midi": [53, 60, 55, 68, 72],
            "baseFret": 8,
            "key": "F",
            "barres": [],
            "fingers": [0, 1, 4, 0, 3, 2],
            "frets": [-1, 1, 3, 0, 2, 1],
            "suffix": "madd9"
        }, {
            "midi": [48, 53, 57, 60, 65],
            "suffix": "/C",
            "barres": [1],
            "frets": [-1, 3, 3, 2, 1, 1],
            "fingers": [0, 3, 4, 2, 1, 1],
            "baseFret": 1,
            "key": "F"
        }, {
            "suffix": "/C",
            "barres": [1],
            "key": "F",
            "baseFret": 3,
            "midi": [48, 53, 60, 65, 69],
            "fingers": [0, 1, 1, 3, 4, 3],
            "frets": [-1, 1, 1, 3, 4, 3]
        }, {
            "barres": [1],
            "midi": [48, 53, 60, 65, 69, 72],
            "baseFret": 8,
            "suffix": "/C",
            "frets": [1, 1, 3, 3, 3, 1],
            "key": "F",
            "fingers": [1, 1, 2, 3, 4, 1]
        }, {
            "midi": [50, 57, 60, 65],
            "baseFret": 1,
            "barres": [1],
            "suffix": "/D",
            "key": "F",
            "frets": [-1, -1, 0, 2, 1, 1],
            "fingers": [0, 0, 0, 2, 1, 1]
        }, {
            "suffix": "/D",
            "midi": [50, 57, 60, 65, 69],
            "fingers": [0, 1, 3, 1, 2, 1],
            "key": "F",
            "barres": [1],
            "baseFret": 5,
            "frets": [-1, 1, 3, 1, 2, 1]
        }, {
            "key": "F",
            "baseFret": 5,
            "fingers": [0, 1, 3, 1, 2, 4],
            "barres": [],
            "frets": [-1, 1, 3, 1, 2, 4],
            "suffix": "/D",
            "midi": [50, 57, 60, 65, 72]
        }, {
            "barres": [1],
            "fingers": [0, 0, 1, 2, 1, 1],
            "midi": [51, 57, 60, 65],
            "frets": [-1, -1, 1, 2, 1, 1],
            "baseFret": 1,
            "suffix": "/D#",
            "key": "F"
        }, {
            "barres": [1],
            "midi": [51, 57, 60, 65, 69],
            "key": "F",
            "baseFret": 5,
            "fingers": [0, 2, 4, 1, 3, 1],
            "suffix": "/D#",
            "frets": [-1, 2, 3, 1, 2, 1]
        }, {
            "baseFret": 3,
            "fingers": [0, 3, 1, 2, 4, 2],
            "suffix": "/D#",
            "frets": [-1, 4, 1, 3, 4, 3],
            "barres": [3],
            "midi": [51, 53, 60, 65, 69],
            "key": "F"
        }, {
            "baseFret": 1,
            "suffix": "/E",
            "midi": [40, 45, 53, 57, 60, 65],
            "barres": [1],
            "fingers": [0, 0, 3, 2, 1, 1],
            "frets": [0, 0, 3, 2, 1, 1],
            "key": "F"
        }, {
            "barres": [1],
            "baseFret": 1,
            "frets": [-1, -1, 2, 2, 1, 1],
            "suffix": "/E",
            "midi": [52, 57, 60, 65],
            "key": "F",
            "fingers": [0, 0, 2, 3, 1, 1]
        }, {
            "midi": [40, 48, 53, 57, 60, 65],
            "barres": [1],
            "baseFret": 1,
            "frets": [0, 3, 3, 2, 1, 1],
            "suffix": "/E",
            "fingers": [0, 3, 4, 2, 1, 1],
            "key": "F"
        }, {
            "barres": [1],
            "midi": [43, 45, 53, 57, 60, 65],
            "key": "F",
            "fingers": [3, 0, 4, 2, 1, 1],
            "frets": [3, 0, 3, 2, 1, 1],
            "suffix": "/G",
            "baseFret": 1
        }, {
            "frets": [3, 3, 3, 2, -1, -1],
            "barres": [],
            "key": "F",
            "baseFret": 1,
            "fingers": [2, 3, 4, 1, 0, 0],
            "suffix": "/G",
            "midi": [43, 48, 53, 57]
        }, {
            "key": "F",
            "suffix": "/G",
            "baseFret": 3,
            "midi": [43, 48, 53, 60, 65, 69],
            "frets": [1, 1, 1, 3, 4, 3],
            "fingers": [1, 1, 1, 3, 4, 3],
            "barres": [1]
        }, {
            "barres": [1],
            "key": "F",
            "suffix": "/A",
            "frets": [-1, 0, 3, 2, 1, 1],
            "baseFret": 1,
            "fingers": [0, 0, 3, 2, 1, 1],
            "midi": [45, 53, 57, 60, 65]
        }, {
            "fingers": [4, 2, 3, 1, 0, 0],
            "key": "F",
            "frets": [4, 2, 2, 1, -1, -1],
            "baseFret": 2,
            "suffix": "/A",
            "midi": [45, 48, 53, 57],
            "barres": []
        }, {
            "key": "F",
            "suffix": "/A",
            "barres": [1],
            "midi": [45, 48, 53, 60, 65, 64],
            "baseFret": 3,
            "fingers": [2, 1, 1, 3, 4, 0],
            "frets": [3, 1, 1, 3, 4, 0]
        }, {
            "barres": [1],
            "fingers": [0, 3, 4, 1, 1, 1],
            "baseFret": 1,
            "suffix": "m/C",
            "midi": [48, 53, 56, 60, 65],
            "frets": [-1, 3, 3, 1, 1, 1],
            "key": "F"
        }, {
            "baseFret": 1,
            "suffix": "m/C",
            "fingers": [0, 2, 3, 1, 1, 4],
            "key": "F",
            "barres": [1],
            "frets": [-1, 3, 3, 1, 1, 4],
            "midi": [48, 53, 56, 60, 68]
        }, {
            "suffix": "m/C",
            "barres": [1],
            "key": "F",
            "fingers": [1, 1, 3, 4, 2, 1],
            "frets": [1, 1, 3, 3, 2, 1],
            "midi": [48, 53, 60, 65, 68, 72],
            "baseFret": 8
        }, {
            "key": "F#",
            "suffix": "major",
            "baseFret": 1,
            "barres": [2],
            "frets": [2, 4, 4, 3, 2, 2],
            "midi": [42, 49, 54, 58, 61, 66],
            "capo": true,
            "fingers": [1, 3, 4, 2, 1, 1]
        }, {
            "key": "F#",
            "suffix": "major",
            "barres": [1],
            "fingers": [0, 1, 1, 2, 4, 3],
            "midi": [49, 54, 61, 66, 70],
            "baseFret": 4,
            "frets": [-1, 1, 1, 3, 4, 3],
            "capo": true
        }, {
            "baseFret": 6,
            "fingers": [1, 4, 3, 1, 2, 1],
            "suffix": "major",
            "barres": [1],
            "key": "F#",
            "midi": [46, 54, 58, 61, 66, 70],
            "frets": [1, 4, 3, 1, 2, 1],
            "capo": true
        }, {
            "midi": [49, 54, 61, 66, 70, 73],
            "barres": [1],
            "baseFret": 9,
            "fingers": [1, 1, 2, 3, 4, 1],
            "key": "F#",
            "capo": true,
            "suffix": "major",
            "frets": [1, 1, 3, 3, 3, 1]
        }, {
            "capo": true,
            "key": "F#",
            "barres": [2],
            "frets": [2, 4, 4, 2, 2, 2],
            "fingers": [1, 3, 4, 1, 1, 1],
            "baseFret": 1,
            "suffix": "minor",
            "midi": [42, 49, 54, 57, 61, 66]
        }, {
            "barres": [1],
            "suffix": "minor",
            "midi": [49, 54, 61, 66, 69],
            "key": "F#",
            "fingers": [0, 1, 1, 3, 4, 2],
            "frets": [-1, 1, 1, 3, 4, 2],
            "baseFret": 4,
            "capo": true
        }, {
            "baseFret": 5,
            "key": "F#",
            "fingers": [0, 0, 3, 2, 4, 1],
            "suffix": "minor",
            "frets": [-1, -1, 3, 2, 3, 1],
            "barres": [],
            "midi": [57, 61, 66, 69]
        }, {
            "baseFret": 9,
            "midi": [49, 54, 61, 66, 69, 73],
            "capo": true,
            "suffix": "minor",
            "frets": [1, 1, 3, 3, 2, 1],
            "fingers": [1, 1, 3, 4, 2, 1],
            "barres": [1],
            "key": "F#"
        }, {
            "fingers": [2, 0, 0, 3, 1, 0],
            "barres": [],
            "frets": [2, 0, -1, 2, 1, -1],
            "key": "F#",
            "baseFret": 1,
            "midi": [42, 45, 57, 60],
            "suffix": "dim"
        }, {
            "key": "F#",
            "baseFret": 4,
            "suffix": "dim",
            "midi": [54, 60, 69],
            "barres": [],
            "frets": [-1, -1, 1, 2, -1, 2],
            "fingers": [0, 0, 1, 2, 0, 3]
        }, {
            "barres": [],
            "suffix": "dim",
            "frets": [-1, 3, 1, -1, 1, 2],
            "baseFret": 7,
            "key": "F#",
            "midi": [54, 57, 66, 72],
            "fingers": [0, 4, 1, 0, 2, 3]
        }, {
            "frets": [-1, 1, 2, 3, 2, -1],
            "key": "F#",
            "baseFret": 9,
            "fingers": [0, 1, 2, 4, 3, 0],
            "suffix": "dim",
            "midi": [54, 60, 66, 69],
            "barres": []
        }, {
            "baseFret": 1,
            "suffix": "dim7",
            "midi": [42, 51, 57, 60],
            "barres": [1],
            "fingers": [2, 0, 1, 3, 1, 0],
            "capo": true,
            "key": "F#",
            "frets": [2, -1, 1, 2, 1, -1]
        }, {
            "midi": [42, 48, 54, 57, 63, 66],
            "frets": [2, 3, 4, 2, 4, 2],
            "capo": true,
            "suffix": "dim7",
            "baseFret": 1,
            "barres": [2],
            "fingers": [1, 2, 3, 1, 4, 1],
            "key": "F#"
        }, {
            "key": "F#",
            "suffix": "dim7",
            "fingers": [0, 0, 1, 3, 2, 4],
            "frets": [-1, -1, 1, 2, 1, 2],
            "midi": [54, 60, 63, 69],
            "barres": [],
            "baseFret": 4
        }, {
            "frets": [1, 2, 3, 1, 3, 1],
            "capo": true,
            "key": "F#",
            "suffix": "dim7",
            "barres": [1],
            "midi": [48, 54, 60, 63, 69, 72],
            "baseFret": 8,
            "fingers": [1, 2, 3, 1, 4, 1]
        }, {
            "key": "F#",
            "suffix": "sus2",
            "fingers": [2, 0, 0, 1, 3, 4],
            "midi": [42, 56, 61, 66],
            "baseFret": 1,
            "barres": [],
            "frets": [2, -1, -1, 1, 2, 2]
        }, {
            "fingers": [1, 1, 1, 3, 4, 1],
            "midi": [44, 49, 54, 61, 66, 68],
            "frets": [1, 1, 1, 3, 4, 1],
            "baseFret": 4,
            "capo": true,
            "barres": [1],
            "key": "F#",
            "suffix": "sus2"
        }, {
            "key": "F#",
            "frets": [1, 1, 3, 3, 1, 1],
            "capo": true,
            "barres": [1],
            "fingers": [1, 1, 3, 4, 1, 1],
            "suffix": "sus2",
            "baseFret": 9,
            "midi": [49, 54, 61, 66, 68, 73]
        }, {
            "capo": true,
            "barres": [1],
            "baseFret": 11,
            "key": "F#",
            "frets": [4, 1, 1, 3, 4, -1],
            "midi": [54, 56, 61, 68, 73],
            "fingers": [3, 1, 1, 2, 4, 0],
            "suffix": "sus2"
        }, {
            "midi": [42, 49, 54, 59, 61, 66],
            "capo": true,
            "fingers": [1, 2, 3, 4, 1, 1],
            "frets": [2, 4, 4, 4, 2, 2],
            "barres": [2],
            "baseFret": 1,
            "key": "F#",
            "suffix": "sus4"
        }, {
            "baseFret": 4,
            "midi": [49, 54, 61, 66, 71],
            "key": "F#",
            "barres": [1],
            "capo": true,
            "suffix": "sus4",
            "frets": [-1, 1, 1, 3, 4, 4],
            "fingers": [0, 1, 1, 2, 3, 4]
        }, {
            "fingers": [1, 1, 2, 3, 4, 1],
            "capo": true,
            "key": "F#",
            "midi": [49, 54, 61, 66, 71, 73],
            "suffix": "sus4",
            "baseFret": 9,
            "frets": [1, 1, 3, 3, 4, 1],
            "barres": [1]
        }, {
            "barres": [1],
            "key": "F#",
            "fingers": [0, 0, 1, 1, 2, 4],
            "suffix": "sus4",
            "capo": true,
            "midi": [61, 66, 71, 78],
            "frets": [-1, -1, 1, 1, 2, 4],
            "baseFret": 11
        }, {
            "key": "F#",
            "barres": [2],
            "fingers": [1, 3, 1, 4, 1, 1],
            "capo": true,
            "midi": [42, 49, 52, 59, 61, 66],
            "baseFret": 1,
            "suffix": "7sus4",
            "frets": [2, 4, 2, 4, 2, 2]
        }, {
            "midi": [54, 61, 64, 71],
            "frets": [-1, -1, 1, 3, 2, 4],
            "key": "F#",
            "fingers": [0, 0, 1, 3, 2, 4],
            "baseFret": 4,
            "suffix": "7sus4",
            "barres": []
        }, {
            "suffix": "7sus4",
            "baseFret": 7,
            "frets": [-1, 3, 3, 3, 1, 1],
            "capo": true,
            "midi": [54, 59, 64, 66, 71],
            "fingers": [0, 2, 3, 4, 1, 1],
            "barres": [1],
            "key": "F#"
        }, {
            "fingers": [1, 1, 3, 1, 4, 1],
            "frets": [1, 1, 3, 1, 4, 1],
            "baseFret": 9,
            "key": "F#",
            "capo": true,
            "barres": [1],
            "suffix": "7sus4",
            "midi": [49, 54, 61, 64, 71, 73]
        }, {
            "midi": [54, 58, 60, 66],
            "suffix": "alt",
            "fingers": [0, 0, 4, 3, 1, 2],
            "frets": [-1, -1, 4, 3, 1, 2],
            "baseFret": 1,
            "barres": [],
            "key": "F#"
        }, {
            "key": "F#",
            "capo": true,
            "fingers": [1, 2, 4, 3, 0, 1],
            "suffix": "alt",
            "barres": [2],
            "midi": [42, 48, 54, 58, 66],
            "frets": [2, 3, 4, 3, -1, 2],
            "baseFret": 1
        }, {
            "frets": [-1, -1, 1, 2, 4, 3],
            "midi": [54, 60, 66, 70],
            "suffix": "alt",
            "barres": [],
            "key": "F#",
            "baseFret": 4,
            "fingers": [0, 0, 1, 2, 4, 3]
        }, {
            "baseFret": 9,
            "midi": [54, 60, 66, 70, 73],
            "capo": true,
            "fingers": [0, 1, 2, 3, 4, 0],
            "key": "F#",
            "frets": [-1, 1, 2, 3, 3, 1],
            "suffix": "alt",
            "barres": [1]
        }, {
            "midi": [54, 58, 62, 66],
            "fingers": [0, 0, 4, 2, 3, 1],
            "frets": [-1, -1, 4, 3, 3, 2],
            "suffix": "aug",
            "barres": [],
            "baseFret": 1,
            "key": "F#"
        }, {
            "capo": true,
            "suffix": "aug",
            "baseFret": 1,
            "midi": [54, 58, 62],
            "frets": [-1, -1, 4, 3, 3, -1],
            "barres": [3],
            "key": "F#",
            "fingers": [0, 0, 2, 1, 1, 0]
        }, {
            "frets": [-1, 3, 2, 1, 1, -1],
            "barres": [1],
            "key": "F#",
            "capo": true,
            "suffix": "aug",
            "baseFret": 7,
            "fingers": [0, 3, 2, 1, 1, 0],
            "midi": [54, 58, 62, 66]
        }, {
            "frets": [4, 3, 2, 1, 1, -1],
            "baseFret": 11,
            "midi": [54, 58, 62, 66, 70],
            "barres": [1],
            "capo": true,
            "suffix": "aug",
            "fingers": [4, 3, 2, 1, 1, 0],
            "key": "F#"
        }, {
            "suffix": "6",
            "fingers": [2, 0, 1, 4, 3, 0],
            "midi": [42, 51, 58, 61],
            "barres": [],
            "frets": [2, -1, 1, 3, 2, -1],
            "key": "F#",
            "baseFret": 1
        }, {
            "barres": [2],
            "frets": [2, -1, 4, 3, 4, 2],
            "key": "F#",
            "suffix": "6",
            "capo": true,
            "fingers": [1, 0, 3, 2, 4, 1],
            "midi": [42, 54, 58, 63, 66],
            "baseFret": 1
        }, {
            "barres": [1],
            "midi": [49, 54, 61, 63, 70],
            "key": "F#",
            "suffix": "6",
            "frets": [-1, 1, 1, 3, 1, 3],
            "baseFret": 4,
            "fingers": [0, 1, 1, 3, 1, 4],
            "capo": true
        }, {
            "frets": [-1, 1, 3, 3, 3, 3],
            "suffix": "6",
            "key": "F#",
            "barres": [3],
            "baseFret": 9,
            "fingers": [0, 1, 3, 3, 3, 3],
            "midi": [54, 61, 66, 70, 75]
        }, {
            "frets": [2, 1, 1, 1, 2, 2],
            "capo": true,
            "suffix": "6/9",
            "midi": [42, 46, 51, 56, 61, 66],
            "baseFret": 1,
            "key": "F#",
            "barres": [1],
            "fingers": [2, 1, 1, 1, 3, 4]
        }, {
            "fingers": [0, 0, 2, 1, 3, 4],
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 4, 3, 4, 4],
            "suffix": "6/9",
            "midi": [54, 58, 63, 68],
            "key": "F#"
        }, {
            "barres": [1],
            "baseFret": 6,
            "fingers": [0, 1, 1, 1, 2, 1],
            "suffix": "6/9",
            "key": "F#",
            "frets": [-1, 1, 1, 1, 2, 1],
            "capo": true,
            "midi": [51, 56, 61, 66, 70]
        }, {
            "midi": [54, 58, 63, 68, 73],
            "fingers": [0, 2, 1, 1, 3, 4],
            "barres": [1],
            "frets": [-1, 2, 1, 1, 2, 2],
            "suffix": "6/9",
            "capo": true,
            "key": "F#",
            "baseFret": 8
        }, {
            "capo": true,
            "suffix": "7",
            "baseFret": 1,
            "barres": [2],
            "frets": [2, 4, 2, 3, 2, 2],
            "midi": [42, 49, 52, 58, 61, 66],
            "key": "F#",
            "fingers": [1, 3, 1, 2, 1, 1]
        }, {
            "midi": [49, 54, 61, 64, 70],
            "baseFret": 4,
            "key": "F#",
            "capo": true,
            "frets": [-1, 1, 1, 3, 2, 3],
            "suffix": "7",
            "fingers": [0, 1, 1, 3, 2, 4],
            "barres": [1]
        }, {
            "key": "F#",
            "midi": [54, 58, 64, 66],
            "barres": [],
            "fingers": [0, 3, 2, 4, 1, 0],
            "frets": [-1, 3, 2, 3, 1, -1],
            "baseFret": 7,
            "suffix": "7"
        }, {
            "baseFret": 9,
            "fingers": [1, 1, 3, 1, 4, 1],
            "key": "F#",
            "suffix": "7",
            "barres": [1],
            "capo": true,
            "midi": [49, 54, 61, 64, 70, 73],
            "frets": [1, 1, 3, 1, 3, 1]
        }, {
            "frets": [2, -1, 2, 3, 1, -1],
            "fingers": [2, 0, 3, 4, 1, 0],
            "suffix": "7b5",
            "baseFret": 1,
            "midi": [42, 52, 58, 60],
            "key": "F#",
            "barres": []
        }, {
            "baseFret": 4,
            "midi": [54, 60, 64, 70],
            "suffix": "7b5",
            "frets": [-1, -1, 1, 2, 2, 3],
            "barres": [],
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "F#"
        }, {
            "capo": true,
            "frets": [-1, 1, 2, 3, 1, 2],
            "baseFret": 7,
            "fingers": [0, 1, 2, 4, 1, 3],
            "midi": [52, 58, 64, 66, 72],
            "key": "F#",
            "suffix": "7b5",
            "barres": [1]
        }, {
            "barres": [1],
            "midi": [54, 60, 64, 70, 64],
            "fingers": [0, 1, 2, 1, 3, 0],
            "baseFret": 9,
            "key": "F#",
            "suffix": "7b5",
            "frets": [-1, 1, 2, 1, 3, 0]
        }, {
            "midi": [42, 52, 58, 62],
            "barres": [],
            "suffix": "aug7",
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 1,
            "key": "F#",
            "frets": [2, -1, 2, 3, 3, -1]
        }, {
            "midi": [54, 62, 64, 70],
            "barres": [],
            "baseFret": 4,
            "frets": [-1, -1, 1, 4, 2, 3],
            "fingers": [0, 0, 1, 4, 2, 3],
            "key": "F#",
            "suffix": "aug7"
        }, {
            "fingers": [0, 4, 3, 1, 2, 0],
            "barres": [],
            "frets": [-1, 3, 2, 1, 1, 0],
            "key": "F#",
            "midi": [54, 58, 62, 66, 64],
            "baseFret": 7,
            "suffix": "aug7"
        }, {
            "fingers": [0, 1, 4, 1, 3, 2],
            "capo": true,
            "frets": [-1, 1, 4, 1, 3, 2],
            "barres": [1],
            "midi": [54, 62, 64, 70, 74],
            "key": "F#",
            "suffix": "aug7",
            "baseFret": 9
        }, {
            "midi": [42, 49, 52, 58, 61, 68],
            "fingers": [1, 3, 1, 2, 1, 4],
            "capo": true,
            "suffix": "9",
            "baseFret": 1,
            "frets": [2, 4, 2, 3, 2, 4],
            "barres": [2],
            "key": "F#"
        }, {
            "frets": [-1, -1, 2, 1, 3, 2],
            "midi": [54, 58, 64, 68],
            "suffix": "9",
            "fingers": [0, 0, 2, 1, 4, 3],
            "key": "F#",
            "barres": [],
            "baseFret": 3
        }, {
            "fingers": [2, 2, 1, 3, 3, 4],
            "frets": [2, 2, 1, 2, 2, 2],
            "midi": [49, 54, 58, 64, 68, 73],
            "key": "F#",
            "barres": [2],
            "baseFret": 8,
            "suffix": "9"
        }, {
            "suffix": "9",
            "midi": [56, 61, 66, 70, 76],
            "fingers": [0, 1, 1, 1, 1, 2],
            "baseFret": 11,
            "frets": [-1, 1, 1, 1, 1, 2],
            "barres": [1],
            "key": "F#",
            "capo": true
        }, {
            "suffix": "9b5",
            "barres": [1],
            "key": "F#",
            "fingers": [2, 1, 3, 1, 1, 4],
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "baseFret": 1,
            "midi": [42, 46, 52, 56, 60, 66]
        }, {
            "barres": [1],
            "frets": [2, 1, 2, 1, 1, 0],
            "fingers": [2, 1, 3, 1, 1, 0],
            "suffix": "9b5",
            "key": "F#",
            "baseFret": 1,
            "midi": [42, 46, 52, 56, 60, 64]
        }, {
            "baseFret": 3,
            "frets": [-1, 1, 2, 1, 3, 2],
            "midi": [48, 54, 58, 64, 68],
            "barres": [1],
            "fingers": [0, 1, 2, 1, 4, 3],
            "capo": true,
            "key": "F#",
            "suffix": "9b5"
        }, {
            "capo": true,
            "fingers": [0, 2, 1, 3, 4, 1],
            "barres": [1],
            "baseFret": 8,
            "key": "F#",
            "midi": [54, 58, 64, 68, 72],
            "suffix": "9b5",
            "frets": [-1, 2, 1, 2, 2, 1]
        }, {
            "midi": [42, 46, 52, 56, 62, 64],
            "key": "F#",
            "suffix": "aug9",
            "baseFret": 1,
            "barres": [1],
            "fingers": [2, 1, 3, 1, 4, 0],
            "frets": [2, 1, 2, 1, 3, 0]
        }, {
            "suffix": "aug9",
            "baseFret": 7,
            "barres": [],
            "fingers": [0, 3, 2, 1, 4, 0],
            "midi": [54, 58, 62, 68, 64],
            "frets": [-1, 3, 2, 1, 3, 0],
            "key": "F#"
        }, {
            "frets": [-1, 2, 1, 2, 2, 3],
            "baseFret": 8,
            "fingers": [0, 2, 1, 3, 3, 4],
            "suffix": "aug9",
            "midi": [54, 58, 64, 68, 74],
            "key": "F#",
            "barres": [2]
        }, {
            "suffix": "aug9",
            "midi": [54, 62, 68, 70, 64],
            "barres": [],
            "key": "F#",
            "frets": [4, -1, 2, 3, 1, 0],
            "fingers": [4, 0, 2, 3, 1, 0],
            "baseFret": 11
        }, {
            "midi": [42, 46, 52, 55, 61, 64],
            "fingers": [2, 1, 3, 0, 4, 0],
            "barres": [],
            "key": "F#",
            "baseFret": 1,
            "frets": [2, 1, 2, 0, 2, 0],
            "suffix": "7b9"
        }, {
            "fingers": [0, 0, 2, 1, 3, 1],
            "midi": [54, 58, 64, 67],
            "capo": true,
            "key": "F#",
            "baseFret": 3,
            "suffix": "7b9",
            "frets": [-1, -1, 2, 1, 3, 1],
            "barres": [1]
        }, {
            "barres": [1],
            "frets": [-1, 2, 1, 2, 1, 2],
            "suffix": "7b9",
            "baseFret": 8,
            "key": "F#",
            "fingers": [0, 2, 1, 3, 1, 4],
            "midi": [54, 58, 64, 67, 73],
            "capo": true
        }, {
            "baseFret": 12,
            "suffix": "7b9",
            "frets": [3, 2, 3, 1, -1, -1],
            "midi": [54, 58, 64, 67],
            "barres": [],
            "fingers": [3, 2, 4, 1, 0, 0],
            "key": "F#"
        }, {
            "midi": [42, 46, 52, 57, 61, 66],
            "key": "F#",
            "barres": [2],
            "frets": [2, 1, 2, 2, 2, 2],
            "suffix": "7#9",
            "fingers": [2, 1, 3, 3, 3, 4],
            "baseFret": 1
        }, {
            "capo": true,
            "fingers": [1, 3, 1, 2, 1, 4],
            "frets": [1, 3, 1, 2, 1, 4],
            "midi": [42, 49, 52, 58, 61, 69],
            "barres": [1],
            "baseFret": 2,
            "key": "F#",
            "suffix": "7#9"
        }, {
            "suffix": "7#9",
            "barres": [],
            "key": "F#",
            "fingers": [0, 0, 2, 1, 3, 4],
            "frets": [-1, -1, 2, 1, 3, 3],
            "baseFret": 3,
            "midi": [54, 58, 64, 69]
        }, {
            "frets": [-1, 2, 1, 2, 3, -1],
            "midi": [54, 58, 64, 69],
            "key": "F#",
            "baseFret": 8,
            "barres": [],
            "fingers": [0, 2, 1, 3, 4, 0],
            "suffix": "7#9"
        }, {
            "baseFret": 1,
            "key": "F#",
            "barres": [],
            "frets": [2, 1, 2, 1, 0, 0],
            "midi": [42, 46, 52, 56, 59, 64],
            "fingers": [3, 1, 4, 2, 0, 0],
            "suffix": "11"
        }, {
            "fingers": [1, 1, 1, 1, 2, 3],
            "baseFret": 4,
            "key": "F#",
            "barres": [1],
            "frets": [1, 1, 1, 1, 2, 3],
            "capo": true,
            "suffix": "11",
            "midi": [44, 49, 54, 59, 64, 70]
        }, {
            "frets": [-1, 3, 2, 3, 1, 1],
            "capo": true,
            "barres": [1],
            "fingers": [0, 3, 2, 4, 1, 1],
            "midi": [54, 58, 64, 66, 71],
            "suffix": "11",
            "baseFret": 7,
            "key": "F#"
        }, {
            "suffix": "11",
            "capo": true,
            "frets": [-1, 1, 1, 1, 3, 1],
            "barres": [1],
            "fingers": [0, 1, 1, 1, 3, 1],
            "midi": [54, 59, 64, 70, 73],
            "key": "F#",
            "baseFret": 9
        }, {
            "barres": [1],
            "frets": [2, 1, 2, 1, 1, 2],
            "midi": [42, 46, 52, 56, 60, 66],
            "suffix": "9#11",
            "fingers": [2, 1, 3, 1, 1, 4],
            "key": "F#",
            "baseFret": 1,
            "capo": true
        }, {
            "key": "F#",
            "baseFret": 4,
            "barres": [],
            "frets": [-1, -1, 1, 2, 2, 3],
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [54, 60, 64, 70],
            "suffix": "9#11"
        }, {
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 8,
            "frets": [-1, 2, 1, 2, 2, 1],
            "midi": [54, 58, 64, 68, 72],
            "suffix": "9#11",
            "capo": true,
            "key": "F#",
            "barres": [1]
        }, {
            "capo": true,
            "suffix": "9#11",
            "barres": [1],
            "midi": [54, 60, 64, 70, 73],
            "fingers": [0, 1, 2, 1, 3, 1],
            "key": "F#",
            "baseFret": 9,
            "frets": [-1, 1, 2, 1, 3, 1]
        }, {
            "midi": [42, 47, 51, 58, 59, 64],
            "fingers": [2, 3, 1, 4, 0, 0],
            "barres": [],
            "frets": [2, 2, 1, 3, 0, 0],
            "suffix": "13",
            "key": "F#",
            "baseFret": 1
        }, {
            "baseFret": 1,
            "capo": true,
            "suffix": "13",
            "fingers": [1, 1, 1, 2, 3, 4],
            "barres": [2],
            "midi": [42, 47, 52, 58, 63, 68],
            "key": "F#",
            "frets": [2, 2, 2, 3, 4, 4]
        }, {
            "key": "F#",
            "baseFret": 7,
            "barres": [],
            "frets": [-1, 3, 2, 2, 1, 0],
            "fingers": [0, 4, 2, 3, 1, 0],
            "suffix": "13",
            "midi": [54, 58, 63, 66, 64]
        }, {
            "capo": true,
            "suffix": "13",
            "key": "F#",
            "midi": [49, 54, 59, 64, 70, 75],
            "barres": [1],
            "baseFret": 9,
            "fingers": [1, 1, 1, 1, 3, 4],
            "frets": [1, 1, 1, 1, 3, 3]
        }, {
            "fingers": [1, 4, 2, 3, 1, 1],
            "baseFret": 1,
            "key": "F#",
            "suffix": "maj7",
            "capo": true,
            "midi": [42, 49, 53, 58, 61, 66],
            "frets": [2, 4, 3, 3, 2, 2],
            "barres": [2]
        }, {
            "suffix": "maj7",
            "barres": [1],
            "frets": [-1, 1, 1, 3, 3, 3],
            "baseFret": 4,
            "capo": true,
            "midi": [49, 54, 61, 65, 70],
            "key": "F#",
            "fingers": [0, 1, 1, 3, 3, 3]
        }, {
            "baseFret": 6,
            "frets": [-1, 4, 3, 1, 1, 1],
            "suffix": "maj7",
            "capo": true,
            "barres": [1],
            "fingers": [0, 4, 3, 1, 1, 1],
            "midi": [54, 58, 61, 65, 70],
            "key": "F#"
        }, {
            "midi": [49, 54, 61, 65, 70, 73],
            "key": "F#",
            "baseFret": 9,
            "fingers": [1, 1, 3, 2, 4, 1],
            "capo": true,
            "suffix": "maj7",
            "frets": [1, 1, 3, 2, 3, 1],
            "barres": [1]
        }, {
            "barres": [1],
            "frets": [2, 1, 3, 3, 1, 1],
            "key": "F#",
            "fingers": [2, 1, 3, 4, 1, 1],
            "capo": true,
            "baseFret": 1,
            "midi": [42, 46, 53, 58, 60, 65],
            "suffix": "maj7b5"
        }, {
            "frets": [-1, -1, 1, 2, 3, 3],
            "fingers": [0, 0, 1, 2, 3, 4],
            "suffix": "maj7b5",
            "barres": [],
            "baseFret": 4,
            "key": "F#",
            "midi": [54, 60, 65, 70]
        }, {
            "key": "F#",
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [54, 58, 65, 70, 72],
            "suffix": "maj7b5",
            "capo": true,
            "frets": [-1, 2, 1, 3, 4, 1],
            "barres": [1],
            "baseFret": 8
        }, {
            "baseFret": 9,
            "fingers": [0, 1, 2, 3, 4, 0],
            "frets": [-1, 1, 2, 2, 3, -1],
            "suffix": "maj7b5",
            "key": "F#",
            "barres": [],
            "midi": [54, 60, 65, 70]
        }, {
            "frets": [2, -1, 3, 3, 3, -1],
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 1,
            "key": "F#",
            "midi": [42, 53, 58, 62],
            "suffix": "maj7#5",
            "barres": []
        }, {
            "barres": [1],
            "baseFret": 6,
            "capo": true,
            "fingers": [1, 4, 3, 2, 1, 1],
            "midi": [46, 54, 58, 62, 65, 70],
            "frets": [1, 4, 3, 2, 1, 1],
            "key": "F#",
            "suffix": "maj7#5"
        }, {
            "baseFret": 9,
            "key": "F#",
            "fingers": [0, 1, 4, 2, 3, 0],
            "frets": [-1, 1, 4, 2, 3, -1],
            "midi": [54, 62, 65, 70],
            "barres": [],
            "suffix": "maj7#5"
        }, {
            "fingers": [0, 0, 2, 1, 1, 4],
            "suffix": "maj7#5",
            "frets": [-1, -1, 2, 1, 1, 3],
            "barres": [1],
            "key": "F#",
            "capo": true,
            "midi": [62, 66, 70, 77],
            "baseFret": 11
        }, {
            "midi": [42, 46, 53, 56, 61, 65],
            "capo": true,
            "barres": [1],
            "suffix": "maj9",
            "key": "F#",
            "frets": [2, 1, 3, 1, 2, 1],
            "baseFret": 1,
            "fingers": [2, 1, 4, 1, 3, 1]
        }, {
            "baseFret": 1,
            "key": "F#",
            "suffix": "maj9",
            "fingers": [1, 0, 2, 3, 1, 4],
            "midi": [42, 53, 58, 61, 68],
            "frets": [2, -1, 3, 3, 2, 4],
            "capo": true,
            "barres": [2]
        }, {
            "frets": [-1, -1, 2, 1, 4, 2],
            "key": "F#",
            "suffix": "maj9",
            "midi": [54, 58, 65, 68],
            "barres": [],
            "baseFret": 3,
            "fingers": [0, 0, 2, 1, 4, 3]
        }, {
            "baseFret": 8,
            "frets": [2, 2, 1, 3, 2, -1],
            "key": "F#",
            "suffix": "maj9",
            "fingers": [2, 2, 1, 4, 3, 0],
            "midi": [49, 54, 58, 65, 68],
            "barres": [2]
        }, {
            "key": "F#",
            "frets": [2, 2, 3, 3, 2, 2],
            "midi": [42, 47, 53, 58, 61, 66],
            "baseFret": 1,
            "suffix": "maj11",
            "fingers": [1, 1, 2, 3, 1, 1],
            "capo": true,
            "barres": [2]
        }, {
            "midi": [54, 59, 65, 70],
            "frets": [-1, -1, 1, 1, 3, 3],
            "baseFret": 4,
            "suffix": "maj11",
            "capo": true,
            "key": "F#",
            "fingers": [0, 0, 1, 1, 3, 4],
            "barres": [1]
        }, {
            "frets": [-1, 2, 1, 3, 0, 2],
            "barres": [],
            "key": "F#",
            "suffix": "maj11",
            "midi": [54, 58, 65, 59, 73],
            "fingers": [0, 2, 1, 4, 0, 3],
            "baseFret": 8
        }, {
            "midi": [49, 54, 59, 65, 70, 73],
            "barres": [1],
            "frets": [1, 1, 1, 2, 3, 1],
            "capo": true,
            "key": "F#",
            "baseFret": 9,
            "fingers": [1, 1, 1, 2, 4, 1],
            "suffix": "maj11"
        }, {
            "baseFret": 1,
            "barres": [1],
            "key": "F#",
            "capo": true,
            "suffix": "maj13",
            "fingers": [2, 1, 1, 1, 3, 1],
            "midi": [42, 46, 51, 56, 61, 65],
            "frets": [2, 1, 1, 1, 2, 1]
        }, {
            "midi": [51, 54, 59, 65, 70],
            "suffix": "maj13",
            "baseFret": 4,
            "key": "F#",
            "fingers": [0, 2, 1, 1, 3, 4],
            "barres": [1],
            "frets": [-1, 3, 1, 1, 3, 3],
            "capo": true
        }, {
            "key": "F#",
            "barres": [1],
            "baseFret": 6,
            "midi": [54, 58, 63, 65, 70],
            "frets": [-1, 4, 3, 3, 1, 1],
            "fingers": [0, 4, 2, 3, 1, 1],
            "suffix": "maj13"
        }, {
            "key": "F#",
            "capo": true,
            "frets": [-1, 1, 1, 2, 3, 3],
            "midi": [54, 59, 65, 70, 75],
            "fingers": [0, 1, 1, 2, 3, 4],
            "barres": [1],
            "baseFret": 9,
            "suffix": "maj13"
        }, {
            "suffix": "m6",
            "fingers": [2, 0, 1, 3, 3, 4],
            "midi": [42, 51, 57, 61, 66],
            "barres": [2],
            "frets": [2, -1, 1, 2, 2, 2],
            "baseFret": 1,
            "key": "F#"
        }, {
            "frets": [-1, 1, 1, 3, 1, 2],
            "capo": true,
            "midi": [49, 54, 61, 63, 69],
            "suffix": "m6",
            "fingers": [0, 1, 1, 3, 1, 2],
            "baseFret": 4,
            "key": "F#",
            "barres": [1]
        }, {
            "fingers": [0, 3, 1, 2, 1, 4],
            "baseFret": 7,
            "barres": [1],
            "frets": [-1, 3, 1, 2, 1, 3],
            "capo": true,
            "midi": [54, 57, 63, 66, 73],
            "key": "F#",
            "suffix": "m6"
        }, {
            "fingers": [0, 2, 4, 1, 3, 0],
            "key": "F#",
            "midi": [54, 61, 63, 69],
            "frets": [-1, 2, 4, 1, 3, -1],
            "barres": [],
            "suffix": "m6",
            "baseFret": 8
        }, {
            "suffix": "m7",
            "barres": [2],
            "fingers": [1, 3, 1, 1, 1, 1],
            "capo": true,
            "baseFret": 1,
            "frets": [2, 4, 2, 2, 2, 2],
            "key": "F#",
            "midi": [42, 49, 52, 57, 61, 66]
        }, {
            "barres": [],
            "midi": [54, 61, 64, 69],
            "frets": [-1, -1, 1, 3, 2, 2],
            "fingers": [0, 0, 1, 4, 2, 3],
            "baseFret": 4,
            "key": "F#",
            "suffix": "m7"
        }, {
            "key": "F#",
            "suffix": "m7",
            "fingers": [1, 1, 3, 1, 2, 1],
            "midi": [49, 54, 61, 64, 69, 73],
            "frets": [1, 1, 3, 1, 2, 1],
            "baseFret": 9,
            "barres": [1],
            "capo": true
        }, {
            "fingers": [0, 0, 2, 3, 1, 4],
            "key": "F#",
            "baseFret": 10,
            "frets": [-1, -1, 2, 2, 1, 3],
            "midi": [61, 66, 69, 76],
            "suffix": "m7",
            "barres": []
        }, {
            "midi": [42, 45, 52, 57, 60, 64],
            "fingers": [2, 0, 3, 4, 1, 0],
            "barres": [],
            "key": "F#",
            "suffix": "m7b5",
            "frets": [2, 0, 2, 2, 1, 0],
            "baseFret": 1
        }, {
            "fingers": [0, 0, 1, 2, 2, 2],
            "key": "F#",
            "suffix": "m7b5",
            "midi": [54, 60, 64, 69],
            "frets": [-1, -1, 1, 2, 2, 2],
            "baseFret": 4,
            "barres": [2]
        }, {
            "midi": [54, 60, 64, 69],
            "frets": [-1, 1, 2, 1, 2, -1],
            "barres": [],
            "fingers": [0, 1, 3, 2, 4, 0],
            "baseFret": 9,
            "suffix": "m7b5",
            "key": "F#"
        }, {
            "key": "F#",
            "suffix": "m7b5",
            "fingers": [0, 0, 1, 2, 1, 4],
            "midi": [60, 66, 69, 76],
            "baseFret": 10,
            "frets": [-1, -1, 1, 2, 1, 3],
            "barres": [1],
            "capo": true
        }, {
            "baseFret": 1,
            "suffix": "m9",
            "frets": [2, 0, 2, 1, 2, 0],
            "key": "F#",
            "fingers": [2, 0, 3, 1, 4, 0],
            "midi": [42, 45, 52, 56, 61, 64],
            "barres": []
        }, {
            "midi": [42, 49, 52, 57, 61, 68],
            "frets": [2, 4, 2, 2, 2, 4],
            "barres": [2],
            "capo": true,
            "suffix": "m9",
            "key": "F#",
            "baseFret": 1,
            "fingers": [1, 2, 1, 1, 1, 3]
        }, {
            "midi": [54, 57, 64, 68, 73],
            "barres": [3],
            "fingers": [0, 2, 1, 3, 4, 4],
            "suffix": "m9",
            "key": "F#",
            "frets": [-1, 3, 1, 3, 3, 3],
            "baseFret": 7
        }, {
            "suffix": "m9",
            "key": "F#",
            "midi": [61, 68, 69, 76],
            "frets": [-1, -1, 2, 4, 1, 3],
            "fingers": [0, 0, 2, 4, 1, 3],
            "barres": [],
            "baseFret": 10
        }, {
            "frets": [2, 0, 1, 1, 2, 2],
            "fingers": [2, 0, 1, 1, 3, 4],
            "baseFret": 1,
            "barres": [1],
            "midi": [42, 45, 51, 56, 61, 66],
            "key": "F#",
            "suffix": "m6/9"
        }, {
            "barres": [4],
            "baseFret": 1,
            "suffix": "m6/9",
            "fingers": [1, 2, 2, 1, 3, 4],
            "key": "F#",
            "frets": [2, 4, 4, 2, 4, 4],
            "midi": [42, 49, 54, 57, 63, 68]
        }, {
            "barres": [1],
            "midi": [45, 49, 54, 61, 63, 68],
            "frets": [2, 1, 1, 3, 1, 1],
            "capo": true,
            "fingers": [2, 1, 1, 3, 1, 1],
            "suffix": "m6/9",
            "key": "F#",
            "baseFret": 4
        }, {
            "fingers": [0, 3, 1, 2, 4, 0],
            "midi": [54, 57, 63, 68],
            "key": "F#",
            "baseFret": 7,
            "barres": [],
            "frets": [-1, 3, 1, 2, 3, -1],
            "suffix": "m6/9"
        }, {
            "frets": [2, 0, 2, 1, 0, 0],
            "baseFret": 1,
            "fingers": [2, 0, 3, 1, 0, 0],
            "barres": [],
            "midi": [42, 45, 52, 56, 59, 64],
            "suffix": "m11",
            "key": "F#"
        }, {
            "capo": true,
            "frets": [2, 2, 2, 2, 2, 4],
            "key": "F#",
            "suffix": "m11",
            "fingers": [1, 1, 1, 1, 1, 4],
            "midi": [42, 47, 52, 57, 61, 68],
            "baseFret": 1,
            "barres": [2]
        }, {
            "key": "F#",
            "capo": true,
            "baseFret": 4,
            "frets": [-1, -1, 1, 1, 2, 2],
            "barres": [1],
            "midi": [54, 59, 64, 69],
            "fingers": [0, 0, 1, 1, 2, 3],
            "suffix": "m11"
        }, {
            "fingers": [0, 2, 1, 3, 4, 1],
            "frets": [-1, 3, 1, 3, 3, 1],
            "baseFret": 7,
            "midi": [54, 57, 64, 68, 71],
            "key": "F#",
            "suffix": "m11",
            "barres": [1],
            "capo": true
        }, {
            "fingers": [1, 3, 2, 1, 1, 1],
            "barres": [2],
            "frets": [2, 4, 3, 2, 2, 2],
            "capo": true,
            "baseFret": 1,
            "midi": [42, 49, 53, 57, 61, 66],
            "key": "F#",
            "suffix": "mmaj7"
        }, {
            "fingers": [0, 1, 1, 3, 4, 2],
            "baseFret": 4,
            "capo": true,
            "key": "F#",
            "suffix": "mmaj7",
            "barres": [1],
            "midi": [49, 54, 61, 65, 69],
            "frets": [-1, 1, 1, 3, 3, 2]
        }, {
            "fingers": [0, 4, 2, 1, 1, 0],
            "suffix": "mmaj7",
            "key": "F#",
            "baseFret": 6,
            "capo": true,
            "midi": [54, 57, 61, 65],
            "barres": [1],
            "frets": [-1, 4, 2, 1, 1, -1]
        }, {
            "barres": [1],
            "baseFret": 9,
            "capo": true,
            "key": "F#",
            "fingers": [1, 1, 4, 2, 3, 1],
            "suffix": "mmaj7",
            "midi": [49, 54, 61, 65, 69, 73],
            "frets": [1, 1, 3, 2, 2, 1]
        }, {
            "barres": [2],
            "capo": true,
            "fingers": [1, 2, 3, 1, 0, 1],
            "key": "F#",
            "baseFret": 1,
            "suffix": "mmaj7b5",
            "frets": [2, 3, 3, 2, -1, 2],
            "midi": [42, 48, 53, 57, 66]
        }, {
            "suffix": "mmaj7b5",
            "midi": [54, 60, 65, 69],
            "key": "F#",
            "baseFret": 4,
            "fingers": [0, 0, 1, 2, 4, 3],
            "barres": [],
            "frets": [-1, -1, 1, 2, 3, 2]
        }, {
            "barres": [3],
            "baseFret": 8,
            "suffix": "mmaj7b5",
            "frets": [1, 2, 3, 3, 3, -1],
            "midi": [48, 54, 60, 65, 69],
            "fingers": [1, 2, 3, 3, 3, 0],
            "key": "F#"
        }, {
            "frets": [-1, 1, 2, 2, 2, -1],
            "suffix": "mmaj7b5",
            "midi": [54, 60, 65, 69],
            "baseFret": 9,
            "key": "F#",
            "fingers": [0, 1, 2, 3, 4, 0],
            "barres": []
        }, {
            "key": "F#",
            "barres": [1],
            "fingers": [2, 0, 4, 1, 3, 1],
            "midi": [42, 45, 53, 56, 61, 65],
            "frets": [2, 0, 3, 1, 2, 1],
            "baseFret": 1,
            "suffix": "mmaj9"
        }, {
            "baseFret": 1,
            "key": "F#",
            "fingers": [2, 0, 4, 1, 3, 0],
            "suffix": "mmaj9",
            "frets": [2, 0, 3, 1, 2, -1],
            "midi": [42, 45, 53, 56, 61],
            "barres": []
        }, {
            "key": "F#",
            "barres": [2],
            "frets": [2, 4, 3, 2, 2, 4],
            "fingers": [1, 3, 2, 1, 1, 4],
            "midi": [42, 49, 53, 57, 61, 68],
            "capo": true,
            "suffix": "mmaj9",
            "baseFret": 1
        }, {
            "midi": [54, 57, 65, 68],
            "barres": [],
            "baseFret": 7,
            "frets": [-1, 3, 1, 4, 3, -1],
            "fingers": [0, 2, 1, 4, 3, 0],
            "key": "F#",
            "suffix": "mmaj9"
        }, {
            "capo": true,
            "suffix": "mmaj11",
            "barres": [2],
            "key": "F#",
            "fingers": [1, 1, 2, 1, 1, 4],
            "baseFret": 1,
            "midi": [42, 47, 53, 57, 61, 68],
            "frets": [2, 2, 3, 2, 2, 4]
        }, {
            "frets": [-1, 1, 1, 1, 3, 2],
            "fingers": [0, 1, 1, 1, 3, 2],
            "key": "F#",
            "suffix": "mmaj11",
            "midi": [49, 54, 59, 65, 69],
            "baseFret": 4,
            "barres": [1],
            "capo": true
        }, {
            "fingers": [0, 2, 1, 4, 3, 1],
            "barres": [1],
            "key": "F#",
            "baseFret": 7,
            "frets": [-1, 3, 1, 4, 3, 1],
            "capo": true,
            "suffix": "mmaj11",
            "midi": [54, 57, 65, 68, 71]
        }, {
            "frets": [1, 1, 1, 2, 2, 1],
            "midi": [49, 54, 59, 65, 69, 73],
            "barres": [1],
            "capo": true,
            "fingers": [1, 1, 1, 2, 3, 1],
            "key": "F#",
            "baseFret": 9,
            "suffix": "mmaj11"
        }, {
            "midi": [42, 46, 56, 61, 66],
            "fingers": [3, 1, 0, 2, 4, 4],
            "baseFret": 1,
            "key": "F#",
            "frets": [2, 1, -1, 1, 2, 2],
            "suffix": "add9",
            "barres": [2]
        }, {
            "midi": [54, 58, 61, 68],
            "barres": [],
            "baseFret": 1,
            "fingers": [0, 0, 3, 2, 1, 4],
            "suffix": "add9",
            "key": "F#",
            "frets": [-1, -1, 4, 3, 2, 4]
        }, {
            "suffix": "add9",
            "barres": [1],
            "baseFret": 6,
            "frets": [-1, 4, 3, 1, 4, 1],
            "capo": true,
            "midi": [54, 58, 61, 68, 70],
            "fingers": [0, 3, 2, 1, 4, 1],
            "key": "F#"
        }, {
            "midi": [54, 58, 68, 73],
            "barres": [],
            "suffix": "add9",
            "key": "F#",
            "baseFret": 8,
            "fingers": [0, 2, 1, 0, 3, 4],
            "frets": [-1, 2, 1, -1, 2, 2]
        }, {
            "key": "F#",
            "frets": [-1, -1, 4, 2, 2, 4],
            "midi": [54, 57, 61, 68],
            "fingers": [0, 0, 3, 1, 1, 4],
            "capo": true,
            "baseFret": 1,
            "barres": [2],
            "suffix": "madd9"
        }, {
            "midi": [42, 49, 54, 57, 61, 68],
            "frets": [2, 4, 4, 2, 2, 4],
            "fingers": [1, 2, 3, 1, 1, 4],
            "baseFret": 1,
            "key": "F#",
            "suffix": "madd9",
            "capo": true,
            "barres": [2]
        }, {
            "midi": [54, 57, 61, 68],
            "frets": [-1, 4, 2, 1, 4, -1],
            "key": "F#",
            "baseFret": 6,
            "barres": [],
            "fingers": [0, 3, 2, 1, 4, 0],
            "suffix": "madd9"
        }, {
            "suffix": "madd9",
            "frets": [-1, 3, 1, -1, 3, 3],
            "key": "F#",
            "baseFret": 7,
            "barres": [],
            "midi": [54, 57, 68, 73],
            "fingers": [0, 2, 1, 0, 3, 4]
        }, {
            "key": "G",
            "suffix": "major",
            "baseFret": 1,
            "fingers": [2, 1, 0, 0, 0, 3],
            "frets": [3, 2, 0, 0, 0, 3],
            "midi": [43, 47, 50, 55, 59, 67],
            "barres": []
        }, {
            "baseFret": 3,
            "key": "G",
            "suffix": "major",
            "fingers": [1, 3, 4, 2, 1, 1],
            "capo": true,
            "barres": [1],
            "midi": [43, 50, 55, 59, 62, 67],
            "frets": [1, 3, 3, 2, 1, 1]
        }, {
            "midi": [50, 55, 62, 67, 71],
            "barres": [1],
            "key": "G",
            "fingers": [0, 1, 1, 2, 4, 3],
            "suffix": "major",
            "frets": [-1, 1, 1, 3, 4, 3],
            "baseFret": 5,
            "capo": true
        }, {
            "frets": [1, 4, 3, 1, 2, 1],
            "capo": true,
            "baseFret": 7,
            "fingers": [1, 4, 3, 1, 2, 1],
            "barres": [1],
            "key": "G",
            "midi": [47, 55, 59, 62, 67, 71],
            "suffix": "major"
        }, {
            "barres": [],
            "frets": [3, 1, 0, 0, 3, 3],
            "midi": [43, 46, 50, 55, 62, 67],
            "baseFret": 1,
            "fingers": [2, 1, 0, 0, 3, 4],
            "suffix": "minor",
            "key": "G"
        }, {
            "barres": [1],
            "frets": [1, 3, 3, 1, 1, 1],
            "fingers": [1, 3, 4, 1, 1, 1],
            "midi": [43, 50, 55, 58, 62, 67],
            "key": "G",
            "suffix": "minor",
            "baseFret": 3,
            "capo": true
        }, {
            "fingers": [0, 0, 1, 3, 4, 2],
            "midi": [55, 62, 67, 70],
            "barres": [],
            "baseFret": 5,
            "key": "G",
            "frets": [-1, -1, 1, 3, 4, 2],
            "suffix": "minor"
        }, {
            "midi": [50, 55, 62, 67, 70, 74],
            "barres": [1],
            "frets": [1, 1, 3, 3, 2, 1],
            "suffix": "minor",
            "baseFret": 10,
            "fingers": [1, 1, 3, 4, 2, 1],
            "capo": true,
            "key": "G"
        }, {
            "key": "G",
            "suffix": "dim",
            "midi": [43, 46, 58, 61],
            "fingers": [3, 1, 0, 4, 2, 0],
            "baseFret": 1,
            "frets": [3, 1, -1, 3, 2, -1],
            "barres": []
        }, {
            "barres": [],
            "baseFret": 5,
            "midi": [55, 61, 70],
            "suffix": "dim",
            "frets": [-1, -1, 1, 2, -1, 2],
            "fingers": [0, 0, 1, 2, 0, 3],
            "key": "G"
        }, {
            "midi": [55, 58, 67, 73],
            "barres": [],
            "suffix": "dim",
            "fingers": [0, 1, 2, 4, 3, 0],
            "baseFret": 8,
            "frets": [-1, 3, 1, -1, 1, 2],
            "key": "G"
        }, {
            "key": "G",
            "midi": [55, 61, 67, 70],
            "frets": [-1, 1, 2, 3, 2, -1],
            "baseFret": 10,
            "barres": [],
            "fingers": [0, 1, 2, 4, 3, 0],
            "suffix": "dim"
        }, {
            "fingers": [3, 1, 0, 4, 2, 0],
            "baseFret": 1,
            "key": "G",
            "midi": [43, 46, 58, 61, 64],
            "suffix": "dim7",
            "frets": [3, 1, -1, 3, 2, 0],
            "barres": []
        }, {
            "suffix": "dim7",
            "midi": [43, 52, 58, 61, 64],
            "barres": [],
            "fingers": [3, 0, 1, 4, 2, 0],
            "baseFret": 1,
            "key": "G",
            "frets": [3, -1, 2, 3, 2, 0]
        }, {
            "fingers": [1, 2, 3, 1, 4, 1],
            "suffix": "dim7",
            "midi": [43, 49, 55, 58, 64, 67],
            "barres": [1],
            "baseFret": 3,
            "frets": [1, 2, 3, 1, 3, 1],
            "capo": true,
            "key": "G"
        }, {
            "key": "G",
            "baseFret": 5,
            "fingers": [0, 0, 1, 3, 2, 4],
            "suffix": "dim7",
            "barres": [],
            "midi": [55, 61, 64, 70],
            "frets": [-1, -1, 1, 2, 1, 2]
        }, {
            "midi": [43, 45, 50, 55, 62, 67],
            "fingers": [1, 0, 0, 0, 2, 3],
            "barres": [],
            "key": "G",
            "baseFret": 1,
            "suffix": "sus2",
            "frets": [3, 0, 0, 0, 3, 3]
        }, {
            "midi": [45, 50, 55, 62, 67, 69],
            "frets": [1, 1, 1, 3, 4, 1],
            "baseFret": 5,
            "capo": true,
            "key": "G",
            "barres": [1],
            "fingers": [1, 1, 1, 3, 4, 1],
            "suffix": "sus2"
        }, {
            "baseFret": 7,
            "barres": [1],
            "capo": true,
            "frets": [-1, 4, 1, 1, 2, 4],
            "suffix": "sus2",
            "key": "G",
            "midi": [55, 57, 62, 67, 74],
            "fingers": [0, 3, 1, 1, 2, 4]
        }, {
            "baseFret": 10,
            "capo": true,
            "fingers": [1, 1, 3, 4, 1, 1],
            "key": "G",
            "suffix": "sus2",
            "barres": [1],
            "midi": [50, 55, 62, 67, 69, 74],
            "frets": [1, 1, 3, 3, 1, 1]
        }, {
            "baseFret": 1,
            "key": "G",
            "midi": [43, 48, 50, 55, 60, 67],
            "barres": [],
            "frets": [3, 3, 0, 0, 1, 3],
            "fingers": [2, 3, 0, 0, 1, 4],
            "suffix": "sus4"
        }, {
            "baseFret": 3,
            "frets": [1, 3, 3, 3, 1, 1],
            "key": "G",
            "fingers": [1, 2, 3, 4, 1, 1],
            "capo": true,
            "barres": [1],
            "suffix": "sus4",
            "midi": [43, 50, 55, 60, 62, 67]
        }, {
            "baseFret": 5,
            "frets": [-1, 1, 1, 3, 4, 4],
            "barres": [1, 4],
            "midi": [50, 55, 62, 67, 72],
            "key": "G",
            "suffix": "sus4",
            "capo": true,
            "fingers": [0, 1, 1, 3, 4, 4]
        }, {
            "capo": true,
            "key": "G",
            "baseFret": 10,
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [50, 55, 62, 67, 72, 74],
            "suffix": "sus4",
            "frets": [1, 1, 3, 3, 4, 1],
            "barres": [1]
        }, {
            "suffix": "7sus4",
            "frets": [3, 3, 0, 0, 1, 1],
            "barres": [1],
            "baseFret": 1,
            "key": "G",
            "midi": [43, 48, 50, 55, 60, 65],
            "capo": true,
            "fingers": [2, 3, 0, 0, 1, 1]
        }, {
            "capo": true,
            "frets": [1, 3, 1, 3, 1, 1],
            "baseFret": 3,
            "suffix": "7sus4",
            "barres": [1],
            "midi": [43, 50, 53, 60, 62, 67],
            "key": "G",
            "fingers": [1, 3, 1, 4, 1, 1]
        }, {
            "frets": [-1, 3, 3, 3, 1, 1],
            "barres": [1],
            "capo": true,
            "baseFret": 8,
            "midi": [55, 60, 65, 67, 72],
            "key": "G",
            "fingers": [0, 2, 3, 4, 1, 1],
            "suffix": "7sus4"
        }, {
            "baseFret": 10,
            "fingers": [1, 1, 3, 1, 4, 1],
            "key": "G",
            "frets": [1, 1, 3, 1, 4, 1],
            "barres": [1],
            "midi": [50, 55, 62, 65, 72, 74],
            "capo": true,
            "suffix": "7sus4"
        }, {
            "midi": [43, 47, 55, 61, 67],
            "key": "G",
            "frets": [3, 2, -1, 0, 2, 3],
            "barres": [],
            "suffix": "alt",
            "fingers": [3, 1, 0, 0, 2, 4],
            "baseFret": 1
        }, {
            "midi": [55, 61, 59, 71],
            "baseFret": 5,
            "barres": [],
            "fingers": [0, 0, 1, 2, 0, 3],
            "frets": [-1, -1, 1, 2, 0, 3],
            "key": "G",
            "suffix": "alt"
        }, {
            "baseFret": 9,
            "suffix": "alt",
            "barres": [],
            "midi": [55, 59, 55, 59, 73],
            "fingers": [0, 3, 1, 0, 0, 2],
            "frets": [-1, 2, 1, 0, 0, 1],
            "key": "G"
        }, {
            "baseFret": 10,
            "frets": [-1, 1, 2, 3, 3, -1],
            "midi": [55, 61, 67, 71],
            "suffix": "alt",
            "key": "G",
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "suffix": "aug",
            "fingers": [3, 2, 1, 0, 0, 0],
            "baseFret": 1,
            "frets": [3, 2, 1, 0, 0, -1],
            "midi": [43, 47, 51, 55, 59],
            "barres": [],
            "key": "G"
        }, {
            "key": "G",
            "barres": [],
            "midi": [43, 55, 59, 63],
            "fingers": [1, 0, 4, 2, 3, 0],
            "baseFret": 3,
            "suffix": "aug",
            "frets": [1, -1, 3, 2, 2, -1]
        }, {
            "baseFret": 4,
            "barres": [1],
            "midi": [55, 59, 63],
            "fingers": [0, 0, 2, 1, 1, 0],
            "key": "G",
            "capo": true,
            "suffix": "aug",
            "frets": [-1, -1, 2, 1, 1, -1]
        }, {
            "fingers": [0, 3, 2, 1, 1, 0],
            "barres": [1],
            "frets": [-1, 3, 2, 1, 1, -1],
            "capo": true,
            "key": "G",
            "midi": [55, 59, 63, 67],
            "suffix": "aug",
            "baseFret": 8
        }, {
            "midi": [43, 47, 50, 55, 59, 64],
            "barres": [],
            "suffix": "6",
            "baseFret": 1,
            "frets": [3, 2, 0, 0, 0, 0],
            "fingers": [2, 1, 0, 0, 0, 0],
            "key": "G"
        }, {
            "midi": [43, 52, 59, 62],
            "barres": [],
            "baseFret": 1,
            "frets": [3, -1, 2, 4, 3, -1],
            "fingers": [2, 0, 1, 4, 3, 0],
            "key": "G",
            "suffix": "6"
        }, {
            "fingers": [0, 1, 1, 3, 1, 4],
            "frets": [-1, 1, 1, 3, 1, 3],
            "baseFret": 5,
            "midi": [50, 55, 62, 64, 71],
            "capo": true,
            "suffix": "6",
            "barres": [1],
            "key": "G"
        }, {
            "baseFret": 10,
            "suffix": "6",
            "barres": [3],
            "fingers": [0, 1, 3, 3, 3, 4],
            "midi": [55, 62, 67, 71, 76],
            "key": "G",
            "frets": [-1, 1, 3, 3, 3, 3]
        }, {
            "suffix": "6/9",
            "baseFret": 1,
            "fingers": [1, 0, 0, 0, 0, 0],
            "key": "G",
            "barres": [],
            "midi": [43, 45, 50, 55, 59, 64],
            "frets": [3, 0, 0, 0, 0, 0]
        }, {
            "baseFret": 1,
            "barres": [2],
            "fingers": [2, 1, 1, 1, 3, 4],
            "frets": [3, 2, 2, 2, 3, 3],
            "capo": true,
            "key": "G",
            "suffix": "6/9",
            "midi": [43, 47, 52, 57, 62, 67]
        }, {
            "suffix": "6/9",
            "baseFret": 4,
            "barres": [2],
            "capo": true,
            "fingers": [0, 2, 2, 1, 3, 4],
            "key": "G",
            "midi": [50, 55, 59, 64, 69],
            "frets": [-1, 2, 2, 1, 2, 2]
        }, {
            "key": "G",
            "capo": true,
            "suffix": "6/9",
            "midi": [55, 59, 64, 69, 74],
            "fingers": [0, 2, 1, 1, 3, 4],
            "frets": [-1, 2, 1, 1, 2, 2],
            "barres": [1],
            "baseFret": 9
        }, {
            "frets": [3, 2, 0, 0, 0, 1],
            "baseFret": 1,
            "midi": [43, 47, 50, 55, 59, 65],
            "suffix": "7",
            "barres": [],
            "key": "G",
            "fingers": [3, 2, 0, 0, 0, 1]
        }, {
            "fingers": [1, 3, 1, 2, 1, 1],
            "barres": [1],
            "suffix": "7",
            "baseFret": 3,
            "midi": [43, 50, 53, 59, 62, 67],
            "capo": true,
            "key": "G",
            "frets": [1, 3, 1, 2, 1, 1]
        }, {
            "baseFret": 5,
            "capo": true,
            "key": "G",
            "fingers": [0, 1, 1, 3, 2, 4],
            "midi": [50, 55, 62, 65, 71],
            "suffix": "7",
            "frets": [-1, 1, 1, 3, 2, 3],
            "barres": [1]
        }, {
            "fingers": [1, 1, 3, 1, 4, 1],
            "key": "G",
            "barres": [1],
            "suffix": "7",
            "frets": [1, 1, 3, 1, 3, 1],
            "baseFret": 10,
            "midi": [50, 55, 62, 65, 71, 74],
            "capo": true
        }, {
            "frets": [3, -1, 3, 4, 2, -1],
            "midi": [43, 53, 59, 61],
            "barres": [],
            "baseFret": 1,
            "key": "G",
            "suffix": "7b5",
            "fingers": [2, 0, 3, 4, 1, 0]
        }, {
            "frets": [-1, -1, 1, 2, 2, 3],
            "midi": [55, 61, 65, 71],
            "suffix": "7b5",
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "G",
            "baseFret": 5,
            "barres": []
        }, {
            "barres": [],
            "suffix": "7b5",
            "midi": [55, 59, 65, 59, 73],
            "fingers": [0, 3, 1, 4, 0, 2],
            "frets": [-1, 2, 1, 2, 0, 1],
            "key": "G",
            "baseFret": 9
        }, {
            "capo": true,
            "frets": [-1, 1, 2, 1, 3, -1],
            "baseFret": 10,
            "midi": [55, 61, 65, 71],
            "barres": [1],
            "fingers": [0, 1, 2, 1, 3, 0],
            "key": "G",
            "suffix": "7b5"
        }, {
            "barres": [],
            "key": "G",
            "frets": [3, 2, 1, 0, 0, 1],
            "fingers": [4, 3, 1, 0, 0, 2],
            "midi": [43, 47, 51, 55, 59, 65],
            "baseFret": 1,
            "suffix": "aug7"
        }, {
            "suffix": "aug7",
            "fingers": [1, 0, 2, 3, 4, 0],
            "key": "G",
            "midi": [43, 53, 59, 63],
            "baseFret": 1,
            "frets": [3, -1, 3, 4, 4, -1],
            "barres": []
        }, {
            "fingers": [0, 0, 1, 4, 2, 3],
            "key": "G",
            "suffix": "aug7",
            "barres": [],
            "frets": [-1, -1, 1, 4, 2, 3],
            "baseFret": 5,
            "midi": [55, 63, 65, 71]
        }, {
            "key": "G",
            "fingers": [0, 1, 4, 1, 3, 2],
            "midi": [55, 63, 65, 71, 75],
            "suffix": "aug7",
            "frets": [-1, 1, 4, 1, 3, 2],
            "barres": [1],
            "baseFret": 10,
            "capo": true
        }, {
            "baseFret": 1,
            "frets": [3, 0, 0, 0, 0, 1],
            "suffix": "9",
            "fingers": [3, 0, 0, 0, 0, 1],
            "midi": [43, 45, 50, 55, 59, 65],
            "barres": [],
            "key": "G"
        }, {
            "key": "G",
            "barres": [2],
            "baseFret": 1,
            "midi": [43, 47, 53, 57, 62],
            "capo": true,
            "fingers": [2, 1, 3, 1, 4, 0],
            "suffix": "9",
            "frets": [3, 2, 3, 2, 3, -1]
        }, {
            "frets": [1, 3, 1, 2, 1, 3],
            "suffix": "9",
            "fingers": [1, 3, 1, 2, 1, 4],
            "midi": [43, 50, 53, 59, 62, 69],
            "baseFret": 3,
            "key": "G",
            "capo": true,
            "barres": [1]
        }, {
            "midi": [50, 55, 59, 65, 69, 74],
            "barres": [2],
            "baseFret": 9,
            "key": "G",
            "suffix": "9",
            "frets": [2, 2, 1, 2, 2, 2],
            "fingers": [2, 2, 1, 3, 3, 4]
        }, {
            "midi": [43, 47, 53, 57, 61, 67],
            "suffix": "9b5",
            "baseFret": 1,
            "key": "G",
            "fingers": [2, 1, 3, 1, 1, 4],
            "frets": [3, 2, 3, 2, 2, 3],
            "capo": true,
            "barres": [2]
        }, {
            "key": "G",
            "frets": [1, 2, 1, 2, 0, 3],
            "barres": [1],
            "fingers": [1, 2, 1, 3, 0, 4],
            "midi": [43, 49, 53, 59, 59, 69],
            "suffix": "9b5",
            "baseFret": 3
        }, {
            "barres": [1],
            "baseFret": 9,
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [55, 59, 65, 69, 73],
            "key": "G",
            "suffix": "9b5",
            "frets": [-1, 2, 1, 2, 2, 1],
            "capo": true
        }, {
            "key": "G",
            "midi": [57, 61, 55, 59, 77],
            "baseFret": 11,
            "fingers": [0, 2, 1, 0, 0, 3],
            "frets": [-1, 2, 1, 0, 0, 3],
            "barres": [],
            "suffix": "9b5"
        }, {
            "baseFret": 1,
            "suffix": "aug9",
            "key": "G",
            "fingers": [3, 0, 2, 0, 0, 1],
            "barres": [],
            "midi": [43, 45, 51, 55, 59, 65],
            "frets": [3, 0, 1, 0, 0, 1]
        }, {
            "midi": [43, 47, 53, 57, 63],
            "fingers": [2, 1, 3, 1, 4, 0],
            "frets": [3, 2, 3, 2, 4, -1],
            "suffix": "aug9",
            "key": "G",
            "barres": [],
            "baseFret": 1
        }, {
            "frets": [-1, 2, 1, 2, 2, 3],
            "midi": [55, 59, 65, 69, 75],
            "baseFret": 9,
            "key": "G",
            "fingers": [0, 2, 1, 3, 3, 4],
            "suffix": "aug9",
            "barres": [2]
        }, {
            "suffix": "aug9",
            "key": "G",
            "barres": [],
            "baseFret": 12,
            "midi": [57, 63, 55, 71, 77],
            "frets": [-1, 1, 2, 0, 1, 2],
            "fingers": [0, 1, 3, 0, 2, 4]
        }, {
            "frets": [3, 2, 0, 1, 3, 1],
            "barres": [1],
            "fingers": [3, 2, 0, 1, 4, 1],
            "key": "G",
            "midi": [43, 47, 50, 56, 62, 65],
            "suffix": "7b9",
            "baseFret": 1
        }, {
            "capo": true,
            "baseFret": 1,
            "midi": [43, 53, 59, 62, 68],
            "fingers": [1, 0, 1, 2, 1, 3],
            "key": "G",
            "suffix": "7b9",
            "frets": [3, -1, 3, 4, 3, 4],
            "barres": [3]
        }, {
            "barres": [1],
            "capo": true,
            "midi": [55, 59, 65, 68],
            "frets": [-1, -1, 2, 1, 3, 1],
            "suffix": "7b9",
            "baseFret": 4,
            "key": "G",
            "fingers": [0, 0, 2, 1, 3, 1]
        }, {
            "midi": [55, 59, 65, 68, 74],
            "capo": true,
            "barres": [1],
            "baseFret": 9,
            "frets": [-1, 2, 1, 2, 1, 2],
            "fingers": [0, 2, 1, 3, 1, 4],
            "suffix": "7b9",
            "key": "G"
        }, {
            "suffix": "7#9",
            "key": "G",
            "frets": [3, 2, 0, 3, 0, 1],
            "midi": [43, 47, 50, 58, 59, 65],
            "fingers": [3, 2, 0, 4, 0, 1],
            "barres": [],
            "baseFret": 1
        }, {
            "frets": [1, 3, 1, 2, 4, 4],
            "key": "G",
            "baseFret": 3,
            "suffix": "7#9",
            "fingers": [1, 3, 1, 2, 4, 4],
            "capo": true,
            "midi": [43, 50, 53, 59, 65, 70],
            "barres": [1, 4]
        }, {
            "fingers": [0, 2, 3, 1, 4, 4],
            "suffix": "7#9",
            "midi": [50, 55, 59, 65, 70],
            "frets": [-1, 2, 2, 1, 3, 3],
            "baseFret": 4,
            "key": "G",
            "barres": [3]
        }, {
            "suffix": "7#9",
            "frets": [-1, 2, 1, 2, 3, -1],
            "key": "G",
            "baseFret": 9,
            "midi": [55, 59, 65, 70],
            "barres": [],
            "fingers": [0, 2, 1, 3, 4, 0]
        }, {
            "suffix": "11",
            "baseFret": 1,
            "barres": [1],
            "fingers": [3, 2, 0, 0, 1, 1],
            "midi": [43, 47, 50, 55, 60, 65],
            "key": "G",
            "frets": [3, 2, 0, 0, 1, 1]
        }, {
            "baseFret": 5,
            "key": "G",
            "frets": [1, 1, 1, 1, 2, 3],
            "suffix": "11",
            "midi": [45, 50, 55, 60, 65, 71],
            "capo": true,
            "fingers": [1, 1, 1, 1, 2, 3],
            "barres": [1]
        }, {
            "capo": true,
            "fingers": [0, 3, 2, 4, 1, 1],
            "barres": [1],
            "frets": [-1, 3, 2, 3, 1, 1],
            "midi": [55, 59, 65, 67, 72],
            "baseFret": 8,
            "key": "G",
            "suffix": "11"
        }, {
            "fingers": [0, 1, 1, 1, 3, 1],
            "baseFret": 10,
            "capo": true,
            "key": "G",
            "frets": [-1, 1, 1, 1, 3, 1],
            "barres": [1],
            "midi": [55, 60, 65, 71, 74],
            "suffix": "11"
        }, {
            "fingers": [2, 1, 3, 1, 1, 4],
            "capo": true,
            "frets": [3, 2, 3, 2, 2, 3],
            "barres": [2],
            "midi": [43, 47, 53, 57, 61, 67],
            "baseFret": 1,
            "suffix": "9#11",
            "key": "G"
        }, {
            "barres": [],
            "suffix": "9#11",
            "baseFret": 5,
            "frets": [-1, -1, 1, 2, 2, 3],
            "fingers": [0, 0, 1, 2, 3, 4],
            "midi": [55, 61, 65, 71],
            "key": "G"
        }, {
            "suffix": "9#11",
            "barres": [1],
            "capo": true,
            "frets": [-1, 2, 1, 2, 2, 1],
            "baseFret": 9,
            "key": "G",
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [55, 59, 65, 69, 73]
        }, {
            "barres": [1],
            "midi": [55, 61, 65, 71, 74],
            "baseFret": 10,
            "capo": true,
            "fingers": [0, 1, 2, 1, 3, 1],
            "key": "G",
            "frets": [-1, 1, 2, 1, 3, 1],
            "suffix": "9#11"
        }, {
            "suffix": "13",
            "frets": [3, 0, 2, 0, 0, 1],
            "baseFret": 1,
            "midi": [43, 45, 52, 55, 59, 65],
            "key": "G",
            "fingers": [3, 0, 2, 0, 0, 1],
            "barres": []
        }, {
            "capo": true,
            "barres": [1],
            "key": "G",
            "fingers": [1, 0, 1, 2, 3, 4],
            "suffix": "13",
            "frets": [1, -1, 1, 2, 3, 3],
            "baseFret": 3,
            "midi": [43, 53, 59, 64, 69]
        }, {
            "suffix": "13",
            "midi": [43, 50, 53, 59, 64, 67],
            "barres": [1],
            "capo": true,
            "frets": [1, 3, 1, 2, 3, 1],
            "fingers": [1, 3, 1, 2, 4, 1],
            "key": "G",
            "baseFret": 3
        }, {
            "suffix": "13",
            "baseFret": 9,
            "key": "G",
            "barres": [2],
            "fingers": [0, 2, 1, 3, 3, 4],
            "frets": [-1, 2, 1, 2, 2, 4],
            "midi": [55, 59, 65, 69, 76]
        }, {
            "baseFret": 1,
            "midi": [43, 47, 50, 55, 59, 66],
            "fingers": [3, 2, 0, 0, 0, 1],
            "key": "G",
            "suffix": "maj7",
            "barres": [],
            "frets": [3, 2, 0, 0, 0, 2]
        }, {
            "barres": [1],
            "fingers": [1, 4, 2, 3, 1, 1],
            "frets": [1, 3, 2, 2, 1, 1],
            "baseFret": 3,
            "key": "G",
            "suffix": "maj7",
            "midi": [43, 50, 54, 59, 62, 67],
            "capo": true
        }, {
            "baseFret": 5,
            "capo": true,
            "barres": [1, 3],
            "key": "G",
            "frets": [-1, 1, 1, 3, 3, 3],
            "suffix": "maj7",
            "midi": [50, 55, 62, 66, 71],
            "fingers": [0, 1, 1, 3, 3, 3]
        }, {
            "fingers": [0, 1, 3, 2, 4, 1],
            "frets": [-1, 1, 3, 2, 3, 1],
            "barres": [1],
            "midi": [55, 62, 66, 71, 74],
            "key": "G",
            "suffix": "maj7",
            "baseFret": 10,
            "capo": true
        }, {
            "fingers": [2, 1, 3, 4, 1, 1],
            "suffix": "maj7b5",
            "barres": [2],
            "capo": true,
            "key": "G",
            "frets": [3, 2, 4, 4, 2, 2],
            "baseFret": 1,
            "midi": [43, 47, 54, 59, 61, 66]
        }, {
            "fingers": [1, 2, 3, 4, 0, 0],
            "frets": [3, 4, 4, 4, -1, -1],
            "midi": [43, 49, 54, 59],
            "key": "G",
            "suffix": "maj7b5",
            "baseFret": 1,
            "barres": []
        }, {
            "barres": [],
            "frets": [-1, -1, 1, 2, 3, 3],
            "key": "G",
            "fingers": [0, 0, 1, 2, 3, 4],
            "baseFret": 5,
            "midi": [55, 61, 66, 71],
            "suffix": "maj7b5"
        }, {
            "frets": [-1, 1, 2, 2, 3, -1],
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0],
            "suffix": "maj7b5",
            "midi": [55, 61, 66, 71],
            "baseFret": 10,
            "key": "G"
        }, {
            "baseFret": 1,
            "fingers": [0, 0, 1, 0, 0, 3],
            "key": "G",
            "barres": [],
            "frets": [-1, -1, 1, 0, 0, 2],
            "suffix": "maj7#5",
            "midi": [51, 55, 59, 66]
        }, {
            "key": "G",
            "fingers": [1, 0, 2, 3, 4, 0],
            "midi": [43, 54, 59, 63],
            "suffix": "maj7#5",
            "barres": [],
            "baseFret": 1,
            "frets": [3, -1, 4, 4, 4, -1]
        }, {
            "frets": [1, 4, 3, 2, 1, 1],
            "suffix": "maj7#5",
            "key": "G",
            "capo": true,
            "barres": [1],
            "fingers": [1, 4, 3, 2, 1, 1],
            "baseFret": 7,
            "midi": [47, 55, 59, 63, 66, 71]
        }, {
            "fingers": [0, 1, 4, 2, 3, 0],
            "barres": [],
            "key": "G",
            "frets": [-1, 1, 4, 2, 3, -1],
            "midi": [55, 63, 66, 71],
            "suffix": "maj7#5",
            "baseFret": 10
        }, {
            "suffix": "maj9",
            "midi": [43, 45, 50, 55, 59, 66],
            "fingers": [2, 0, 0, 0, 0, 1],
            "key": "G",
            "barres": [],
            "frets": [3, 0, 0, 0, 0, 2],
            "baseFret": 1
        }, {
            "capo": true,
            "key": "G",
            "baseFret": 1,
            "fingers": [2, 1, 4, 1, 3, 1],
            "barres": [2],
            "frets": [3, 2, 4, 2, 3, 2],
            "midi": [43, 47, 54, 57, 62, 66],
            "suffix": "maj9"
        }, {
            "baseFret": 3,
            "barres": [],
            "frets": [-1, -1, 2, 2, 1, 3],
            "suffix": "maj9",
            "midi": [54, 59, 62, 69],
            "key": "G",
            "fingers": [0, 0, 2, 3, 1, 4]
        }, {
            "barres": [],
            "frets": [-1, 2, 1, 3, 2, -1],
            "fingers": [0, 2, 1, 4, 3, 0],
            "key": "G",
            "baseFret": 9,
            "midi": [55, 59, 66, 69],
            "suffix": "maj9"
        }, {
            "suffix": "maj11",
            "midi": [43, 47, 50, 55, 60, 66],
            "baseFret": 1,
            "frets": [3, 2, 0, 0, 1, 2],
            "fingers": [4, 2, 0, 0, 1, 3],
            "barres": [],
            "key": "G"
        }, {
            "key": "G",
            "midi": [43, 48, 54, 59, 62, 67],
            "barres": [3],
            "baseFret": 1,
            "fingers": [1, 1, 2, 3, 1, 1],
            "frets": [3, 3, 4, 4, 3, 3],
            "capo": true,
            "suffix": "maj11"
        }, {
            "frets": [-1, -1, 3, 0, 1, 2],
            "midi": [59, 55, 66, 72],
            "fingers": [0, 0, 3, 0, 1, 2],
            "key": "G",
            "barres": [],
            "suffix": "maj11",
            "baseFret": 7
        }, {
            "barres": [1],
            "suffix": "maj11",
            "baseFret": 10,
            "midi": [50, 55, 60, 66, 71, 74],
            "key": "G",
            "capo": true,
            "frets": [1, 1, 1, 2, 3, 1],
            "fingers": [1, 1, 1, 2, 3, 1]
        }, {
            "capo": true,
            "fingers": [3, 1, 1, 1, 3, 1],
            "midi": [43, 47, 52, 57, 62, 66],
            "key": "G",
            "suffix": "maj13",
            "baseFret": 1,
            "frets": [3, 2, 2, 2, 3, 2],
            "barres": [2, 3]
        }, {
            "midi": [43, 48, 54, 59, 64, 67],
            "capo": true,
            "key": "G",
            "barres": [1],
            "suffix": "maj13",
            "frets": [1, 1, 2, 2, 3, 1],
            "baseFret": 3,
            "fingers": [1, 1, 2, 3, 4, 1]
        }, {
            "barres": [1],
            "suffix": "maj13",
            "key": "G",
            "frets": [-1, 4, 3, 3, 1, 1],
            "baseFret": 7,
            "fingers": [0, 4, 2, 3, 1, 1],
            "midi": [55, 59, 64, 66, 71]
        }, {
            "midi": [55, 60, 66, 71, 76],
            "frets": [-1, 1, 1, 2, 3, 3],
            "fingers": [0, 1, 1, 2, 3, 4],
            "barres": [1],
            "baseFret": 10,
            "key": "G",
            "suffix": "maj13",
            "capo": true
        }, {
            "midi": [43, 52, 58, 62, 67],
            "baseFret": 1,
            "fingers": [2, 0, 1, 3, 4, 4],
            "frets": [3, -1, 2, 3, 3, 3],
            "barres": [3],
            "suffix": "m6",
            "key": "G"
        }, {
            "frets": [1, 3, 3, 1, 3, 1],
            "midi": [43, 50, 55, 58, 64, 67],
            "baseFret": 3,
            "key": "G",
            "suffix": "m6",
            "capo": true,
            "fingers": [1, 2, 3, 1, 4, 1],
            "barres": [1]
        }, {
            "key": "G",
            "baseFret": 5,
            "capo": true,
            "fingers": [0, 1, 1, 3, 1, 2],
            "frets": [-1, 1, 1, 3, 1, 2],
            "midi": [50, 55, 62, 64, 70],
            "suffix": "m6",
            "barres": [1]
        }, {
            "frets": [-1, 3, 1, 2, 1, 3],
            "midi": [55, 58, 64, 67, 74],
            "barres": [1],
            "key": "G",
            "capo": true,
            "fingers": [0, 3, 1, 2, 1, 4],
            "baseFret": 8,
            "suffix": "m6"
        }, {
            "key": "G",
            "midi": [43, 50, 53, 58, 62, 67],
            "capo": true,
            "suffix": "m7",
            "fingers": [1, 3, 1, 1, 1, 1],
            "baseFret": 3,
            "barres": [1],
            "frets": [1, 3, 1, 1, 1, 1]
        }, {
            "baseFret": 5,
            "key": "G",
            "barres": [1],
            "capo": true,
            "fingers": [0, 1, 1, 4, 2, 3],
            "suffix": "m7",
            "midi": [50, 55, 62, 65, 70],
            "frets": [-1, 1, 1, 3, 2, 2]
        }, {
            "capo": true,
            "baseFret": 8,
            "midi": [55, 58, 65, 67, 74],
            "frets": [-1, 3, 1, 3, 1, 3],
            "suffix": "m7",
            "key": "G",
            "fingers": [0, 2, 1, 3, 1, 4],
            "barres": [1]
        }, {
            "key": "G",
            "suffix": "m7",
            "frets": [1, 1, 3, 1, 2, 1],
            "capo": true,
            "fingers": [1, 1, 3, 1, 2, 1],
            "midi": [50, 55, 62, 65, 70, 74],
            "barres": [1],
            "baseFret": 10
        }, {
            "midi": [43, 58, 61, 65],
            "frets": [3, -1, -1, 3, 2, 1],
            "baseFret": 1,
            "key": "G",
            "barres": [],
            "suffix": "m7b5",
            "fingers": [3, 0, 0, 4, 2, 1]
        }, {
            "baseFret": 1,
            "midi": [43, 53, 58, 61],
            "barres": [],
            "key": "G",
            "suffix": "m7b5",
            "fingers": [2, 0, 3, 4, 1, 0],
            "frets": [3, -1, 3, 3, 2, -1]
        }, {
            "barres": [2],
            "suffix": "m7b5",
            "baseFret": 5,
            "fingers": [0, 0, 1, 2, 2, 2],
            "midi": [55, 61, 65, 70],
            "frets": [-1, -1, 1, 2, 2, 2],
            "key": "G"
        }, {
            "suffix": "m7b5",
            "fingers": [0, 1, 3, 2, 4, 0],
            "midi": [55, 61, 65, 70],
            "frets": [-1, 1, 2, 1, 2, -1],
            "key": "G",
            "baseFret": 10,
            "barres": []
        }, {
            "frets": [3, 0, 0, 3, 3, 1],
            "midi": [43, 45, 50, 58, 62, 65],
            "key": "G",
            "barres": [],
            "baseFret": 1,
            "fingers": [2, 0, 0, 3, 4, 1],
            "suffix": "m9"
        }, {
            "fingers": [1, 3, 1, 1, 1, 4],
            "suffix": "m9",
            "frets": [1, 3, 1, 1, 1, 3],
            "key": "G",
            "midi": [43, 50, 53, 58, 62, 69],
            "capo": true,
            "baseFret": 3,
            "barres": [1]
        }, {
            "key": "G",
            "barres": [1],
            "baseFret": 6,
            "frets": [-1, -1, 2, 0, 1, 1],
            "midi": [57, 55, 65, 70],
            "suffix": "m9",
            "fingers": [0, 0, 2, 0, 1, 1]
        }, {
            "fingers": [0, 2, 1, 3, 4, 4],
            "barres": [3],
            "baseFret": 8,
            "suffix": "m9",
            "frets": [-1, 3, 1, 3, 3, 3],
            "key": "G",
            "midi": [55, 58, 65, 69, 74]
        }, {
            "suffix": "m6/9",
            "frets": [3, 1, 0, 2, 3, 0],
            "baseFret": 1,
            "barres": [],
            "midi": [43, 46, 50, 57, 62, 64],
            "key": "G",
            "fingers": [3, 1, 0, 2, 4, 0]
        }, {
            "barres": [3],
            "key": "G",
            "frets": [-1, 3, 3, 1, 3, 3],
            "midi": [50, 55, 58, 64, 69],
            "fingers": [0, 2, 2, 1, 3, 4],
            "baseFret": 3,
            "suffix": "m6/9"
        }, {
            "frets": [2, 1, 1, 3, 1, 1],
            "capo": true,
            "suffix": "m6/9",
            "fingers": [2, 1, 1, 3, 1, 1],
            "key": "G",
            "barres": [1],
            "baseFret": 5,
            "midi": [46, 50, 55, 62, 64, 69]
        }, {
            "midi": [55, 58, 64, 69, 74],
            "baseFret": 8,
            "key": "G",
            "suffix": "m6/9",
            "fingers": [0, 3, 1, 2, 4, 4],
            "barres": [3],
            "frets": [-1, 3, 1, 2, 3, 3]
        }, {
            "frets": [3, -1, 3, 3, 1, -1],
            "key": "G",
            "midi": [43, 53, 58, 60],
            "fingers": [2, 0, 3, 4, 1, 0],
            "baseFret": 1,
            "barres": [],
            "suffix": "m11"
        }, {
            "baseFret": 3,
            "frets": [1, 1, 1, 1, 1, 3],
            "key": "G",
            "capo": true,
            "suffix": "m11",
            "midi": [43, 48, 53, 58, 62, 69],
            "barres": [1],
            "fingers": [1, 1, 1, 1, 1, 4]
        }, {
            "baseFret": 5,
            "barres": [1],
            "suffix": "m11",
            "capo": true,
            "frets": [-1, -1, 1, 1, 3, 3],
            "fingers": [0, 0, 1, 1, 2, 3],
            "key": "G",
            "midi": [55, 60, 66, 71]
        }, {
            "frets": [-1, 3, 1, 3, 3, 1],
            "baseFret": 8,
            "key": "G",
            "suffix": "m11",
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [55, 58, 65, 69, 72],
            "barres": [1],
            "capo": true
        }, {
            "key": "G",
            "suffix": "mmaj7",
            "midi": [43, 46, 50, 55, 62, 66],
            "barres": [],
            "frets": [3, 1, 0, 0, 3, 2],
            "fingers": [3, 1, 0, 0, 4, 2],
            "baseFret": 1
        }, {
            "barres": [1],
            "fingers": [1, 3, 2, 1, 1, 1],
            "capo": true,
            "suffix": "mmaj7",
            "frets": [1, 3, 2, 1, 1, 1],
            "midi": [43, 50, 54, 58, 62, 67],
            "baseFret": 3,
            "key": "G"
        }, {
            "fingers": [0, 1, 1, 3, 4, 2],
            "frets": [-1, 1, 1, 3, 3, 2],
            "capo": true,
            "barres": [1],
            "midi": [50, 55, 62, 66, 70],
            "baseFret": 5,
            "key": "G",
            "suffix": "mmaj7"
        }, {
            "fingers": [0, 1, 4, 2, 3, 1],
            "key": "G",
            "barres": [1],
            "capo": true,
            "suffix": "mmaj7",
            "baseFret": 10,
            "frets": [-1, 1, 3, 2, 2, 1],
            "midi": [55, 62, 66, 70, 74]
        }, {
            "barres": [3],
            "capo": true,
            "baseFret": 1,
            "frets": [3, 4, 4, 3, -1, 3],
            "key": "G",
            "fingers": [1, 2, 3, 1, 0, 1],
            "suffix": "mmaj7b5",
            "midi": [43, 49, 54, 58, 67]
        }, {
            "baseFret": 5,
            "fingers": [0, 0, 1, 2, 4, 3],
            "key": "G",
            "suffix": "mmaj7b5",
            "frets": [-1, -1, 1, 2, 3, 2],
            "midi": [55, 61, 66, 70],
            "barres": []
        }, {
            "fingers": [1, 2, 3, 3, 3, 0],
            "key": "G",
            "baseFret": 9,
            "suffix": "mmaj7b5",
            "barres": [3],
            "frets": [1, 2, 3, 3, 3, -1],
            "midi": [49, 55, 61, 66, 70]
        }, {
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0],
            "frets": [-1, 1, 2, 2, 2, -1],
            "key": "G",
            "midi": [55, 61, 66, 70],
            "baseFret": 10,
            "suffix": "mmaj7b5"
        }, {
            "barres": [],
            "frets": [3, 0, 0, 3, 3, 2],
            "key": "G",
            "fingers": [2, 0, 0, 3, 4, 1],
            "baseFret": 1,
            "suffix": "mmaj9",
            "midi": [43, 45, 50, 58, 62, 66]
        }, {
            "midi": [43, 50, 54, 58, 62, 69],
            "frets": [1, 3, 2, 1, 1, 3],
            "key": "G",
            "suffix": "mmaj9",
            "capo": true,
            "barres": [1],
            "baseFret": 3,
            "fingers": [1, 3, 2, 1, 1, 4]
        }, {
            "suffix": "mmaj9",
            "barres": [],
            "key": "G",
            "frets": [-1, -1, 2, 0, 2, 1],
            "fingers": [0, 0, 2, 0, 3, 1],
            "midi": [57, 55, 66, 70],
            "baseFret": 6
        }, {
            "key": "G",
            "fingers": [0, 2, 1, 4, 3, 0],
            "frets": [-1, 3, 1, 4, 3, -1],
            "barres": [],
            "midi": [55, 58, 66, 69],
            "baseFret": 8,
            "suffix": "mmaj9"
        }, {
            "frets": [1, 1, 2, 1, 1, 3],
            "barres": [1],
            "suffix": "mmaj11",
            "baseFret": 3,
            "fingers": [1, 1, 2, 1, 1, 4],
            "key": "G",
            "capo": true,
            "midi": [43, 48, 54, 58, 62, 69]
        }, {
            "suffix": "mmaj11",
            "barres": [1],
            "baseFret": 5,
            "key": "G",
            "capo": true,
            "frets": [-1, 1, 1, 1, 3, 2],
            "midi": [50, 55, 60, 66, 70],
            "fingers": [0, 1, 1, 1, 3, 2]
        }, {
            "baseFret": 8,
            "key": "G",
            "suffix": "mmaj11",
            "frets": [-1, 3, 1, 4, 3, 1],
            "barres": [1],
            "fingers": [0, 2, 1, 4, 3, 1],
            "midi": [55, 58, 66, 69, 72],
            "capo": true
        }, {
            "midi": [50, 55, 60, 66, 70, 74],
            "fingers": [1, 1, 1, 2, 3, 1],
            "frets": [1, 1, 1, 2, 2, 1],
            "barres": [1],
            "baseFret": 10,
            "capo": true,
            "suffix": "mmaj11",
            "key": "G"
        }, {
            "midi": [43, 45, 50, 57, 59, 67],
            "frets": [3, 0, 0, 2, 0, 3],
            "baseFret": 1,
            "key": "G",
            "fingers": [2, 0, 0, 1, 0, 3],
            "suffix": "add9",
            "barres": []
        }, {
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 3, 2, 1, 4],
            "key": "G",
            "midi": [53, 57, 60, 68],
            "fingers": [0, 0, 3, 2, 1, 4],
            "suffix": "add9"
        }, {
            "fingers": [0, 3, 2, 1, 4, 1],
            "frets": [-1, 4, 3, 1, 4, 1],
            "capo": true,
            "baseFret": 7,
            "barres": [1],
            "midi": [55, 59, 62, 69, 71],
            "key": "G",
            "suffix": "add9"
        }, {
            "midi": [55, 59, 55, 69, 74],
            "fingers": [0, 2, 1, 0, 3, 4],
            "key": "G",
            "suffix": "add9",
            "baseFret": 9,
            "barres": [],
            "frets": [-1, 2, 1, 0, 2, 2]
        }, {
            "barres": [3],
            "fingers": [3, 1, 0, 2, 4, 4],
            "frets": [3, 1, 0, 2, 3, 3],
            "key": "G",
            "midi": [43, 46, 50, 57, 62, 67],
            "baseFret": 1,
            "suffix": "madd9"
        }, {
            "barres": [1],
            "baseFret": 3,
            "midi": [55, 58, 62, 69],
            "frets": [-1, -1, 3, 1, 1, 3],
            "capo": true,
            "key": "G",
            "fingers": [0, 0, 3, 1, 1, 4],
            "suffix": "madd9"
        }, {
            "suffix": "madd9",
            "frets": [-1, -1, 2, 0, 3, 1],
            "baseFret": 6,
            "barres": [],
            "fingers": [0, 0, 2, 0, 3, 1],
            "midi": [57, 55, 67, 70],
            "key": "G"
        }, {
            "fingers": [0, 3, 2, 1, 4, 0],
            "key": "G",
            "midi": [55, 58, 62, 69],
            "frets": [-1, 4, 2, 1, 4, -1],
            "barres": [],
            "suffix": "madd9",
            "baseFret": 7
        }, {
            "key": "G",
            "barres": [],
            "baseFret": 1,
            "fingers": [1, 2, 0, 0, 0, 3],
            "frets": [2, 2, 0, 0, 0, 3],
            "suffix": "/F#",
            "midi": [42, 47, 50, 55, 59, 67]
        }, {
            "frets": [2, 2, 0, 0, 3, 3],
            "fingers": [1, 2, 0, 0, 3, 4],
            "midi": [42, 47, 50, 55, 62, 67],
            "suffix": "/F#",
            "baseFret": 1,
            "barres": [],
            "key": "G"
        }, {
            "frets": [-1, -1, 4, 4, 3, 3],
            "midi": [54, 59, 62, 67],
            "barres": [3],
            "fingers": [0, 0, 2, 3, 1, 1],
            "suffix": "/F#",
            "key": "G",
            "baseFret": 1
        }, {
            "barres": [],
            "frets": [-1, 2, 0, 0, 3, 3],
            "key": "G",
            "baseFret": 1,
            "fingers": [0, 1, 0, 0, 2, 3],
            "midi": [47, 50, 55, 62, 67],
            "suffix": "/B"
        }, {
            "midi": [47, 50, 55, 59, 67],
            "baseFret": 1,
            "frets": [-1, 2, 0, 0, 0, 3],
            "fingers": [0, 1, 0, 0, 0, 2],
            "key": "G",
            "suffix": "/B",
            "barres": []
        }, {
            "midi": [47, 55, 59, 62, 67],
            "baseFret": 2,
            "frets": [-1, 1, 4, 3, 2, 2],
            "barres": [2],
            "key": "G",
            "suffix": "/B",
            "fingers": [0, 1, 4, 3, 2, 2]
        }, {
            "suffix": "/D",
            "frets": [-1, -1, 0, 0, 0, 3],
            "fingers": [0, 0, 0, 0, 0, 1],
            "barres": [],
            "baseFret": 1,
            "key": "G",
            "midi": [50, 55, 59, 67]
        }, {
            "barres": [1],
            "baseFret": 3,
            "frets": [-1, 3, 3, 2, 1, 1],
            "midi": [50, 55, 59, 62, 67],
            "key": "G",
            "fingers": [0, 3, 4, 2, 1, 1],
            "suffix": "/D"
        }, {
            "fingers": [0, 1, 1, 3, 4, 3],
            "baseFret": 5,
            "midi": [50, 55, 62, 67, 71],
            "frets": [-1, 1, 1, 3, 4, 3],
            "suffix": "/D",
            "barres": [1],
            "key": "G"
        }, {
            "frets": [0, 2, 0, 0, 3, 3],
            "fingers": [0, 1, 0, 0, 2, 3],
            "barres": [],
            "midi": [40, 47, 50, 55, 62, 67],
            "baseFret": 1,
            "suffix": "/E",
            "key": "G"
        }, {
            "barres": [],
            "baseFret": 1,
            "fingers": [0, 1, 0, 0, 0, 2],
            "key": "G",
            "midi": [40, 47, 50, 55, 59, 67],
            "suffix": "/E",
            "frets": [0, 2, 0, 0, 0, 3]
        }, {
            "frets": [-1, -1, 2, 4, 3, 3],
            "barres": [],
            "fingers": [0, 0, 1, 4, 2, 3],
            "key": "G",
            "midi": [52, 59, 62, 67],
            "suffix": "/E",
            "baseFret": 1
        }, {
            "baseFret": 1,
            "midi": [41, 47, 50, 55, 62, 67],
            "barres": [],
            "key": "G",
            "suffix": "/F",
            "fingers": [1, 2, 0, 0, 3, 4],
            "frets": [1, 2, 0, 0, 3, 3]
        }, {
            "fingers": [1, 2, 0, 0, 0, 3],
            "baseFret": 1,
            "key": "G",
            "suffix": "/F",
            "frets": [1, 2, 0, 0, 0, 3],
            "barres": [],
            "midi": [41, 47, 50, 55, 59, 67]
        }, {
            "key": "G",
            "frets": [-1, -1, 3, 4, 3, 3],
            "baseFret": 1,
            "midi": [53, 59, 62, 67],
            "fingers": [0, 0, 1, 2, 1, 1],
            "suffix": "/F",
            "barres": []
        }, {
            "frets": [4, 3, 1, 1, 1, -1],
            "baseFret": 1,
            "midi": [44, 48, 51, 56, 60],
            "suffix": "major",
            "barres": [1],
            "fingers": [3, 2, 1, 1, 1, 0],
            "key": "Ab",
            "capo": true
        }, {
            "barres": [1],
            "key": "Ab",
            "frets": [1, 3, 3, 2, 1, 1],
            "capo": true,
            "baseFret": 4,
            "suffix": "major",
            "fingers": [1, 3, 4, 2, 1, 1],
            "midi": [44, 51, 56, 60, 63, 68]
        }, {
            "capo": true,
            "frets": [-1, 1, 1, 3, 4, 3],
            "barres": [1],
            "fingers": [0, 1, 1, 2, 4, 3],
            "baseFret": 6,
            "suffix": "major",
            "midi": [51, 56, 63, 68, 72],
            "key": "Ab"
        }, {
            "suffix": "major",
            "barres": [1],
            "fingers": [1, 4, 3, 1, 2, 1],
            "baseFret": 8,
            "frets": [1, 4, 3, 1, 2, 1],
            "midi": [48, 56, 60, 63, 68, 72],
            "capo": true,
            "key": "Ab"
        }, {
            "barres": [1],
            "fingers": [1, 3, 4, 1, 1, 1],
            "midi": [44, 51, 56, 59, 63, 68],
            "capo": true,
            "frets": [1, 3, 3, 1, 1, 1],
            "baseFret": 4,
            "key": "Ab",
            "suffix": "minor"
        }, {
            "midi": [56, 63, 68, 71],
            "suffix": "minor",
            "key": "Ab",
            "barres": [],
            "baseFret": 6,
            "frets": [-1, -1, 1, 3, 4, 2],
            "fingers": [0, 0, 1, 3, 4, 2]
        }, {
            "key": "Ab",
            "barres": [],
            "suffix": "minor",
            "midi": [59, 63, 68, 71],
            "frets": [-1, -1, 3, 2, 3, 1],
            "baseFret": 7,
            "fingers": [0, 0, 3, 2, 4, 1]
        }, {
            "midi": [51, 56, 63, 68, 71, 75],
            "fingers": [1, 1, 3, 4, 2, 1],
            "capo": true,
            "baseFret": 11,
            "suffix": "minor",
            "frets": [1, 1, 3, 3, 2, 1],
            "barres": [1],
            "key": "Ab"
        }, {
            "key": "Ab",
            "midi": [44, 47, 59, 62],
            "fingers": [3, 1, 0, 4, 2, 0],
            "frets": [4, 2, -1, 4, 3, -1],
            "baseFret": 1,
            "suffix": "dim",
            "barres": []
        }, {
            "fingers": [0, 0, 1, 2, 0, 3],
            "midi": [56, 62, 71],
            "key": "Ab",
            "barres": [],
            "baseFret": 6,
            "suffix": "dim",
            "frets": [-1, -1, 1, 2, -1, 2]
        }, {
            "key": "Ab",
            "barres": [],
            "baseFret": 9,
            "midi": [56, 59, 68, 74],
            "fingers": [0, 4, 1, 0, 2, 3],
            "frets": [-1, 3, 1, -1, 1, 2],
            "suffix": "dim"
        }, {
            "baseFret": 11,
            "fingers": [0, 1, 2, 4, 3, 0],
            "barres": [],
            "suffix": "dim",
            "frets": [-1, 1, 2, 3, 2, -1],
            "key": "Ab",
            "midi": [56, 62, 68, 71]
        }, {
            "midi": [50, 56, 59, 65],
            "key": "Ab",
            "barres": [],
            "frets": [-1, -1, 0, 1, 0, 1],
            "suffix": "dim7",
            "fingers": [0, 0, 0, 1, 0, 2],
            "baseFret": 1
        }, {
            "key": "Ab",
            "suffix": "dim7",
            "fingers": [2, 0, 1, 3, 1, 4],
            "frets": [4, -1, 3, 4, 3, 4],
            "baseFret": 1,
            "capo": true,
            "barres": [3],
            "midi": [44, 53, 59, 62, 68]
        }, {
            "key": "Ab",
            "baseFret": 6,
            "barres": [],
            "fingers": [0, 0, 1, 3, 2, 4],
            "suffix": "dim7",
            "midi": [56, 62, 65, 71],
            "frets": [-1, -1, 1, 2, 1, 2]
        }, {
            "key": "Ab",
            "baseFret": 10,
            "barres": [1],
            "fingers": [1, 2, 3, 1, 4, 1],
            "midi": [50, 56, 62, 65, 71, 74],
            "frets": [1, 2, 3, 1, 3, 1],
            "capo": true,
            "suffix": "dim7"
        }, {
            "midi": [44, 58, 63, 68],
            "suffix": "sus2",
            "barres": [],
            "frets": [4, -1, -1, 3, 4, 4],
            "baseFret": 1,
            "fingers": [2, 0, 0, 1, 3, 4],
            "key": "Ab"
        }, {
            "capo": true,
            "fingers": [1, 2, 3, 0, 1, 4],
            "midi": [44, 51, 56, 63, 70],
            "barres": [1],
            "frets": [1, 3, 3, -1, 1, 3],
            "key": "Ab",
            "suffix": "sus2",
            "baseFret": 4
        }, {
            "baseFret": 6,
            "suffix": "sus2",
            "capo": true,
            "barres": [1],
            "fingers": [1, 1, 1, 3, 4, 1],
            "midi": [46, 51, 56, 63, 68, 70],
            "key": "Ab",
            "frets": [1, 1, 1, 3, 4, 1]
        }, {
            "barres": [1],
            "capo": true,
            "baseFret": 11,
            "key": "Ab",
            "frets": [1, 1, 3, 3, 1, 1],
            "fingers": [1, 1, 3, 4, 1, 1],
            "midi": [51, 56, 63, 68, 70, 75],
            "suffix": "sus2"
        }, {
            "baseFret": 1,
            "frets": [-1, -1, 1, 1, 2, 4],
            "fingers": [0, 0, 1, 1, 2, 4],
            "key": "Ab",
            "barres": [1],
            "midi": [51, 56, 61, 68],
            "capo": true,
            "suffix": "sus4"
        }, {
            "midi": [44, 51, 56, 61, 63, 68],
            "baseFret": 4,
            "key": "Ab",
            "fingers": [1, 2, 3, 4, 1, 1],
            "capo": true,
            "suffix": "sus4",
            "frets": [1, 3, 3, 3, 1, 1],
            "barres": [1]
        }, {
            "frets": [-1, 1, 1, 3, 4, 4],
            "baseFret": 6,
            "barres": [1],
            "key": "Ab",
            "capo": true,
            "fingers": [0, 1, 1, 2, 3, 4],
            "midi": [51, 56, 63, 68, 73],
            "suffix": "sus4"
        }, {
            "barres": [1],
            "capo": true,
            "key": "Ab",
            "frets": [1, 1, 3, 3, 4, 1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [51, 56, 63, 68, 73, 75],
            "suffix": "sus4",
            "baseFret": 11
        }, {
            "baseFret": 1,
            "barres": [1, 2],
            "key": "Ab",
            "fingers": [0, 0, 1, 1, 2, 2],
            "frets": [-1, -1, 1, 1, 2, 2],
            "suffix": "7sus4",
            "midi": [51, 56, 61, 66],
            "capo": true
        }, {
            "fingers": [1, 3, 1, 4, 1, 1],
            "suffix": "7sus4",
            "barres": [1],
            "key": "Ab",
            "frets": [1, 3, 1, 3, 1, 1],
            "midi": [44, 51, 54, 61, 63, 68],
            "baseFret": 4,
            "capo": true
        }, {
            "frets": [-1, 3, 3, 3, 1, 1],
            "capo": true,
            "midi": [56, 61, 66, 68, 73],
            "barres": [1],
            "fingers": [0, 2, 3, 4, 1, 1],
            "baseFret": 9,
            "key": "Ab",
            "suffix": "7sus4"
        }, {
            "barres": [1],
            "baseFret": 11,
            "fingers": [1, 1, 3, 1, 4, 1],
            "capo": true,
            "key": "Ab",
            "suffix": "7sus4",
            "frets": [1, 1, 3, 1, 4, 1],
            "midi": [51, 56, 63, 66, 73, 75]
        }, {
            "baseFret": 3,
            "suffix": "alt",
            "frets": [-1, -1, 4, 3, 1, 2],
            "key": "Ab",
            "midi": [56, 60, 62, 68],
            "fingers": [0, 0, 4, 3, 1, 2],
            "barres": []
        }, {
            "baseFret": 6,
            "midi": [56, 62, 68, 72],
            "key": "Ab",
            "fingers": [0, 0, 1, 2, 4, 3],
            "barres": [],
            "frets": [-1, -1, 1, 2, 4, 3],
            "suffix": "alt"
        }, {
            "frets": [-1, 2, 1, 4, 4, 1],
            "capo": true,
            "baseFret": 10,
            "fingers": [0, 2, 1, 4, 4, 1],
            "midi": [56, 60, 68, 72, 74],
            "key": "Ab",
            "suffix": "alt",
            "barres": [1, 4]
        }, {
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0],
            "baseFret": 11,
            "midi": [56, 62, 68, 72],
            "key": "Ab",
            "frets": [-1, 1, 2, 3, 3, -1],
            "suffix": "alt"
        }, {
            "capo": true,
            "fingers": [4, 3, 2, 1, 1, 0],
            "suffix": "aug",
            "baseFret": 1,
            "key": "Ab",
            "frets": [4, 3, 2, 1, 1, -1],
            "midi": [44, 48, 52, 56, 60],
            "barres": [1]
        }, {
            "key": "Ab",
            "suffix": "aug",
            "frets": [1, -1, 3, 2, 2, -1],
            "barres": [],
            "fingers": [1, 0, 4, 2, 3, 0],
            "midi": [44, 56, 60, 64],
            "baseFret": 4
        }, {
            "baseFret": 5,
            "frets": [-1, -1, 2, 1, 1, -1],
            "capo": true,
            "key": "Ab",
            "midi": [56, 60, 64],
            "fingers": [0, 0, 2, 1, 1, 0],
            "barres": [1],
            "suffix": "aug"
        }, {
            "fingers": [0, 3, 2, 1, 1, 0],
            "barres": [1],
            "suffix": "aug",
            "capo": true,
            "frets": [-1, 3, 2, 1, 1, -1],
            "midi": [56, 60, 64, 68],
            "key": "Ab",
            "baseFret": 9
        }, {
            "baseFret": 1,
            "frets": [-1, 3, 1, 1, 1, 1],
            "suffix": "6",
            "barres": [1],
            "midi": [48, 51, 56, 60, 65],
            "key": "Ab",
            "capo": true,
            "fingers": [0, 3, 1, 1, 1, 1]
        }, {
            "fingers": [2, 0, 1, 4, 3, 0],
            "midi": [44, 53, 60, 63],
            "suffix": "6",
            "key": "Ab",
            "baseFret": 3,
            "frets": [2, -1, 1, 3, 2, -1],
            "barres": []
        }, {
            "fingers": [0, 1, 1, 3, 1, 4],
            "capo": true,
            "key": "Ab",
            "barres": [1],
            "frets": [-1, 1, 1, 3, 1, 3],
            "midi": [51, 56, 63, 65, 72],
            "suffix": "6",
            "baseFret": 6
        }, {
            "suffix": "6",
            "frets": [-1, 3, 2, 2, 1, -1],
            "midi": [56, 60, 65, 68],
            "baseFret": 9,
            "fingers": [0, 4, 2, 3, 1, 0],
            "key": "Ab",
            "barres": []
        }, {
            "key": "Ab",
            "frets": [-1, 1, 1, 1, 1, 1],
            "baseFret": 1,
            "capo": true,
            "fingers": [0, 1, 1, 1, 1, 1],
            "suffix": "6/9",
            "midi": [46, 51, 56, 60, 65],
            "barres": [1]
        }, {
            "barres": [3],
            "capo": true,
            "frets": [4, 3, 3, 3, 4, 4],
            "fingers": [2, 1, 1, 1, 3, 4],
            "baseFret": 1,
            "suffix": "6/9",
            "midi": [44, 48, 53, 58, 63, 68],
            "key": "Ab"
        }, {
            "key": "Ab",
            "midi": [56, 60, 65, 70],
            "barres": [],
            "frets": [-1, -1, 2, 1, 2, 2],
            "baseFret": 5,
            "suffix": "6/9",
            "fingers": [0, 0, 2, 1, 3, 4]
        }, {
            "fingers": [0, 2, 1, 1, 3, 4],
            "baseFret": 10,
            "barres": [1],
            "midi": [56, 60, 65, 70, 75],
            "key": "Ab",
            "frets": [-1, 2, 1, 1, 2, 2],
            "capo": true,
            "suffix": "6/9"
        }, {
            "suffix": "7",
            "fingers": [0, 0, 1, 1, 1, 2],
            "frets": [-1, -1, 1, 1, 1, 2],
            "key": "Ab",
            "barres": [1],
            "capo": true,
            "midi": [51, 56, 60, 66],
            "baseFret": 1
        }, {
            "frets": [1, 3, 1, 2, 1, 1],
            "capo": true,
            "key": "Ab",
            "fingers": [1, 3, 1, 2, 1, 1],
            "barres": [1],
            "baseFret": 4,
            "suffix": "7",
            "midi": [44, 51, 54, 60, 63, 68]
        }, {
            "suffix": "7",
            "barres": [1],
            "key": "Ab",
            "baseFret": 6,
            "capo": true,
            "midi": [51, 56, 63, 66, 72],
            "frets": [-1, 1, 1, 3, 2, 3],
            "fingers": [0, 1, 1, 3, 2, 4]
        }, {
            "barres": [1],
            "fingers": [1, 1, 3, 1, 4, 1],
            "frets": [1, 1, 3, 1, 3, 1],
            "baseFret": 11,
            "key": "Ab",
            "midi": [51, 56, 63, 66, 72, 75],
            "capo": true,
            "suffix": "7"
        }, {
            "barres": [],
            "frets": [2, -1, 2, 3, 1, -1],
            "fingers": [2, 0, 3, 4, 1, 0],
            "midi": [44, 54, 60, 62],
            "key": "Ab",
            "baseFret": 3,
            "suffix": "7b5"
        }, {
            "key": "Ab",
            "suffix": "7b5",
            "barres": [],
            "baseFret": 6,
            "fingers": [0, 0, 1, 2, 3, 4],
            "frets": [-1, -1, 1, 2, 2, 3],
            "midi": [56, 62, 66, 72]
        }, {
            "midi": [54, 60, 66, 68, 74],
            "barres": [1],
            "key": "Ab",
            "capo": true,
            "suffix": "7b5",
            "frets": [-1, 1, 2, 3, 1, 2],
            "baseFret": 9,
            "fingers": [0, 1, 2, 4, 1, 3]
        }, {
            "barres": [1],
            "capo": true,
            "fingers": [0, 1, 2, 1, 3, 0],
            "key": "Ab",
            "midi": [56, 62, 66, 72],
            "frets": [-1, 1, 2, 1, 3, -1],
            "suffix": "7b5",
            "baseFret": 11
        }, {
            "midi": [44, 54, 60, 64, 64],
            "key": "Ab",
            "frets": [1, -1, 1, 2, 2, 0],
            "baseFret": 4,
            "barres": [],
            "suffix": "aug7",
            "fingers": [1, 0, 2, 3, 4, 0]
        }, {
            "barres": [],
            "midi": [56, 64, 66, 72],
            "baseFret": 6,
            "key": "Ab",
            "fingers": [0, 0, 1, 4, 2, 3],
            "frets": [-1, -1, 1, 4, 2, 3],
            "suffix": "aug7"
        }, {
            "frets": [-1, 3, 2, 3, 1, 0],
            "fingers": [0, 3, 2, 4, 1, 0],
            "barres": [],
            "suffix": "aug7",
            "baseFret": 9,
            "key": "Ab",
            "midi": [56, 60, 66, 68, 64]
        }, {
            "frets": [-1, 1, 4, 1, 3, 2],
            "barres": [1],
            "key": "Ab",
            "baseFret": 11,
            "fingers": [0, 1, 4, 1, 3, 2],
            "suffix": "aug7",
            "midi": [56, 64, 66, 72, 76],
            "capo": true
        }, {
            "barres": [3],
            "fingers": [2, 1, 3, 1, 4, 0],
            "midi": [44, 48, 54, 58, 63],
            "capo": true,
            "frets": [4, 3, 4, 3, 4, -1],
            "suffix": "9",
            "baseFret": 1,
            "key": "Ab"
        }, {
            "midi": [44, 51, 54, 60, 63, 70],
            "key": "Ab",
            "baseFret": 4,
            "frets": [1, 3, 1, 2, 1, 3],
            "suffix": "9",
            "barres": [1],
            "capo": true,
            "fingers": [1, 3, 1, 2, 1, 4]
        }, {
            "midi": [56, 60, 66, 70],
            "baseFret": 5,
            "fingers": [0, 0, 2, 1, 4, 3],
            "key": "Ab",
            "suffix": "9",
            "barres": [],
            "frets": [-1, -1, 2, 1, 3, 2]
        }, {
            "frets": [2, 2, 1, 2, 2, 2],
            "key": "Ab",
            "midi": [51, 56, 60, 66, 70, 75],
            "baseFret": 10,
            "fingers": [2, 2, 1, 3, 3, 4],
            "barres": [2],
            "suffix": "9"
        }, {
            "suffix": "9b5",
            "midi": [44, 48, 50, 58, 66],
            "barres": [],
            "frets": [4, 3, 0, 3, -1, 2],
            "fingers": [4, 2, 0, 3, 0, 1],
            "key": "Ab",
            "baseFret": 1
        }, {
            "capo": true,
            "key": "Ab",
            "frets": [4, 3, 4, 3, 3, 4],
            "baseFret": 1,
            "barres": [3],
            "fingers": [2, 1, 3, 1, 1, 4],
            "midi": [44, 48, 54, 58, 62, 68],
            "suffix": "9b5"
        }, {
            "suffix": "9b5",
            "barres": [1],
            "midi": [44, 50, 54, 60, 70],
            "frets": [1, 2, 1, 2, -1, 3],
            "fingers": [1, 2, 1, 3, 0, 4],
            "capo": true,
            "baseFret": 4,
            "key": "Ab"
        }, {
            "midi": [56, 60, 66, 70, 74],
            "barres": [1],
            "suffix": "9b5",
            "capo": true,
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 10,
            "frets": [-1, 2, 1, 2, 2, 1],
            "key": "Ab"
        }, {
            "capo": true,
            "barres": [1],
            "suffix": "aug9",
            "key": "Ab",
            "midi": [42, 46, 52, 56, 60, 66],
            "baseFret": 1,
            "fingers": [2, 1, 3, 1, 1, 4],
            "frets": [2, 1, 2, 1, 1, 2]
        }, {
            "midi": [44, 48, 54, 58, 64, 64],
            "baseFret": 3,
            "fingers": [2, 1, 3, 1, 4, 0],
            "suffix": "aug9",
            "barres": [1],
            "frets": [2, 1, 2, 1, 3, 0],
            "key": "Ab"
        }, {
            "barres": [],
            "midi": [54, 60, 64, 70],
            "key": "Ab",
            "baseFret": 4,
            "suffix": "aug9",
            "fingers": [0, 0, 1, 2, 3, 4],
            "frets": [-1, -1, 1, 2, 2, 3]
        }, {
            "suffix": "aug9",
            "key": "Ab",
            "fingers": [0, 2, 1, 3, 4, 0],
            "frets": [-1, 2, 1, 2, 2, 0],
            "barres": [],
            "baseFret": 10,
            "midi": [56, 60, 66, 70, 64]
        }, {
            "baseFret": 1,
            "suffix": "7b9",
            "fingers": [0, 0, 1, 1, 1, 2],
            "key": "Ab",
            "frets": [-1, 0, 1, 1, 1, 2],
            "barres": [1],
            "midi": [45, 51, 56, 60, 66]
        }, {
            "key": "Ab",
            "frets": [-1, -1, 1, 2, 1, 2],
            "midi": [54, 60, 63, 69],
            "barres": [1],
            "suffix": "7b9",
            "baseFret": 4,
            "fingers": [1, 0, 1, 2, 1, 3]
        }, {
            "fingers": [0, 0, 2, 1, 3, 1],
            "frets": [-1, -1, 2, 1, 3, 1],
            "capo": true,
            "key": "Ab",
            "suffix": "7b9",
            "baseFret": 5,
            "barres": [1],
            "midi": [56, 60, 66, 69]
        }, {
            "key": "Ab",
            "frets": [-1, 2, 1, 2, 1, 2],
            "barres": [1],
            "midi": [56, 60, 66, 69, 75],
            "suffix": "7b9",
            "capo": true,
            "baseFret": 10,
            "fingers": [0, 2, 1, 3, 1, 4]
        }, {
            "midi": [44, 48, 54, 59, 63, 68],
            "fingers": [2, 1, 3, 3, 3, 4],
            "frets": [4, 3, 4, 4, 4, 4],
            "suffix": "7#9",
            "barres": [4],
            "key": "Ab",
            "baseFret": 1
        }, {
            "baseFret": 4,
            "midi": [44, 51, 54, 60, 66, 71],
            "barres": [1, 4],
            "key": "Ab",
            "fingers": [1, 3, 1, 2, 4, 4],
            "frets": [1, 3, 1, 2, 4, 4],
            "capo": true,
            "suffix": "7#9"
        }, {
            "fingers": [0, 0, 3, 1, 4, 4],
            "baseFret": 5,
            "suffix": "7#9",
            "midi": [56, 60, 66, 71],
            "frets": [-1, -1, 2, 1, 3, 3],
            "key": "Ab",
            "barres": [3]
        }, {
            "fingers": [0, 2, 1, 3, 4, 0],
            "baseFret": 10,
            "midi": [56, 60, 66, 71],
            "key": "Ab",
            "suffix": "7#9",
            "barres": [],
            "frets": [-1, 2, 1, 2, 3, -1]
        }, {
            "frets": [1, 1, 1, 2, 1, 1],
            "barres": [1],
            "midi": [44, 49, 54, 60, 63, 68],
            "capo": true,
            "suffix": "11",
            "baseFret": 4,
            "key": "Ab",
            "fingers": [1, 1, 1, 2, 1, 1]
        }, {
            "frets": [1, 1, 1, 1, 2, 3],
            "baseFret": 6,
            "fingers": [1, 1, 1, 1, 2, 3],
            "midi": [46, 51, 56, 61, 66, 72],
            "key": "Ab",
            "capo": true,
            "suffix": "11",
            "barres": [1]
        }, {
            "barres": [1],
            "baseFret": 9,
            "suffix": "11",
            "capo": true,
            "fingers": [0, 3, 2, 4, 1, 1],
            "frets": [-1, 3, 2, 3, 1, 1],
            "midi": [56, 60, 66, 68, 73],
            "key": "Ab"
        }, {
            "baseFret": 11,
            "midi": [56, 61, 66, 72, 75],
            "barres": [1],
            "capo": true,
            "key": "Ab",
            "suffix": "11",
            "fingers": [0, 1, 1, 1, 3, 1],
            "frets": [-1, 1, 1, 1, 3, 1]
        }, {
            "key": "Ab",
            "midi": [44, 54, 60, 62],
            "barres": [],
            "frets": [2, -1, 2, 3, 1, -1],
            "baseFret": 3,
            "fingers": [2, 0, 3, 4, 1, 0],
            "suffix": "9#11"
        }, {
            "barres": [],
            "frets": [-1, -1, 1, 2, 2, 3],
            "midi": [56, 62, 66, 72],
            "key": "Ab",
            "baseFret": 6,
            "fingers": [0, 0, 1, 2, 3, 4],
            "suffix": "9#11"
        }, {
            "capo": true,
            "suffix": "9#11",
            "barres": [1],
            "frets": [-1, 2, 1, 2, 2, 1],
            "baseFret": 10,
            "key": "Ab",
            "midi": [56, 60, 66, 70, 74],
            "fingers": [0, 2, 1, 3, 4, 1]
        }, {
            "fingers": [0, 1, 2, 1, 3, 1],
            "barres": [1],
            "capo": true,
            "key": "Ab",
            "frets": [-1, 1, 2, 1, 3, 1],
            "baseFret": 11,
            "midi": [56, 62, 66, 72, 75],
            "suffix": "9#11"
        }, {
            "barres": [1],
            "midi": [44, 46, 53, 56, 60, 66],
            "capo": true,
            "frets": [4, 1, 3, 1, 1, 2],
            "suffix": "13",
            "fingers": [4, 1, 3, 1, 1, 2],
            "baseFret": 1,
            "key": "Ab"
        }, {
            "midi": [44, 51, 54, 60, 65, 68],
            "capo": true,
            "key": "Ab",
            "barres": [1],
            "frets": [1, 3, 1, 2, 3, 1],
            "baseFret": 4,
            "fingers": [1, 3, 1, 2, 4, 1],
            "suffix": "13"
        }, {
            "suffix": "13",
            "frets": [1, 1, 1, 2, 3, 3],
            "key": "Ab",
            "baseFret": 4,
            "fingers": [1, 1, 1, 2, 3, 4],
            "capo": true,
            "barres": [1],
            "midi": [44, 49, 54, 60, 65, 70]
        }, {
            "midi": [56, 60, 66, 72, 77],
            "baseFret": 10,
            "key": "Ab",
            "barres": [4],
            "suffix": "13",
            "fingers": [0, 2, 1, 3, 4, 4],
            "frets": [-1, 2, 1, 2, 4, 4]
        }, {
            "fingers": [1, 4, 2, 3, 1, 1],
            "frets": [1, 3, 2, 2, 1, 1],
            "capo": true,
            "barres": [1],
            "baseFret": 4,
            "midi": [44, 51, 55, 60, 63, 68],
            "suffix": "maj7",
            "key": "Ab"
        }, {
            "midi": [51, 56, 63, 67, 72],
            "capo": true,
            "frets": [-1, 1, 1, 3, 3, 3],
            "fingers": [0, 1, 1, 3, 3, 3],
            "key": "Ab",
            "barres": [1],
            "baseFret": 6,
            "suffix": "maj7"
        }, {
            "key": "Ab",
            "baseFret": 9,
            "midi": [56, 60, 67, 68],
            "frets": [-1, 3, 2, 4, 1, -1],
            "fingers": [0, 3, 2, 4, 1, 0],
            "suffix": "maj7",
            "barres": []
        }, {
            "suffix": "maj7",
            "barres": [1],
            "midi": [51, 56, 63, 67, 72, 75],
            "frets": [1, 1, 3, 2, 3, 1],
            "key": "Ab",
            "baseFret": 11,
            "fingers": [1, 1, 3, 2, 4, 1],
            "capo": true
        }, {
            "frets": [2, 1, 3, 3, 1, 1],
            "baseFret": 3,
            "key": "Ab",
            "barres": [1],
            "suffix": "maj7b5",
            "midi": [44, 48, 55, 60, 62, 67],
            "fingers": [2, 1, 3, 4, 1, 1],
            "capo": true
        }, {
            "baseFret": 4,
            "key": "Ab",
            "barres": [],
            "suffix": "maj7b5",
            "midi": [44, 50, 55, 60],
            "fingers": [1, 2, 3, 4, 0, 0],
            "frets": [1, 2, 2, 2, -1, -1]
        }, {
            "key": "Ab",
            "capo": true,
            "barres": [3],
            "midi": [40, 45, 56, 62, 67, 72],
            "fingers": [0, 0, 1, 2, 3, 4],
            "frets": [0, 0, 1, 2, 3, 3],
            "baseFret": 6,
            "suffix": "maj7b5"
        }, {
            "midi": [56, 62, 67, 72],
            "suffix": "maj7b5",
            "frets": [-1, 1, 2, 2, 3, -1],
            "barres": [2],
            "baseFret": 11,
            "fingers": [0, 1, 2, 2, 4, 0],
            "key": "Ab"
        }, {
            "barres": [],
            "fingers": [4, 3, 2, 0, 1, 0],
            "frets": [4, 3, 2, 0, 1, 0],
            "baseFret": 1,
            "suffix": "maj7#5",
            "key": "Ab",
            "midi": [44, 48, 52, 55, 60, 64]
        }, {
            "suffix": "maj7#5",
            "barres": [],
            "baseFret": 3,
            "fingers": [2, 1, 3, 0, 4, 0],
            "midi": [44, 48, 55, 55, 64, 64],
            "key": "Ab",
            "frets": [2, 1, 3, 0, 3, 0]
        }, {
            "key": "Ab",
            "baseFret": 8,
            "frets": [1, 4, 3, 2, 1, 1],
            "barres": [1],
            "fingers": [1, 4, 3, 2, 1, 1],
            "midi": [48, 56, 60, 64, 67, 72],
            "suffix": "maj7#5",
            "capo": true
        }, {
            "barres": [],
            "key": "Ab",
            "fingers": [0, 1, 4, 2, 3, 0],
            "baseFret": 11,
            "frets": [-1, 1, 4, 2, 3, -1],
            "suffix": "maj7#5",
            "midi": [56, 64, 67, 72]
        }, {
            "frets": [-1, 1, 1, 1, 1, 3],
            "baseFret": 1,
            "fingers": [0, 1, 1, 1, 1, 4],
            "barres": [1],
            "suffix": "maj9",
            "capo": true,
            "key": "Ab",
            "midi": [46, 51, 56, 60, 67]
        }, {
            "suffix": "maj9",
            "key": "Ab",
            "barres": [1],
            "capo": true,
            "baseFret": 3,
            "frets": [2, 1, 3, 1, 2, 1],
            "fingers": [2, 1, 4, 1, 3, 1],
            "midi": [44, 48, 55, 58, 63, 67]
        }, {
            "midi": [44, 51, 55, 60, 63, 70],
            "key": "Ab",
            "suffix": "maj9",
            "baseFret": 4,
            "barres": [1],
            "fingers": [1, 3, 2, 2, 1, 4],
            "frets": [1, 3, 2, 2, 1, 3],
            "capo": true
        }, {
            "midi": [51, 56, 60, 67, 70],
            "barres": [2],
            "frets": [2, 2, 1, 3, 2, -1],
            "baseFret": 10,
            "suffix": "maj9",
            "fingers": [2, 2, 1, 4, 3, 0],
            "key": "Ab"
        }, {
            "frets": [4, 3, 1, 0, 2, -1],
            "key": "Ab",
            "baseFret": 1,
            "midi": [44, 48, 51, 55, 61],
            "fingers": [4, 3, 1, 0, 2, 0],
            "barres": [],
            "suffix": "maj11"
        }, {
            "barres": [1],
            "frets": [1, 1, 2, 2, 1, 1],
            "fingers": [1, 1, 2, 3, 1, 1],
            "midi": [44, 49, 55, 60, 63, 68],
            "suffix": "maj11",
            "capo": true,
            "baseFret": 4,
            "key": "Ab"
        }, {
            "capo": true,
            "barres": [1],
            "frets": [-1, -1, 1, 1, 3, 3],
            "key": "Ab",
            "fingers": [0, 0, 1, 1, 3, 4],
            "suffix": "maj11",
            "baseFret": 6,
            "midi": [56, 61, 67, 72]
        }, {
            "key": "Ab",
            "fingers": [1, 1, 1, 2, 3, 1],
            "suffix": "maj11",
            "frets": [1, 1, 1, 2, 3, 1],
            "midi": [51, 56, 61, 67, 72, 75],
            "capo": true,
            "barres": [1],
            "baseFret": 11
        }, {
            "baseFret": 1,
            "suffix": "maj13",
            "capo": true,
            "barres": [3],
            "fingers": [2, 1, 1, 1, 3, 1],
            "frets": [4, 3, 3, 3, 4, 3],
            "midi": [44, 48, 53, 58, 63, 67],
            "key": "Ab"
        }, {
            "baseFret": 4,
            "suffix": "maj13",
            "fingers": [1, 1, 2, 3, 4, 1],
            "barres": [1],
            "midi": [44, 49, 55, 60, 65, 68],
            "frets": [1, 1, 2, 2, 3, 1],
            "capo": true,
            "key": "Ab"
        }, {
            "suffix": "maj13",
            "baseFret": 8,
            "midi": [56, 60, 65, 67, 72],
            "fingers": [0, 4, 2, 3, 1, 1],
            "key": "Ab",
            "capo": true,
            "frets": [-1, 4, 3, 3, 1, 1],
            "barres": [1]
        }, {
            "midi": [56, 61, 67, 72, 77],
            "baseFret": 11,
            "barres": [1],
            "key": "Ab",
            "fingers": [0, 1, 1, 2, 3, 4],
            "frets": [-1, 1, 1, 2, 3, 3],
            "capo": true,
            "suffix": "maj13"
        }, {
            "fingers": [2, 0, 1, 3, 4, 0],
            "key": "Ab",
            "baseFret": 1,
            "midi": [44, 53, 59, 63],
            "barres": [],
            "frets": [4, -1, 3, 4, 4, -1],
            "suffix": "m6"
        }, {
            "capo": true,
            "key": "Ab",
            "suffix": "m6",
            "midi": [44, 51, 56, 59, 65, 68],
            "barres": [1],
            "frets": [1, 3, 3, 1, 3, 1],
            "baseFret": 4,
            "fingers": [1, 2, 3, 1, 4, 1]
        }, {
            "barres": [1],
            "baseFret": 6,
            "frets": [-1, 1, 1, 3, 1, 2],
            "capo": true,
            "midi": [51, 56, 63, 65, 71],
            "suffix": "m6",
            "fingers": [0, 1, 1, 3, 1, 2],
            "key": "Ab"
        }, {
            "suffix": "m6",
            "barres": [1],
            "midi": [56, 59, 65, 68, 75],
            "baseFret": 9,
            "frets": [-1, 3, 1, 2, 1, 3],
            "capo": true,
            "fingers": [0, 3, 1, 2, 1, 4],
            "key": "Ab"
        }, {
            "barres": [1],
            "suffix": "m7",
            "midi": [44, 51, 54, 59, 63, 68],
            "fingers": [1, 3, 1, 1, 1, 1],
            "frets": [1, 3, 1, 1, 1, 1],
            "baseFret": 4,
            "capo": true,
            "key": "Ab"
        }, {
            "baseFret": 6,
            "midi": [51, 56, 63, 66, 71],
            "key": "Ab",
            "frets": [-1, 1, 1, 3, 2, 2],
            "suffix": "m7",
            "fingers": [0, 1, 1, 4, 2, 3],
            "capo": true,
            "barres": [1]
        }, {
            "barres": [1],
            "fingers": [0, 2, 1, 3, 1, 0],
            "baseFret": 9,
            "key": "Ab",
            "suffix": "m7",
            "frets": [-1, 3, 1, 3, 1, -1],
            "midi": [56, 59, 66, 68],
            "capo": true
        }, {
            "barres": [1],
            "suffix": "m7",
            "baseFret": 11,
            "frets": [1, 1, 3, 1, 2, 1],
            "capo": true,
            "fingers": [1, 1, 3, 1, 2, 1],
            "key": "Ab",
            "midi": [51, 56, 63, 66, 71, 75]
        }, {
            "frets": [-1, -1, 0, 1, 0, 2],
            "fingers": [0, 0, 0, 1, 0, 3],
            "midi": [50, 56, 59, 66],
            "key": "Ab",
            "suffix": "m7b5",
            "barres": [],
            "baseFret": 1
        }, {
            "midi": [44, 54, 59, 62],
            "suffix": "m7b5",
            "barres": [],
            "fingers": [2, 0, 3, 4, 1, 0],
            "key": "Ab",
            "frets": [4, -1, 4, 4, 3, -1],
            "baseFret": 1
        }, {
            "fingers": [0, 0, 1, 2, 2, 2],
            "midi": [56, 62, 66, 71],
            "key": "Ab",
            "baseFret": 6,
            "barres": [2],
            "suffix": "m7b5",
            "frets": [-1, -1, 1, 2, 2, 2]
        }, {
            "barres": [],
            "suffix": "m7b5",
            "key": "Ab",
            "baseFret": 11,
            "frets": [-1, 1, 2, 1, 2, -1],
            "fingers": [0, 1, 3, 2, 4, 0],
            "midi": [56, 62, 66, 71]
        }, {
            "frets": [4, 1, 1, 1, 0, 2],
            "fingers": [4, 1, 1, 2, 0, 3],
            "midi": [44, 46, 51, 56, 59, 66],
            "suffix": "m9",
            "key": "Ab",
            "baseFret": 1,
            "barres": [1]
        }, {
            "barres": [1],
            "key": "Ab",
            "fingers": [1, 3, 1, 1, 1, 4],
            "midi": [44, 51, 54, 59, 63, 70],
            "frets": [1, 3, 1, 1, 1, 3],
            "baseFret": 4,
            "suffix": "m9",
            "capo": true
        }, {
            "key": "Ab",
            "suffix": "m9",
            "midi": [47, 54, 58, 63, 68, 71],
            "barres": [2],
            "fingers": [1, 3, 2, 2, 4, 1],
            "baseFret": 7,
            "frets": [1, 3, 2, 2, 3, 1]
        }, {
            "barres": [3],
            "key": "Ab",
            "frets": [-1, 3, 1, 3, 3, 3],
            "suffix": "m9",
            "baseFret": 9,
            "fingers": [0, 2, 1, 3, 4, 4],
            "midi": [56, 59, 66, 70, 75]
        }, {
            "fingers": [2, 0, 1, 3, 3, 4],
            "baseFret": 3,
            "midi": [44, 53, 59, 63, 70],
            "frets": [2, -1, 1, 2, 2, 4],
            "suffix": "m6/9",
            "key": "Ab",
            "barres": [2]
        }, {
            "midi": [44, 51, 56, 59, 65, 70],
            "capo": true,
            "barres": [1, 3],
            "suffix": "m6/9",
            "baseFret": 4,
            "fingers": [1, 2, 2, 1, 3, 4],
            "frets": [1, 3, 3, 1, 3, 3],
            "key": "Ab"
        }, {
            "fingers": [2, 1, 1, 3, 1, 1],
            "barres": [1],
            "key": "Ab",
            "frets": [2, 1, 1, 3, 1, 1],
            "baseFret": 6,
            "suffix": "m6/9",
            "capo": true,
            "midi": [47, 51, 56, 63, 65, 70]
        }, {
            "frets": [-1, 3, 1, 2, 3, 3],
            "key": "Ab",
            "fingers": [0, 3, 1, 2, 4, 4],
            "suffix": "m6/9",
            "barres": [3],
            "baseFret": 9,
            "midi": [56, 59, 65, 70, 75]
        }, {
            "key": "Ab",
            "barres": [2],
            "frets": [4, 2, 4, 3, 2, 2],
            "midi": [44, 47, 54, 58, 61, 66],
            "fingers": [3, 1, 4, 2, 1, 1],
            "capo": true,
            "baseFret": 1,
            "suffix": "m11"
        }, {
            "baseFret": 4,
            "fingers": [1, 1, 1, 1, 1, 4],
            "barres": [1],
            "midi": [44, 49, 54, 59, 63, 70],
            "capo": true,
            "suffix": "m11",
            "frets": [1, 1, 1, 1, 1, 3],
            "key": "Ab"
        }, {
            "capo": true,
            "midi": [56, 61, 66, 71],
            "fingers": [0, 0, 1, 1, 2, 3],
            "suffix": "m11",
            "frets": [-1, -1, 1, 1, 2, 2],
            "baseFret": 6,
            "key": "Ab",
            "barres": [1]
        }, {
            "baseFret": 9,
            "capo": true,
            "key": "Ab",
            "frets": [-1, 3, 1, 3, 3, 1],
            "barres": [1],
            "midi": [56, 59, 66, 70, 73],
            "fingers": [0, 3, 1, 3, 4, 1],
            "suffix": "m11"
        }, {
            "frets": [-1, 2, 1, 1, 4, 3],
            "baseFret": 1,
            "key": "Ab",
            "barres": [1],
            "capo": true,
            "fingers": [0, 2, 1, 1, 4, 3],
            "suffix": "mmaj7",
            "midi": [47, 51, 56, 63, 67]
        }, {
            "frets": [1, 3, 2, 1, 1, 1],
            "barres": [1],
            "fingers": [1, 3, 2, 1, 1, 1],
            "midi": [44, 51, 55, 59, 63, 68],
            "key": "Ab",
            "baseFret": 4,
            "capo": true,
            "suffix": "mmaj7"
        }, {
            "suffix": "mmaj7",
            "key": "Ab",
            "midi": [51, 56, 63, 67, 71],
            "frets": [-1, 1, 1, 3, 3, 2],
            "capo": true,
            "baseFret": 6,
            "barres": [1],
            "fingers": [0, 1, 1, 3, 4, 2]
        }, {
            "key": "Ab",
            "baseFret": 11,
            "fingers": [0, 1, 4, 2, 3, 1],
            "suffix": "mmaj7",
            "frets": [-1, 1, 3, 2, 2, 1],
            "capo": true,
            "barres": [1],
            "midi": [56, 63, 67, 71, 75]
        }, {
            "suffix": "mmaj7b5",
            "barres": [1],
            "midi": [44, 50, 55, 59, 68],
            "key": "Ab",
            "capo": true,
            "fingers": [1, 2, 3, 1, 0, 1],
            "frets": [1, 2, 2, 1, -1, 1],
            "baseFret": 4
        }, {
            "key": "Ab",
            "suffix": "mmaj7b5",
            "barres": [],
            "baseFret": 6,
            "fingers": [0, 0, 1, 2, 4, 3],
            "midi": [56, 62, 67, 71],
            "frets": [-1, -1, 1, 2, 3, 2]
        }, {
            "key": "Ab",
            "baseFret": 10,
            "barres": [3],
            "frets": [1, 2, 3, 3, 3, -1],
            "midi": [50, 56, 62, 67, 71],
            "fingers": [1, 2, 3, 3, 3, 0],
            "suffix": "mmaj7b5"
        }, {
            "baseFret": 11,
            "barres": [],
            "frets": [-1, 1, 2, 2, 2, -1],
            "fingers": [0, 1, 2, 3, 4, 0],
            "suffix": "mmaj7b5",
            "midi": [56, 62, 67, 71],
            "key": "Ab"
        }, {
            "fingers": [2, 0, 4, 1, 0, 3],
            "key": "Ab",
            "suffix": "mmaj9",
            "frets": [2, -1, 3, 1, 0, 2],
            "midi": [44, 55, 58, 59, 68],
            "barres": [],
            "baseFret": 3
        }, {
            "key": "Ab",
            "suffix": "mmaj9",
            "barres": [1],
            "baseFret": 4,
            "fingers": [1, 3, 2, 1, 1, 4],
            "capo": true,
            "midi": [44, 51, 55, 59, 63, 70],
            "frets": [1, 3, 2, 1, 1, 3]
        }, {
            "frets": [1, 1, 1, 3, 3, 2],
            "barres": [1],
            "midi": [46, 51, 56, 63, 67, 71],
            "key": "Ab",
            "suffix": "mmaj9",
            "capo": true,
            "fingers": [1, 1, 1, 3, 4, 2],
            "baseFret": 6
        }, {
            "suffix": "mmaj9",
            "key": "Ab",
            "fingers": [0, 2, 1, 4, 3, 0],
            "frets": [-1, 3, 1, 4, 3, -1],
            "midi": [56, 59, 67, 70],
            "baseFret": 9,
            "barres": []
        }, {
            "baseFret": 4,
            "fingers": [1, 1, 2, 1, 1, 4],
            "barres": [1],
            "capo": true,
            "frets": [1, 1, 2, 1, 1, 3],
            "suffix": "mmaj11",
            "key": "Ab",
            "midi": [44, 49, 55, 59, 63, 70]
        }, {
            "key": "Ab",
            "barres": [1],
            "frets": [-1, 1, 1, 1, 3, 2],
            "capo": true,
            "fingers": [0, 1, 1, 1, 3, 2],
            "suffix": "mmaj11",
            "midi": [51, 56, 61, 67, 71],
            "baseFret": 6
        }, {
            "baseFret": 9,
            "suffix": "mmaj11",
            "key": "Ab",
            "barres": [1],
            "fingers": [0, 2, 1, 4, 3, 1],
            "capo": true,
            "frets": [-1, 3, 1, 4, 3, 1],
            "midi": [56, 59, 67, 70, 73]
        }, {
            "fingers": [1, 1, 1, 2, 3, 1],
            "midi": [51, 56, 61, 67, 71, 75],
            "suffix": "mmaj11",
            "key": "Ab",
            "frets": [1, 1, 1, 2, 2, 1],
            "barres": [1],
            "baseFret": 11,
            "capo": true
        }, {
            "key": "Ab",
            "barres": [],
            "frets": [4, 3, -1, 3, 4, -1],
            "midi": [44, 48, 58, 63],
            "baseFret": 1,
            "fingers": [3, 1, 0, 2, 4, 0],
            "suffix": "add9"
        }, {
            "baseFret": 4,
            "frets": [-1, -1, 3, 2, 1, 3],
            "key": "Ab",
            "fingers": [0, 0, 3, 2, 1, 4],
            "suffix": "add9",
            "midi": [56, 60, 63, 70],
            "barres": []
        }, {
            "capo": true,
            "key": "Ab",
            "frets": [-1, 4, 3, 1, 4, 1],
            "suffix": "add9",
            "baseFret": 8,
            "fingers": [0, 3, 2, 1, 4, 1],
            "midi": [56, 60, 63, 70, 72],
            "barres": [1]
        }, {
            "fingers": [0, 2, 1, 0, 3, 4],
            "frets": [-1, 2, 1, -1, 2, 2],
            "key": "Ab",
            "baseFret": 10,
            "barres": [],
            "midi": [56, 60, 70, 75],
            "suffix": "add9"
        }, {
            "fingers": [3, 1, 0, 2, 4, 0],
            "suffix": "madd9",
            "key": "Ab",
            "frets": [4, 2, -1, 3, 4, -1],
            "baseFret": 1,
            "midi": [44, 47, 58, 63],
            "barres": []
        }, {
            "barres": [1],
            "capo": true,
            "key": "Ab",
            "fingers": [0, 0, 3, 1, 1, 4],
            "baseFret": 4,
            "midi": [56, 59, 63, 70],
            "suffix": "madd9",
            "frets": [-1, -1, 3, 1, 1, 3]
        }, {
            "key": "Ab",
            "suffix": "madd9",
            "capo": true,
            "midi": [44, 51, 56, 59, 63, 70],
            "frets": [1, 3, 3, 1, 1, 3],
            "barres": [1],
            "baseFret": 4,
            "fingers": [1, 2, 3, 1, 1, 4]
        }, {
            "fingers": [0, 3, 2, 1, 4, 0],
            "suffix": "madd9",
            "frets": [-1, 4, 2, 1, 4, -1],
            "key": "Ab",
            "midi": [56, 59, 63, 70],
            "baseFret": 8,
            "barres": []
        }, {
            "fingers": [0, 0, 1, 2, 3, 0],
            "frets": [-1, 0, 2, 2, 2, 0],
            "suffix": "major",
            "key": "A",
            "barres": [],
            "baseFret": 1,
            "midi": [45, 52, 57, 61, 64]
        }, {
            "midi": [45, 52, 57, 61, 69],
            "baseFret": 2,
            "capo": true,
            "suffix": "major",
            "barres": [1],
            "key": "A",
            "frets": [-1, 0, 1, 1, 1, 4],
            "fingers": [0, 0, 1, 1, 1, 4]
        }, {
            "key": "A",
            "frets": [1, 3, 3, 2, 1, 1],
            "fingers": [1, 3, 4, 2, 1, 1],
            "baseFret": 5,
            "suffix": "major",
            "barres": [1],
            "midi": [45, 52, 57, 61, 64, 69],
            "capo": true
        }, {
            "midi": [45, 57, 64, 69, 73],
            "barres": [],
            "suffix": "major",
            "key": "A",
            "frets": [-1, 0, 1, 3, 4, 3],
            "baseFret": 7,
            "fingers": [0, 0, 1, 2, 4, 3]
        }, {
            "fingers": [0, 0, 2, 3, 1, 0],
            "barres": [],
            "midi": [45, 52, 57, 60, 64],
            "frets": [-1, 0, 2, 2, 1, 0],
            "suffix": "minor",
            "key": "A",
            "baseFret": 1
        }, {
            "barres": [4],
            "fingers": [0, 0, 1, 4, 4, 4],
            "capo": true,
            "suffix": "minor",
            "midi": [45, 52, 60, 64, 69],
            "key": "A",
            "baseFret": 2,
            "frets": [-1, 0, 1, 4, 4, 4]
        }, {
            "baseFret": 5,
            "capo": true,
            "key": "A",
            "frets": [1, 3, 3, 1, 1, 1],
            "barres": [1],
            "midi": [45, 52, 57, 60, 64, 69],
            "suffix": "minor",
            "fingers": [1, 3, 4, 1, 1, 1]
        }, {
            "midi": [45, 57, 64, 69, 72],
            "barres": [],
            "baseFret": 7,
            "suffix": "minor",
            "key": "A",
            "frets": [-1, 0, 1, 3, 4, 2],
            "fingers": [0, 0, 1, 3, 4, 2]
        }, {
            "midi": [45, 51, 57, 60],
            "baseFret": 1,
            "fingers": [0, 0, 1, 3, 2, 0],
            "key": "A",
            "frets": [-1, 0, 1, 2, 1, -1],
            "suffix": "dim",
            "barres": []
        }, {
            "midi": [45, 48, 59, 62],
            "key": "A",
            "fingers": [3, 1, 0, 4, 2, 0],
            "baseFret": 3,
            "suffix": "dim",
            "frets": [3, 1, -1, 2, 1, -1],
            "barres": []
        }, {
            "key": "A",
            "frets": [-1, -1, 1, 2, -1, 2],
            "barres": [],
            "fingers": [0, 0, 1, 2, 0, 3],
            "midi": [57, 63, 72],
            "baseFret": 7,
            "suffix": "dim"
        }, {
            "key": "A",
            "barres": [],
            "fingers": [0, 4, 1, 0, 2, 3],
            "frets": [-1, 3, 1, -1, 1, 2],
            "midi": [57, 60, 69, 75],
            "baseFret": 10,
            "suffix": "dim"
        }, {
            "barres": [],
            "key": "A",
            "suffix": "dim7",
            "midi": [45, 51, 57, 60, 66],
            "frets": [-1, 0, 1, 2, 1, 2],
            "fingers": [0, 0, 1, 3, 2, 4],
            "baseFret": 1
        }, {
            "baseFret": 4,
            "frets": [2, -1, 1, 2, 1, -1],
            "suffix": "dim7",
            "midi": [45, 54, 60, 63],
            "barres": [1],
            "fingers": [2, 0, 1, 3, 1, 0],
            "capo": true,
            "key": "A"
        }, {
            "fingers": [1, 2, 3, 1, 4, 1],
            "baseFret": 5,
            "capo": true,
            "suffix": "dim7",
            "barres": [1],
            "key": "A",
            "frets": [1, 2, 3, 1, 3, 1],
            "midi": [45, 51, 57, 60, 66, 69]
        }, {
            "frets": [-1, 0, 1, 2, 1, 2],
            "fingers": [0, 0, 1, 3, 2, 4],
            "suffix": "dim7",
            "midi": [45, 57, 63, 66, 72],
            "barres": [1],
            "key": "A",
            "baseFret": 7
        }, {
            "barres": [],
            "suffix": "sus2",
            "fingers": [0, 0, 2, 3, 0, 0],
            "midi": [45, 52, 57, 59, 64],
            "baseFret": 1,
            "frets": [-1, 0, 2, 2, 0, 0],
            "key": "A"
        }, {
            "frets": [-1, 0, 2, 4, 0, 0],
            "fingers": [0, 0, 1, 4, 0, 0],
            "baseFret": 1,
            "barres": [],
            "midi": [45, 52, 59, 59, 64],
            "key": "A",
            "suffix": "sus2"
        }, {
            "capo": true,
            "baseFret": 7,
            "barres": [1],
            "fingers": [1, 1, 1, 3, 4, 1],
            "suffix": "sus2",
            "midi": [47, 52, 57, 64, 69, 71],
            "key": "A",
            "frets": [1, 1, 1, 3, 4, 1]
        }, {
            "baseFret": 9,
            "frets": [-1, 0, 1, 1, 0, 0],
            "barres": [],
            "suffix": "sus2",
            "key": "A",
            "midi": [45, 59, 64, 59, 64],
            "fingers": [0, 0, 1, 2, 0, 0]
        }, {
            "fingers": [0, 0, 1, 2, 3, 0],
            "suffix": "sus4",
            "baseFret": 1,
            "key": "A",
            "midi": [45, 52, 57, 62, 64],
            "barres": [],
            "frets": [-1, 0, 2, 2, 3, 0]
        }, {
            "frets": [-1, 0, 0, -1, 3, 0],
            "suffix": "sus4",
            "barres": [],
            "baseFret": 1,
            "fingers": [0, 0, 0, 0, 1, 0],
            "midi": [45, 50, 62, 64],
            "key": "A"
        }, {
            "key": "A",
            "midi": [45, 52, 57, 62, 64, 69],
            "suffix": "sus4",
            "capo": true,
            "baseFret": 5,
            "frets": [1, 3, 3, 3, 1, 1],
            "fingers": [1, 3, 3, 4, 1, 1],
            "barres": [1, 3]
        }, {
            "midi": [52, 57, 64, 69, 74],
            "frets": [-1, 1, 1, 3, 4, 4],
            "suffix": "sus4",
            "fingers": [0, 1, 1, 2, 3, 4],
            "key": "A",
            "capo": true,
            "barres": [1],
            "baseFret": 7
        }, {
            "fingers": [0, 0, 2, 0, 3, 0],
            "key": "A",
            "midi": [45, 52, 55, 62, 64],
            "suffix": "7sus4",
            "barres": [],
            "frets": [-1, 0, 2, 0, 3, 0],
            "baseFret": 1
        }, {
            "suffix": "7sus4",
            "baseFret": 5,
            "fingers": [1, 3, 1, 4, 1, 1],
            "barres": [1],
            "capo": true,
            "frets": [1, 3, 1, 3, 1, 1],
            "midi": [45, 52, 55, 62, 64, 69],
            "key": "A"
        }, {
            "barres": [],
            "baseFret": 7,
            "key": "A",
            "frets": [-1, 0, 1, 3, 2, 4],
            "fingers": [0, 0, 1, 3, 2, 4],
            "midi": [45, 57, 64, 67, 74],
            "suffix": "7sus4"
        }, {
            "barres": [1],
            "baseFret": 10,
            "fingers": [0, 2, 3, 4, 1, 1],
            "key": "A",
            "suffix": "7sus4",
            "midi": [57, 62, 67, 69, 74],
            "frets": [-1, 3, 3, 3, 1, 1],
            "capo": true
        }, {
            "baseFret": 1,
            "barres": [],
            "frets": [-1, 0, 1, 2, 2, -1],
            "midi": [45, 51, 57, 61],
            "suffix": "alt",
            "fingers": [0, 0, 1, 2, 3, 0],
            "key": "A"
        }, {
            "barres": [],
            "baseFret": 4,
            "fingers": [0, 0, 4, 3, 1, 2],
            "key": "A",
            "suffix": "alt",
            "midi": [45, 57, 61, 63, 69],
            "frets": [-1, 0, 4, 3, 1, 2]
        }, {
            "suffix": "alt",
            "frets": [-1, 0, 4, 1, 3, 2],
            "key": "A",
            "barres": [],
            "fingers": [0, 0, 4, 1, 3, 2],
            "midi": [45, 61, 63, 69, 73],
            "baseFret": 8
        }, {
            "baseFret": 12,
            "barres": [],
            "key": "A",
            "midi": [57, 63, 69, 73],
            "frets": [-1, 1, 2, 3, 3, -1],
            "suffix": "alt",
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "baseFret": 1,
            "frets": [-1, 0, 3, 2, 2, 1],
            "midi": [45, 53, 57, 61, 65],
            "fingers": [0, 0, 4, 2, 3, 1],
            "suffix": "aug",
            "key": "A",
            "barres": []
        }, {
            "capo": true,
            "midi": [45, 49, 53, 57, 61],
            "barres": [1],
            "frets": [4, 3, 2, 1, 1, -1],
            "key": "A",
            "fingers": [4, 3, 2, 1, 1, 0],
            "suffix": "aug",
            "baseFret": 2
        }, {
            "baseFret": 5,
            "fingers": [1, 0, 4, 2, 3, 1],
            "barres": [1],
            "capo": true,
            "suffix": "aug",
            "frets": [1, -1, 3, 2, 2, 1],
            "midi": [45, 57, 61, 65, 69],
            "key": "A"
        }, {
            "midi": [57, 61, 65, 69],
            "capo": true,
            "suffix": "aug",
            "frets": [-1, 3, 2, 1, 1, -1],
            "baseFret": 10,
            "fingers": [0, 3, 2, 1, 1, 0],
            "barres": [1],
            "key": "A"
        }, {
            "key": "A",
            "baseFret": 1,
            "frets": [-1, 0, 2, 2, 2, 2],
            "barres": [2],
            "suffix": "6",
            "fingers": [0, 0, 1, 1, 1, 1],
            "midi": [45, 52, 57, 61, 66]
        }, {
            "suffix": "6",
            "fingers": [2, 0, 1, 4, 3, 0],
            "barres": [],
            "baseFret": 4,
            "frets": [2, -1, 1, 3, 2, -1],
            "midi": [45, 54, 61, 64],
            "key": "A"
        }, {
            "fingers": [1, 3, 0, 2, 4, 1],
            "capo": true,
            "baseFret": 5,
            "barres": [1],
            "suffix": "6",
            "frets": [1, 3, -1, 2, 3, 1],
            "midi": [45, 52, 61, 66, 69],
            "key": "A"
        }, {
            "baseFret": 10,
            "barres": [],
            "fingers": [0, 4, 2, 3, 1, 0],
            "suffix": "6",
            "key": "A",
            "frets": [-1, 3, 2, 2, 1, -1],
            "midi": [57, 61, 66, 69]
        }, {
            "midi": [45, 54, 59, 61, 66],
            "fingers": [0, 0, 3, 4, 1, 1],
            "frets": [-1, 0, 4, 4, 2, 2],
            "barres": [2],
            "key": "A",
            "suffix": "6/9",
            "baseFret": 1
        }, {
            "frets": [2, 1, 1, 1, 2, 2],
            "baseFret": 4,
            "key": "A",
            "suffix": "6/9",
            "fingers": [2, 1, 1, 1, 3, 4],
            "barres": [1],
            "capo": true,
            "midi": [45, 49, 54, 59, 64, 69]
        }, {
            "fingers": [0, 2, 2, 1, 3, 4],
            "midi": [52, 57, 61, 66, 71],
            "frets": [-1, 2, 2, 1, 2, 2],
            "barres": [2],
            "key": "A",
            "capo": true,
            "baseFret": 6,
            "suffix": "6/9"
        }, {
            "baseFret": 11,
            "barres": [1],
            "capo": true,
            "frets": [-1, 2, 1, 1, 2, 2],
            "fingers": [0, 2, 1, 1, 3, 4],
            "key": "A",
            "midi": [57, 61, 66, 71, 76],
            "suffix": "6/9"
        }, {
            "barres": [],
            "baseFret": 1,
            "key": "A",
            "frets": [-1, 0, 2, 0, 2, 0],
            "suffix": "7",
            "midi": [45, 52, 55, 61, 64],
            "fingers": [0, 0, 2, 0, 3, 0]
        }, {
            "key": "A",
            "midi": [45, 52, 57, 61, 67],
            "capo": true,
            "fingers": [0, 0, 1, 1, 1, 2],
            "barres": [2],
            "frets": [-1, 0, 2, 2, 2, 3],
            "baseFret": 1,
            "suffix": "7"
        }, {
            "capo": true,
            "key": "A",
            "suffix": "7",
            "baseFret": 5,
            "barres": [1],
            "fingers": [1, 3, 1, 2, 1, 1],
            "midi": [45, 52, 55, 61, 64, 69],
            "frets": [1, 3, 1, 2, 1, 1]
        }, {
            "frets": [-1, 0, 1, 3, 2, 3],
            "baseFret": 7,
            "fingers": [0, 0, 1, 3, 2, 4],
            "midi": [45, 57, 64, 67, 73],
            "key": "A",
            "barres": [],
            "suffix": "7"
        }, {
            "baseFret": 1,
            "key": "A",
            "frets": [-1, 0, 1, 2, 2, 3],
            "midi": [45, 51, 57, 61, 67],
            "fingers": [0, 0, 1, 2, 3, 4],
            "barres": [],
            "suffix": "7b5"
        }, {
            "suffix": "7b5",
            "barres": [],
            "frets": [-1, 0, 2, 3, 1, 2],
            "key": "A",
            "fingers": [0, 0, 2, 4, 1, 3],
            "baseFret": 4,
            "midi": [45, 55, 61, 63, 69]
        }, {
            "key": "A",
            "barres": [],
            "midi": [57, 63, 67, 73],
            "baseFret": 7,
            "suffix": "7b5",
            "frets": [-1, -1, 1, 2, 2, 3],
            "fingers": [0, 0, 1, 2, 3, 4]
        }, {
            "key": "A",
            "fingers": [0, 1, 2, 4, 1, 3],
            "barres": [1],
            "frets": [-1, 1, 2, 3, 1, 2],
            "baseFret": 10,
            "suffix": "7b5",
            "capo": true,
            "midi": [55, 61, 67, 69, 75]
        }, {
            "midi": [45, 53, 55, 61, 65],
            "frets": [-1, 0, 3, 0, 2, 1],
            "fingers": [0, 0, 3, 0, 2, 1],
            "key": "A",
            "baseFret": 1,
            "suffix": "aug7",
            "barres": []
        }, {
            "barres": [2],
            "fingers": [0, 0, 2, 1, 1, 3],
            "midi": [45, 53, 57, 61, 67],
            "baseFret": 1,
            "frets": [-1, 0, 3, 2, 2, 3],
            "suffix": "aug7",
            "key": "A"
        }, {
            "suffix": "aug7",
            "frets": [-1, 0, 1, 2, 2, 1],
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 1, 2, 3, 1],
            "key": "A",
            "baseFret": 5,
            "midi": [45, 55, 61, 65, 69]
        }, {
            "fingers": [0, 0, 1, 4, 2, 3],
            "midi": [57, 65, 67, 73],
            "suffix": "aug7",
            "baseFret": 7,
            "key": "A",
            "frets": [-1, -1, 1, 4, 2, 3],
            "barres": []
        }, {
            "baseFret": 2,
            "suffix": "9",
            "fingers": [4, 3, 1, 0, 0, 0],
            "key": "A",
            "midi": [45, 49, 52, 55, 59, 64],
            "frets": [4, 3, 1, 0, 0, 0],
            "barres": []
        }, {
            "barres": [2],
            "fingers": [0, 0, 1, 3, 1, 2],
            "baseFret": 1,
            "key": "A",
            "suffix": "9",
            "frets": [-1, 0, 2, 4, 2, 3],
            "midi": [45, 52, 59, 61, 67]
        }, {
            "midi": [45, 52, 55, 61, 64, 71],
            "key": "A",
            "frets": [1, 3, 1, 2, 1, 3],
            "capo": true,
            "fingers": [1, 3, 1, 2, 1, 4],
            "baseFret": 5,
            "barres": [1],
            "suffix": "9"
        }, {
            "fingers": [0, 2, 1, 3, 3, 3],
            "frets": [-1, 2, 1, 2, 2, 2],
            "baseFret": 11,
            "key": "A",
            "midi": [57, 61, 67, 71, 76],
            "barres": [2],
            "suffix": "9"
        }, {
            "fingers": [0, 0, 1, 4, 2, 3],
            "barres": [],
            "baseFret": 1,
            "key": "A",
            "midi": [45, 51, 59, 61, 67],
            "suffix": "9b5",
            "frets": [-1, 0, 1, 4, 2, 3]
        }, {
            "frets": [2, 1, 2, 1, 1, 2],
            "baseFret": 4,
            "barres": [1],
            "fingers": [2, 1, 3, 1, 1, 4],
            "key": "A",
            "midi": [45, 49, 55, 59, 63, 69],
            "capo": true,
            "suffix": "9b5"
        }, {
            "baseFret": 8,
            "suffix": "9b5",
            "frets": [-1, 0, 2, 1, 1, 2],
            "key": "A",
            "barres": [1],
            "midi": [45, 59, 63, 67, 73],
            "fingers": [0, 0, 2, 1, 1, 3]
        }, {
            "capo": true,
            "key": "A",
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 11,
            "barres": [1],
            "midi": [57, 61, 67, 71, 75],
            "suffix": "9b5",
            "frets": [-1, 2, 1, 2, 2, 1]
        }, {
            "suffix": "aug9",
            "barres": [],
            "fingers": [0, 0, 2, 4, 1, 3],
            "frets": [-1, 0, 3, 4, 2, 3],
            "midi": [45, 53, 59, 61, 67],
            "baseFret": 1,
            "key": "A"
        }, {
            "frets": [3, 2, 1, 0, 0, 3],
            "baseFret": 3,
            "key": "A",
            "barres": [],
            "fingers": [3, 2, 1, 0, 0, 4],
            "midi": [45, 49, 53, 55, 59, 69],
            "suffix": "aug9"
        }, {
            "midi": [45, 55, 61, 65, 71],
            "suffix": "aug9",
            "barres": [],
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "A",
            "baseFret": 5,
            "frets": [-1, 0, 1, 2, 2, 3]
        }, {
            "fingers": [0, 2, 1, 3, 0, 4],
            "suffix": "aug9",
            "midi": [57, 61, 67, 59, 77],
            "baseFret": 11,
            "barres": [],
            "frets": [-1, 2, 1, 2, 0, 3],
            "key": "A"
        }, {
            "fingers": [0, 0, 1, 2, 1, 3],
            "suffix": "7b9",
            "midi": [45, 52, 58, 61, 67],
            "baseFret": 1,
            "barres": [2],
            "frets": [-1, 0, 2, 3, 2, 3],
            "key": "A"
        }, {
            "frets": [1, 3, 1, 2, 1, 2],
            "suffix": "7b9",
            "fingers": [1, 4, 1, 2, 1, 3],
            "capo": true,
            "midi": [45, 52, 55, 61, 64, 70],
            "key": "A",
            "barres": [1],
            "baseFret": 5
        }, {
            "baseFret": 6,
            "frets": [-1, -1, 2, 1, 3, 1],
            "barres": [1],
            "capo": true,
            "midi": [57, 61, 67, 70],
            "key": "A",
            "suffix": "7b9",
            "fingers": [0, 0, 2, 1, 3, 1]
        }, {
            "midi": [57, 61, 67, 70, 76],
            "capo": true,
            "barres": [1],
            "key": "A",
            "frets": [-1, 2, 1, 2, 1, 2],
            "fingers": [0, 2, 1, 3, 1, 4],
            "suffix": "7b9",
            "baseFret": 11
        }, {
            "key": "A",
            "fingers": [1, 3, 1, 2, 4, 4],
            "baseFret": 5,
            "capo": true,
            "suffix": "7#9",
            "midi": [45, 52, 55, 61, 67, 72],
            "barres": [1, 4],
            "frets": [1, 3, 1, 2, 4, 4]
        }, {
            "baseFret": 6,
            "suffix": "7#9",
            "frets": [-1, -1, 2, 1, 3, 3],
            "barres": [],
            "midi": [57, 61, 67, 72],
            "key": "A",
            "fingers": [0, 0, 2, 1, 3, 4]
        }, {
            "barres": [],
            "fingers": [0, 0, 4, 2, 1, 3],
            "frets": [-1, 0, 3, 2, 1, 2],
            "baseFret": 8,
            "midi": [45, 60, 64, 67, 73],
            "suffix": "7#9",
            "key": "A"
        }, {
            "suffix": "7#9",
            "fingers": [0, 2, 1, 3, 4, 0],
            "barres": [],
            "midi": [57, 61, 67, 72],
            "baseFret": 11,
            "frets": [-1, 2, 1, 2, 3, -1],
            "key": "A"
        }, {
            "baseFret": 1,
            "midi": [45, 50, 55, 61, 64],
            "frets": [-1, 0, 0, 0, 2, 0],
            "key": "A",
            "suffix": "11",
            "barres": [],
            "fingers": [0, 0, 0, 0, 2, 0]
        }, {
            "suffix": "11",
            "barres": [],
            "baseFret": 3,
            "frets": [3, 2, 0, 0, 0, 1],
            "key": "A",
            "fingers": [3, 2, 0, 0, 0, 1],
            "midi": [45, 49, 50, 55, 59, 67]
        }, {
            "barres": [1],
            "key": "A",
            "capo": true,
            "midi": [45, 50, 55, 61, 64, 69],
            "frets": [1, 1, 1, 2, 1, 1],
            "baseFret": 5,
            "suffix": "11",
            "fingers": [1, 1, 1, 2, 1, 1]
        }, {
            "capo": true,
            "suffix": "11",
            "midi": [47, 52, 57, 62, 67, 73],
            "fingers": [1, 1, 1, 1, 2, 3],
            "frets": [1, 1, 1, 1, 2, 3],
            "key": "A",
            "barres": [1],
            "baseFret": 7
        }, {
            "baseFret": 1,
            "midi": [45, 51, 55, 61, 64],
            "key": "A",
            "barres": [],
            "suffix": "9#11",
            "frets": [-1, 0, 1, 0, 2, 0],
            "fingers": [0, 0, 1, 0, 3, 0]
        }, {
            "key": "A",
            "capo": true,
            "midi": [45, 49, 55, 59, 63, 69],
            "suffix": "9#11",
            "barres": [1],
            "fingers": [2, 1, 3, 1, 1, 4],
            "frets": [2, 1, 2, 1, 1, 2],
            "baseFret": 4
        }, {
            "fingers": [0, 0, 1, 2, 3, 4],
            "suffix": "9#11",
            "midi": [57, 63, 67, 73],
            "frets": [-1, -1, 1, 2, 2, 3],
            "baseFret": 7,
            "key": "A",
            "barres": []
        }, {
            "barres": [1],
            "capo": true,
            "frets": [-1, 2, 1, 2, 2, 1],
            "key": "A",
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [57, 61, 67, 71, 75],
            "baseFret": 11,
            "suffix": "9#11"
        }, {
            "barres": [],
            "midi": [45, 52, 55, 61, 66],
            "key": "A",
            "frets": [-1, 0, 2, 0, 2, 2],
            "fingers": [0, 0, 1, 0, 2, 3],
            "baseFret": 1,
            "suffix": "13"
        }, {
            "barres": [],
            "suffix": "13",
            "baseFret": 3,
            "midi": [45, 49, 54, 55, 62, 64],
            "key": "A",
            "frets": [3, 2, 2, 0, 1, 0],
            "fingers": [4, 2, 3, 0, 1, 0]
        }, {
            "key": "A",
            "capo": true,
            "baseFret": 5,
            "barres": [1],
            "fingers": [1, 3, 1, 2, 4, 1],
            "frets": [1, 3, 1, 2, 3, 1],
            "midi": [45, 52, 55, 61, 66, 69],
            "suffix": "13"
        }, {
            "barres": [4],
            "frets": [-1, 2, 1, 2, 4, 4],
            "midi": [57, 61, 67, 73, 78],
            "key": "A",
            "suffix": "13",
            "fingers": [0, 2, 1, 3, 4, 4],
            "baseFret": 11
        }, {
            "frets": [-1, 0, 2, 1, 2, 0],
            "fingers": [0, 0, 2, 1, 3, 0],
            "barres": [],
            "baseFret": 1,
            "key": "A",
            "midi": [45, 52, 56, 61, 64],
            "suffix": "maj7"
        }, {
            "key": "A",
            "suffix": "maj7",
            "barres": [2],
            "midi": [45, 52, 57, 61, 68],
            "baseFret": 1,
            "capo": true,
            "fingers": [0, 0, 1, 1, 1, 4],
            "frets": [-1, 0, 2, 2, 2, 4]
        }, {
            "midi": [45, 52, 56, 61, 64, 69],
            "capo": true,
            "suffix": "maj7",
            "key": "A",
            "frets": [1, 3, 2, 2, 1, 1],
            "baseFret": 5,
            "barres": [1],
            "fingers": [1, 4, 2, 3, 1, 1]
        }, {
            "baseFret": 7,
            "midi": [45, 57, 64, 68, 73],
            "suffix": "maj7",
            "key": "A",
            "barres": [3],
            "fingers": [0, 0, 1, 3, 3, 3],
            "frets": [-1, 0, 1, 3, 3, 3]
        }, {
            "barres": [1],
            "frets": [-1, 0, 1, 1, 2, 4],
            "baseFret": 1,
            "suffix": "maj7b5",
            "key": "A",
            "fingers": [0, 0, 1, 1, 2, 4],
            "midi": [45, 51, 56, 61, 68]
        }, {
            "midi": [45, 51, 57, 61, 68],
            "frets": [-1, 0, 1, 2, 2, 4],
            "fingers": [0, 0, 1, 2, 2, 4],
            "barres": [2],
            "baseFret": 1,
            "key": "A",
            "suffix": "maj7b5"
        }, {
            "key": "A",
            "midi": [45, 51, 56, 61],
            "frets": [1, 2, 2, 2, -1, -1],
            "baseFret": 5,
            "fingers": [1, 2, 3, 4, 0, 0],
            "barres": [],
            "suffix": "maj7b5"
        }, {
            "midi": [45, 57, 63, 68, 73],
            "key": "A",
            "fingers": [0, 0, 1, 2, 3, 4],
            "barres": [],
            "frets": [-1, 0, 1, 2, 3, 3],
            "suffix": "maj7b5",
            "baseFret": 7
        }, {
            "midi": [45, 53, 56, 61, 65],
            "suffix": "maj7#5",
            "barres": [1],
            "key": "A",
            "frets": [-1, 0, 3, 1, 2, 1],
            "fingers": [0, 0, 3, 1, 2, 1],
            "baseFret": 1
        }, {
            "baseFret": 1,
            "barres": [2],
            "midi": [45, 53, 57, 61, 68],
            "suffix": "maj7#5",
            "frets": [-1, 0, 3, 2, 2, 4],
            "fingers": [0, 0, 2, 1, 1, 3],
            "key": "A"
        }, {
            "barres": [],
            "baseFret": 5,
            "suffix": "maj7#5",
            "frets": [-1, 0, 2, 2, 2, 1],
            "key": "A",
            "midi": [45, 56, 61, 65, 69],
            "fingers": [0, 0, 2, 3, 4, 1]
        }, {
            "fingers": [0, 4, 3, 2, 1, 1],
            "capo": true,
            "midi": [49, 57, 61, 65, 68, 73],
            "frets": [1, 4, 3, 2, 1, 1],
            "barres": [1],
            "key": "A",
            "suffix": "maj7#5",
            "baseFret": 9
        }, {
            "fingers": [0, 0, 1, 3, 1, 4],
            "barres": [2],
            "key": "A",
            "suffix": "maj9",
            "midi": [45, 52, 59, 61, 68],
            "frets": [-1, 0, 2, 4, 2, 4],
            "baseFret": 1
        }, {
            "suffix": "maj9",
            "key": "A",
            "midi": [45, 49, 56, 59, 64, 64],
            "barres": [1],
            "baseFret": 4,
            "frets": [2, 1, 3, 1, 2, 0],
            "fingers": [2, 1, 4, 1, 3, 0]
        }, {
            "key": "A",
            "midi": [45, 56, 61, 64, 71],
            "barres": [],
            "frets": [-1, 0, 2, 2, 1, 3],
            "baseFret": 5,
            "fingers": [0, 0, 2, 3, 1, 4],
            "suffix": "maj9"
        }, {
            "key": "A",
            "baseFret": 11,
            "fingers": [2, 2, 1, 4, 3, 0],
            "frets": [2, 2, 1, 3, 2, -1],
            "suffix": "maj9",
            "barres": [2],
            "midi": [52, 57, 61, 68, 71]
        }, {
            "fingers": [0, 0, 0, 1, 2, 0],
            "baseFret": 1,
            "barres": [],
            "suffix": "maj11",
            "frets": [-1, 0, 0, 1, 2, 0],
            "key": "A",
            "midi": [45, 50, 56, 61, 64]
        }, {
            "frets": [-1, 0, 0, 2, 2, 4],
            "suffix": "maj11",
            "midi": [45, 50, 57, 61, 68],
            "barres": [2],
            "fingers": [0, 0, 0, 1, 1, 4],
            "baseFret": 1,
            "key": "A"
        }, {
            "key": "A",
            "frets": [1, 1, 2, 2, 1, 3],
            "baseFret": 5,
            "suffix": "maj11",
            "fingers": [1, 1, 2, 3, 1, 4],
            "midi": [45, 50, 56, 61, 64, 71],
            "barres": [1]
        }, {
            "fingers": [2, 0, 1, 1, 1, 1],
            "frets": [2, 0, 1, 1, 1, 1],
            "midi": [50, 45, 59, 64, 68, 73],
            "barres": [1],
            "key": "A",
            "baseFret": 9,
            "capo": true,
            "suffix": "maj11"
        }, {
            "frets": [-1, 0, 2, 1, 2, 2],
            "baseFret": 1,
            "key": "A",
            "midi": [45, 52, 56, 61, 66],
            "barres": [],
            "suffix": "maj13",
            "fingers": [0, 0, 2, 1, 3, 4]
        }, {
            "suffix": "maj13",
            "barres": [1],
            "key": "A",
            "fingers": [2, 1, 1, 1, 3, 1],
            "frets": [2, 1, 1, 1, 2, 1],
            "midi": [45, 49, 54, 59, 64, 68],
            "baseFret": 4,
            "capo": true
        }, {
            "midi": [45, 56, 61, 66, 71],
            "key": "A",
            "frets": [-1, 0, 1, 1, 2, 2],
            "barres": [1],
            "fingers": [0, 0, 1, 1, 3, 4],
            "baseFret": 6,
            "suffix": "maj13"
        }, {
            "baseFret": 9,
            "capo": true,
            "suffix": "maj13",
            "barres": [1],
            "frets": [-1, 4, 3, 3, 1, 1],
            "fingers": [0, 4, 2, 3, 1, 1],
            "key": "A",
            "midi": [57, 61, 66, 68, 73]
        }, {
            "fingers": [0, 0, 2, 3, 1, 4],
            "frets": [-1, 0, 2, 2, 1, 2],
            "baseFret": 1,
            "suffix": "m6",
            "key": "A",
            "barres": [],
            "midi": [45, 52, 57, 60, 66]
        }, {
            "frets": [2, -1, 1, 2, 2, 2],
            "barres": [2],
            "baseFret": 4,
            "suffix": "m6",
            "key": "A",
            "fingers": [2, 0, 1, 3, 3, 4],
            "midi": [45, 54, 60, 64, 69]
        }, {
            "capo": true,
            "fingers": [1, 2, 3, 1, 4, 1],
            "barres": [1],
            "suffix": "m6",
            "key": "A",
            "midi": [45, 52, 57, 60, 66, 69],
            "baseFret": 5,
            "frets": [1, 3, 3, 1, 3, 1]
        }, {
            "fingers": [0, 1, 1, 3, 1, 2],
            "capo": true,
            "key": "A",
            "frets": [-1, 1, 1, 3, 1, 2],
            "midi": [52, 57, 64, 66, 72],
            "barres": [1],
            "suffix": "m6",
            "baseFret": 7
        }, {
            "midi": [45, 52, 55, 60, 64],
            "frets": [-1, 0, 2, 0, 1, 0],
            "suffix": "m7",
            "key": "A",
            "barres": [],
            "fingers": [0, 0, 2, 0, 1, 0],
            "baseFret": 1
        }, {
            "frets": [-1, 0, 2, 2, 1, 3],
            "fingers": [0, 0, 2, 3, 1, 4],
            "baseFret": 1,
            "barres": [],
            "suffix": "m7",
            "midi": [45, 52, 57, 60, 67],
            "key": "A"
        }, {
            "capo": true,
            "midi": [45, 52, 55, 60, 64, 69],
            "key": "A",
            "fingers": [1, 3, 1, 1, 1, 1],
            "barres": [1],
            "frets": [1, 3, 1, 1, 1, 1],
            "suffix": "m7",
            "baseFret": 5
        }, {
            "frets": [-1, 1, 1, 3, 2, 2],
            "capo": true,
            "baseFret": 7,
            "fingers": [0, 1, 1, 4, 2, 3],
            "suffix": "m7",
            "barres": [1],
            "key": "A",
            "midi": [52, 57, 64, 67, 72]
        }, {
            "key": "A",
            "frets": [-1, 0, 1, 0, 1, -1],
            "barres": [],
            "suffix": "m7b5",
            "fingers": [0, 0, 2, 0, 3, 0],
            "midi": [45, 51, 55, 60],
            "baseFret": 1
        }, {
            "frets": [2, -1, 2, 2, 1, -1],
            "fingers": [2, 0, 3, 4, 1, 0],
            "key": "A",
            "barres": [],
            "midi": [45, 55, 60, 63],
            "baseFret": 4,
            "suffix": "m7b5"
        }, {
            "capo": true,
            "midi": [45, 51, 57, 60, 67, 69],
            "key": "A",
            "baseFret": 5,
            "fingers": [1, 2, 3, 1, 4, 1],
            "barres": [1],
            "suffix": "m7b5",
            "frets": [1, 2, 3, 1, 4, 1]
        }, {
            "frets": [-1, -1, 1, 2, 2, 2],
            "key": "A",
            "fingers": [0, 0, 1, 2, 2, 2],
            "barres": [2],
            "suffix": "m7b5",
            "midi": [57, 63, 67, 72],
            "baseFret": 7
        }, {
            "baseFret": 1,
            "key": "A",
            "frets": [-1, 0, 2, 4, 1, 3],
            "barres": [],
            "fingers": [0, 0, 2, 4, 1, 3],
            "midi": [45, 52, 59, 60, 67],
            "suffix": "m9"
        }, {
            "key": "A",
            "frets": [1, 3, 1, 1, 1, 3],
            "capo": true,
            "barres": [1],
            "suffix": "m9",
            "fingers": [1, 3, 1, 1, 1, 4],
            "baseFret": 5,
            "midi": [45, 52, 55, 60, 64, 71]
        }, {
            "fingers": [1, 0, 3, 0, 2, 0],
            "baseFret": 8,
            "midi": [48, 45, 59, 55, 67, 64],
            "key": "A",
            "suffix": "m9",
            "barres": [],
            "frets": [1, 0, 2, 0, 1, 0]
        }, {
            "key": "A",
            "fingers": [0, 2, 1, 3, 4, 4],
            "frets": [-1, 3, 1, 3, 3, 3],
            "baseFret": 10,
            "suffix": "m9",
            "barres": [3],
            "midi": [57, 60, 67, 71, 76]
        }, {
            "barres": [],
            "baseFret": 4,
            "suffix": "m6/9",
            "frets": [-1, 0, 1, 2, 0, 0],
            "fingers": [0, 0, 2, 4, 0, 0],
            "midi": [45, 54, 60, 59, 64],
            "key": "A"
        }, {
            "suffix": "m6/9",
            "capo": true,
            "key": "A",
            "midi": [45, 52, 57, 60, 66, 71],
            "baseFret": 5,
            "fingers": [1, 2, 2, 1, 3, 4],
            "barres": [1, 3],
            "frets": [1, 3, 3, 1, 3, 3]
        }, {
            "baseFret": 7,
            "capo": true,
            "fingers": [2, 0, 1, 3, 1, 1],
            "midi": [48, 45, 57, 64, 66, 71],
            "suffix": "m6/9",
            "barres": [1],
            "frets": [2, 0, 1, 3, 1, 1],
            "key": "A"
        }, {
            "frets": [-1, 3, 1, 2, 3, 3],
            "key": "A",
            "fingers": [0, 3, 1, 2, 4, 4],
            "midi": [57, 60, 66, 71, 76],
            "baseFret": 10,
            "barres": [3],
            "suffix": "m6/9"
        }, {
            "suffix": "m11",
            "fingers": [0, 0, 0, 0, 1, 0],
            "frets": [-1, 0, 0, 0, 1, 0],
            "baseFret": 1,
            "barres": [],
            "key": "A",
            "midi": [45, 50, 55, 60, 64]
        }, {
            "key": "A",
            "frets": [3, 1, 3, 2, 1, 1],
            "midi": [45, 48, 55, 59, 62, 67],
            "baseFret": 3,
            "barres": [1],
            "suffix": "m11",
            "fingers": [3, 1, 4, 2, 1, 1],
            "capo": true
        }, {
            "baseFret": 5,
            "fingers": [1, 1, 1, 1, 1, 4],
            "suffix": "m11",
            "barres": [1],
            "capo": true,
            "frets": [1, 1, 1, 1, 1, 3],
            "midi": [45, 50, 55, 60, 64, 71],
            "key": "A"
        }, {
            "key": "A",
            "suffix": "m11",
            "capo": true,
            "frets": [-1, 3, 1, 3, 3, 1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 10,
            "midi": [57, 60, 67, 71, 74],
            "barres": [1]
        }, {
            "fingers": [0, 0, 3, 1, 2, 0],
            "frets": [-1, 0, 2, 1, 1, 0],
            "baseFret": 1,
            "barres": [],
            "key": "A",
            "midi": [45, 52, 56, 60, 64],
            "suffix": "mmaj7"
        }, {
            "fingers": [1, 3, 2, 1, 1, 1],
            "midi": [45, 52, 56, 60, 64, 69],
            "baseFret": 5,
            "key": "A",
            "capo": true,
            "suffix": "mmaj7",
            "frets": [1, 3, 2, 1, 1, 1],
            "barres": [1]
        }, {
            "key": "A",
            "baseFret": 7,
            "suffix": "mmaj7",
            "frets": [-1, 1, 1, 3, 3, 2],
            "fingers": [0, 1, 1, 3, 4, 2],
            "barres": [1],
            "capo": true,
            "midi": [52, 57, 64, 68, 72]
        }, {
            "key": "A",
            "frets": [-1, 4, 2, 1, 1, -1],
            "baseFret": 9,
            "capo": true,
            "suffix": "mmaj7",
            "barres": [1],
            "midi": [57, 60, 64, 68],
            "fingers": [0, 4, 2, 1, 1, 0]
        }, {
            "fingers": [0, 0, 1, 1, 1, 4],
            "key": "A",
            "midi": [45, 51, 56, 60, 68],
            "baseFret": 1,
            "suffix": "mmaj7b5",
            "barres": [1],
            "frets": [-1, 0, 1, 1, 1, 4]
        }, {
            "suffix": "mmaj7b5",
            "midi": [45, 51, 56, 60, 69],
            "frets": [1, 2, 2, 1, -1, 1],
            "barres": [1],
            "baseFret": 5,
            "capo": true,
            "fingers": [1, 2, 3, 1, 0, 1],
            "key": "A"
        }, {
            "barres": [],
            "baseFret": 7,
            "key": "A",
            "midi": [57, 63, 68, 72],
            "fingers": [0, 0, 1, 2, 4, 3],
            "suffix": "mmaj7b5",
            "frets": [-1, -1, 1, 2, 3, 2]
        }, {
            "baseFret": 11,
            "midi": [51, 57, 63, 68, 72],
            "frets": [1, 2, 3, 3, 3, -1],
            "barres": [3],
            "key": "A",
            "fingers": [1, 2, 3, 3, 3, 0],
            "suffix": "mmaj7b5"
        }, {
            "key": "A",
            "midi": [45, 48, 56, 59, 59, 64],
            "suffix": "mmaj9",
            "fingers": [3, 1, 4, 2, 0, 0],
            "barres": [],
            "frets": [3, 1, 4, 2, 0, 0],
            "baseFret": 3
        }, {
            "midi": [45, 56, 60, 59, 68],
            "suffix": "mmaj9",
            "frets": [-1, 0, 3, 2, 0, 1],
            "baseFret": 4,
            "key": "A",
            "fingers": [0, 0, 3, 2, 0, 1],
            "barres": []
        }, {
            "midi": [45, 52, 56, 60, 64, 71],
            "frets": [1, 3, 2, 1, 1, 3],
            "capo": true,
            "suffix": "mmaj9",
            "baseFret": 5,
            "barres": [1],
            "key": "A",
            "fingers": [1, 3, 2, 1, 1, 4]
        }, {
            "key": "A",
            "baseFret": 8,
            "midi": [45, 59, 64, 68, 72],
            "barres": [],
            "suffix": "mmaj9",
            "fingers": [0, 0, 2, 3, 4, 1],
            "frets": [-1, 0, 2, 2, 2, 1]
        }, {
            "fingers": [0, 0, 0, 1, 2, 0],
            "frets": [-1, 0, 0, 1, 1, 0],
            "midi": [45, 50, 56, 60, 64],
            "suffix": "mmaj11",
            "baseFret": 1,
            "barres": [],
            "key": "A"
        }, {
            "key": "A",
            "suffix": "mmaj11",
            "capo": true,
            "fingers": [1, 1, 2, 1, 1, 4],
            "midi": [45, 50, 56, 60, 64, 71],
            "barres": [1],
            "baseFret": 5,
            "frets": [1, 1, 2, 1, 1, 3]
        }, {
            "key": "A",
            "baseFret": 7,
            "midi": [45, 57, 62, 68, 72],
            "frets": [-1, 0, 1, 1, 3, 2],
            "suffix": "mmaj11",
            "fingers": [0, 0, 1, 1, 3, 2],
            "barres": [1]
        }, {
            "frets": [-1, 3, 1, 4, 3, 1],
            "capo": true,
            "fingers": [0, 2, 1, 4, 3, 1],
            "midi": [57, 60, 68, 71, 74],
            "key": "A",
            "suffix": "mmaj11",
            "baseFret": 10,
            "barres": [1]
        }, {
            "fingers": [0, 0, 1, 3, 2, 0],
            "key": "A",
            "baseFret": 1,
            "barres": [],
            "suffix": "add9",
            "midi": [45, 52, 59, 61, 64],
            "frets": [-1, 0, 2, 4, 2, 0]
        }, {
            "key": "A",
            "fingers": [0, 0, 3, 2, 1, 4],
            "baseFret": 5,
            "frets": [-1, -1, 3, 2, 1, 3],
            "barres": [],
            "midi": [57, 61, 64, 71],
            "suffix": "add9"
        }, {
            "midi": [57, 61, 64, 71, 73],
            "capo": true,
            "suffix": "add9",
            "fingers": [0, 3, 2, 1, 4, 1],
            "key": "A",
            "frets": [-1, 4, 3, 1, 4, 1],
            "baseFret": 9,
            "barres": [1]
        }, {
            "frets": [-1, 2, 1, -1, 2, 2],
            "suffix": "add9",
            "key": "A",
            "midi": [57, 61, 71, 76],
            "barres": [],
            "baseFret": 11,
            "fingers": [0, 2, 1, 0, 3, 4]
        }, {
            "key": "A",
            "barres": [],
            "fingers": [0, 0, 2, 4, 1, 0],
            "frets": [-1, 0, 2, 4, 1, 0],
            "suffix": "madd9",
            "midi": [45, 52, 59, 60, 64],
            "baseFret": 1
        }, {
            "barres": [1],
            "fingers": [0, 0, 3, 1, 1, 4],
            "midi": [57, 60, 64, 71],
            "key": "A",
            "suffix": "madd9",
            "frets": [-1, -1, 3, 1, 1, 3],
            "baseFret": 5,
            "capo": true
        }, {
            "suffix": "madd9",
            "fingers": [0, 0, 1, 3, 0, 2],
            "midi": [57, 64, 59, 72],
            "baseFret": 7,
            "barres": [],
            "frets": [-1, -1, 1, 3, 0, 2],
            "key": "A"
        }, {
            "midi": [57, 60, 64, 71],
            "barres": [],
            "baseFret": 9,
            "suffix": "madd9",
            "frets": [-1, 4, 2, 1, 4, -1],
            "key": "A",
            "fingers": [0, 3, 2, 1, 4, 0]
        }, {
            "frets": [-1, 3, 1, 1, 4, 4],
            "suffix": "/C#",
            "barres": [1],
            "fingers": [0, 3, 1, 1, 4, 4],
            "baseFret": 2,
            "midi": [49, 52, 57, 64, 69],
            "key": "A"
        }, {
            "frets": [-1, 3, 1, 1, 1, 4],
            "barres": [1],
            "fingers": [0, 3, 1, 1, 1, 4],
            "midi": [49, 52, 57, 61, 69],
            "key": "A",
            "baseFret": 2,
            "suffix": "/C#"
        }, {
            "suffix": "/C#",
            "key": "A",
            "barres": [2],
            "frets": [-1, 1, 4, 3, 2, 2],
            "midi": [49, 57, 61, 64, 69],
            "fingers": [0, 1, 4, 3, 2, 2],
            "baseFret": 4
        }, {
            "baseFret": 1,
            "fingers": [0, 0, 1, 2, 3, 0],
            "midi": [40, 45, 52, 57, 61, 64],
            "frets": [0, 0, 2, 2, 2, 0],
            "key": "A",
            "barres": [],
            "suffix": "/E"
        }, {
            "frets": [-1, 3, 3, 2, 1, 1],
            "midi": [52, 57, 61, 64, 69],
            "barres": [1],
            "suffix": "/E",
            "key": "A",
            "fingers": [0, 3, 4, 2, 1, 1],
            "baseFret": 5
        }, {
            "barres": [1],
            "midi": [52, 57, 61, 69],
            "key": "A",
            "suffix": "/E",
            "baseFret": 2,
            "fingers": [0, 0, 1, 1, 1, 4],
            "frets": [-1, -1, 1, 1, 1, 4]
        }, {
            "frets": [1, 0, 2, 2, 2, 0],
            "suffix": "/F",
            "fingers": [1, 0, 2, 3, 4, 0],
            "midi": [41, 45, 52, 57, 61, 64],
            "barres": [],
            "baseFret": 1,
            "key": "A"
        }, {
            "suffix": "/F",
            "barres": [],
            "midi": [53, 57, 61, 64],
            "key": "A",
            "baseFret": 1,
            "fingers": [0, 0, 3, 1, 2, 0],
            "frets": [-1, -1, 3, 2, 2, 0]
        }, {
            "suffix": "/F",
            "fingers": [1, 4, 2, 2, 2, 0],
            "midi": [41, 49, 52, 57, 61],
            "key": "A",
            "frets": [1, 4, 2, 2, 2, -1],
            "baseFret": 1,
            "barres": [2]
        }, {
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 1,
            "key": "A",
            "barres": [],
            "midi": [42, 45, 52, 57, 61, 64],
            "suffix": "/F#",
            "frets": [2, 0, 2, 2, 2, 0]
        }, {
            "barres": [1],
            "midi": [42, 49, 52, 57, 64, 69],
            "key": "A",
            "baseFret": 2,
            "suffix": "/F#",
            "frets": [1, 3, 1, 1, 4, 4],
            "fingers": [1, 3, 1, 1, 4, 4]
        }, {
            "baseFret": 2,
            "fingers": [1, 3, 1, 1, 1, 4],
            "suffix": "/F#",
            "key": "A",
            "midi": [42, 49, 52, 57, 61, 69],
            "barres": [1],
            "frets": [1, 3, 1, 1, 1, 4]
        }, {
            "midi": [43, 45, 52, 57, 61, 64],
            "fingers": [4, 0, 1, 2, 3, 0],
            "key": "A",
            "frets": [3, 0, 2, 2, 2, 0],
            "barres": [],
            "baseFret": 1,
            "suffix": "/G"
        }, {
            "baseFret": 5,
            "barres": [1],
            "fingers": [0, 0, 1, 2, 1, 1],
            "frets": [-1, -1, 1, 2, 1, 1],
            "key": "A",
            "suffix": "/G",
            "midi": [55, 61, 64, 69]
        }, {
            "baseFret": 2,
            "key": "A",
            "frets": [2, 3, 1, 1, 4, 4],
            "midi": [43, 49, 52, 57, 64, 69],
            "barres": [],
            "fingers": [2, 3, 1, 1, 4, 4],
            "suffix": "/G"
        }, {
            "frets": [3, 3, 1, 1, 4, 4],
            "suffix": "/G#",
            "key": "A",
            "barres": [1],
            "fingers": [2, 3, 1, 1, 4, 4],
            "baseFret": 2,
            "midi": [44, 49, 52, 57, 64, 69]
        }, {
            "midi": [44, 49, 52, 57, 61, 69],
            "key": "A",
            "baseFret": 2,
            "frets": [3, 3, 1, 1, 1, 4],
            "barres": [1],
            "fingers": [2, 3, 1, 1, 1, 4],
            "suffix": "/G#"
        }, {
            "suffix": "/G#",
            "barres": [1],
            "midi": [56, 61, 64, 69],
            "baseFret": 5,
            "frets": [-1, -1, 2, 2, 1, 1],
            "key": "A",
            "fingers": [0, 0, 2, 3, 1, 1]
        }, {
            "fingers": [0, 4, 2, 3, 1, 0],
            "midi": [48, 52, 57, 60, 64],
            "frets": [-1, 3, 2, 2, 1, 0],
            "baseFret": 1,
            "suffix": "m/C",
            "key": "A",
            "barres": []
        }, {
            "baseFret": 2,
            "fingers": [0, 2, 1, 4, 4, 4],
            "suffix": "m/C",
            "barres": [4],
            "frets": [-1, 2, 1, 4, 4, 4],
            "midi": [48, 52, 60, 64, 69],
            "key": "A"
        }, {
            "midi": [48, 52, 57, 64, 69],
            "barres": [1],
            "frets": [-1, 2, 1, 1, 4, 4],
            "suffix": "m/C",
            "fingers": [0, 2, 1, 1, 4, 4],
            "baseFret": 2,
            "key": "A"
        }, {
            "key": "A",
            "baseFret": 1,
            "suffix": "m/E",
            "midi": [40, 45, 52, 57, 60, 64],
            "fingers": [0, 0, 2, 3, 1, 0],
            "frets": [0, 0, 2, 2, 1, 0],
            "barres": []
        }, {
            "frets": [0, 3, 2, 2, 1, 0],
            "baseFret": 1,
            "key": "A",
            "midi": [40, 48, 52, 57, 60, 64],
            "suffix": "m/E",
            "fingers": [0, 4, 2, 3, 1, 0],
            "barres": []
        }, {
            "baseFret": 5,
            "midi": [52, 57, 60, 64, 69],
            "suffix": "m/E",
            "frets": [-1, 3, 3, 1, 1, 1],
            "fingers": [0, 3, 4, 1, 1, 1],
            "key": "A",
            "barres": [1]
        }, {
            "suffix": "m/F",
            "frets": [1, 0, 2, 2, 1, 0],
            "key": "A",
            "fingers": [1, 0, 3, 4, 2, 0],
            "midi": [41, 45, 52, 57, 60, 64],
            "baseFret": 1,
            "barres": []
        }, {
            "key": "A",
            "baseFret": 1,
            "fingers": [0, 0, 3, 2, 1, 0],
            "suffix": "m/F",
            "midi": [53, 57, 60, 64],
            "barres": [],
            "frets": [-1, -1, 3, 2, 1, 0]
        }, {
            "fingers": [1, 4, 2, 3, 1, 0],
            "midi": [41, 48, 52, 57, 60],
            "suffix": "m/F",
            "baseFret": 1,
            "key": "A",
            "barres": [1],
            "frets": [1, 3, 2, 2, 1, -1]
        }, {
            "fingers": [2, 0, 3, 4, 1, 0],
            "midi": [42, 45, 52, 57, 60, 64],
            "key": "A",
            "barres": [],
            "frets": [2, 0, 2, 2, 1, 0],
            "baseFret": 1,
            "suffix": "m/F#"
        }, {
            "frets": [-1, -1, 1, 2, 2, 2],
            "midi": [54, 60, 64, 69],
            "barres": [],
            "suffix": "m/F#",
            "key": "A",
            "fingers": [0, 0, 1, 2, 3, 4],
            "baseFret": 4
        }, {
            "midi": [42, 48, 52, 60, 64, 69],
            "barres": [1],
            "key": "A",
            "frets": [1, 2, 1, 4, 4, 4],
            "fingers": [1, 2, 1, 4, 4, 4],
            "baseFret": 2,
            "suffix": "m/F#"
        }, {
            "suffix": "m/G",
            "baseFret": 5,
            "midi": [55, 60, 64, 69],
            "frets": [-1, -1, 1, 1, 1, 1],
            "barres": [1],
            "key": "A",
            "fingers": [0, 0, 1, 1, 1, 1]
        }, {
            "key": "A",
            "suffix": "m/G",
            "fingers": [4, 0, 2, 3, 1, 0],
            "midi": [43, 45, 52, 57, 60, 64],
            "barres": [],
            "baseFret": 1,
            "frets": [3, 0, 2, 2, 1, 0]
        }, {
            "frets": [2, 2, 1, 4, 4, 4],
            "suffix": "m/G",
            "fingers": [2, 3, 1, 4, 4, 4],
            "key": "A",
            "baseFret": 2,
            "midi": [43, 48, 52, 60, 64, 69],
            "barres": [4]
        }, {
            "suffix": "m/G#",
            "frets": [-1, -1, 1, 2, 2, 2],
            "key": "A",
            "midi": [54, 60, 64, 69],
            "barres": [2],
            "baseFret": 4,
            "fingers": [0, 0, 2, 1, 1, 1]
        }, {
            "suffix": "m/G#",
            "midi": [44, 48, 52, 60, 64, 69],
            "barres": [4],
            "frets": [3, 2, 1, 4, 4, 4],
            "key": "A",
            "baseFret": 2,
            "fingers": [3, 2, 1, 4, 4, 4]
        }, {
            "baseFret": 2,
            "fingers": [3, 2, 1, 1, 4, 4],
            "barres": [1],
            "key": "A",
            "midi": [44, 48, 52, 57, 64, 69],
            "suffix": "m/G#",
            "frets": [3, 2, 1, 1, 4, 4]
        }, {
            "frets": [-1, 1, 3, 3, 3, 1],
            "baseFret": 1,
            "key": "Bb",
            "midi": [46, 53, 58, 62, 65],
            "capo": true,
            "suffix": "major",
            "barres": [1],
            "fingers": [0, 1, 2, 3, 4, 1]
        }, {
            "midi": [46, 50, 53, 58, 62],
            "suffix": "major",
            "frets": [4, 3, 1, 1, 1, -1],
            "capo": true,
            "barres": [1],
            "baseFret": 3,
            "fingers": [4, 3, 1, 1, 1, 0],
            "key": "Bb"
        }, {
            "baseFret": 6,
            "barres": [1],
            "fingers": [1, 3, 4, 2, 1, 1],
            "suffix": "major",
            "frets": [1, 3, 3, 2, 1, 1],
            "capo": true,
            "midi": [46, 53, 58, 62, 65, 70],
            "key": "Bb"
        }, {
            "fingers": [0, 1, 1, 2, 4, 3],
            "frets": [-1, 1, 1, 3, 4, 3],
            "midi": [53, 58, 65, 70, 74],
            "capo": true,
            "baseFret": 8,
            "suffix": "major",
            "key": "Bb",
            "barres": [1]
        }, {
            "frets": [-1, 1, 3, 3, 2, 1],
            "capo": true,
            "barres": [1],
            "midi": [46, 53, 58, 61, 65],
            "fingers": [0, 1, 3, 4, 2, 1],
            "baseFret": 1,
            "key": "Bb",
            "suffix": "minor"
        }, {
            "suffix": "minor",
            "barres": [1],
            "capo": true,
            "key": "Bb",
            "frets": [1, 3, 3, 1, 1, 1],
            "fingers": [1, 3, 4, 1, 1, 1],
            "midi": [46, 53, 58, 61, 65, 70],
            "baseFret": 6
        }, {
            "frets": [-1, -1, 3, 1, 1, 1],
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 3, 1, 1, 1],
            "midi": [58, 61, 65, 70],
            "baseFret": 6,
            "key": "Bb",
            "suffix": "minor"
        }, {
            "barres": [],
            "frets": [-1, -1, 1, 3, 4, 2],
            "midi": [58, 65, 70, 73],
            "fingers": [0, 0, 1, 3, 4, 2],
            "baseFret": 8,
            "suffix": "minor",
            "key": "Bb"
        }, {
            "suffix": "dim",
            "barres": [],
            "key": "Bb",
            "midi": [46, 52, 58, 61],
            "fingers": [0, 1, 2, 4, 3, 0],
            "baseFret": 1,
            "frets": [-1, 1, 2, 3, 2, -1]
        }, {
            "barres": [],
            "key": "Bb",
            "suffix": "dim",
            "midi": [46, 49, 61, 64],
            "frets": [3, 1, -1, 3, 2, -1],
            "baseFret": 4,
            "fingers": [3, 1, 0, 4, 2, 0]
        }, {
            "frets": [-1, -1, 1, 2, -1, 2],
            "suffix": "dim",
            "midi": [58, 64, 73],
            "baseFret": 8,
            "fingers": [0, 0, 1, 2, 0, 3],
            "key": "Bb",
            "barres": []
        }, {
            "frets": [-1, 3, 1, -1, 1, 2],
            "suffix": "dim",
            "fingers": [0, 4, 1, 0, 2, 3],
            "barres": [],
            "midi": [58, 61, 70, 76],
            "key": "Bb",
            "baseFret": 11
        }, {
            "midi": [46, 52, 55, 61, 64],
            "fingers": [0, 1, 2, 0, 3, 0],
            "suffix": "dim7",
            "frets": [-1, 1, 2, 0, 2, 0],
            "baseFret": 1,
            "key": "Bb",
            "barres": []
        }, {
            "key": "Bb",
            "barres": [],
            "suffix": "dim7",
            "baseFret": 1,
            "midi": [52, 58, 61, 67],
            "fingers": [0, 0, 1, 3, 2, 4],
            "frets": [-1, -1, 2, 3, 2, 3]
        }, {
            "midi": [46, 52, 58, 61, 67, 70],
            "fingers": [1, 2, 3, 1, 4, 1],
            "frets": [1, 2, 3, 1, 3, 1],
            "key": "Bb",
            "suffix": "dim7",
            "capo": true,
            "baseFret": 6,
            "barres": [1]
        }, {
            "midi": [58, 64, 67, 73],
            "suffix": "dim7",
            "barres": [],
            "fingers": [0, 0, 1, 3, 2, 4],
            "key": "Bb",
            "baseFret": 8,
            "frets": [-1, -1, 1, 2, 1, 2]
        }, {
            "barres": [1],
            "baseFret": 1,
            "capo": true,
            "suffix": "sus2",
            "fingers": [1, 1, 3, 4, 1, 1],
            "key": "Bb",
            "midi": [41, 46, 53, 58, 60, 65],
            "frets": [1, 1, 3, 3, 1, 1]
        }, {
            "key": "Bb",
            "frets": [4, 1, 1, 3, 4, -1],
            "baseFret": 3,
            "barres": [1],
            "fingers": [3, 1, 1, 2, 4, 0],
            "suffix": "sus2",
            "midi": [46, 48, 53, 60, 65],
            "capo": true
        }, {
            "key": "Bb",
            "barres": [1],
            "fingers": [1, 1, 1, 3, 4, 1],
            "suffix": "sus2",
            "baseFret": 8,
            "frets": [1, 1, 1, 3, 4, 1],
            "capo": true,
            "midi": [48, 53, 58, 65, 70, 72]
        }, {
            "barres": [1],
            "baseFret": 10,
            "fingers": [0, 3, 1, 1, 2, 4],
            "midi": [58, 60, 65, 70, 77],
            "frets": [-1, 4, 1, 1, 2, 4],
            "key": "Bb",
            "capo": true,
            "suffix": "sus2"
        }, {
            "suffix": "sus4",
            "frets": [-1, 1, 3, 3, 4, 1],
            "barres": [1],
            "key": "Bb",
            "midi": [46, 53, 58, 63, 65],
            "capo": true,
            "fingers": [0, 1, 2, 3, 4, 1],
            "baseFret": 1
        }, {
            "key": "Bb",
            "barres": [1],
            "capo": true,
            "baseFret": 3,
            "suffix": "sus4",
            "fingers": [0, 0, 1, 1, 2, 4],
            "midi": [53, 58, 63, 70],
            "frets": [-1, -1, 1, 1, 2, 4]
        }, {
            "key": "Bb",
            "capo": true,
            "suffix": "sus4",
            "midi": [46, 53, 58, 63, 65, 70],
            "frets": [1, 3, 3, 3, 1, 1],
            "fingers": [1, 3, 3, 3, 1, 1],
            "baseFret": 6,
            "barres": [1]
        }, {
            "capo": true,
            "fingers": [0, 1, 1, 2, 3, 4],
            "frets": [-1, 1, 1, 3, 4, 4],
            "key": "Bb",
            "barres": [1],
            "baseFret": 8,
            "midi": [53, 58, 65, 70, 75],
            "suffix": "sus4"
        }, {
            "midi": [46, 53, 56, 63, 65],
            "frets": [-1, 1, 3, 1, 4, 1],
            "capo": true,
            "fingers": [0, 1, 3, 1, 4, 1],
            "baseFret": 1,
            "suffix": "7sus4",
            "key": "Bb",
            "barres": [1]
        }, {
            "capo": true,
            "barres": [3, 4],
            "frets": [-1, -1, 3, 3, 4, 4],
            "midi": [53, 58, 63, 68],
            "baseFret": 1,
            "suffix": "7sus4",
            "key": "Bb",
            "fingers": [0, 0, 1, 1, 2, 2]
        }, {
            "capo": true,
            "frets": [1, 3, 1, 3, 1, 1],
            "key": "Bb",
            "suffix": "7sus4",
            "fingers": [1, 3, 1, 4, 1, 1],
            "midi": [46, 53, 56, 63, 65, 70],
            "barres": [1],
            "baseFret": 6
        }, {
            "key": "Bb",
            "suffix": "7sus4",
            "barres": [],
            "baseFret": 8,
            "fingers": [0, 0, 1, 3, 2, 4],
            "midi": [58, 65, 68, 75],
            "frets": [-1, -1, 1, 3, 2, 4]
        }, {
            "baseFret": 1,
            "barres": [],
            "key": "Bb",
            "suffix": "alt",
            "midi": [46, 52, 58, 62, 64],
            "fingers": [0, 1, 2, 3, 4, 0],
            "frets": [-1, 1, 2, 3, 3, 0]
        }, {
            "barres": [],
            "frets": [2, 3, 0, 3, 1, 0],
            "midi": [46, 52, 50, 62, 64, 64],
            "baseFret": 5,
            "suffix": "alt",
            "key": "Bb",
            "fingers": [2, 3, 0, 4, 1, 0]
        }, {
            "suffix": "alt",
            "fingers": [1, 3, 0, 4, 0, 2],
            "midi": [46, 52, 50, 62, 70],
            "baseFret": 6,
            "barres": [],
            "key": "Bb",
            "frets": [1, 2, 0, 2, -1, 1]
        }, {
            "key": "Bb",
            "fingers": [0, 0, 1, 2, 4, 3],
            "barres": [],
            "baseFret": 8,
            "frets": [-1, -1, 1, 2, 4, 3],
            "suffix": "alt",
            "midi": [58, 64, 70, 74]
        }, {
            "baseFret": 1,
            "key": "Bb",
            "fingers": [0, 1, 4, 2, 3, 0],
            "midi": [46, 54, 58, 62],
            "frets": [-1, 1, 4, 3, 3, -1],
            "suffix": "aug",
            "barres": []
        }, {
            "fingers": [4, 3, 2, 1, 1, 0],
            "capo": true,
            "key": "Bb",
            "barres": [1],
            "baseFret": 3,
            "midi": [46, 50, 54, 58, 62],
            "frets": [4, 3, 2, 1, 1, -1],
            "suffix": "aug"
        }, {
            "midi": [58, 62, 66, 70],
            "key": "Bb",
            "baseFret": 6,
            "suffix": "aug",
            "frets": [-1, -1, 3, 2, 2, 1],
            "fingers": [0, 0, 4, 2, 3, 1],
            "barres": []
        }, {
            "suffix": "aug",
            "capo": true,
            "barres": [1],
            "frets": [-1, -1, 2, 1, 1, -1],
            "midi": [58, 62, 66],
            "baseFret": 7,
            "key": "Bb",
            "fingers": [0, 0, 2, 1, 1, 0]
        }, {
            "barres": [3],
            "frets": [-1, 1, 3, 3, 3, 3],
            "midi": [46, 53, 58, 62, 67],
            "key": "Bb",
            "fingers": [0, 1, 3, 3, 3, 3],
            "baseFret": 1,
            "suffix": "6"
        }, {
            "midi": [46, 50, 50, 55, 65, 70],
            "barres": [],
            "fingers": [2, 1, 0, 0, 3, 4],
            "frets": [2, 1, 0, 0, 2, 2],
            "key": "Bb",
            "baseFret": 5,
            "suffix": "6"
        }, {
            "barres": [1],
            "capo": true,
            "frets": [1, 3, -1, 2, 3, 1],
            "suffix": "6",
            "baseFret": 6,
            "fingers": [1, 3, 0, 2, 4, 0],
            "midi": [46, 53, 62, 67, 70],
            "key": "Bb"
        }, {
            "baseFret": 10,
            "frets": [-1, 4, 2, 2, 1, -1],
            "key": "Bb",
            "fingers": [0, 4, 2, 3, 1, 0],
            "midi": [58, 61, 66, 69],
            "suffix": "6",
            "barres": []
        }, {
            "fingers": [0, 1, 0, 0, 2, 3],
            "barres": [],
            "midi": [46, 50, 55, 60, 65],
            "frets": [-1, 1, 0, 0, 1, 1],
            "suffix": "6/9",
            "key": "Bb",
            "baseFret": 1
        }, {
            "suffix": "6/9",
            "baseFret": 5,
            "capo": true,
            "key": "Bb",
            "barres": [1],
            "fingers": [2, 1, 1, 1, 3, 4],
            "midi": [46, 50, 55, 60, 65, 70],
            "frets": [2, 1, 1, 1, 2, 2]
        }, {
            "barres": [2],
            "fingers": [0, 2, 2, 1, 3, 4],
            "baseFret": 7,
            "key": "Bb",
            "suffix": "6/9",
            "frets": [-1, 2, 2, 1, 2, 2],
            "midi": [53, 58, 62, 67, 72]
        }, {
            "barres": [1],
            "baseFret": 12,
            "suffix": "6/9",
            "capo": true,
            "frets": [-1, 2, 1, 1, 2, 2],
            "midi": [58, 62, 67, 72, 77],
            "key": "Bb",
            "fingers": [0, 2, 1, 1, 3, 4]
        }, {
            "barres": [1],
            "suffix": "7",
            "capo": true,
            "midi": [46, 53, 56, 62, 65],
            "frets": [-1, 1, 3, 1, 3, 1],
            "fingers": [0, 1, 3, 1, 4, 1],
            "baseFret": 1,
            "key": "Bb"
        }, {
            "suffix": "7",
            "capo": true,
            "fingers": [1, 3, 1, 2, 1, 1],
            "midi": [46, 53, 56, 62, 65, 70],
            "barres": [1],
            "frets": [1, 3, 1, 2, 1, 1],
            "baseFret": 6,
            "key": "Bb"
        }, {
            "fingers": [0, 1, 1, 3, 2, 4],
            "midi": [53, 58, 65, 68, 74],
            "key": "Bb",
            "baseFret": 8,
            "capo": true,
            "frets": [-1, 1, 1, 3, 2, 3],
            "barres": [1],
            "suffix": "7"
        }, {
            "key": "Bb",
            "midi": [58, 62, 68, 70],
            "baseFret": 11,
            "suffix": "7",
            "fingers": [0, 3, 2, 4, 1, 0],
            "barres": [],
            "frets": [-1, 3, 2, 3, 1, -1]
        }, {
            "fingers": [0, 1, 2, 1, 3, 0],
            "midi": [46, 52, 56, 62],
            "baseFret": 1,
            "capo": true,
            "frets": [-1, 1, 2, 1, 3, -1],
            "barres": [1],
            "suffix": "7b5",
            "key": "Bb"
        }, {
            "midi": [46, 56, 62, 64, 64],
            "barres": [],
            "frets": [2, -1, 2, 3, 1, 0],
            "key": "Bb",
            "baseFret": 5,
            "fingers": [2, 0, 3, 4, 1, 0],
            "suffix": "7b5"
        }, {
            "baseFret": 8,
            "fingers": [0, 0, 1, 2, 3, 4],
            "key": "Bb",
            "frets": [-1, -1, 1, 2, 2, 3],
            "midi": [58, 64, 68, 74],
            "barres": [],
            "suffix": "7b5"
        }, {
            "suffix": "7b5",
            "barres": [],
            "baseFret": 11,
            "frets": [-1, 3, 2, 3, 1, 0],
            "midi": [58, 62, 68, 70, 64],
            "key": "Bb",
            "fingers": [0, 3, 2, 4, 1, 0]
        }, {
            "frets": [-1, 1, 4, 1, 3, 2],
            "baseFret": 1,
            "capo": true,
            "fingers": [0, 1, 4, 1, 3, 2],
            "midi": [46, 54, 56, 62, 66],
            "barres": [1],
            "suffix": "aug7",
            "key": "Bb"
        }, {
            "fingers": [1, 0, 2, 3, 4, 0],
            "barres": [],
            "suffix": "aug7",
            "baseFret": 6,
            "frets": [1, -1, 1, 2, 2, -1],
            "key": "Bb",
            "midi": [46, 56, 62, 66]
        }, {
            "baseFret": 8,
            "key": "Bb",
            "midi": [58, 66, 68, 74],
            "fingers": [0, 0, 1, 4, 2, 3],
            "barres": [],
            "frets": [-1, -1, 1, 4, 2, 3],
            "suffix": "aug7"
        }, {
            "fingers": [0, 2, 1, 3, 0, 4],
            "barres": [],
            "baseFret": 12,
            "key": "Bb",
            "suffix": "aug7",
            "midi": [58, 62, 68, 78],
            "frets": [-1, 2, 1, 2, -1, 3]
        }, {
            "midi": [46, 50, 56, 60, 65],
            "suffix": "9",
            "baseFret": 1,
            "fingers": [0, 1, 0, 2, 3, 4],
            "key": "Bb",
            "frets": [-1, 1, 0, 1, 1, 1],
            "barres": []
        }, {
            "fingers": [2, 1, 3, 1, 4, 0],
            "baseFret": 5,
            "capo": true,
            "suffix": "9",
            "midi": [46, 50, 56, 60, 65],
            "barres": [1],
            "frets": [2, 1, 2, 1, 2, -1],
            "key": "Bb"
        }, {
            "capo": true,
            "key": "Bb",
            "midi": [46, 53, 56, 62, 65, 72],
            "barres": [1],
            "frets": [1, 3, 1, 2, 1, 3],
            "suffix": "9",
            "fingers": [1, 3, 1, 2, 1, 4],
            "baseFret": 6
        }, {
            "barres": [2],
            "frets": [-1, 2, 1, 2, 2, 2],
            "key": "Bb",
            "suffix": "9",
            "midi": [58, 62, 68, 72, 77],
            "baseFret": 12,
            "fingers": [0, 2, 1, 3, 3, 3]
        }, {
            "fingers": [0, 1, 0, 2, 3, 0],
            "key": "Bb",
            "midi": [46, 50, 56, 60, 64],
            "barres": [],
            "baseFret": 1,
            "suffix": "9b5",
            "frets": [-1, 1, 0, 1, 1, 0]
        }, {
            "baseFret": 4,
            "barres": [],
            "midi": [46, 50, 60, 64, 68],
            "frets": [3, -1, 0, 2, 2, 1],
            "fingers": [4, 0, 0, 2, 3, 1],
            "key": "Bb",
            "suffix": "9b5"
        }, {
            "capo": true,
            "fingers": [2, 1, 3, 1, 1, 4],
            "midi": [46, 50, 56, 60, 64, 70],
            "baseFret": 5,
            "frets": [2, 1, 2, 1, 1, 2],
            "barres": [1],
            "key": "Bb",
            "suffix": "9b5"
        }, {
            "barres": [],
            "suffix": "9b5",
            "fingers": [0, 2, 1, 3, 4, 0],
            "midi": [58, 62, 68, 72, 64],
            "baseFret": 12,
            "key": "Bb",
            "frets": [-1, 2, 1, 2, 2, 0]
        }, {
            "fingers": [0, 1, 0, 2, 3, 4],
            "key": "Bb",
            "barres": [],
            "baseFret": 1,
            "suffix": "aug9",
            "frets": [-1, 1, 0, 1, 1, 2],
            "midi": [46, 50, 56, 60, 66]
        }, {
            "midi": [44, 48, 54, 58, 62, 68],
            "frets": [4, 3, 4, 3, 3, 4],
            "capo": true,
            "suffix": "aug9",
            "baseFret": 1,
            "barres": [3],
            "fingers": [2, 1, 3, 1, 1, 4],
            "key": "Bb"
        }, {
            "barres": [1],
            "suffix": "aug9",
            "frets": [2, 1, 2, 1, 3, -1],
            "key": "Bb",
            "capo": true,
            "fingers": [2, 1, 3, 1, 4, 0],
            "baseFret": 5,
            "midi": [46, 50, 56, 60, 66]
        }, {
            "fingers": [1, 0, 1, 2, 3, 4],
            "frets": [1, -1, 1, 2, 2, 3],
            "baseFret": 6,
            "midi": [46, 56, 62, 66, 72],
            "capo": true,
            "key": "Bb",
            "barres": [1],
            "suffix": "aug9"
        }, {
            "midi": [46, 50, 56, 59, 65],
            "suffix": "7b9",
            "barres": [],
            "fingers": [0, 1, 0, 2, 0, 3],
            "key": "Bb",
            "baseFret": 1,
            "frets": [-1, 1, 0, 1, 0, 1]
        }, {
            "midi": [46, 50, 56, 59],
            "suffix": "7b9",
            "baseFret": 4,
            "fingers": [3, 2, 4, 1, 0, 0],
            "barres": [],
            "key": "Bb",
            "frets": [3, 2, 3, 1, -1, -1]
        }, {
            "barres": [1],
            "suffix": "7b9",
            "baseFret": 6,
            "fingers": [1, 0, 1, 2, 1, 3],
            "key": "Bb",
            "midi": [46, 56, 62, 65, 71],
            "frets": [1, -1, 1, 2, 1, 2],
            "capo": true
        }, {
            "fingers": [0, 2, 1, 3, 1, 4],
            "baseFret": 12,
            "suffix": "7b9",
            "barres": [1],
            "capo": true,
            "frets": [-1, 2, 1, 2, 1, 2],
            "midi": [58, 62, 68, 71, 77],
            "key": "Bb"
        }, {
            "suffix": "7#9",
            "midi": [46, 50, 56, 61],
            "barres": [],
            "fingers": [0, 1, 0, 2, 3, 0],
            "baseFret": 1,
            "key": "Bb",
            "frets": [-1, 1, 0, 1, 2, -1]
        }, {
            "midi": [46, 53, 56, 62, 68, 73],
            "capo": true,
            "barres": [1, 4],
            "suffix": "7#9",
            "key": "Bb",
            "baseFret": 6,
            "fingers": [1, 3, 1, 2, 4, 4],
            "frets": [1, 3, 1, 2, 4, 4]
        }, {
            "barres": [],
            "fingers": [0, 0, 2, 1, 3, 4],
            "frets": [-1, -1, 2, 1, 3, 3],
            "midi": [58, 62, 68, 73],
            "suffix": "7#9",
            "baseFret": 7,
            "key": "Bb"
        }, {
            "key": "Bb",
            "baseFret": 12,
            "frets": [-1, 2, 1, 2, 3, -1],
            "barres": [],
            "fingers": [0, 2, 1, 3, 4, 0],
            "suffix": "7#9",
            "midi": [58, 62, 68, 73]
        }, {
            "midi": [46, 51, 56, 62, 65],
            "frets": [-1, 1, 1, 1, 3, 1],
            "key": "Bb",
            "capo": true,
            "suffix": "11",
            "baseFret": 1,
            "barres": [1],
            "fingers": [0, 1, 1, 1, 3, 1]
        }, {
            "suffix": "11",
            "capo": true,
            "midi": [46, 50, 50, 60, 63, 68],
            "frets": [3, 2, 0, 2, 1, 1],
            "fingers": [4, 2, 0, 3, 1, 1],
            "baseFret": 4,
            "barres": [1],
            "key": "Bb"
        }, {
            "fingers": [1, 1, 1, 1, 2, 3],
            "frets": [1, 1, 1, 1, 2, 3],
            "baseFret": 8,
            "key": "Bb",
            "capo": true,
            "midi": [48, 53, 58, 63, 68, 74],
            "suffix": "11",
            "barres": [1]
        }, {
            "capo": true,
            "key": "Bb",
            "frets": [-1, 3, 2, 3, 1, 1],
            "barres": [1],
            "suffix": "11",
            "midi": [58, 62, 68, 70, 75],
            "fingers": [0, 3, 2, 4, 1, 1],
            "baseFret": 11
        }, {
            "barres": [],
            "midi": [46, 50, 56, 60, 64],
            "key": "Bb",
            "baseFret": 1,
            "suffix": "9#11",
            "fingers": [0, 1, 0, 2, 3, 0],
            "frets": [-1, 1, 0, 1, 1, 0]
        }, {
            "baseFret": 5,
            "suffix": "9#11",
            "fingers": [2, 1, 3, 1, 1, 0],
            "capo": true,
            "key": "Bb",
            "barres": [1],
            "midi": [46, 50, 56, 60, 64],
            "frets": [2, 1, 2, 1, 1, -1]
        }, {
            "midi": [58, 64, 68, 74],
            "barres": [],
            "fingers": [0, 0, 1, 2, 3, 4],
            "suffix": "9#11",
            "key": "Bb",
            "frets": [-1, -1, 1, 2, 2, 3],
            "baseFret": 8
        }, {
            "midi": [58, 62, 68, 72, 76],
            "capo": true,
            "suffix": "9#11",
            "fingers": [0, 2, 1, 3, 4, 1],
            "baseFret": 12,
            "key": "Bb",
            "barres": [1],
            "frets": [-1, 2, 1, 2, 2, 1]
        }, {
            "suffix": "13",
            "key": "Bb",
            "baseFret": 1,
            "frets": [-1, 1, 0, 1, 3, 3],
            "midi": [46, 50, 56, 62, 67],
            "barres": [3],
            "fingers": [0, 1, 0, 2, 4, 4]
        }, {
            "barres": [1],
            "midi": [46, 50, 50, 55, 63, 68],
            "suffix": "13",
            "frets": [3, 2, 0, 0, 1, 1],
            "key": "Bb",
            "fingers": [3, 2, 0, 0, 1, 1],
            "baseFret": 4
        }, {
            "midi": [46, 51, 56, 62, 67, 72],
            "barres": [1],
            "fingers": [1, 1, 1, 2, 3, 4],
            "key": "Bb",
            "frets": [1, 1, 1, 2, 3, 3],
            "suffix": "13",
            "baseFret": 6,
            "capo": true
        }, {
            "barres": [4],
            "midi": [58, 62, 68, 74, 79],
            "fingers": [0, 2, 1, 3, 4, 4],
            "frets": [-1, 2, 1, 2, 4, 4],
            "key": "Bb",
            "baseFret": 12,
            "suffix": "13"
        }, {
            "barres": [1],
            "frets": [-1, 1, 3, 2, 3, 1],
            "baseFret": 1,
            "fingers": [0, 1, 3, 2, 4, 1],
            "key": "Bb",
            "capo": true,
            "midi": [46, 53, 57, 62, 65],
            "suffix": "maj7"
        }, {
            "suffix": "maj7",
            "capo": true,
            "barres": [1],
            "midi": [53, 58, 62, 69],
            "fingers": [0, 0, 1, 1, 1, 4],
            "frets": [-1, -1, 1, 1, 1, 3],
            "baseFret": 3,
            "key": "Bb"
        }, {
            "midi": [46, 53, 57, 62, 65, 70],
            "barres": [1],
            "key": "Bb",
            "suffix": "maj7",
            "frets": [1, 3, 2, 2, 1, 1],
            "baseFret": 6,
            "fingers": [1, 4, 2, 3, 1, 1],
            "capo": true
        }, {
            "midi": [53, 58, 65, 69, 74],
            "capo": true,
            "suffix": "maj7",
            "fingers": [0, 1, 1, 3, 3, 3],
            "frets": [-1, 1, 1, 3, 3, 3],
            "barres": [1, 3],
            "key": "Bb",
            "baseFret": 8
        }, {
            "baseFret": 1,
            "frets": [-1, 1, 2, 2, 3, -1],
            "midi": [46, 52, 57, 62],
            "barres": [],
            "fingers": [0, 1, 2, 3, 4, 0],
            "suffix": "maj7b5",
            "key": "Bb"
        }, {
            "frets": [2, 1, 3, 3, 1, 1],
            "capo": true,
            "key": "Bb",
            "fingers": [2, 1, 3, 4, 1, 1],
            "baseFret": 5,
            "midi": [46, 50, 57, 62, 64, 69],
            "suffix": "maj7b5",
            "barres": [1]
        }, {
            "fingers": [1, 2, 3, 4, 0, 0],
            "frets": [1, 2, 2, 2, -1, 0],
            "barres": [],
            "midi": [46, 52, 57, 62, 64],
            "key": "Bb",
            "baseFret": 6,
            "suffix": "maj7b5"
        }, {
            "suffix": "maj7b5",
            "key": "Bb",
            "barres": [],
            "baseFret": 8,
            "midi": [58, 64, 69, 74],
            "frets": [-1, -1, 1, 2, 3, 3],
            "fingers": [0, 0, 1, 2, 3, 4]
        }, {
            "midi": [46, 50, 57, 62, 66],
            "barres": [],
            "baseFret": 1,
            "suffix": "maj7#5",
            "frets": [-1, 1, 0, 2, 3, 2],
            "key": "Bb",
            "fingers": [0, 1, 0, 2, 4, 3]
        }, {
            "key": "Bb",
            "barres": [1],
            "midi": [54, 58, 62, 69],
            "fingers": [0, 0, 2, 1, 1, 4],
            "capo": true,
            "suffix": "maj7#5",
            "frets": [-1, -1, 2, 1, 1, 3],
            "baseFret": 3
        }, {
            "midi": [46, 57, 62, 66],
            "barres": [],
            "fingers": [1, 0, 2, 3, 4, 0],
            "baseFret": 6,
            "key": "Bb",
            "frets": [1, -1, 2, 2, 2, -1],
            "suffix": "maj7#5"
        }, {
            "baseFret": 10,
            "fingers": [1, 4, 3, 2, 1, 1],
            "key": "Bb",
            "suffix": "maj7#5",
            "capo": true,
            "barres": [1],
            "frets": [1, 4, 3, 2, 1, 1],
            "midi": [50, 58, 62, 66, 69, 74]
        }, {
            "key": "Bb",
            "midi": [41, 46, 50, 57, 60],
            "baseFret": 1,
            "suffix": "maj9",
            "fingers": [1, 1, 0, 3, 2, 0],
            "barres": [1],
            "frets": [1, 1, 0, 2, 1, -1]
        }, {
            "capo": true,
            "key": "Bb",
            "midi": [46, 48, 53, 58, 62, 69],
            "suffix": "maj9",
            "baseFret": 3,
            "fingers": [4, 1, 1, 1, 1, 3],
            "frets": [4, 1, 1, 1, 1, 3],
            "barres": [1]
        }, {
            "key": "Bb",
            "fingers": [2, 1, 4, 1, 3, 0],
            "capo": true,
            "suffix": "maj9",
            "frets": [2, 1, 3, 1, 2, -1],
            "baseFret": 5,
            "midi": [46, 50, 57, 60, 65],
            "barres": [1]
        }, {
            "suffix": "maj9",
            "fingers": [1, 3, 2, 2, 1, 4],
            "frets": [1, 3, 2, 2, 1, 3],
            "midi": [46, 53, 57, 62, 65, 72],
            "capo": true,
            "barres": [1, 2],
            "key": "Bb",
            "baseFret": 6
        }, {
            "frets": [-1, 1, 1, 2, 3, 1],
            "fingers": [0, 1, 1, 2, 3, 1],
            "barres": [1],
            "suffix": "maj11",
            "key": "Bb",
            "baseFret": 1,
            "capo": true,
            "midi": [46, 51, 57, 62, 65]
        }, {
            "frets": [3, -1, 0, 2, 1, 2],
            "fingers": [4, 0, 0, 2, 1, 3],
            "key": "Bb",
            "baseFret": 4,
            "midi": [46, 50, 60, 63, 69],
            "barres": [],
            "suffix": "maj11"
        }, {
            "midi": [46, 51, 57, 62, 65, 70],
            "fingers": [1, 1, 2, 3, 1, 1],
            "baseFret": 6,
            "barres": [1],
            "suffix": "maj11",
            "key": "Bb",
            "frets": [1, 1, 2, 2, 1, 1],
            "capo": true
        }, {
            "baseFret": 8,
            "suffix": "maj11",
            "frets": [-1, -1, 1, 1, 3, 3],
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 1, 1, 3, 4],
            "midi": [58, 63, 69, 74],
            "key": "Bb"
        }, {
            "fingers": [0, 1, 1, 2, 3, 4],
            "capo": true,
            "key": "Bb",
            "frets": [-1, 1, 1, 2, 3, 3],
            "baseFret": 1,
            "suffix": "maj13",
            "midi": [46, 51, 57, 62, 67],
            "barres": [1]
        }, {
            "baseFret": 5,
            "suffix": "maj13",
            "barres": [1],
            "frets": [2, 1, 1, 1, 2, 1],
            "fingers": [2, 1, 1, 1, 3, 1],
            "key": "Bb",
            "midi": [46, 50, 55, 60, 65, 69],
            "capo": true
        }, {
            "barres": [1],
            "capo": true,
            "baseFret": 6,
            "frets": [1, 1, 2, 2, 3, 1],
            "fingers": [1, 1, 2, 3, 4, 1],
            "key": "Bb",
            "suffix": "maj13",
            "midi": [46, 51, 57, 62, 67, 70]
        }, {
            "capo": true,
            "fingers": [0, 4, 2, 3, 1, 1],
            "key": "Bb",
            "barres": [1],
            "frets": [-1, 4, 3, 3, 1, 1],
            "baseFret": 10,
            "suffix": "maj13",
            "midi": [58, 62, 67, 69, 74]
        }, {
            "key": "Bb",
            "midi": [46, 53, 61, 67],
            "frets": [-1, 1, 3, -1, 2, 3],
            "fingers": [0, 1, 3, 0, 2, 4],
            "barres": [],
            "suffix": "m6",
            "baseFret": 1
        }, {
            "barres": [],
            "midi": [49, 55, 58, 65],
            "key": "Bb",
            "fingers": [0, 2, 3, 1, 4, 0],
            "baseFret": 3,
            "suffix": "m6",
            "frets": [-1, 2, 3, 1, 4, -1]
        }, {
            "baseFret": 5,
            "barres": [2],
            "frets": [2, -1, 1, 2, 2, 2],
            "fingers": [2, 0, 1, 3, 3, 4],
            "midi": [46, 55, 61, 65, 70],
            "suffix": "m6",
            "key": "Bb"
        }, {
            "baseFret": 6,
            "key": "Bb",
            "capo": true,
            "frets": [1, 3, 3, 1, 3, 1],
            "fingers": [1, 2, 3, 1, 4, 1],
            "barres": [1],
            "midi": [46, 53, 58, 61, 67, 70],
            "suffix": "m6"
        }, {
            "fingers": [0, 1, 3, 1, 2, 1],
            "baseFret": 1,
            "frets": [-1, 1, 3, 1, 2, 1],
            "capo": true,
            "suffix": "m7",
            "barres": [1],
            "key": "Bb",
            "midi": [46, 53, 56, 61, 65]
        }, {
            "barres": [],
            "frets": [-1, -1, 3, 3, 2, 4],
            "suffix": "m7",
            "baseFret": 1,
            "key": "Bb",
            "midi": [53, 58, 61, 68],
            "fingers": [0, 0, 2, 3, 1, 4]
        }, {
            "barres": [1],
            "suffix": "m7",
            "frets": [1, 3, 1, 1, 1, 1],
            "fingers": [1, 3, 1, 1, 1, 1],
            "capo": true,
            "midi": [46, 53, 56, 61, 65, 70],
            "baseFret": 6,
            "key": "Bb"
        }, {
            "suffix": "m7",
            "baseFret": 8,
            "barres": [1],
            "midi": [53, 58, 65, 68, 73],
            "capo": true,
            "key": "Bb",
            "fingers": [0, 1, 1, 4, 2, 3],
            "frets": [-1, 1, 1, 3, 2, 2]
        }, {
            "suffix": "m7b5",
            "barres": [],
            "baseFret": 1,
            "frets": [-1, 1, 2, 1, 2, -1],
            "key": "Bb",
            "fingers": [0, 1, 3, 2, 4, 0],
            "midi": [46, 52, 56, 61]
        }, {
            "midi": [52, 58, 61, 68],
            "baseFret": 1,
            "suffix": "m7b5",
            "frets": [-1, -1, 2, 3, 2, 4],
            "key": "Bb",
            "fingers": [0, 0, 1, 2, 1, 4],
            "barres": [2],
            "capo": true
        }, {
            "suffix": "m7b5",
            "frets": [2, -1, 2, 2, 1, -1],
            "barres": [],
            "fingers": [2, 0, 3, 4, 1, 0],
            "baseFret": 5,
            "midi": [46, 56, 61, 64],
            "key": "Bb"
        }, {
            "midi": [58, 64, 68, 73],
            "fingers": [0, 0, 1, 2, 2, 2],
            "suffix": "m7b5",
            "key": "Bb",
            "frets": [-1, -1, 1, 2, 2, 2],
            "barres": [2],
            "baseFret": 8
        }, {
            "barres": [],
            "fingers": [0, 0, 2, 4, 1, 3],
            "key": "Bb",
            "midi": [53, 60, 61, 68],
            "frets": [-1, -1, 2, 4, 1, 3],
            "suffix": "m9",
            "baseFret": 2
        }, {
            "fingers": [3, 1, 0, 2, 4, 1],
            "key": "Bb",
            "suffix": "m9",
            "midi": [46, 49, 60, 65, 68],
            "frets": [3, 1, -1, 2, 3, 1],
            "barres": [1],
            "baseFret": 4,
            "capo": true
        }, {
            "midi": [46, 53, 56, 61, 65, 72],
            "barres": [1],
            "baseFret": 6,
            "suffix": "m9",
            "fingers": [1, 3, 1, 1, 1, 4],
            "frets": [1, 3, 1, 1, 1, 3],
            "key": "Bb",
            "capo": true
        }, {
            "baseFret": 11,
            "frets": [-1, 3, 1, 3, 3, -1],
            "barres": [],
            "fingers": [0, 2, 1, 3, 4, 0],
            "midi": [58, 61, 68, 72],
            "key": "Bb",
            "suffix": "m9"
        }, {
            "key": "Bb",
            "fingers": [2, 0, 1, 3, 3, 4],
            "suffix": "m6/9",
            "barres": [2],
            "frets": [2, -1, 1, 2, 2, 4],
            "baseFret": 5,
            "midi": [46, 55, 61, 65, 72]
        }, {
            "fingers": [1, 0, 2, 1, 3, 4],
            "midi": [46, 58, 61, 67, 72],
            "capo": true,
            "suffix": "m6/9",
            "barres": [1],
            "key": "Bb",
            "frets": [1, -1, 3, 1, 3, 3],
            "baseFret": 6
        }, {
            "fingers": [2, 0, 1, 4, 1, 1],
            "suffix": "m6/9",
            "barres": [1],
            "frets": [2, -1, 1, 3, 1, 1],
            "midi": [49, 58, 65, 67, 72],
            "capo": true,
            "baseFret": 8,
            "key": "Bb"
        }, {
            "suffix": "m6/9",
            "barres": [],
            "frets": [-1, 3, 1, 2, 3, -1],
            "midi": [58, 61, 67, 72],
            "key": "Bb",
            "baseFret": 11,
            "fingers": [0, 3, 1, 2, 4, 0]
        }, {
            "baseFret": 4,
            "capo": true,
            "fingers": [3, 1, 4, 2, 1, 1],
            "barres": [1],
            "key": "Bb",
            "frets": [3, 1, 3, 2, 1, 1],
            "suffix": "m11",
            "midi": [46, 49, 56, 60, 63, 68]
        }, {
            "capo": true,
            "suffix": "m11",
            "barres": [1],
            "key": "Bb",
            "frets": [1, 1, 1, 1, 1, 3],
            "midi": [46, 51, 56, 61, 65, 72],
            "baseFret": 6,
            "fingers": [1, 1, 1, 1, 1, 4]
        }, {
            "capo": true,
            "barres": [1],
            "frets": [-1, -1, 1, 1, 2, 2],
            "baseFret": 8,
            "suffix": "m11",
            "fingers": [0, 0, 1, 1, 2, 3],
            "key": "Bb",
            "midi": [58, 63, 68, 73]
        }, {
            "fingers": [0, 2, 1, 3, 4, 1],
            "capo": true,
            "frets": [-1, 3, 1, 3, 3, 1],
            "suffix": "m11",
            "midi": [58, 61, 68, 72, 75],
            "baseFret": 11,
            "key": "Bb",
            "barres": [1]
        }, {
            "barres": [1],
            "fingers": [0, 1, 4, 2, 3, 1],
            "frets": [-1, 1, 3, 2, 2, 1],
            "capo": true,
            "baseFret": 1,
            "suffix": "mmaj7",
            "key": "Bb",
            "midi": [46, 53, 57, 61, 65]
        }, {
            "frets": [1, 3, 2, 1, 1, 1],
            "fingers": [1, 3, 2, 1, 1, 1],
            "barres": [1],
            "key": "Bb",
            "midi": [46, 53, 57, 61, 65, 70],
            "baseFret": 6,
            "suffix": "mmaj7",
            "capo": true
        }, {
            "key": "Bb",
            "frets": [-1, 1, 1, 3, 3, 2],
            "midi": [53, 58, 65, 69, 73],
            "capo": true,
            "baseFret": 8,
            "suffix": "mmaj7",
            "barres": [1],
            "fingers": [0, 1, 1, 3, 4, 2]
        }, {
            "midi": [58, 61, 65, 69],
            "capo": true,
            "barres": [1],
            "key": "Bb",
            "frets": [-1, 4, 2, 1, 1, -1],
            "fingers": [0, 4, 2, 1, 1, 0],
            "suffix": "mmaj7",
            "baseFret": 10
        }, {
            "key": "Bb",
            "fingers": [0, 1, 2, 3, 4, 0],
            "frets": [-1, 1, 2, 2, 2, 0],
            "midi": [46, 52, 57, 61, 64],
            "barres": [],
            "baseFret": 1,
            "suffix": "mmaj7b5"
        }, {
            "fingers": [2, 4, 0, 3, 1, 1],
            "baseFret": 5,
            "midi": [46, 52, 61, 64, 69],
            "barres": [1],
            "frets": [2, 3, -1, 2, 1, 1],
            "capo": true,
            "key": "Bb",
            "suffix": "mmaj7b5"
        }, {
            "midi": [46, 52, 57, 61, 70],
            "key": "Bb",
            "baseFret": 6,
            "suffix": "mmaj7b5",
            "frets": [1, 2, 2, 1, -1, 1],
            "fingers": [1, 2, 3, 1, 0, 1],
            "barres": [1],
            "capo": true
        }, {
            "midi": [58, 64, 69, 73],
            "suffix": "mmaj7b5",
            "barres": [],
            "frets": [-1, -1, 1, 2, 3, 2],
            "fingers": [0, 0, 1, 2, 4, 3],
            "baseFret": 8,
            "key": "Bb"
        }, {
            "frets": [3, 1, -1, 2, 3, 2],
            "fingers": [3, 1, 0, 2, 4, 2],
            "barres": [2],
            "midi": [46, 49, 60, 65, 69],
            "baseFret": 4,
            "suffix": "mmaj9",
            "key": "Bb"
        }, {
            "frets": [3, 1, 4, 2, -1, -1],
            "barres": [],
            "midi": [46, 49, 57, 60],
            "baseFret": 4,
            "fingers": [3, 1, 4, 2, 0, 0],
            "key": "Bb",
            "suffix": "mmaj9"
        }, {
            "barres": [1],
            "frets": [1, 3, 2, 1, 1, 3],
            "key": "Bb",
            "baseFret": 6,
            "capo": true,
            "suffix": "mmaj9",
            "fingers": [1, 3, 2, 1, 1, 4],
            "midi": [46, 53, 57, 61, 65, 72]
        }, {
            "frets": [1, 1, 1, 3, 3, 2],
            "fingers": [1, 1, 1, 3, 4, 2],
            "midi": [48, 53, 58, 65, 69, 73],
            "suffix": "mmaj9",
            "barres": [1],
            "baseFret": 8,
            "key": "Bb",
            "capo": true
        }, {
            "capo": true,
            "barres": [1],
            "fingers": [0, 1, 1, 2, 3, 1],
            "midi": [46, 51, 57, 61, 65],
            "baseFret": 1,
            "key": "Bb",
            "suffix": "mmaj11",
            "frets": [-1, 1, 1, 2, 2, 1]
        }, {
            "suffix": "mmaj11",
            "baseFret": 6,
            "fingers": [1, 1, 2, 1, 1, 4],
            "capo": true,
            "midi": [46, 51, 57, 61, 65, 72],
            "key": "Bb",
            "barres": [1],
            "frets": [1, 1, 2, 1, 1, 3]
        }, {
            "capo": true,
            "frets": [-1, 1, 1, 1, 3, 2],
            "midi": [53, 58, 63, 69, 73],
            "baseFret": 8,
            "barres": [1],
            "key": "Bb",
            "suffix": "mmaj11",
            "fingers": [0, 1, 1, 1, 3, 2]
        }, {
            "baseFret": 11,
            "barres": [1],
            "frets": [-1, 3, 1, 4, 3, 1],
            "fingers": [0, 2, 1, 4, 3, 1],
            "suffix": "mmaj11",
            "midi": [58, 61, 69, 72, 75],
            "key": "Bb",
            "capo": true
        }, {
            "baseFret": 1,
            "barres": [],
            "suffix": "add9",
            "midi": [46, 50, 58, 60, 65],
            "key": "Bb",
            "fingers": [0, 1, 0, 4, 2, 3],
            "frets": [-1, 1, 0, 3, 1, 1]
        }, {
            "barres": [],
            "baseFret": 6,
            "frets": [-1, -1, 3, 2, 1, 3],
            "suffix": "add9",
            "key": "Bb",
            "midi": [58, 62, 65, 72],
            "fingers": [0, 0, 3, 2, 1, 4]
        }, {
            "suffix": "add9",
            "fingers": [0, 0, 2, 1, 0, 3],
            "frets": [-1, -1, 2, 1, -1, 2],
            "midi": [58, 62, 72],
            "baseFret": 7,
            "barres": [],
            "key": "Bb"
        }, {
            "barres": [1],
            "frets": [-1, 4, 3, 1, 4, 1],
            "midi": [58, 62, 65, 72, 74],
            "capo": true,
            "baseFret": 10,
            "suffix": "add9",
            "fingers": [0, 3, 2, 1, 4, 1],
            "key": "Bb"
        }, {
            "barres": [],
            "key": "Bb",
            "fingers": [0, 4, 2, 3, 1, 0],
            "midi": [49, 53, 58, 60],
            "baseFret": 1,
            "frets": [-1, 4, 3, 3, 1, -1],
            "suffix": "madd9"
        }, {
            "frets": [3, 1, -1, 2, 3, -1],
            "suffix": "madd9",
            "midi": [46, 49, 60, 65],
            "barres": [],
            "key": "Bb",
            "fingers": [3, 1, 0, 2, 4, 0],
            "baseFret": 4
        }, {
            "key": "Bb",
            "frets": [-1, -1, 3, 1, 1, 3],
            "midi": [58, 61, 65, 72],
            "baseFret": 6,
            "fingers": [0, 0, 3, 1, 1, 4],
            "suffix": "madd9",
            "capo": true,
            "barres": [1]
        }, {
            "baseFret": 10,
            "suffix": "madd9",
            "barres": [],
            "fingers": [0, 3, 2, 1, 4, 0],
            "midi": [58, 61, 65, 72],
            "key": "Bb",
            "frets": [-1, 4, 2, 1, 4, -1]
        }, {
            "capo": true,
            "barres": [2],
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [42, 47, 54, 59, 63, 66],
            "baseFret": 1,
            "suffix": "major",
            "frets": [2, 2, 4, 4, 4, 2],
            "key": "B"
        }, {
            "barres": [1],
            "key": "B",
            "frets": [-1, -1, 1, 1, 1, 4],
            "baseFret": 4,
            "midi": [54, 59, 63, 71],
            "fingers": [0, 0, 1, 1, 1, 4],
            "suffix": "major",
            "capo": true
        }, {
            "baseFret": 7,
            "midi": [47, 54, 59, 63, 66, 71],
            "barres": [1],
            "suffix": "major",
            "key": "B",
            "fingers": [1, 3, 4, 2, 1, 1],
            "capo": true,
            "frets": [1, 3, 3, 2, 1, 1]
        }, {
            "frets": [-1, 1, 1, 3, 4, 3],
            "baseFret": 9,
            "key": "B",
            "capo": true,
            "barres": [1],
            "midi": [54, 59, 66, 71, 75],
            "suffix": "major",
            "fingers": [0, 1, 1, 2, 4, 3]
        }, {
            "key": "B",
            "suffix": "minor",
            "barres": [2],
            "fingers": [1, 1, 3, 4, 2, 1],
            "midi": [42, 47, 54, 59, 62, 66],
            "frets": [2, 2, 4, 4, 3, 2],
            "baseFret": 1,
            "capo": true
        }, {
            "capo": true,
            "baseFret": 7,
            "midi": [47, 54, 59, 62, 66, 71],
            "barres": [1],
            "frets": [1, 3, 3, 1, 1, 1],
            "fingers": [1, 3, 4, 1, 1, 1],
            "key": "B",
            "suffix": "minor"
        }, {
            "fingers": [0, 0, 1, 3, 4, 2],
            "baseFret": 9,
            "barres": [],
            "key": "B",
            "frets": [-1, -1, 1, 3, 4, 2],
            "midi": [59, 66, 71, 74],
            "suffix": "minor"
        }, {
            "fingers": [0, 0, 3, 2, 4, 1],
            "key": "B",
            "suffix": "minor",
            "baseFret": 10,
            "midi": [62, 66, 71, 74],
            "frets": [-1, -1, 3, 2, 3, 1],
            "barres": []
        }, {
            "key": "B",
            "baseFret": 1,
            "suffix": "dim",
            "midi": [47, 50, 59, 65],
            "barres": [],
            "frets": [-1, 2, 0, -1, 0, 1],
            "fingers": [0, 3, 0, 0, 0, 2]
        }, {
            "barres": [],
            "suffix": "dim",
            "key": "B",
            "frets": [-1, 2, 3, 4, 3, -1],
            "fingers": [0, 1, 2, 4, 3, 0],
            "baseFret": 1,
            "midi": [47, 53, 59, 62]
        }, {
            "suffix": "dim",
            "baseFret": 5,
            "fingers": [3, 1, 0, 4, 2, 0],
            "key": "B",
            "barres": [],
            "midi": [47, 50, 62, 65],
            "frets": [3, 1, -1, 3, 2, -1]
        }, {
            "fingers": [0, 0, 1, 2, 0, 3],
            "midi": [59, 65, 74],
            "suffix": "dim",
            "frets": [-1, -1, 1, 2, -1, 2],
            "baseFret": 9,
            "barres": [],
            "key": "B"
        }, {
            "frets": [-1, 2, 3, 1, 3, 1],
            "barres": [1],
            "fingers": [0, 2, 3, 1, 4, 1],
            "baseFret": 1,
            "key": "B",
            "midi": [47, 53, 56, 62, 65],
            "suffix": "dim7",
            "capo": true
        }, {
            "fingers": [0, 0, 1, 3, 2, 4],
            "key": "B",
            "midi": [53, 59, 62, 68],
            "suffix": "dim7",
            "barres": [],
            "baseFret": 1,
            "frets": [-1, -1, 3, 4, 3, 4]
        }, {
            "suffix": "dim7",
            "frets": [2, -1, 1, 2, 1, -1],
            "fingers": [3, 0, 1, 4, 2, 0],
            "key": "B",
            "midi": [47, 56, 62, 65],
            "barres": [],
            "baseFret": 6
        }, {
            "fingers": [1, 2, 3, 1, 4, 1],
            "baseFret": 7,
            "suffix": "dim7",
            "capo": true,
            "barres": [1],
            "frets": [1, 2, 3, 1, 3, 1],
            "midi": [47, 53, 59, 62, 68, 71],
            "key": "B"
        }, {
            "frets": [2, 2, 4, 4, 2, 2],
            "midi": [42, 47, 54, 59, 61, 66],
            "fingers": [1, 1, 3, 4, 1, 1],
            "baseFret": 1,
            "key": "B",
            "suffix": "sus2",
            "capo": true,
            "barres": [2]
        }, {
            "suffix": "sus2",
            "fingers": [2, 0, 0, 1, 3, 4],
            "barres": [],
            "frets": [2, -1, -1, 1, 2, 2],
            "baseFret": 6,
            "midi": [47, 61, 66, 71],
            "key": "B"
        }, {
            "baseFret": 9,
            "barres": [1],
            "midi": [49, 54, 59, 66, 71, 73],
            "key": "B",
            "fingers": [1, 1, 1, 3, 4, 1],
            "capo": true,
            "frets": [1, 1, 1, 3, 4, 1],
            "suffix": "sus2"
        }, {
            "barres": [1],
            "key": "B",
            "baseFret": 11,
            "frets": [-1, 4, 1, 1, 2, 4],
            "suffix": "sus2",
            "fingers": [0, 3, 1, 1, 2, 4],
            "midi": [59, 61, 66, 71, 78],
            "capo": true
        }, {
            "suffix": "sus4",
            "key": "B",
            "baseFret": 2,
            "fingers": [1, 1, 2, 3, 4, 1],
            "midi": [42, 47, 54, 59, 64, 66],
            "barres": [1],
            "capo": true,
            "frets": [1, 1, 3, 3, 4, 1]
        }, {
            "fingers": [0, 0, 1, 1, 2, 4],
            "capo": true,
            "baseFret": 4,
            "midi": [54, 59, 64, 71],
            "key": "B",
            "suffix": "sus4",
            "barres": [1],
            "frets": [-1, -1, 1, 1, 2, 4]
        }, {
            "frets": [1, 3, 3, 3, 1, 1],
            "suffix": "sus4",
            "midi": [47, 54, 59, 64, 66, 71],
            "key": "B",
            "fingers": [1, 2, 3, 4, 1, 1],
            "barres": [1],
            "baseFret": 7,
            "capo": true
        }, {
            "suffix": "sus4",
            "midi": [54, 59, 66, 71, 76],
            "barres": [1, 4],
            "fingers": [0, 1, 1, 3, 4, 4],
            "frets": [-1, 1, 1, 3, 4, 4],
            "capo": true,
            "key": "B",
            "baseFret": 9
        }, {
            "suffix": "7sus4",
            "barres": [],
            "baseFret": 1,
            "key": "B",
            "frets": [-1, 2, 2, 2, 0, 0],
            "fingers": [0, 1, 2, 3, 0, 0],
            "midi": [47, 52, 57, 59, 64]
        }, {
            "suffix": "7sus4",
            "capo": true,
            "barres": [1],
            "midi": [42, 47, 54, 57, 64, 66],
            "fingers": [1, 1, 3, 1, 4, 1],
            "frets": [1, 1, 3, 1, 4, 1],
            "baseFret": 2,
            "key": "B"
        }, {
            "suffix": "7sus4",
            "fingers": [0, 0, 1, 1, 2, 2],
            "midi": [54, 59, 64, 69],
            "capo": true,
            "baseFret": 4,
            "barres": [1, 2],
            "key": "B",
            "frets": [-1, -1, 1, 1, 2, 2]
        }, {
            "capo": true,
            "baseFret": 7,
            "suffix": "7sus4",
            "midi": [47, 54, 57, 64, 66, 71],
            "frets": [1, 3, 1, 3, 1, 1],
            "fingers": [1, 3, 1, 4, 1, 1],
            "barres": [1],
            "key": "B"
        }, {
            "frets": [-1, 2, 3, 4, 4, -1],
            "baseFret": 1,
            "fingers": [0, 1, 2, 3, 4, 0],
            "suffix": "alt",
            "key": "B",
            "barres": [],
            "midi": [47, 53, 59, 63]
        }, {
            "barres": [],
            "midi": [59, 63, 65, 71],
            "baseFret": 6,
            "key": "B",
            "fingers": [0, 0, 4, 3, 1, 2],
            "frets": [-1, -1, 4, 3, 1, 2],
            "suffix": "alt"
        }, {
            "baseFret": 7,
            "frets": [1, 2, 3, 2, 0, -1],
            "barres": [],
            "midi": [47, 53, 59, 63, 59],
            "key": "B",
            "suffix": "alt",
            "fingers": [1, 2, 4, 3, 0, 0]
        }, {
            "fingers": [0, 0, 1, 2, 0, 3],
            "barres": [],
            "midi": [59, 65, 59, 75],
            "key": "B",
            "suffix": "alt",
            "frets": [-1, -1, 1, 2, 0, 3],
            "baseFret": 9
        }, {
            "suffix": "aug",
            "barres": [],
            "baseFret": 1,
            "fingers": [0, 2, 1, 0, 0, 0],
            "midi": [47, 51, 55, 59],
            "key": "B",
            "frets": [-1, 2, 1, 0, 0, -1]
        }, {
            "key": "B",
            "midi": [55, 59, 63, 67],
            "barres": [],
            "baseFret": 3,
            "frets": [-1, -1, 3, 2, 2, 1],
            "fingers": [0, 0, 4, 2, 3, 1],
            "suffix": "aug"
        }, {
            "suffix": "aug",
            "midi": [47, 59, 63, 67],
            "frets": [1, -1, 3, 2, 2, -1],
            "fingers": [1, 0, 4, 2, 3, 0],
            "barres": [],
            "baseFret": 7,
            "key": "B"
        }, {
            "suffix": "aug",
            "fingers": [0, 3, 2, 1, 1, 0],
            "barres": [1],
            "capo": true,
            "key": "B",
            "baseFret": 12,
            "frets": [-1, 3, 2, 1, 1, 0],
            "midi": [59, 63, 67, 71, 64]
        }, {
            "midi": [47, 51, 56, 59],
            "fingers": [0, 3, 1, 2, 0, 0],
            "frets": [-1, 2, 1, 1, 0, -1],
            "barres": [],
            "baseFret": 1,
            "suffix": "6",
            "key": "B"
        }, {
            "barres": [4],
            "frets": [-1, 2, 4, 4, 4, 4],
            "fingers": [0, 1, 3, 3, 3, 3],
            "baseFret": 1,
            "suffix": "6",
            "midi": [47, 54, 59, 63, 68],
            "key": "B"
        }, {
            "baseFret": 7,
            "key": "B",
            "suffix": "6",
            "fingers": [1, 0, 3, 2, 4, 0],
            "frets": [1, -1, 3, 2, 3, -1],
            "barres": [],
            "midi": [47, 59, 63, 68]
        }, {
            "capo": true,
            "key": "B",
            "baseFret": 9,
            "fingers": [0, 0, 1, 3, 1, 4],
            "suffix": "6",
            "midi": [59, 66, 68, 75],
            "frets": [-1, -1, 1, 3, 1, 3],
            "barres": [1]
        }, {
            "midi": [47, 51, 56, 61, 66],
            "frets": [-1, 2, 1, 1, 2, 2],
            "baseFret": 1,
            "suffix": "6/9",
            "fingers": [0, 2, 1, 1, 3, 4],
            "key": "B",
            "capo": true,
            "barres": [1]
        }, {
            "fingers": [2, 1, 1, 1, 3, 4],
            "suffix": "6/9",
            "capo": true,
            "midi": [47, 51, 56, 61, 66, 71],
            "barres": [1],
            "frets": [2, 1, 1, 1, 2, 2],
            "baseFret": 6,
            "key": "B"
        }, {
            "fingers": [0, 2, 2, 1, 3, 4],
            "midi": [54, 59, 63, 68, 73],
            "frets": [-1, 2, 2, 1, 2, 2],
            "key": "B",
            "barres": [2],
            "baseFret": 8,
            "suffix": "6/9"
        }, {
            "capo": true,
            "frets": [-1, 4, 1, 3, 2, 1],
            "midi": [59, 61, 68, 71, 75],
            "key": "B",
            "suffix": "6/9",
            "baseFret": 11,
            "barres": [1],
            "fingers": [0, 4, 1, 3, 2, 1]
        }, {
            "key": "B",
            "suffix": "7",
            "frets": [-1, 2, 1, 2, 0, 2],
            "fingers": [0, 2, 1, 3, 0, 4],
            "barres": [],
            "baseFret": 1,
            "midi": [47, 51, 57, 59, 66]
        }, {
            "baseFret": 1,
            "midi": [42, 47, 54, 57, 63, 66],
            "key": "B",
            "frets": [2, 2, 4, 2, 4, 2],
            "suffix": "7",
            "barres": [2],
            "fingers": [1, 1, 3, 1, 4, 1],
            "capo": true
        }, {
            "barres": [1],
            "baseFret": 4,
            "suffix": "7",
            "capo": true,
            "midi": [54, 59, 63, 69],
            "fingers": [0, 0, 1, 1, 1, 2],
            "key": "B",
            "frets": [-1, -1, 1, 1, 1, 2]
        }, {
            "capo": true,
            "key": "B",
            "barres": [1],
            "fingers": [1, 3, 1, 2, 1, 1],
            "baseFret": 7,
            "midi": [47, 54, 57, 63, 66, 71],
            "suffix": "7",
            "frets": [1, 3, 1, 2, 1, 1]
        }, {
            "midi": [47, 51, 57, 59, 65],
            "suffix": "7b5",
            "frets": [-1, 2, 1, 2, 0, 1],
            "fingers": [0, 3, 1, 4, 0, 2],
            "barres": [],
            "key": "B",
            "baseFret": 1
        }, {
            "key": "B",
            "suffix": "7b5",
            "midi": [47, 53, 57, 63],
            "barres": [],
            "frets": [-1, 2, 3, 2, 4, -1],
            "baseFret": 1,
            "fingers": [0, 1, 2, 1, 3, 0]
        }, {
            "fingers": [2, 0, 3, 4, 1, 0],
            "midi": [47, 57, 63, 65],
            "baseFret": 6,
            "barres": [],
            "key": "B",
            "frets": [2, -1, 2, 3, 1, -1],
            "suffix": "7b5"
        }, {
            "midi": [59, 65, 69, 75],
            "suffix": "7b5",
            "barres": [],
            "fingers": [0, 0, 1, 2, 3, 4],
            "frets": [-1, -1, 1, 2, 2, 3],
            "baseFret": 9,
            "key": "B"
        }, {
            "frets": [-1, 2, 1, 2, 0, 3],
            "barres": [],
            "fingers": [0, 2, 1, 3, 0, 4],
            "key": "B",
            "baseFret": 1,
            "midi": [47, 51, 57, 59, 67],
            "suffix": "aug7"
        }, {
            "capo": true,
            "frets": [-1, 1, 4, 1, 3, 2],
            "fingers": [0, 0, 2, 1, 1, 3],
            "key": "B",
            "midi": [47, 55, 57, 63, 67],
            "baseFret": 2,
            "barres": [1],
            "suffix": "aug7"
        }, {
            "suffix": "aug7",
            "fingers": [1, 0, 2, 3, 4, 0],
            "frets": [1, -1, 1, 2, 2, -1],
            "baseFret": 7,
            "barres": [],
            "key": "B",
            "midi": [47, 57, 63, 67]
        }, {
            "frets": [-1, -1, 1, 4, 2, 3],
            "barres": [],
            "key": "B",
            "suffix": "aug7",
            "baseFret": 9,
            "fingers": [0, 0, 1, 4, 2, 3],
            "midi": [59, 67, 69, 75]
        }, {
            "baseFret": 1,
            "barres": [2],
            "midi": [47, 51, 57, 61, 66],
            "frets": [-1, 2, 1, 2, 2, 2],
            "key": "B",
            "suffix": "9",
            "fingers": [0, 2, 1, 3, 3, 4]
        }, {
            "barres": [1],
            "fingers": [4, 1, 1, 3, 1, 2],
            "capo": true,
            "suffix": "9",
            "baseFret": 4,
            "midi": [47, 49, 54, 61, 63, 69],
            "frets": [4, 1, 1, 3, 1, 2],
            "key": "B"
        }, {
            "capo": true,
            "suffix": "9",
            "frets": [1, 3, 1, 2, 1, 3],
            "barres": [1],
            "key": "B",
            "midi": [47, 54, 57, 63, 66, 73],
            "fingers": [1, 3, 1, 2, 1, 4],
            "baseFret": 7
        }, {
            "barres": [],
            "fingers": [0, 0, 2, 1, 4, 3],
            "baseFret": 8,
            "midi": [59, 63, 69, 73],
            "frets": [-1, -1, 2, 1, 3, 2],
            "suffix": "9",
            "key": "B"
        }, {
            "suffix": "9b5",
            "frets": [-1, 2, 1, 2, 2, 1],
            "capo": true,
            "key": "B",
            "fingers": [0, 2, 1, 3, 4, 1],
            "midi": [47, 51, 57, 61, 65],
            "baseFret": 1,
            "barres": [1]
        }, {
            "key": "B",
            "midi": [47, 51, 57, 61, 65, 71],
            "suffix": "9b5",
            "fingers": [2, 1, 3, 1, 1, 4],
            "capo": true,
            "barres": [1],
            "baseFret": 6,
            "frets": [2, 1, 2, 1, 1, 2]
        }, {
            "baseFret": 7,
            "suffix": "9b5",
            "frets": [1, 2, 1, 2, -1, 3],
            "midi": [47, 53, 57, 63, 73],
            "fingers": [1, 2, 1, 3, 0, 4],
            "capo": true,
            "barres": [1],
            "key": "B"
        }, {
            "midi": [59, 63, 69, 73, 77],
            "capo": true,
            "frets": [-1, 2, 1, 2, 2, 1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "key": "B",
            "baseFret": 13,
            "suffix": "9b5",
            "barres": [1]
        }, {
            "key": "B",
            "barres": [2],
            "baseFret": 1,
            "fingers": [0, 2, 1, 3, 3, 4],
            "suffix": "aug9",
            "midi": [47, 51, 57, 61, 67],
            "frets": [-1, 2, 1, 2, 2, 3]
        }, {
            "fingers": [2, 1, 3, 1, 1, 4],
            "key": "B",
            "suffix": "aug9",
            "frets": [2, 1, 2, 1, 1, 2],
            "capo": true,
            "midi": [45, 49, 55, 59, 63, 69],
            "barres": [1],
            "baseFret": 4
        }, {
            "capo": true,
            "key": "B",
            "frets": [2, 1, 2, 1, 3, -1],
            "barres": [1],
            "fingers": [2, 1, 3, 1, 4, 0],
            "suffix": "aug9",
            "midi": [47, 51, 57, 61, 67],
            "baseFret": 6
        }, {
            "suffix": "aug9",
            "capo": true,
            "barres": [1],
            "fingers": [1, 2, 1, 3, 4, 1],
            "midi": [51, 57, 61, 67, 71, 75],
            "frets": [1, 2, 1, 2, 2, 1],
            "baseFret": 11,
            "key": "B"
        }, {
            "baseFret": 1,
            "capo": true,
            "barres": [1],
            "fingers": [0, 2, 1, 3, 1, 4],
            "key": "B",
            "suffix": "7b9",
            "midi": [47, 51, 57, 60, 66],
            "frets": [-1, 2, 1, 2, 1, 2]
        }, {
            "baseFret": 5,
            "key": "B",
            "suffix": "7b9",
            "frets": [3, 2, 3, 1, -1, -1],
            "fingers": [3, 2, 4, 1, 0, 0],
            "barres": [],
            "midi": [47, 51, 57, 60]
        }, {
            "capo": true,
            "barres": [1],
            "key": "B",
            "midi": [47, 57, 63, 66, 72],
            "frets": [1, -1, 1, 2, 1, 2],
            "fingers": [1, 0, 1, 2, 1, 3],
            "baseFret": 7,
            "suffix": "7b9"
        }, {
            "fingers": [0, 0, 2, 1, 3, 1],
            "barres": [1],
            "key": "B",
            "frets": [-1, -1, 2, 1, 3, 1],
            "baseFret": 8,
            "midi": [59, 63, 69, 72],
            "suffix": "7b9"
        }, {
            "midi": [47, 51, 57, 62],
            "barres": [],
            "key": "B",
            "fingers": [0, 2, 1, 3, 4, 0],
            "suffix": "7#9",
            "frets": [-1, 2, 1, 2, 3, -1],
            "baseFret": 1
        }, {
            "fingers": [3, 2, 0, 4, 0, 1],
            "key": "B",
            "suffix": "7#9",
            "frets": [3, 2, 0, 3, 0, 1],
            "midi": [47, 51, 50, 62, 59, 69],
            "baseFret": 5,
            "barres": []
        }, {
            "capo": true,
            "barres": [1, 4],
            "fingers": [1, 3, 1, 2, 4, 4],
            "baseFret": 7,
            "frets": [1, 3, 1, 2, 4, 4],
            "midi": [47, 54, 57, 63, 69, 74],
            "suffix": "7#9",
            "key": "B"
        }, {
            "frets": [-1, -1, 2, 1, 3, 3],
            "key": "B",
            "barres": [],
            "baseFret": 8,
            "suffix": "7#9",
            "midi": [59, 63, 69, 74],
            "fingers": [0, 0, 2, 1, 3, 4]
        }, {
            "barres": [],
            "suffix": "11",
            "midi": [47, 51, 57, 59, 64],
            "key": "B",
            "fingers": [0, 2, 1, 3, 0, 0],
            "frets": [-1, 2, 1, 2, 0, 0],
            "baseFret": 1
        }, {
            "suffix": "11",
            "key": "B",
            "midi": [42, 47, 52, 57, 63, 66],
            "barres": [2],
            "frets": [2, 2, 2, 2, 4, 2],
            "fingers": [1, 1, 1, 1, 3, 1],
            "capo": true,
            "baseFret": 1
        }, {
            "fingers": [1, 1, 1, 2, 1, 1],
            "baseFret": 7,
            "frets": [1, 1, 1, 2, 1, 1],
            "capo": true,
            "suffix": "11",
            "barres": [1],
            "key": "B",
            "midi": [47, 52, 57, 63, 66, 71]
        }, {
            "suffix": "11",
            "capo": true,
            "midi": [49, 54, 59, 64, 69, 75],
            "barres": [1],
            "baseFret": 9,
            "fingers": [1, 1, 1, 1, 2, 3],
            "frets": [1, 1, 1, 1, 2, 3],
            "key": "B"
        }, {
            "midi": [47, 51, 57, 61, 65],
            "key": "B",
            "baseFret": 1,
            "barres": [1],
            "fingers": [0, 2, 1, 3, 4, 1],
            "capo": true,
            "suffix": "9#11",
            "frets": [-1, 2, 1, 2, 2, 1]
        }, {
            "baseFret": 1,
            "key": "B",
            "barres": [2],
            "frets": [-1, 2, 3, 2, 4, 2],
            "midi": [47, 53, 57, 63, 66],
            "suffix": "9#11",
            "fingers": [0, 1, 2, 1, 3, 1],
            "capo": true
        }, {
            "baseFret": 6,
            "key": "B",
            "midi": [47, 57, 63, 65],
            "frets": [2, -1, 2, 3, 1, -1],
            "fingers": [2, 0, 3, 4, 1, 0],
            "barres": [],
            "suffix": "9#11"
        }, {
            "fingers": [0, 0, 1, 2, 3, 4],
            "suffix": "9#11",
            "barres": [],
            "baseFret": 9,
            "midi": [59, 65, 69, 75],
            "key": "B",
            "frets": [-1, -1, 1, 2, 2, 3]
        }, {
            "key": "B",
            "midi": [47, 51, 57, 63, 68],
            "suffix": "13",
            "baseFret": 1,
            "barres": [4],
            "fingers": [0, 2, 1, 3, 4, 4],
            "frets": [-1, 2, 1, 2, 4, 4]
        }, {
            "fingers": [1, 1, 1, 1, 3, 4],
            "suffix": "13",
            "baseFret": 1,
            "key": "B",
            "barres": [2],
            "midi": [42, 47, 52, 57, 63, 68],
            "capo": true,
            "frets": [2, 2, 2, 2, 4, 4]
        }, {
            "frets": [4, 1, 3, 1, 1, 2],
            "fingers": [4, 1, 3, 1, 1, 2],
            "baseFret": 4,
            "key": "B",
            "suffix": "13",
            "midi": [47, 49, 56, 59, 63, 69],
            "capo": true,
            "barres": [1]
        }, {
            "barres": [1],
            "capo": true,
            "baseFret": 7,
            "midi": [47, 52, 57, 63, 68, 73],
            "key": "B",
            "frets": [1, 1, 1, 2, 3, 3],
            "suffix": "13",
            "fingers": [1, 1, 1, 2, 3, 4]
        }, {
            "fingers": [1, 1, 3, 2, 4, 1],
            "midi": [42, 47, 54, 58, 63, 66],
            "frets": [2, 2, 4, 3, 4, 2],
            "baseFret": 1,
            "barres": [2],
            "key": "B",
            "suffix": "maj7",
            "capo": true
        }, {
            "frets": [-1, -1, 1, 1, 1, 3],
            "fingers": [0, 0, 1, 1, 1, 4],
            "capo": true,
            "midi": [54, 59, 63, 70],
            "key": "B",
            "suffix": "maj7",
            "baseFret": 4,
            "barres": [1]
        }, {
            "baseFret": 7,
            "frets": [1, 3, 2, 2, 1, 1],
            "fingers": [1, 4, 2, 3, 1, 1],
            "key": "B",
            "midi": [47, 54, 58, 63, 66, 71],
            "suffix": "maj7",
            "capo": true,
            "barres": [1]
        }, {
            "suffix": "maj7",
            "baseFret": 9,
            "frets": [-1, 1, 1, 3, 3, 3],
            "fingers": [0, 1, 1, 3, 3, 3],
            "midi": [54, 59, 66, 70, 75],
            "capo": true,
            "barres": [1, 3],
            "key": "B"
        }, {
            "frets": [-1, 2, 3, 3, 4, -1],
            "suffix": "maj7b5",
            "key": "B",
            "midi": [47, 53, 58, 63],
            "fingers": [0, 1, 2, 3, 4, 0],
            "barres": [],
            "baseFret": 1
        }, {
            "baseFret": 6,
            "barres": [1],
            "fingers": [2, 1, 3, 4, 1, 1],
            "midi": [47, 51, 58, 63, 65, 70],
            "suffix": "maj7b5",
            "key": "B",
            "capo": true,
            "frets": [2, 1, 3, 3, 1, 1]
        }, {
            "barres": [],
            "midi": [47, 53, 58, 63, 59],
            "baseFret": 7,
            "fingers": [1, 2, 3, 4, 0, 0],
            "frets": [1, 2, 2, 2, 0, -1],
            "suffix": "maj7b5",
            "key": "B"
        }, {
            "frets": [-1, -1, 1, 2, 3, 3],
            "midi": [59, 65, 70, 75],
            "barres": [],
            "fingers": [0, 0, 1, 2, 3, 4],
            "baseFret": 9,
            "suffix": "maj7b5",
            "key": "B"
        }, {
            "frets": [-1, 2, 1, 3, 0, 3],
            "midi": [47, 51, 58, 59, 67],
            "suffix": "maj7#5",
            "barres": [],
            "key": "B",
            "baseFret": 1,
            "fingers": [0, 2, 1, 3, 0, 4]
        }, {
            "key": "B",
            "midi": [47, 55, 58, 63],
            "fingers": [0, 1, 4, 2, 3, 0],
            "barres": [],
            "baseFret": 2,
            "suffix": "maj7#5",
            "frets": [-1, 1, 4, 2, 3, -1]
        }, {
            "barres": [],
            "key": "B",
            "frets": [2, 1, 3, 0, 3, -1],
            "midi": [47, 51, 58, 55, 67],
            "baseFret": 6,
            "fingers": [2, 1, 3, 0, 3, 0],
            "suffix": "maj7#5"
        }, {
            "fingers": [1, 4, 3, 2, 1, 1],
            "barres": [1],
            "baseFret": 11,
            "suffix": "maj7#5",
            "frets": [1, 4, 3, 2, 1, 1],
            "key": "B",
            "capo": true,
            "midi": [51, 59, 63, 67, 70, 75]
        }, {
            "midi": [42, 47, 51, 58, 61],
            "barres": [2],
            "suffix": "maj9",
            "frets": [2, 2, 1, 3, 2, -1],
            "fingers": [2, 2, 1, 4, 3, 0],
            "baseFret": 1,
            "key": "B"
        }, {
            "baseFret": 4,
            "midi": [54, 61, 63, 70],
            "barres": [1],
            "frets": [-1, -1, 1, 3, 1, 3],
            "capo": true,
            "key": "B",
            "fingers": [0, 0, 1, 3, 1, 4],
            "suffix": "maj9"
        }, {
            "midi": [47, 51, 58, 61, 66],
            "barres": [1],
            "frets": [2, 1, 3, 1, 2, -1],
            "key": "B",
            "fingers": [2, 1, 4, 1, 3, 0],
            "baseFret": 6,
            "suffix": "maj9"
        }, {
            "barres": [],
            "key": "B",
            "fingers": [0, 0, 2, 1, 4, 3],
            "baseFret": 8,
            "midi": [59, 63, 70, 73],
            "suffix": "maj9",
            "frets": [-1, -1, 2, 1, 4, 2]
        }, {
            "baseFret": 1,
            "key": "B",
            "barres": [],
            "suffix": "maj11",
            "frets": [-1, 2, 1, 3, 0, 0],
            "fingers": [0, 2, 1, 3, 0, 0],
            "midi": [47, 51, 58, 59, 64]
        }, {
            "baseFret": 1,
            "suffix": "maj11",
            "fingers": [1, 1, 1, 2, 3, 1],
            "key": "B",
            "capo": true,
            "midi": [42, 47, 52, 58, 63, 66],
            "frets": [2, 2, 2, 3, 4, 2],
            "barres": [2]
        }, {
            "key": "B",
            "midi": [47, 52, 58, 63, 66, 73],
            "suffix": "maj11",
            "capo": true,
            "barres": [1],
            "frets": [1, 1, 2, 2, 1, 3],
            "fingers": [1, 1, 2, 2, 1, 3],
            "baseFret": 7
        }, {
            "fingers": [0, 0, 1, 1, 3, 4],
            "midi": [59, 64, 70, 75],
            "frets": [-1, -1, 1, 1, 3, 3],
            "baseFret": 9,
            "suffix": "maj11",
            "barres": [1],
            "capo": true,
            "key": "B"
        }, {
            "barres": [2],
            "midi": [47, 52, 58, 63, 68],
            "key": "B",
            "baseFret": 1,
            "frets": [-1, 2, 2, 3, 4, 4],
            "capo": true,
            "fingers": [0, 1, 1, 2, 3, 4],
            "suffix": "maj13"
        }, {
            "frets": [2, 1, 1, 1, 2, 1],
            "fingers": [2, 1, 1, 1, 3, 1],
            "baseFret": 6,
            "midi": [47, 51, 56, 61, 66, 70],
            "key": "B",
            "suffix": "maj13",
            "capo": true,
            "barres": [1]
        }, {
            "key": "B",
            "suffix": "maj13",
            "midi": [47, 52, 58, 63, 68, 71],
            "frets": [1, 1, 2, 2, 3, 1],
            "barres": [1],
            "capo": true,
            "fingers": [1, 1, 2, 3, 4, 1],
            "baseFret": 7
        }, {
            "suffix": "maj13",
            "capo": true,
            "midi": [59, 63, 68, 70, 75],
            "key": "B",
            "baseFret": 11,
            "frets": [-1, 4, 3, 3, 1, 1],
            "barres": [1],
            "fingers": [0, 4, 2, 3, 1, 1]
        }, {
            "baseFret": 1,
            "suffix": "m6",
            "key": "B",
            "barres": [],
            "midi": [42, 47, 50, 56, 59, 66],
            "frets": [2, 2, 0, 1, 0, 2],
            "fingers": [2, 3, 0, 1, 0, 4]
        }, {
            "fingers": [0, 0, 2, 3, 1, 4],
            "barres": [],
            "suffix": "m6",
            "frets": [-1, -1, 4, 4, 3, 4],
            "midi": [54, 59, 62, 68],
            "baseFret": 1,
            "key": "B"
        }, {
            "barres": [],
            "midi": [47, 56, 62, 66],
            "baseFret": 6,
            "key": "B",
            "fingers": [2, 0, 1, 3, 4, 0],
            "suffix": "m6",
            "frets": [2, -1, 1, 2, 2, -1]
        }, {
            "key": "B",
            "suffix": "m6",
            "barres": [1],
            "midi": [47, 54, 59, 62, 68, 71],
            "capo": true,
            "frets": [1, 3, 3, 1, 3, 1],
            "fingers": [1, 2, 3, 1, 4, 1],
            "baseFret": 7
        }, {
            "barres": [2],
            "fingers": [1, 1, 3, 1, 2, 1],
            "midi": [42, 47, 54, 57, 62, 66],
            "frets": [2, 2, 4, 2, 3, 2],
            "baseFret": 1,
            "key": "B",
            "suffix": "m7",
            "capo": true
        }, {
            "midi": [54, 59, 62, 69],
            "suffix": "m7",
            "key": "B",
            "frets": [-1, -1, 2, 2, 1, 3],
            "barres": [],
            "fingers": [0, 0, 2, 3, 1, 4],
            "baseFret": 3
        }, {
            "baseFret": 7,
            "barres": [1],
            "frets": [1, 3, 1, 1, 1, 1],
            "midi": [47, 54, 57, 62, 66, 71],
            "key": "B",
            "capo": true,
            "fingers": [1, 3, 1, 1, 1, 1],
            "suffix": "m7"
        }, {
            "capo": true,
            "frets": [-1, 1, 1, 3, 2, 2],
            "key": "B",
            "fingers": [0, 1, 1, 4, 2, 3],
            "barres": [1],
            "baseFret": 9,
            "midi": [54, 59, 66, 69, 74],
            "suffix": "m7"
        }, {
            "barres": [],
            "fingers": [0, 1, 3, 2, 4, 0],
            "frets": [-1, 2, 3, 2, 3, -1],
            "baseFret": 1,
            "key": "B",
            "midi": [47, 53, 57, 62],
            "suffix": "m7b5"
        }, {
            "midi": [47, 57, 62, 65],
            "frets": [2, -1, 2, 2, 1, -1],
            "suffix": "m7b5",
            "barres": [],
            "baseFret": 6,
            "fingers": [2, 0, 3, 4, 1, 0],
            "key": "B"
        }, {
            "capo": true,
            "suffix": "m7b5",
            "baseFret": 7,
            "barres": [1],
            "key": "B",
            "midi": [47, 53, 59, 62, 69, 71],
            "frets": [1, 2, 3, 1, 4, 1],
            "fingers": [1, 2, 3, 1, 4, 1]
        }, {
            "barres": [2],
            "key": "B",
            "baseFret": 9,
            "frets": [-1, -1, 1, 2, 2, 2],
            "midi": [59, 65, 69, 74],
            "suffix": "m7b5",
            "fingers": [0, 0, 1, 2, 2, 2]
        }, {
            "midi": [47, 50, 57, 61, 66],
            "barres": [],
            "key": "B",
            "frets": [-1, 2, 0, 2, 2, 2],
            "suffix": "m9",
            "fingers": [0, 1, 0, 2, 3, 4],
            "baseFret": 1
        }, {
            "midi": [49, 54, 59, 62, 69],
            "suffix": "m9",
            "barres": [2],
            "baseFret": 3,
            "frets": [-1, 2, 2, 2, 1, 3],
            "key": "B",
            "fingers": [0, 2, 3, 3, 1, 4]
        }, {
            "suffix": "m9",
            "baseFret": 7,
            "barres": [1],
            "key": "B",
            "frets": [1, 3, 1, 1, 1, 3],
            "fingers": [1, 3, 1, 1, 1, 4],
            "midi": [47, 54, 57, 62, 66, 73],
            "capo": true
        }, {
            "key": "B",
            "midi": [50, 57, 61, 66, 71, 74],
            "fingers": [1, 3, 2, 2, 4, 1],
            "capo": true,
            "barres": [1, 2],
            "suffix": "m9",
            "frets": [1, 3, 2, 2, 3, 1],
            "baseFret": 10
        }, {
            "key": "B",
            "barres": [],
            "fingers": [0, 2, 0, 1, 3, 4],
            "midi": [47, 50, 56, 61, 66],
            "baseFret": 1,
            "suffix": "m6/9",
            "frets": [-1, 2, 0, 1, 2, 2]
        }, {
            "midi": [50, 56, 61, 66, 71],
            "suffix": "m6/9",
            "fingers": [0, 1, 2, 2, 3, 3],
            "key": "B",
            "baseFret": 5,
            "frets": [-1, 1, 2, 2, 3, 3],
            "barres": [2, 3]
        }, {
            "midi": [47, 54, 59, 62, 68, 73],
            "fingers": [1, 2, 2, 1, 3, 4],
            "suffix": "m6/9",
            "barres": [1, 3],
            "frets": [1, 3, 3, 1, 3, 3],
            "key": "B",
            "capo": true,
            "baseFret": 7
        }, {
            "fingers": [2, 0, 1, 3, 1, 1],
            "midi": [50, 59, 66, 68, 73],
            "baseFret": 9,
            "frets": [2, -1, 1, 3, 1, 1],
            "suffix": "m6/9",
            "key": "B",
            "barres": [1],
            "capo": true
        }, {
            "midi": [47, 50, 57, 61, 64],
            "barres": [],
            "fingers": [0, 1, 0, 2, 3, 0],
            "suffix": "m11",
            "baseFret": 1,
            "frets": [-1, 2, 0, 2, 2, 0],
            "key": "B"
        }, {
            "baseFret": 5,
            "suffix": "m11",
            "fingers": [3, 1, 4, 2, 1, 1],
            "capo": true,
            "key": "B",
            "barres": [1],
            "midi": [47, 50, 57, 61, 64, 69],
            "frets": [3, 1, 3, 2, 1, 1]
        }, {
            "capo": true,
            "frets": [1, 1, 1, 1, 1, 3],
            "barres": [1],
            "midi": [47, 52, 57, 62, 66, 73],
            "fingers": [1, 1, 1, 1, 1, 4],
            "baseFret": 7,
            "key": "B",
            "suffix": "m11"
        }, {
            "suffix": "m11",
            "frets": [-1, -1, 1, 1, 2, 2],
            "midi": [59, 64, 69, 74],
            "fingers": [0, 0, 1, 1, 2, 3],
            "baseFret": 9,
            "key": "B",
            "capo": true,
            "barres": [1, 2]
        }, {
            "key": "B",
            "frets": [-1, 2, 0, 3, 0, 2],
            "fingers": [0, 1, 0, 3, 0, 2],
            "midi": [47, 50, 58, 59, 66],
            "baseFret": 1,
            "suffix": "mmaj7",
            "barres": []
        }, {
            "baseFret": 1,
            "fingers": [1, 1, 4, 2, 3, 1],
            "barres": [2],
            "key": "B",
            "midi": [42, 47, 54, 58, 62, 66],
            "capo": true,
            "frets": [2, 2, 4, 3, 3, 2],
            "suffix": "mmaj7"
        }, {
            "barres": [1],
            "key": "B",
            "suffix": "mmaj7",
            "fingers": [1, 3, 2, 1, 1, 1],
            "capo": true,
            "midi": [47, 54, 58, 62, 66, 71],
            "baseFret": 7,
            "frets": [1, 3, 2, 1, 1, 1]
        }, {
            "barres": [1],
            "baseFret": 9,
            "frets": [-1, 1, 1, 3, 3, 2],
            "key": "B",
            "midi": [54, 59, 66, 70, 74],
            "fingers": [0, 1, 1, 3, 4, 2],
            "capo": true,
            "suffix": "mmaj7"
        }, {
            "key": "B",
            "midi": [47, 53, 58, 62],
            "frets": [-1, 2, 3, 3, 3, -1],
            "suffix": "mmaj7b5",
            "barres": [],
            "baseFret": 1,
            "fingers": [0, 1, 2, 3, 4, 0]
        }, {
            "fingers": [2, 4, 0, 3, 1, 1],
            "baseFret": 6,
            "key": "B",
            "barres": [1],
            "capo": true,
            "frets": [2, 3, -1, 2, 1, 1],
            "suffix": "mmaj7b5",
            "midi": [47, 53, 62, 65, 70]
        }, {
            "baseFret": 7,
            "midi": [47, 53, 58, 62, 71],
            "key": "B",
            "frets": [1, 2, 2, 1, -1, 1],
            "fingers": [1, 2, 3, 1, 0, 1],
            "suffix": "mmaj7b5",
            "barres": [1],
            "capo": true
        }, {
            "frets": [-1, -1, 1, 2, 3, 2],
            "baseFret": 9,
            "midi": [59, 65, 70, 74],
            "barres": [],
            "suffix": "mmaj7b5",
            "key": "B",
            "fingers": [0, 0, 1, 2, 4, 3]
        }, {
            "frets": [-1, 2, 0, 3, 2, 2],
            "key": "B",
            "baseFret": 1,
            "barres": [],
            "midi": [47, 50, 58, 61, 66],
            "fingers": [0, 1, 0, 4, 2, 3],
            "suffix": "mmaj9"
        }, {
            "midi": [47, 50, 58, 61, 59],
            "frets": [3, 1, 4, 2, 0, -1],
            "fingers": [3, 1, 4, 2, 0, 0],
            "barres": [],
            "baseFret": 5,
            "suffix": "mmaj9",
            "key": "B"
        }, {
            "midi": [47, 54, 58, 62, 66, 73],
            "barres": [1],
            "fingers": [1, 3, 2, 1, 1, 4],
            "key": "B",
            "frets": [1, 3, 2, 1, 1, 3],
            "baseFret": 7,
            "capo": true,
            "suffix": "mmaj9"
        }, {
            "frets": [-1, 3, 1, 4, 3, -1],
            "baseFret": 12,
            "fingers": [0, 3, 1, 4, 3, 0],
            "suffix": "mmaj9",
            "barres": [],
            "key": "B",
            "midi": [59, 62, 70, 73]
        }, {
            "fingers": [0, 1, 0, 3, 2, 0],
            "frets": [-1, 2, 0, 3, 2, 0],
            "suffix": "mmaj11",
            "barres": [],
            "key": "B",
            "midi": [47, 50, 58, 61, 64],
            "baseFret": 1
        }, {
            "key": "B",
            "suffix": "mmaj11",
            "capo": true,
            "baseFret": 1,
            "fingers": [1, 1, 1, 2, 3, 1],
            "frets": [2, 2, 2, 3, 3, 2],
            "midi": [42, 47, 52, 58, 62, 66],
            "barres": [2]
        }, {
            "key": "B",
            "frets": [1, 1, 2, 1, 1, 3],
            "capo": true,
            "fingers": [1, 1, 2, 1, 1, 4],
            "midi": [47, 52, 58, 62, 66, 73],
            "baseFret": 7,
            "barres": [1],
            "suffix": "mmaj11"
        }, {
            "capo": true,
            "barres": [1],
            "fingers": [0, 1, 1, 1, 3, 2],
            "baseFret": 9,
            "suffix": "mmaj11",
            "frets": [-1, 1, 1, 1, 3, 2],
            "key": "B",
            "midi": [54, 59, 64, 70, 74]
        }, {
            "frets": [-1, 2, 1, -1, 2, 2],
            "key": "B",
            "midi": [47, 51, 61, 66],
            "baseFret": 1,
            "barres": [],
            "suffix": "add9",
            "fingers": [0, 2, 1, 0, 3, 4]
        }, {
            "key": "B",
            "suffix": "add9",
            "midi": [47, 51, 61, 66, 71],
            "fingers": [3, 1, 0, 2, 4, 4],
            "barres": [2],
            "frets": [2, 1, -1, 1, 2, 2],
            "baseFret": 6
        }, {
            "key": "B",
            "fingers": [0, 0, 3, 2, 1, 4],
            "baseFret": 7,
            "frets": [-1, -1, 3, 2, 1, 3],
            "barres": [],
            "midi": [59, 63, 66, 73],
            "suffix": "add9"
        }, {
            "frets": [-1, 4, 3, 1, 4, 1],
            "key": "B",
            "barres": [1],
            "capo": true,
            "baseFret": 11,
            "midi": [59, 63, 66, 73, 75],
            "suffix": "add9",
            "fingers": [0, 3, 2, 1, 4, 1]
        }, {
            "key": "B",
            "frets": [-1, 4, 3, 3, 1, -1],
            "barres": [],
            "suffix": "madd9",
            "baseFret": 2,
            "fingers": [0, 4, 2, 3, 1, 0],
            "midi": [50, 54, 59, 61]
        }, {
            "midi": [47, 50, 50, 61, 66],
            "barres": [],
            "frets": [3, 1, 0, 2, 3, -1],
            "baseFret": 5,
            "fingers": [3, 1, 0, 2, 4, 0],
            "suffix": "madd9",
            "key": "B"
        }, {
            "frets": [-1, -1, 3, 1, 1, 3],
            "key": "B",
            "suffix": "madd9",
            "midi": [59, 62, 66, 73],
            "baseFret": 7,
            "barres": [1],
            "capo": true,
            "fingers": [0, 0, 3, 1, 1, 4]
        }, {
            "barres": [],
            "key": "B",
            "suffix": "madd9",
            "frets": [-1, 4, 2, 1, 4, -1],
            "midi": [59, 62, 66, 73],
            "baseFret": 11,
            "fingers": [0, 3, 2, 1, 4, 0]
        }]
        """.data(using: .utf8)
}
