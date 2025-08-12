//
//  AlertExtension.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import Foundation

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, ok: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: ok, style: .default)

        alert.addAction(ok)
        //alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
