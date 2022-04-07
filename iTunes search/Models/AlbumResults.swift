//
//  Album.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 28.03.2022.
//

import UIKit

struct AlbumResults: Codable {
    
    let results: [Album]
}
    
struct Album: Codable, Equatable {
    
    let collectionName: String
    let artistName: String
    let trackCount: Int
    let artworkUrl100: String?
    let releaseDate: String
    let collectionId: Int
}
