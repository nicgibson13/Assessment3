//
//  MovieTableViewController.swift
//  Assessment3
//
//  Created by Nic Gibson on 6/28/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieController.sharedInstance.fetchMoviesWith(term: "Star Wars") { (moviesFromCompletion) in
            if let unwrappedMovies = moviesFromCompletion {
                self.movies = unwrappedMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        let movie = movies[indexPath.row]
        cell.movieTitleLabel.text = movie.title
        cell.movieRatingLabel.text = String(movie.rating)
        cell.movieOverviewTextView.text = movie.overview
        
        MovieController.sharedInstance.fetchImageFor(movie: movie) { (image) in
            DispatchQueue.main.async {
                cell.movieImage.image = image
            }
        }
        
        return cell
        
    }
}

extension MovieTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchTerm != "" else {return}
        MovieController.sharedInstance.fetchMoviesWith(term: searchTerm) { (moviesFromCompletion) in
            if let unwrappedMovies = moviesFromCompletion {
                self.movies = unwrappedMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    searchBar.text = ""
                }
            }
        }
    }
}

