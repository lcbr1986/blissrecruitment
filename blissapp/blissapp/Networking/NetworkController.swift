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

    public func getHealth(completionHandler: @escaping (Data?, Error?) -> Void) {
        let endpoint = "https://private-anon-27236c9e20-blissrecruitmentapi.apiary-mock.com/health"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    public func getQuestions(limit: Int, offset: Int, filter: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let baseUrl = "https://private-anon-27236c9e20-blissrecruitmentapi.apiary-mock.com/questions"
        let endpoint = "\(baseUrl)?limit=\(limit)&offset=\(offset)&filter=\(filter)"
        
        createRequest(urlString: endpoint, completionHandler: completionHandler)
    }
    
    private func createRequest(urlString: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
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
