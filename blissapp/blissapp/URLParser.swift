//
//  URLParser.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit


struct URLParser {
    static let detailSegue = "questionIdDetailSegue"
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
                        let questionListViewController = URLParser.getQuestionsViewController()
                        questionListViewController.setFilter(filter: filterValue)
                        URLParser.presentViewController(viewController: questionListViewController, topController: topController)
                    }
                }
            } else if queryItem?.name == "question_id",
                let questionId = queryItem?.value {
                if let topController = UIApplication.topViewController() {
                    if topController is QuestionListViewController {
                        if let questionListViewController = topController as? QuestionListViewController {
                            questionListViewController.questionIdToSegueTo = questionId
                            questionListViewController.performSegue(withIdentifier: detailSegue, sender: nil)
                        }
                    } else {
                        let questionListViewController = URLParser.getQuestionsViewController()
                        questionListViewController.questionIdToSegueTo = questionId
                        URLParser.presentViewController(viewController: questionListViewController, topController: topController) {
                            questionListViewController.performSegue(withIdentifier: detailSegue, sender: nil)
                        }
                    }
                }
            }
        }
        return false
    }
    
    static func getQuestionsViewController() -> QuestionListViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "QuestionListViewController") as! QuestionListViewController
    }
    
    static func presentViewController(viewController: UIViewController, topController: UIViewController, closure: @escaping () -> Void = { }) {
        let navigationViewController = UINavigationController(rootViewController: viewController)
        DispatchQueue.main.async {
            topController.present(navigationViewController, animated: true) {
                closure()
            }
        }
    }
}
