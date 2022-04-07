//
//  NetworkManager.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 28.03.2022.
//

import UIKit

class NetworkManager {
    
    // Singletone init
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Methods
    
    func getAlbums(urlString: String, completion: @escaping (AlbumResults?, Error?) -> Void) {
        
        // Check can we get the url
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(AlbumResults.self, from: data)
                completion(decodedData, nil)
                
            } catch let error {
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
    func getLogo(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else {
                completion(nil, error)
                print("Can't get data")
                return
            }
            
            let image = UIImage(data: data)
            completion(image, nil)
        }
        
        dataTask.resume()
    }
    
    // Get data with songs for DetailAlbumViewController
    
    func getSongs(idAlbum: Int, urlString: String, completion: @escaping (SongModel?, Error?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let decodedData = try decoder.decode(SongModel.self, from: data)
                completion(decodedData, nil)
                
            } catch let error {
                completion(nil,error)
            }
        }
        dataTask.resume()
    }
}
