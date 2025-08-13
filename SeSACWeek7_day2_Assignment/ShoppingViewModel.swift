//
//  ShoppingViewModel.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation

final class ShoppingViewModel {
    
    struct Input {
        var sortButtonTrigger: Observable<String> = Observable("")
        var sortTypeTrigger: Observable<Int> = Observable(0)
    }
    struct Output {
        var shoppingList: Observable<[ProductsList]> = Observable([])
        var naviTitle: Observable<String> = Observable("")
    }
    
    var input: Input
    var output: Output
    
//    var inputSortButtonTrigger: Observable<String> = Observable("")
//    var inputSortTypeTrigger: Observable<Int> = Observable(0)
//    
//    var outputShoppingList: Observable<[ProductsList]> = Observable([])
//    var outputNaviTitle: Observable<String> = Observable("")
        
    init() {
        
        input = Input()
        output = Output()
        
        input.sortButtonTrigger.lazyBind {
            self.callRequest(searchBarWord: self.output.naviTitle.value, sortIndex: self.input.sortTypeTrigger.value)
        }
        input.sortTypeTrigger.lazyBind {
            print("정렬 버튼 신호 받음")
            self.callRequest(searchBarWord: self.output.naviTitle.value, sortIndex: self.input.sortTypeTrigger.value)
        }
       
    }
    
    func callRequest(searchBarWord: String, sortIndex: Int) {
        
        NetworkManager.shared.callRequst(completionHandler: { shoppinglist in
            
            self.output.shoppingList.value = shoppinglist
            //self.outputNaviTitle.value = searchBarWord
            
        }, searchBarWord: searchBarWord, sortIndex: sortIndex)
        
    }
    
}
