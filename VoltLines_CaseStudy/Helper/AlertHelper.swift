//
//  AlertHelper.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit

enum ErrorTypes {
    case locationError(UIAlertAction)
    case tripError
    case internetError
}

class AlertHelper {
    static let shared = AlertHelper()
    
    func showAlert(currentVC:UIViewController,errorType:ErrorTypes){
            let alert = createError(errorType)
            currentVC.present(alert, animated: true)
        }
    
    private func createError(_ errorType:ErrorTypes)->UIAlertController{
            
        var alertAction: UIAlertAction?
        var title = String()
        var message = String()
            
        switch errorType {
            case .locationError(let action):
                title = "Location Service"
                message = "Permission needs to be granted"
                alertAction = action
            case .tripError:
                title = "The trip you selected is full."
                message = "Please select another one"
                alertAction = UIAlertAction(title: "Select a Trip", style: .default)
            case .internetError:
                title = "Internet Error"
                message = "Failed to retrieve data, check your internet connection"
                alertAction = UIAlertAction(title: "OK", style: .default)
        }
        
        alertAction?.setValue(UIColor.blue, forKey: "titleTextColor")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = alertAction ?? UIAlertAction()
        alert.addAction(action)
        
        return alert
    }
}
