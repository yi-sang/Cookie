//
//  MovieResponse.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/05/07.
//

struct MovieResponse: Decodable {
    let movieList: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.movieList = try values.decodeIfPresent([Movie].self, forKey: .results) ?? [Movie]()
    }
}
