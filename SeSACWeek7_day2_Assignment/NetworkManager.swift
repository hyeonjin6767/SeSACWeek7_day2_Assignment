//
//  NetworkManager.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }

    var list: [ProductsList] = []
    var url = ""
    var fixUrl = ""

    let sorts = ["", "sim", "date", "dsc", "asc"]
    
    func callRequst(completionHandler: @escaping ([ProductsList]) -> Void, searchBarWord: String, sortIndex: Int) {
        //print(#function, "첫번째")
        var url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchBarWord)&display=100&start=1&sort=\(sorts[sortIndex])"
        let removePart = "&sort=\(sorts[sortIndex])"
        
        if sortIndex == 0 {
            if let range = url.range(of: removePart) {
                url.removeSubrange(range)
            }
        }
        let header: HTTPHeaders = ["X-Naver-Client-Id": "xA5LXXctMDL0kfcaEa4x",
                                   "X-Naver-Client-Secret": "xspwBdaWWj"]
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingList.self) { response in
            //print(#function, "두번째")
            switch response.result {
            case .success(let value):
                print("success")
                
                self.list = value.items
                completionHandler(self.list)
                
            case .failure(let error):
                //self.showAlert(title: "데이터를 가져오는데 실패했습니다.", message: "", ok: "확인")
                print("fail", error)
            }
        }
        //print(#function, "세번째")
        print("url체크 : \(url)")
    }
}

