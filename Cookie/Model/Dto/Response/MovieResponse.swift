//
//  TodayMovieResponse.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/05/07.
//

struct MovieResponse: Decodable {
  
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.isSuccess = try values.decodeIfPresent(Bool.self, forKey: .isSuccess) ?? false
        self.code = try values.decodeIfPresent(Int.self, forKey: .code) ?? 0
        self.message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.result = try values.decodeIfPresent([Movie].self, forKey: .result) ?? []
    }
}
