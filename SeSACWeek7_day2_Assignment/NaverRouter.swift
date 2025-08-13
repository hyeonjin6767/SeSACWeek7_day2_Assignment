//
//  NaverRouter.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/13/25.
//

import Foundation
import Alamofire

enum NaverRouter {
    
    case all(searchWord: String)
    case sorted(searchWord: String, sortIndex: Int)
        
    var baseURL: String {
        
        return "https://openapi.naver.com/v1/search/shop.json?query="
    }
    
    //let url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchBarWord)&display=100&start=1"
    //let url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchBarWord)&display=100&start=1&sort=\(sorts[sortIndex])"
    var endpoint: URL {
        
        switch self {
        case .all(let searchWord):
            URL(string: baseURL + "\(searchWord)")!
        case .sorted(let searchWord, _):
            URL(string: baseURL + "\(searchWord)")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch self {
        case .all:
            return ["display":"100", "start":"1"]
        case .sorted(_, let sortKey):
            return ["start":"1", "display":"100", "sort":"\(NetworkManager.sorts[sortKey])"] //딕셔너리라 파라미터 순서 상관 없음
        }
    }
    
    var headers: HTTPHeaders {
        return ["X-Naver-Client-Id": "xA5LXXctMDL0kfcaEa4x", "X-Naver-Client-Secret": "xspwBdaWWj"]
    }
    
}
