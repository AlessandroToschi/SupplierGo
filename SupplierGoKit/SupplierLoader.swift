//
//  SupplierLoader.swift
//  SupplierGoKit
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import Foundation


/// The errors that can occur when downloading the suppliers.
public enum SupplierError: Error{
    /// A generic error from the underlying level.
    case dataError(DataLoaderError)
    /// The data returned is empty.
    case noData
    /// The data is not representable as list of suppliers.
    case invalidData
    /// The avatar's URL is invalid.
    case invalidAvatarURL
}

public class SupplierLoader{
    public let endpoint: URL
    public private(set) var suppliers: [Supplier]
    private let jsonDecoder: JSONDecoder
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
        self.suppliers = []
        self.jsonDecoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.jsonDecoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    
    /// Download the suppliers from the endpoint set during the instantiation.
    /// - Parameter completionHandler: Returns the error if occurred during the download and notifies for the end of the download.
    public func load(completionHandler: @escaping (_ error: SupplierError?) -> Void){
        DataLoader.load(fromURL: self.endpoint) {(data, error) in
            if let error = error{
                completionHandler(.dataError(error))
                return
            }
            guard let data = data else{
                completionHandler(.noData)
                return
            }
            
            guard let retrievedSupplier = try? self.jsonDecoder.decode([Supplier].self, from: data) else{
                completionHandler(.invalidData)
                return
            }
            
            self.suppliers = retrievedSupplier
            completionHandler(nil)
        }
    }
    
    /// Download the supplier's avatars, if suppliers are already loaded.
    /// - Parameter completionHandler: Returns the error if occurred during the download and notifies for the end of the download.
    public func loadAvatars(completionHandler: @escaping (_ error: SupplierError?) -> Void){
        for (index, supplier) in self.suppliers.enumerated(){
            guard let avatarURL = URL(string: supplier.avatar.endpoint) else{
                completionHandler(.invalidAvatarURL)
                continue
            }
            DataLoader.load(fromURL: avatarURL) {(data, error) in
                if let error = error{
                    completionHandler(.dataError(error))
                    return
                }
                guard let data = data else{
                    completionHandler(.noData)
                    return
                }
                
                self.suppliers[index].avatar.data = data
                completionHandler(nil)
            }
        }
    }
}
