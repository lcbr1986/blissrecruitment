//
//  QuestionParser.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 15/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import Foundation

enum ParsingError: Error {
    case jsonSerialization(reason: String)
    case parsingError(reason: String)
}

struct QuestionParser {
    
    static func parseQuestions(questionData: Data?, completionHandler: @escaping ([Question]?, Error?) -> Void) {
        guard let data = questionData else {
            let error = ParsingError.parsingError(reason: "No data")
            completionHandler(nil, error)
            return
        }
        
        var questions = [Question]()
        do {
            if let questionsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for questionDict in questionsArray {
                    if let question = Question(dictionary: questionDict) {
                        questions.append(question)
                    }
                }
                
                completionHandler(questions, nil)
            } else {
                let error = ParsingError.parsingError(reason: "Could not parse JSON")
                completionHandler(nil, error)
            }
        }
        catch {
            let error = ParsingError.jsonSerialization(reason: "Could not serialize JSON")
            completionHandler(nil, error)
        }
    }
}
