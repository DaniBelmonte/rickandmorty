//
//  Character.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import Foundation

struct CharacterList: Codable {
    var results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let image: String
    let status: String
    let species: String
    let type: String
    let gender: String
}
