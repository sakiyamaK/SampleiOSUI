//
//  UserListEntity.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation
import UIKit.UIImage

public struct User: Codable, Hashable {
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public struct Id: Codable {
        let name: String?
        let value: String?
        var displayName: String {
            if let name, let value {
                name + ", " + value
            } else {
                "no name"
            }
        }
    }
    public struct Picture: Codable {
        let thumbnail: String?
        let large: String?
    }
    
    let id: Id
    let picture: Picture
    var uuid: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case picture
    }
    
    // Custom initializer for decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Id.self, forKey: .id)
        self.picture = try container.decode(Picture.self, forKey: .picture)
        self.uuid = UUID() // Generate a new UUID
    }
    
    public init(id: Id, picture: Picture) {
        self.id = id
        self.picture = picture
        self.uuid = UUID()
    }
    
    static var dummyUsers: [User] {
        guard let url = Bundle.module.url(forResource: "Users", withExtension: "json") else {
            print("Users.jsonがないよ")
            return []
        }
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let result = try JSONDecoder().decode(APIResult.self, from: data)
            return result.results
        } catch let e {
            print(e)
        }
        return []
    }
}

