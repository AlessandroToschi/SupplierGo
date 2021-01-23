//
//  Supplier.swift
//  SupplierGoKit
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import Foundation

public struct Supplier: Decodable{
    public let id: Int
    public let creationDate: Date
    public let fullname: String
    public var avatar: SupplierAvatar
    public let phone: String
    public let company: String
    public let email: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SupplierCodingKeys.self)
        self.id = Int(try container.decode(String.self, forKey: .id))!
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.fullname = try container.decode(String.self, forKey: .fullname)
        self.avatar = SupplierAvatar(endpoint: try container.decode(String.self, forKey: .avatar), data: nil)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.company = try container.decode(String.self, forKey: .company)
        self.email = try container.decode(String.self, forKey: .email)
    }
    
    private enum SupplierCodingKeys: String, CodingKey{
        case id
        case creationDate = "createdAt"
        case fullname
        case avatar
        case phone
        case company
        case email
    }
}
