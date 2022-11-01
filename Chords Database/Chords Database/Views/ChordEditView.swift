//
//  ChordEditView.swift
//  Chords Database
//
//  Created by Nick Berendsen on 28/10/2022.
//

import SwiftUI
import SwiftyChords

struct ChordEditView: View {
    
    @EnvironmentObject var model: ChordsDatabaseModel
    
    @Environment(\.dismiss) var dismiss
    
    let chord: ChordPosition
    @State private var values: Chord
    
    @State private var result: ChordPosition
    
    @State private var status: Status = .new
    
    @State private var chordID: Int?
    
    init(chord: ChordPosition) {
        self.chord = chord
        _result = State(wrappedValue: chord)
        _values = State(wrappedValue: Chord(id: chord.id,
                                            frets: chord.frets,
                                            fingers: chord.fingers,
                                            baseFret: chord.baseFret,
                                            barres: chord.barres.first ?? 0,
                                            capo: chord.capo,
                                            key: chord.key,
                                            suffix: chord.suffix)
        )
    }
    
    var body: some View {
        VStack {
            Text("\(values.key.rawValue) \(values.suffix.rawValue)")
                .font(.title)
            Text(result.define)
                .textSelection(.enabled)
                .font(.headline)
                .padding()
            Picker("Key:", selection: $values.key) {
                ForEach(Chords.Key.allCases, id: \.rawValue) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            HStack {
                Picker("Suffix:", selection: $values.suffix) {
                    ForEach(Chords.Suffix.allCases, id: \.rawValue) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
                Picker("Base fret:", selection: $values.baseFret) {
                    ForEach(1...20, id: \.self) { value in
                        Text(value.description)
                            .tag(value)
                    }
                }
                Picker("Barres:", selection: $values.barres) {
                    Text("None")
                        .tag(0)
                    ForEach(1...4, id: \.self) { value in
                        Text(value.description)
                            .tag(value)
                    }
                }
            }
            HStack {
                VStack {
                    model.diagram(chord: result, frame: CGRect(x: 0, y: 0, width: 200, height: 300))
                    Text("Calculated MIDI")
                        .font(.headline)
                    
                    HStack {
                        Divider()
                            .frame(height: 20)
                        ForEach(values.midi, id: \.self) { midi in
                            VStack {
                                Text(midi.description)
                                Text(MidiNotes.keyString(note: midi))
                                
                            }
                            Divider()
                                .frame(height: 20)
                            
                        }
                    }
                }
                .frame(width: 400)
                VStack {
                    Section(
                        content: {
                            HStack {
                                ForEach(Strings.allCases, id: \.rawValue) { fret in
                                    Picker(
                                        selection: $values.frets[fret.rawValue],
                                        content: {
                                            Text("⛌")
                                                .tag(-1)
                                                .foregroundColor(.red)
                                            ForEach(0...5, id: \.self) { value in
                                                Text(value.description)
                                                    .tag(value)
                                            }
                                        },
                                        label: {
                                            Text(String(describing: fret))
                                                .font(.title2)
                                        }
                                    )
                                    Divider()
                                }
                            }
                            .pickerStyle(.radioGroup)
                        }, header: {
                            header(text: "Frets")
                        })
                    
                    Section(
                        content: {
                            HStack {
                                ForEach(Strings.allCases, id: \.rawValue) { finger in
                                    Picker(
                                        selection: $values.fingers[finger.rawValue],
                                        content: {
                                            ForEach(0...4, id: \.self) { value in
                                                Text(value.description)
                                                    .tag(value)
                                            }
                                        },
                                        label: {
                                            Text(String(describing: finger))
                                                .font(.title2)
                                        }
                                    )
                                    Divider()
                                }
                            }
                            .pickerStyle(.radioGroup)
                        }, header: {
                            header(text: "Fingers")
                        })
                    
                }
            }
            Divider()
                .padding(.top)
            HStack {
                Button(action: {
                    switch status {
                    case .new:
                        model.allChords.append(result)
                    case .update:
                        if let index = chordID {
                            model.allChords[index] = result
                        }
                    }
                    model.updateDocument.toggle()
                    dismiss()
                }, label: {
                    Text(status.rawValue)
                })
                .disabled(chord.define() == result.define())
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
        }
        .padding()
        .animation(.default, value: values)
        .task {
            if let index = model.allChords.firstIndex(where: {$0.id == values.id}) {
                status = .update
                chordID = index
            }
        }
        .task(id: values) {
            do {
                result = try ChordPosition(id: values.id,
                                           frets: values.frets,
                                           fingers: values.fingers,
                                           baseFret: values.baseFret,
                                           barres: values.barres != 0 ? [values.barres] : [],
                                           midi: values.midi,
                                           key: values.key,
                                           suffix: values.suffix
                )
            } catch {
                print(error)
            }
        }
    }
    
    func header(text: String) -> some View {
        VStack {
            Text(text)
                .font(.title2)
                .padding(.top)
            Divider()
        }
    }
    
    enum Status: String {
        case new = "Save New Chord"
        case update = "Update Chord"
    }
}
