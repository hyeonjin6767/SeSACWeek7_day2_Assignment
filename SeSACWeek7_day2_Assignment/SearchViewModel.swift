//
//  SearchViewModel.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation

final class SearchViewModel {
    
    var inputSearchBarTrigger: Observable<String> = Observable("")
    
    var outputNaverShoppingData: Observable<[ProductsList]> = Observable([])
    
    var outputNaviTitle: Observable<String> = Observable("")
        
    init() {
        
        inputSearchBarTrigger.lazyBind {
            print("검색어 신호 받음, \(self.inputSearchBarTrigger.value)")
            self.callRequest(searchBarWord: self.inputSearchBarTrigger.value, sortIndex: 0)
        }
    }
    
    func callRequest(searchBarWord: String, sortIndex: Int) {
        
        NetworkManager.shared.callRequst(completionHandler: { shoppinglist in
            
            self.outputNaverShoppingData.value = shoppinglist
            self.outputNaviTitle.value = searchBarWord
            
        }, searchBarWord: searchBarWord, sortIndex: sortIndex)
        
    }
}
