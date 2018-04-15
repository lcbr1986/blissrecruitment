//
//  ViewController.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 14/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHealth()        
    }
    
    func getHealth() {
        let networkManager = NetworkController()
        
        networkManager.getHealth { (data, error) in
            guard let data = data else {
                self.showRetry()
                return
            }
            do {
                if let statusDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    guard let status = statusDict["status"] as? String else {
                        self.showRetry()
                        return
                    }
                    if status == "OK" {
                        self.presentListViewController()
                    } else {
                        self.showRetry()
                    }
                }
            }
            catch {
                self.showRetry()
            }
        }
    }
    
    func showRetry() {
        retryButton.setTitle("Retry", for: .normal)
        retryButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func retryAction(_ sender: Any) {
        retryButton.setTitle("Loading", for: .normal)
        retryButton.isEnabled = false
        activityIndicator.startAnimating()
        getHealth()
    }
    
    func presentListViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let questionListViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionListViewController") as! QuestionListViewController
        self.present(questionListViewController, animated: true, completion: nil)

    }
    
}

