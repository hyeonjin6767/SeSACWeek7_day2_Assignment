//
//  SearchViewModel.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation

final class SearchViewModel {
    
    struct Input {
        var searchBarTrigger: Observable<String> = Observable("")
    }
    struct Output {
        var naverShoppingData: Observable<ShoppingList?> = Observable(nil)
        var naviTitle: Observable<String> = Observable("")
    }
    
    var input: Input
    var output: Output
    
    //    var inputSearchBarTrigger: Observable<String> = Observable("")
    //
    //    var outputNaverShoppingData: Observable<[ProductsList]> = Observable([])
    //    var outputNaviTitle: Observable<String> = Observable("")
    
    init() {
        
        input = Input()
        output = Output()
        
        input.searchBarTrigger.lazyBind {
            print("검색어 신호 받음, \(self.input.searchBarTrigger.value)")
            self.callRequest(searchBarWord: self.input.searchBarTrigger.value, sortIndex: 0)
        }
    }
    
    func callRequest(searchBarWord: String, sortIndex: Int) {
        
        NetworkManager.shared.callRequst(api: .all(searchWord: searchBarWord), success: { response in
            self.output.naverShoppingData.value = response
            self.output.naviTitle.value = searchBarWord
        }, type: ShoppingList.self)
        
        //        NetworkManager.shared.callRequst(completionHandler: { shoppinglist in
        //
        //            self.output.naverShoppingData.value = shoppinglist
        //            self.output.naviTitle.value = searchBarWord
        //
        //        }, searchBarWord: searchBarWord, sortIndex: sortIndex)
        //
    }
    
}
