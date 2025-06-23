//
//  StatisticheView.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import SwiftUI
import Charts

struct StatisticheView: View {
    @ObservedObject var viewModel: PartiteViewModel

    struct Stat: Identifiable {
        var id: String { nome }
        let nome: String
        let punti: Int
        let vinte: Int
    }

    var stats: [Stat] {
        var punteggi: [String: Int] = [:]
        var vittorie: [String: Int] = [:]

        for partita in viewModel.partite {
            let maxPunti = partita.giocatori.map { $0.punteggio }.max() ?? 0
            let vincitori = partita.giocatori.filter { $0.punteggio == maxPunti }.map { $0.nome }

            for g in partita.giocatori {
                punteggi[g.nome, default: 0] += g.punteggio
                if vincitori.contains(g.nome) {
                    vittorie[g.nome, default: 0] += 1
                }
            }
        }

        return punteggi.map { (nome, punti) in
            Stat(nome: nome, punti: punti, vinte: vittorie[nome, default: 0])
        }
        .sorted { $0.punti > $1.punti }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Statistiche Giocatori")
                        .font(.title2.bold())
                        .padding(.bottom)
                    
                    Chart(stats) { stat in
                        BarMark(
                            x: .value("Giocatore", stat.nome),
                            y: .value("Punti", stat.punti)
                        )
                        .foregroundStyle(by: .value("Giocatore", stat.nome))
                    }
                    .frame(height: 250)
                    
                    Divider().padding(.vertical)
                    
                    ForEach(stats) { stat in
                        HStack {
                            AvatarView(name: stat.nome)
                                .frame(width: 32, height: 32)
                            
                            Text(stat.nome)
                            Spacer()
                            Text("🏆 \(stat.vinte)  |  \(stat.punti) punti")
                                .bold()
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .onAppear {
                    Task {
                        await viewModel.caricaPartite()
                    }
                }
            }
            .navigationTitle("Statistiche")
        }
    }
}
