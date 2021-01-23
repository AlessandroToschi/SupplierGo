//
//  SupplierLoader.swift
//  SupplierGoKit
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import Foundation

public enum SupplierError: Error{
    case dataError(DataLoaderError)
    case noData
    case invalidData
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
}
