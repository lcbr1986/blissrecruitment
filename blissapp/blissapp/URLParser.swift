//
//  URLParser.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

struct URLParser {
    static func parseUrl(url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            return false
        }
        
        if host == "questions" {
            let queryItem = components.queryItems?[0]
            
            if queryItem?.name == "question_filter",
                let filterValue = queryItem?.value {
                if let topController = UIApplication.topViewController() {
                    if topController is QuestionListViewController {
                        if let questionsListViewController = topController as? QuestionListViewController {
                            questionsListViewController.setFilter(filter: filterValue)
                        }
                    } else {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let questionListViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionListViewController") as! QuestionListViewController
                        questionListViewController.setFilter(filter: filterValue)
                        let navigationViewController = UINavigationController(rootViewController: questionListViewController)
                        topController.present(navigationViewController, animated: true) {}
                    }
                }
            }
        }
        return false
    }
}
