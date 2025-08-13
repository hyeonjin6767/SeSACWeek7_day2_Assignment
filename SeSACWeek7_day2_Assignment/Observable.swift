//
//  Observable.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation

class Observable<T> {
    
    private var action: (() -> Void)?
    
    var value: T {
        didSet {
            print("Observable didSet")
            action?()
        }
    }
    
    init(_ value: T) {
        print("Observable Init")
        self.value = value
    }

    func bind(action: @escaping () -> Void) {
        print("Observable bind")
        action()
        self.action = action
    }
    
    func lazyBind(play: @escaping () -> Void) {
        
        action = play
    }
}
