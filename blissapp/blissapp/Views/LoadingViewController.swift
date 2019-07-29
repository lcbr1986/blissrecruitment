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
        let networkController = NetworkController()
        
        networkController.getHealth { (data, error) in
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
        DispatchQueue.main.async {
            self.retryButton.setTitle("Retry", for: .normal)
            self.retryButton.isEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func retryAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.retryButton.setTitle("Loading", for: .normal)
            self.retryButton.isEnabled = false
            self.activityIndicator.startAnimating()
        }
        getHealth()
    }
    
    func presentListViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let questionListViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionsNavigationController") as! UINavigationController
        DispatchQueue.main.async {
            self.present(questionListViewController, animated: true, completion: nil)
        }

    }
    
}

