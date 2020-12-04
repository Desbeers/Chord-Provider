//
//  Section.swift
//  SongPro Editor
//
//  Created by Brian Kelly on 6/29/20.
//  Copyright © 2020 SongPro. All rights reserved.
//

import Foundation

public class Section: Identifiable {
    public var id = UUID()
    public var name: String?
    public var type: String?
    public var lines = [Line]()
}
