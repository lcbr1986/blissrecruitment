//
//  QuestionListViewController.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class QuestionListViewController: UIViewController {
    
    var questions: [Question] = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let networkManager = NetworkController()
        
        networkManager.getQuestions(limit: 10, offset: 0, filter: "") { (data, error) in
            guard let data = data else {
                return
            }
            
            do {
                if let questions = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    for questionDict in questions {
                        if let question = Question(dictionary: questionDict) {
                            self.questions.append(question)
                        }
                    }
                    
                    print(self.questions)
                }
            }
            catch {
                
            }
        }
    }


}
