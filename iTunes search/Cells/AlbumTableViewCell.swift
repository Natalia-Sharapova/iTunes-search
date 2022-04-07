//
//  AlbumTableViewCell.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 22.03.2022.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameAlbumLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.backgroundColor = .cyan
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make imageView is round
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
    }
    
    // Set the data to the labels and imageView
    
    func configureCell(with album: Album) {
        
        guard let urlString = album.artworkUrl100 else {
            
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
        
        nameAlbumLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks"
    }
}
