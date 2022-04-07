//
//  AlbumsTableViewController.swift
//  iTunes search
//
//  Created by Наталья Шарапова on 22.03.2022.
//

import UIKit

class AlbumsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Properties
    
    var albums = [Album]()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        navigationItem.title = "Albums"
    }
    
    private func fetchAlbum(albumName: String) {
        
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        
        NetworkManager.shared.getAlbums(urlString: urlString) { albumResults, error in
            
            guard let albumResults = albumResults else {
                
                if let error = error {
                    print(#line, #function, "Error", error.localizedDescription)
                }
                return
            }
            
            if albumResults.results != [] {
                
                let sortedAlbums = albumResults.results.sorted { firstItem, secondItem in
                    return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                }
                self.albums = sortedAlbums
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.alert(title: "There is no album with this name", message: "Please, change your request")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ToTheDetailsAlbum" else { return }
        
        let destination = segue.destination as! DetailAlbumViewController
        
        guard let albumIndex = tableView.indexPathForSelectedRow else { return }
        
        destination.album = albums[albumIndex.row]
        destination.title = destination.album?.artistName
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text {
            
            guard let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            fetchAlbum(albumName: text)
        }
    }
}

// MARK: - Extensions

extension AlbumsTableViewController /*: UiTableViewDataSource */ {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumTableViewCell
        
        let album = albums[indexPath.row]
        
        cell.configureCell(with: album)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
