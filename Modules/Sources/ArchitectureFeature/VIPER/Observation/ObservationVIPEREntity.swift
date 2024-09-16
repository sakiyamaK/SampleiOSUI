//
//  ObservationVIPEREntity.swift
//
//
//  Created by sakiyamaK on 2024/09/16.
//

import Foundation

public enum ObservationVIPERViewEvent {
    case viewDidLoad
    case refreshControlValueChanged
    case didSelect(user: User)
}

public struct User: Codable, Hashable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    struct Id: Codable {
        let name: String?
        let value: String?
    }
    struct Picture: Codable {
        let thumbnail: String?
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
}

