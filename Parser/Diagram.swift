//
//  Diagram.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 10/12/2020.
//

import Foundation

public class Diagram: Codable {
    public var  frets: [Int]
    public var  fingers: [Int]
    public var  baseFret: Int
    public var  barres: [Int]
    public var  capo: Bool?
    public var  midi: [Int]
    public var  key: String
    public var  suffix: String

    public static var all: [Diagram] {
        print("Diagram.all: loading diagrams")
        guard let data = ChordsData.data else {
            return []
        }
        do {
            let allChords = try JSONDecoder().decode([Diagram].self, from: data)
            return allChords
        } catch {
            print(error)
        }
        return []
    }
}
