//
//  ShareQuestionViewController.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 16/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class ShareQuestionViewController: UIViewController {

    var questionId: String?
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        emailTextField.resignFirstResponder()
        let button = sender as! UIButton
        button.isEnabled = false
        if let questionId = self.questionId {
            let networkController = NetworkController()
            
            networkController.shareQuestion(destinationEmail: emailTextField.text!, questionId: questionId) { (data, error) in
                guard let data = data else {
                    button.isEnabled = true
                    return
                }
                do {
                    if let statusDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        guard let status = statusDict["status"] as? String else {
                            button.isEnabled = true
                            return
                        }
                        if status == "OK" {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                catch {
                    button.isEnabled = true
                }
            }
        }
    }
}
