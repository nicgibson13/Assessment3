//
//  Movie.swift
//  Assessment3
//
//  Created by Nic Gibson on 6/28/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import Foundation

struct TopLevelJSON: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let title: String
    let rating: String
    let overview: String
    let image: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case rating = "vote_average"
        case overview
        case image
    }
}

