//
//  MetronomeView.swift
//  Chord Provider (macOS)
//
//  Created by Nick Berendsen on 05/12/2020.
//

import SwiftUI
import Combine
//import AudioToolbox
import AVFoundation

struct MetronomeView: View {
    @StateObject var metro = Metronome()
    var body: some View {
        #if os(macOS)
        VStack {
            BeatsView(metro: metro)
            MetronomeOptionsView(metro: metro)
        }
        .onAppear(perform: setup)
        .onDisappear(perform: bye)
        #endif
        #if os(iOS)
        HStack {
            MetronomeOptionsView(metro: metro).frame(width: 200)
            BeatsView(metro: metro)
        }
        .onAppear(perform: setup)
        .onDisappear(perform: bye)
        #endif
    }
    
    func setup() {
        let mop = Subscribers.Sink<(), Never>(receiveCompletion: {_ in }, receiveValue: {
            print("Current Value: \(self.metro.beatsPerMinute)")
        })
        
        metro.objectWillChange.subscribe(mop)
    }
    func bye() {
        metro.timer?.invalidate()
        print("I'm gone")
    }
}

struct MetronomeOptionsView: View {
    @StateObject var metro = Metronome()
    
     var body: some View {
        VStack {
            Text("\(metro.beatsPerMinute) BPM")
            Slider(value: $metro.sliderPercent)
            Button(action: {
                metro.beep.toggle()
            } ) {
                Text(metro.beep ? "Stop tick" : "Start tick")
            }
        }.padding()
     }
}

struct BeatsView: View {
    @StateObject var metro = Metronome()
    
     var body: some View {
        VStack {
            BeatView(currentBeat: metro.quarterBeat.current, totalBeats: 4)
            //BeatView(currentBeat: metro.thirthBeat.current, totalBeats: 3)
        }.padding()
     }
}

struct BeatView: View {
    let currentBeat: Int
    let totalBeats: Int
    
     var body: some View {
        HStack() {
            ForEach(0...(totalBeats - 1), id: \.self) { beat in
                Circle().foregroundColor(beat == self.currentBeat ? .pink : .green)
             }
         }
     }
}

class Metronome: ObservableObject {
    weak var timer: Timer?
    //let objectWillChange = PassthroughSubject<Void, Never>()
    private let granularity: Int = 16
    
    private var timeInterval: TimeInterval {
        return 1 / ((Double(beatsPerMinute) / 240.0) * Double(granularity))
    }
    
    func configureTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            self.tick()
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        beep = false
        objectWillChange.send()
        print("Timer off?")
    }
    
    private var current: Int = 0
    
    var quarterBeat: (current: Int, total: Int) {
        (current / 4, 4)
    }

    var thirthBeat: (current: Int, total: Int) {
        (current / 4, 3)
    }
    
    var eigthBeat: (current: Int, total: Int) {
         (current / 2, 8)
    }
    
    var sixteenthBeat: (current: Int, total: Int) {
         (current, 8)
    }
    

    
    // Default is 16th notes
    func tick() {
        current += 1
        if current >= granularity {
            //NSSound(named: NSSound.Name("Morse"))?.play()
            
            if beep {
                #if os(macOS)
                    NSSound.beep()
                #else
                    AudioServicesPlayAlertSound(SystemSoundID(1104))
                #endif
            }
            
            current = 0
        }
        objectWillChange.send()
    }
    
    var beatsPerMinute: Int {
        Int(sliderPercent * 208)
    }

    @Published var beep: Bool = false
    
    @Published var sliderPercent: Double = 0 {
        didSet {
            configureTimer()
            //objectWillChange.send()
        }
    }
}

