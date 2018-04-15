//
//  Question.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import Foundation

struct Question {
    let id: Int
    let question: String
    let imageUrl: String
    let thumbUrl: String
    let publishedAt: Date
    let choices: [Choice]
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let question = dictionary["question"] as? String,
            let imageUrl = dictionary["image_url"] as? String,
            let thumbUrl = dictionary["thumb_url"] as? String,
            let publishedAtString = dictionary["published_at"] as? String,
            let choicesArray = dictionary["choices"] as? [[String: Any]] else {
                return nil
        }
        self.id = id
        self.question = question
        self.imageUrl = imageUrl
        self.thumbUrl = thumbUrl
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let publishedAt = dateFormatter.date(from: publishedAtString) else {
            return nil
        }
        self.publishedAt = publishedAt
        var choices = [Choice]()
        for choiceDict in choicesArray {
            if let choice = Choice(dictionary: choiceDict) {
                choices.append(choice)
            }
        }
        self.choices = choices
    }
}
