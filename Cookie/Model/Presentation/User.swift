//
//  User.swift
//  Cookie
//
//  Created by 이상현 on 2022/08/02.
//

import Foundation

struct User: Codable, Equatable {
    var experience: Int
    var movieList: [String]
    var direction: Bool
    init () {
        self.experience = 0
        self.movieList = []
        self.direction = false
    }
    
    init (experience: Int, movieList: [String], dirction: Bool) {
        self.experience = experience
        self.movieList = movieList
        self.direction = dirction
    }
}

extension User {
    func toDictionary() -> [String: Any] {
        return ["experience" : experience,
                "movieList" : movieList,
                "direction" : direction
        ]
    }
}
