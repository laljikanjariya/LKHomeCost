//
//  LKAlertAction.swift
//  LKHomeCost
//
//  Created by Lalji on 26/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit

class LKAlertAction: NSObject {
    class func showAlert(title: String?, message: String?, alertAction actions:[UIAlertAction], displayViewController view:UIViewController ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        view.present(alert, animated: true, completion: nil)
    }
    class func getAlertActionNormal(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }
    class func getAlertActionSuggestion(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel, handler: handler)
    }
    class func getAlertActionDelete(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .destructive, handler: handler)
    }
}
