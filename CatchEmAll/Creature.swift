//
//  Creature.swift
//  CatchEmAll
//
//  Created by Theodore Utomo on 10/19/24.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String // url detail on Pokemon
    
    enum CodingKeys: CodingKey { // ignore property ID when decoding
        case name
        case url
    }
}
