//
//  Movie.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

struct Movie: Decodable {
    let title: String
    let posterPath: String
    
    enum Codingkeys: String, CodingKey {
        case title
        case poster_path
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.posterPath = "https://image.tmdb.org/t/p/original\(try values.decodeIfPresent(String.self, forKey: .poster_path) ?? "")"
    }
}
