//
//  DetailAlbumViewController.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 23.03.2022.
//

import UIKit

class DetailAlbumViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var album: Album?
    var songs = [Song]()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        guard let album = album else { return }
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks:"
        releaseDateLabel.text = setDateFormat(date: album.releaseDate)
        setSongs()
        setLogo()
    }
    
    private func setDateFormat(date: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        
        guard let backendDate = formatter.date(from: date) else { return "" }
        
        let releaseDateFormatter = DateFormatter()
        
        releaseDateFormatter.dateFormat = "dd-MM-yyyy"
        
        let releaseDate = releaseDateFormatter.string(from: backendDate)
        
        return releaseDate
    }
    
    private func setLogo() {
        
        guard let urlString = album?.artworkUrl100 else {
            logoImageView.image = nil
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.shared.getLogo(url: url) { image, error in
            
            if let error = error {
                print(#line, #function, error.localizedDescription)
            }
            
            if let image = image {
                DispatchQueue.main.async {
                    self.logoImageView.image = image
                }
            }
        }
    }
    
    private func setSongs() {
        
        guard let idAlbum = album?.collectionId else { return }
        
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetworkManager.shared.getSongs(idAlbum: idAlbum, urlString: urlString) { songModel, error in
            
            guard let songModel = songModel else {
                
                if let error = error {
                    print(#line, #function, "Error", error.localizedDescription)
                }
                return
            }
            self.songs = songModel.results
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Extensions

extension DetailAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongCollectionViewCell
        
        let song = songs[indexPath.row].trackName
        
        cell.nameSongLabel.text = song
        
        return cell
    }
}

extension DetailAlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 350, height: 50)
    }
}
