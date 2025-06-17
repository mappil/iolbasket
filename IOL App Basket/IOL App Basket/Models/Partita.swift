//
//  Partita.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import Foundation

struct Partita: Codable, Identifiable {
    var id: String { data } // ISO string
    let data: String
    let giocatori: [Giocatore]
    
    
}
