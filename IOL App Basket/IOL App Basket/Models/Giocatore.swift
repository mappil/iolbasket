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
    
    var device: String {
        switch nome.lowercased() {
        case "max", "ste":
            return ""
        default:
            return "🤖"
        }
    }
    
    var nomeWithDevice: String {
        "\(nome) \(device)"
    }
    
}
