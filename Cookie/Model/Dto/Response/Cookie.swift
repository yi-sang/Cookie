//
//  Cookie.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/28.
//

struct Cookie: Codable, Equatable {
    var uuid : String
    var cookieType : Int
    
    init () {
        self.uuid = ""
        self.cookieType = 0
    }
    
    init (uuid: String, cookieType: Int) {
        self.uuid = uuid
        self.cookieType = cookieType
    }
}

extension Cookie {
    func toDictionary() -> [String: Any] {
        return [
            "uuid": uuid,
            "cookieType": cookieType
        ]
    }
}
