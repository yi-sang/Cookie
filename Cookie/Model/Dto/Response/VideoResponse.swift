//
//  VideoResponse.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/25.
//

struct VideoResponse: Decodable {
    let results: [Key]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try values.decodeIfPresent([Key].self, forKey: .results) ?? [Key]()
    }
}
