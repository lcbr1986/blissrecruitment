//
//  NetworkManager.swift
//  blissapp
//
//  Created by Luis Carlos Rosa on 14/04/18.
//  Copyright © 2018 Luis. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
}

class NetworkController {

    let baseUrl = "https://private-anon-6a87a4a71d-blissrecruitmentapi.apiary-mock.com"
    public func getHealth(completionHandler: @escaping (Data?, Error?) -> Void) {
        let endpoint = "\(baseUrl)/health"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    public func getQuestions(limit: Int, offset: Int, filter: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let url = "\(baseUrl)/questions"
        let endpoint = "\(url)?limit=\(limit)&offset=\(offset)&filter=\(filter)"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    public func getQuestion(id: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let endpoint = "\(baseUrl)/questions/\(id)"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    public func shareQuestion(destinationEmail: String, questionId: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let url = "\(baseUrl)/share"
        let endpoint = "\(url)?destination_email=\(destinationEmail)&content_url=blissrecruitment://questions?question_id=\(questionId)"
        
        createRequest(urlString: endpoint, method: "POST", completionHandler: completionHandler)
    }
    
    public func updateQuestion(questionId: Int, body: Data, completionHandler: @escaping (Data?, Error?) -> Void) {
        let endpoint = "\(baseUrl)/questions/\(questionId)"
        
        createRequest(urlString: endpoint, method: "PUT", body: body, completionHandler: completionHandler)
    }
    
    private func createRequest(urlString: String, method: String = "GET", body: Data? = nil, completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            guard let responseData = data else {
                let error = BackendError.objectSerialization(reason: "No data in response")
                completionHandler(nil, error)
                return
            }
            completionHandler(responseData, nil)
        })
        task.resume()
    }
    
}
