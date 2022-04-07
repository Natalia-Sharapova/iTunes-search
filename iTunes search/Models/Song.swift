//
//  Song.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 30.03.2022.
//

import Foundation

struct SongModel: Decodable {
    
    let results: [Song]
}

struct Song: Decodable {
    
    let trackName: String?
}
