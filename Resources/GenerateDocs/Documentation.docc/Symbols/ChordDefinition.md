# ``/ChordProviderCore/ChordDefinition``

@Metadata {
    @DisplayName("Chord Definition")
}

A *Chord Definition* contains all bits and pieces to create Chord Diagrams, transpose Chords, play them with MIDI and analise them for correctness.

### Mapping a ChordPro chord definition

This is how a **ChordPro** *{define ...}* is mapped to a **Chord Provider** structure:

```yaml
# ChordPro definition
{define-guitar: G7 base-fret 1 frets 3 2 0 0 0 1 fingers 3 2 0 0 0 1}

# Chord Provider elements
- name: G7
- root: G
- quality: 7
- slash: nil
- baseFret: 1
- frets: 3 2 0 0 0 1
- fingers: 3 2 0 0 0 1
```

## Topics

### Basic properties

The properties taken from the `define` *directive* or set directly.

- ``name``
- ``root``
- ``quality``
- ``slash``
- ``baseFret``
- ``frets``
- ``fingers``

### Additional required properties

More properties that **must** be set for a Chord Definition.

- ``id``
- ``instrument``
- ``kind``

### Additional optional properties

More properties that **can** be set for a Chord Definition.

- ``plain``
- ``capo``
- ``strum``
- ``transposed``

### Properties that are internal set

These properties are set during the `init` of a Chord Definition.

- ``barres``
- ``status``
- ``validationWarnings``
- ``transposedName``


### Calculated properties

- ``knownChord``
- ``notes``
- ``noteCombinations``
- ``midiNotes``
- ``components``
- ``define``
- ``/ChordProviderGnome/ChordProviderCore/ChordDefinition/style``

### Display of chord elements

- ``display``
- ``displayAllNotes``
- ``displayNaturalOrAccidentals``
- ``displayIntervals``
- ``displayToolTip``

### Find chords

- ``Swift/Array/matching(root:)``
- ``Swift/Array/matching(quality:)``
- ``Swift/Array/matching(slash:)``
- ``Swift/Array/matching(baseFret:)``
- ``Swift/Array/matching(group:)``
- ``Swift/Array/matching(sharpAndflatRoot:)``

### Public methods

- ``transpose(transpose:scale:chords:)``
- ``correctFinger(string:)``
- ``mirrorChordDiagram()``
- ``enharmonicEquivalent(in:)``

### Initializers
- ``init(name:chords:)``
- ``init(define:instrument:)``
- ``init(text:kind:instrument:)``
- ``init(chord:instrument:)``
- ``init(instrument:chords:)``
- ``init(instrument:)``
- ``init(id:plain:frets:fingers:baseFret:root:quality:slash:instrument:kind:status:)``
- ``init(from:)``

### Protocol conformance

- ``description``
- ``<(_:_:)``
