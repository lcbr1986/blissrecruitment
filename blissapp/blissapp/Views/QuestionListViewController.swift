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
    var imageCache:[String: UIImage] = [String: UIImage]()
    
    var filter = ""
    
    var questionIdToSegueTo: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.text = self.filter
    }

    public func setFilter(filter: String) {
        self.filter = filter
    }
    
    func getQuestions() {
        let networkController = NetworkController()
        
        networkController.getQuestions(limit: 10, offset: currentOffset, filter: filter) { (data, error) in
            if error != nil {
                self.showError(error: error)
            } else {
                QuestionParser.parseQuestions(questionData: data, completionHandler: { (questions, error) in
                    if error != nil {
                        self.showError(error: error)
                    } else {
                        guard let questions = questions else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.questions.append(contentsOf: questions)
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    func resetList() {
        currentOffset = 0
        questions = [Question]()
        filter = ""
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionDetailSegue" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
            let selectedQuestion = questions[indexPath.row] as Question? else {
                return
            }
            let questionDetailViewController = segue.destination as! QuestionDetailViewController
            questionDetailViewController.question = selectedQuestion
        }
        if segue.identifier == "questionIdDetailSegue" {
            let questionDetailViewController = segue.destination as! QuestionDetailViewController
            questionDetailViewController.questionId = self.questionIdToSegueTo
        }
    }
}

extension QuestionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.questions.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        
        let currentQuestion = questions[indexPath.row]
        cell.textLabel?.text = currentQuestion.question
        
        cell.imageView?.image = nil
        if let questionImage = imageCache[currentQuestion.thumbUrl] {
            cell.imageView?.image = questionImage
        } else {
            guard let url = URL(string: currentQuestion.thumbUrl) else {
                return cell
            }
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let questionImage = UIImage(data: data)
                        self.imageCache[currentQuestion.thumbUrl] = questionImage
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                } else {
                    cell.imageView?.image = nil
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.questions.count {
            self.currentOffset += questions.count
            getQuestions()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension QuestionListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        resetList()
        guard let searchTerm = searchBar.text else {
            return
        }
        self.filter = searchTerm
        getQuestions()
    }
}
