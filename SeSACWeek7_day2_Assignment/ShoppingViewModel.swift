//
//  ShoppingViewModel.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation

final class ShoppingViewModel {
    
    var inputSortButtonTrigger: Observable<String> = Observable("")
    var inputSortTypeTrigger: Observable<Int> = Observable(0)
    
    var outputShoppingList: Observable<[ProductsList]> = Observable([])
    
    var outputNaviTitle: Observable<String> = Observable("")
        
    init() {
        
        inputSortButtonTrigger.lazyBind {
            self.callRequest(searchBarWord: self.outputNaviTitle.value, sortIndex: self.inputSortTypeTrigger.value)
        }
        inputSortTypeTrigger.lazyBind {
            print("정렬 버튼 신호 받음")
            self.callRequest(searchBarWord: self.outputNaviTitle.value, sortIndex: self.inputSortTypeTrigger.value)

        }
       
    }
    
    func callRequest(searchBarWord: String, sortIndex: Int) {
        
        NetworkManager.shared.callRequst(completionHandler: { shoppinglist in
            
            self.outputShoppingList.value = shoppinglist
            //self.outputNaviTitle.value = searchBarWord
            
        }, searchBarWord: searchBarWord, sortIndex: sortIndex)
        
    }
    
}
