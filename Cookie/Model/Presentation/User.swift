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
    init () {
        self.experience = 0
        self.movieList = []
    }
    
    init (experience: Int, movieList: [String]) {
        self.experience = experience
        self.movieList = movieList
    }
}

extension User {
    func toDictionary() -> [String: Any] {
        return ["experience" : experience,
                "movieList" : movieList
        ]
    }
}
