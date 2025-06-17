//
//  PartiteViewModel.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import SwiftUI

class PartiteViewModel: ObservableObject {
    @Published var partite: [Partita] = []
    
    private let baseURL = "https://api.jsonbin.io/v3/b/685008f88a456b7966af054c"
    private let apiKey = "$2a$10$cEHKzlSJVBpENNlazaGOmOsiBxtNzzbWp5qBPExxp9zXvkhrN//wi"

    func caricaPartite() {
        guard let url = URL(string: "\(baseURL)/latest") else { return }
        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")
        
        URLSession.shared.dataTask(with: req) { data, _, _ in
            if let data = data {
                if let wrapper = try? JSONDecoder().decode(BinWrapper.self, from: data) {
                    DispatchQueue.main.async {
                        self.partite = wrapper.record.sorted { $0.data > $1.data }
                    }
                }
            }
        }.resume()
    }

    func salvaPartita(_ nuova: Partita) {
        guard let getURL = URL(string: baseURL) else { return }
        var getReq = URLRequest(url: getURL)
        getReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")

        URLSession.shared.dataTask(with: getReq) { [self] data, _, _ in
            guard let data = data,
                  var wrapper = try? JSONDecoder().decode(BinWrapper.self, from: data) else { return }

            // Sostituisci se data già esiste
            if let index = wrapper.record.firstIndex(where: { $0.data == nuova.data }) {
                wrapper.record[index] = nuova
            } else {
                wrapper.record.append(nuova)
            }

            guard let putURL = URL(string: self.baseURL) else { return }
            var putReq = URLRequest(url: putURL)
            putReq.httpMethod = "PUT"
            putReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            putReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")
            putReq.httpBody = try? JSONEncoder().encode(wrapper.record)

            URLSession.shared.dataTask(with: putReq).resume()
        }.resume()
    }

    func eliminaPartita(id: String) {
        guard let getURL = URL(string: self.baseURL) else { return }
        var getReq = URLRequest(url: getURL)
        getReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")

        partite.removeAll { $0.data == id }

        URLSession.shared.dataTask(with: getReq) { data, _, _ in
            guard let data = data,
                  var wrapper = try? JSONDecoder().decode(BinWrapper.self, from: data) else { return }

            wrapper.record.removeAll { $0.data == id }

            guard let putURL = URL(string: self.baseURL) else { return }
            var putReq = URLRequest(url: putURL)
            putReq.httpMethod = "PUT"
            putReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            putReq.setValue(self.apiKey, forHTTPHeaderField: "X-Master-Key")
            putReq.httpBody = try? JSONEncoder().encode(wrapper.record)

            URLSession.shared.dataTask(with: putReq).resume()
            self.caricaPartite()
        }.resume()
    }
}
