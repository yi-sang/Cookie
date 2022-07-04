//
//  Movie.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

struct Movie: Decodable {
    let movieIdx: Int
    let movieName: String
    let moviePhotoList: [String]
    let movieGenreList: [String]
    let likeCnt: Int
    let liked: Bool
    
    enum Codingkeys: String, CodingKey {
        case movieIdx
        case movieName
        case moviePhotoList
        case movieGenreList
        case likeCnt
        case liked
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        
        self.movieIdx = try values.decodeIfPresent(Int.self, forKey: .movieIdx) ?? 0
        self.movieName = try values.decodeIfPresent(String.self, forKey: .movieName) ?? ""
        self.moviePhotoList = try values.decodeIfPresent([String].self, forKey: .moviePhotoList) ?? []
        self.movieGenreList = try values.decodeIfPresent([String].self, forKey: .movieGenreList) ?? []
        self.likeCnt = try values.decodeIfPresent(Int.self, forKey: .likeCnt) ?? 0
        self.liked = try values.decodeIfPresent(Bool.self, forKey: .liked) ?? false
    }
}
