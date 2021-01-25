//
//  DataLoader.swift
//  SupplierGoKit
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import Foundation


/// Error returned by a Loadable component.
public enum DataLoaderError: Error{
    /// The HTTP(S) call returned a KO status code).
    case HTTPRStatusCodeKO
    /// The response of the endpoint is not HTTP.
    case NonHTTPResponse
    /// A generic error occured.
    case genericError(String)
}

/// A protocol that models the download from an URL.
public protocol Loadable{
    
    typealias CompletionHandler = (_ data: Data?, _ error: DataLoaderError?) -> Void
    
    
    /// Download data from the given URL endpoint.
    /// - Parameters:
    ///   - url: The endpoint.
    ///   - completionHandler: Returns the downloaded data to the caller, or the error that has occurred.
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
