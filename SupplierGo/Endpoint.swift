//
//  Endpoint.swift
//  SupplierGo
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import Foundation

struct Endpoint{
    //static let baseAddress = "https://5f69b5fcd808b90016bc0551.mockapi.io/api/v1/addressBook/list"
    static let prot = "https"
    static let domain = "5f69b5fcd808b90016bc0551.mockapi.io"
    static let api = "api"
    static let version = "v1"
    
    static func addressBookList() -> URL{
        let components = [domain, api, version, "addressBook", "list"]
        let stringURL = prot + "://" + components.joined(separator: "/")
        guard let url = URL(string: stringURL) else{
            fatalError("Invalid URL")
        }
        return url
    }
}
