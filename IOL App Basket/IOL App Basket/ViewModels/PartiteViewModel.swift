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

    @MainActor
    func caricaPartite() async {
        guard let url = URL(string: "\(baseURL)/latest") else { return }

        var req = URLRequest(url: url)
        req.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")

        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            let wrapper = try JSONDecoder().decode(BinWrapper.self, from: data)

            // Aggiorna la proprietà @Published direttamente su main thread grazie a @MainActor
            self.partite = wrapper.record.sorted { $0.data > $1.data }

        } catch {
            print("Errore in caricaPartite: \(error)")
        }
    }

    func salvaPartita(_ nuova: Partita) async {
        guard let getURL = URL(string: baseURL) else { return }

        var getReq = URLRequest(url: getURL)
        getReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")

        do {
            let (data, _) = try await URLSession.shared.data(for: getReq)
            var wrapper = try JSONDecoder().decode(BinWrapper.self, from: data)

            if let index = wrapper.record.firstIndex(where: { $0.data == nuova.data }) {
                wrapper.record[index] = nuova
            } else {
                wrapper.record.append(nuova)
            }

            guard let putURL = URL(string: baseURL) else { return }

            var putReq = URLRequest(url: putURL)
            putReq.httpMethod = "PUT"
            putReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            putReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")
            putReq.httpBody = try JSONEncoder().encode(wrapper.record)

            _ = try await URLSession.shared.data(for: putReq)

        } catch {
            print("Errore in salvaPartita: \(error)")
        }
    }

    func eliminaPartita(id: String) async {
        guard let getURL = URL(string: baseURL) else { return }

        var getReq = URLRequest(url: getURL)
        getReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")

        do {
            let (data, _) = try await URLSession.shared.data(for: getReq)
            var wrapper = try JSONDecoder().decode(BinWrapper.self, from: data)

            wrapper.record.removeAll { $0.data == id }

            guard let putURL = URL(string: baseURL) else { return }

            var putReq = URLRequest(url: putURL)
            putReq.httpMethod = "PUT"
            putReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            putReq.setValue(apiKey, forHTTPHeaderField: "X-Master-Key")
            putReq.httpBody = try JSONEncoder().encode(wrapper.record)

            _ = try await URLSession.shared.data(for: putReq)

            await caricaPartite() // Assicurati che anche questa sia async

        } catch {
            print("Errore in eliminaPartita: \(error)")
        }
    }
}
