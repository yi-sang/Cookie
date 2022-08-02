//
//  Movie.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

struct Movie: Decodable, Equatable {
    var title: String
    var posterPath: String
    var overview: String
    var id: Int
    var releaseDate: String
    enum Codingkeys: String, CodingKey {
        case title
        case poster_path
        case overview
        case id
        case release_date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.posterPath = "https://image.tmdb.org/t/p/original\(try values.decodeIfPresent(String.self, forKey: .poster_path) ?? "")"
        self.overview = try values.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.releaseDate = try values.decodeIfPresent(String.self, forKey: .release_date) ?? ""
    }
    
    init () {
        self.title = ""
        self.posterPath = ""
        self.overview = ""
        self.id = 0
        self.releaseDate = ""
    }
}

enum MovieSection: String {
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
}
