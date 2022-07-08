//
//  TodayMovieResponse.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/05/07.
//

struct MovieResponse: Decodable {
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try values.decodeIfPresent([Movie].self, forKey: .results) ?? [Movie]()
    }
}
