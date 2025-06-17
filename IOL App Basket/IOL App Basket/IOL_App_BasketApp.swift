//
//  IOL_App_BasketApp.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import SwiftUI

@main
struct IOL_App_BasketApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PartitaListView()
                    .tabItem {
                        Label("Partite", systemImage: "list.bullet")
                    }
                StatisticheView(viewModel: PartiteViewModel())
                    .tabItem {
                        Label("Statistiche", systemImage: "chart.bar.fill")
                    }
            }
        }
    }
}
