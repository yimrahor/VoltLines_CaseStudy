//
//  AlertHelper.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit

enum ErrorTypes {
    case locationError(UIAlertAction)
}

class AlertHelper {
    static let shared = AlertHelper()
    
    func showAlert(currentVC:UIViewController,errorType:ErrorTypes){
            let alert = create(errorType)
            currentVC.present(alert, animated: true)
        }
    
    private func create(_ errorType:ErrorTypes)->UIAlertController{
            
            var alertAction = UIAlertAction()
            var title = String()
            var message = String()
            
            switch errorType {
            case .locationError(let action):
                title = "Location Service"
                message = "Permission needs to be granted"
                alertAction = action
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(alertAction)
            
            return alert
        }
       
}
