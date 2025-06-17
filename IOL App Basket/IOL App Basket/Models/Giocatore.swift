//
//  Giocatore.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import Foundation

struct Giocatore: Codable, Identifiable, Equatable {
    let id: UUID = UUID()
    let nome: String
    let punteggio: Int
}
