//
//  TotalCookie.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/21.
//

struct TotalCookie: Codable, Equatable {
    var noClue: Int
    var noCookie: Int
    var oneCookie: Int
    var twoCookie: Int
    var personal : [Cookie]
    init () {
        self.noClue = 0
        self.noCookie = 0
        self.oneCookie = 0
        self.twoCookie = 0
        self.personal = [Cookie()]
    }
    
    init (noCookie: Int, uuid: String) {
        self.noClue = 0
        self.noCookie = noCookie + 1
        self.oneCookie = 0
        self.twoCookie = 0
        self.personal = [Cookie(uuid: uuid, cookieType: 0)]
    }
    
    init (oneCookie: Int, uuid: String) {
        self.noClue = 0
        self.noCookie = 0
        self.oneCookie = oneCookie + 1
        self.twoCookie = 0
        self.personal = [Cookie(uuid: uuid, cookieType: 1)]
    }
    
    init (twoCookie: Int, uuid: String) {
        self.noClue = 0
        self.noCookie = 0
        self.oneCookie = 0
        self.twoCookie = twoCookie + 1
        self.personal = [Cookie(uuid: uuid, cookieType: 2)]
    }
}

extension TotalCookie {
    func toDictionary() -> [String: Any] {
        let personalArray = personal.map { $0.toDictionary() }
        return ["noClue" : noClue,
                "noCookie" : noCookie,
                "oneCookie" : oneCookie,
                "twoCookie" : twoCookie,
                "personal" : personalArray
        ]
    }
}
