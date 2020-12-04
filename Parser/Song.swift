//
//  Song.swift
//  SongPro Editor
//
//  Created by Brian Kelly on 6/29/20.
//  Copyright © 2020 SongPro. All rights reserved.
//

import Foundation

public class Song: Identifiable {
    public var id = UUID()
    public var title: String?
    public var artist: String?
    public var capo: String?
    public var key: String?
    public var tempo: String?
    public var year: String?
    public var album: String?
    public var tuning: String?
    public var custom = [String: String]()
    public var sections = [Section]()
}
