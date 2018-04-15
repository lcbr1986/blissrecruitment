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
    var currentOffset: Int = 0
    var totalQuestions: Int = 0
    var imageCache:[String: UIImage] = [String: UIImage]()
    
    var filter = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestions()
    }

    func getQuestions() {
        let networkController = NetworkController()
        
        networkController.getQuestions(limit: 10, offset: currentOffset, filter: "") { (data, error) in
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
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            catch {
                
            }
        }
    }
    
}

extension QuestionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        
        let currentQuestion = questions[indexPath.row]
        cell.textLabel?.text = currentQuestion.question
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.questions.count-1 {
            self.currentOffset += questions.count
            getQuestions()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
