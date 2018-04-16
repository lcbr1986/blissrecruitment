//
//  QuestionDetailViewController.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    var question: Question?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choice1Label: UILabel!
    @IBOutlet weak var choice1VotesLabel: UILabel!
    @IBOutlet weak var choice2Label: UILabel!
    @IBOutlet weak var choice2VotesLabel: UILabel!
    @IBOutlet weak var choice3Label: UILabel!
    @IBOutlet weak var choice3VotesLabel: UILabel!
    @IBOutlet weak var choice4Label: UILabel!
    @IBOutlet weak var choice4VotesLabel: UILabel!
    @IBOutlet var voteButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let question = self.question else {
            return
        }
        setUIElements(question: question)
    }
    
    func setUIElements(question: Question) {
        titleLabel.text = question.question
        createdAtLabel.text = "Created at: \(question.publishedAt)"
        if let url = URL(string: question.thumbUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let questionImage = UIImage(data: data)
                        self.imageView.image = questionImage
                    }
                }
            }
        }
        choice1Label.text = question.choices[0].choice
        choice1VotesLabel.text = "Votes: \(question.choices[0].votes)"
        choice2Label.text = question.choices[1].choice
        choice2VotesLabel.text = "Votes: \(question.choices[1].votes)"
        choice3Label.text = question.choices[2].choice
        choice3VotesLabel.text = "Votes: \(question.choices[2].votes)"
        choice4Label.text = question.choices[3].choice
        choice4VotesLabel.text = "Votes: \(question.choices[3].votes)"
    }

    @IBAction func voteChoice1Action(_ sender: Any) {
    }

    @IBAction func voteChoice2Action(_ sender: Any) {
    }

    @IBAction func voteChoice3Action(_ sender: Any) {
    }

    @IBAction func voteChoice4Action(_ sender: Any) {
    }
}
