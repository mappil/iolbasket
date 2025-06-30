//
//  PartitaListView.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import SwiftUI

struct PartitaListView: View {
    @StateObject private var viewModel: PartiteViewModel = .init()
    @State private var partitaDaEliminare: Partita?
    
    var body: some View {
        NavigationStack {
            if viewModel.partite.isEmpty {
                VStack {
                    Spacer()
                    Text("Caricamento in corso...")
                    Spacer()
                }
            }
            List {
                
                ForEach(viewModel.partite) { partita in
                    Section {
                        ForEach(partita.giocatori) { g in
                            HStack {
                                AvatarView(name: g.nome)
                                    .frame(width: 80, height: 80)
                                
                                Text(g.nome)
                                Spacer()
                                
                                if g.punteggio == punteggioMassimo(partita) {
                                    Text("🏆")
                                }
                                
                                Text("\(g.punteggio)")
                                    .bold()
                            }
                        }
                    } header: {
                        HStack {
                            Text(formatoData(partita.data))
                            Spacer()
                            Button(role: .destructive) {
                                partitaDaEliminare = partita
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("IOL Mobile App Basket")
            .toolbar {
                NavigationLink(destination: NuovaPartitaView()) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
                
            }
            .onAppear {
                Task {
                    await viewModel.caricaPartite()
                }
            }
            .alert("Sei sicuro di voler eliminare questa partita?", isPresented: .constant(partitaDaEliminare != nil), presenting: partitaDaEliminare) { partita in
                Button("Elimina", role: .destructive) {
                    Task {
                        await viewModel.eliminaPartita(id: partita.id)
                        partitaDaEliminare = nil
                    }
                }
                Button("Annulla", role: .cancel) {
                    partitaDaEliminare = nil
                }
            } message: { _ in
                Text("L'operazione è definitiva!")
            }
        }
        
    }
    
    func punteggioMassimo(_ partita: Partita) -> Int {
        partita.giocatori.map { $0.punteggio }.max() ?? 0
    }
    
    func formatoData(_ iso: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: iso) {
            return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        } else {
            // riprova senza frazioni di secondo
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: iso) {
                return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            }
        }
        
        return iso // fallback finale
    }
}
