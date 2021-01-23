//
//  DataLoader.swift
//  SupplierGoKit
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import Foundation

public enum DataLoaderError: Error{
    case HTTPRStatusCodeKO
    case NonHTTPResponse
    case genericError(String)
}

public protocol Loadable{
    typealias CompletionHandler = (_ data: Data?, _ error: DataLoaderError?) -> Void
    
    static func load(fromURL url: URL, completionHandler: @escaping CompletionHandler)
}

public struct DataLoader: Loadable{
    public static func load(fromURL url: URL, completionHandler: @escaping CompletionHandler){
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error{
                completionHandler(nil, .genericError(error.localizedDescription))
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                completionHandler(nil, .NonHTTPResponse)
                return
            }
            
            if 200...299 ~= response.statusCode{
                completionHandler(data, nil)
            } else{
                completionHandler(nil, .HTTPRStatusCodeKO)
            }
        }
        task.resume()
    }
}
