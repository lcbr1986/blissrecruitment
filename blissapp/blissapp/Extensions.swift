//
//  Extensions.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    func showError(error: Error?) {
        var messageToShow:String = ""
        guard error == nil else {
            guard let errorMessage = error?.localizedDescription else {
                messageToShow = "Error Occured"
                return
            }
            messageToShow = errorMessage
            return
        }
        let alertController = UIAlertController(title: "Error", message:
            messageToShow, preferredStyle: UIAlertController.Style.alert)
        self.present(alertController, animated: true, completion: nil)
    }
}
