//
//  MovieController.swift
//  Assessment3
//
//  Created by Nic Gibson on 6/28/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit

class MovieController {
    
    static let sharedInstance = MovieController()
    
    //MARK: Properties
    let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")
    let imageBaseURL = URL(string: "http://image.tmdb.org/t/p/w500")
    var movies: [Movie] = []
    
    //MARK: CRUD
    func fetchMoviesWith(term: String, completion: @escaping ([Movie]?) -> Void) {
        //BUILD URL
        guard let url = baseURL else { completion(nil);return}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let APIQuery = URLQueryItem(name: "api_key", value: "f263ca83d42eba9997e31373d6b38788")
        let searchQuery = URLQueryItem(name: "query", value: term)
        components?.queryItems = [APIQuery,searchQuery]
        guard let finalURL = components?.url else {completion(nil);return}
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("🐶 ate my homework, now I'm getting an error. \(error.localizedDescription)")
                completion(nil);return
            }
            
            guard let data = data else { completion(nil);return}
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(TopLevelJSON.self, from: data)
                completion(topLevelJSON.results)
            } catch {
                print("🙈 blind monkey doesn't know why the data isn't there. \(error.localizedDescription)")
                completion(nil);return
            }
        } .resume()
    }
    func fetchImageFor(movie: Movie, completion: @escaping (UIImage?) -> Void) {
        guard let movieImage = movie.image else {completion(nil);return}
        guard let imageBaseURL = imageBaseURL else {completion(nil);return}
        let finalURL = imageBaseURL.appendingPathComponent(movieImage)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("🐢 couldn't get the data for the image... \(error.localizedDescription)")
                completion(nil);return
            }

            guard let data = data else {
                print("Where is the image data? 🐭")
                completion(nil);return
            }

            let image = UIImage(data: data)
            completion(image)
        }
            .resume()
    }
}
