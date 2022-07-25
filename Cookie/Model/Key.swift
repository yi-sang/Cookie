//
//  Key.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/26.
//

struct Key: Decodable {
    var key: String
    enum Codingkeys: String, CodingKey {
        case key
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        
        self.key = try values.decodeIfPresent(String.self, forKey: .key) ?? ""
    }
    
    init() {
        self.key = ""
    }
}
