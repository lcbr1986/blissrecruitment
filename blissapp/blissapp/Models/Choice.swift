//
//  Choice.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

struct Choice {
    let choice: String
    let votes: Int
    
    init?(dictionary: [String: Any]) {
        guard let choice = dictionary["choice"] as? String,
            let votes = dictionary["votes"] as? Int else {
            return nil
        }
        
        self.choice = choice
        self.votes = votes
    }
}
