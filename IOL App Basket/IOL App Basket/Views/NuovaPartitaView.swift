//
//  NuovaPartitaView.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import SwiftUI

struct NuovaPartitaView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PartiteViewModel = .init()

    let tuttiGiocatori = [
        "Sbaruffa",
        "Max",
        "Ema",
        "Ste",
        "Pam",
        "Claudia"
    ]

    @State private var selezionati: [String] = []
    @State private var punteggi: [String: Int] = [:]
    @State private var data = Date()

    var body: some View {
        Form {
            EmptyView()
            
            DatePicker("Data", selection: $data, displayedComponents: .date)

            ForEach(tuttiGiocatori, id: \.self) { nome in
                Section {
                    HStack {
                        AvatarView(name: nome)
                        .frame(width: 40, height: 40)
                        
                        Toggle(nome, isOn: Binding(
                            get: { selezionati.contains(nome) },
                            set: { nuovoVal in
                                if nuovoVal {
                                    selezionati.append(nome)
                                } else {
                                    selezionati.removeAll { $0 == nome }
                                    punteggi[nome] = nil
                                }
                            }
                        ))
                        
                    }
                    if selezionati.contains(nome) {
                        Stepper("Punti: \(punteggi[nome, default: 0])", value: Binding(
                            get: { punteggi[nome, default: 0] },
                            set: { punteggi[nome] = $0 }
                        ), in: 0...30)
                    }
                }
            }

            Button("Salva") {
                let giocatori = selezionati.map {
                    Giocatore(nome: $0, punteggio: punteggi[$0] ?? 0)
                }
                let isoData = ISO8601DateFormatter().string(from: data)
                Task {
                    let nuova = Partita(data: isoData, giocatori: giocatori)
                    await viewModel.salvaPartita(nuova)
                    dismiss()
                }
            }
            .disabled(selezionati.isEmpty)
        }
        .navigationTitle("Nuova Partita")
    }
}
