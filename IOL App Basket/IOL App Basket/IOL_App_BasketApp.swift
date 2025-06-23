//
//  IOL_App_BasketApp.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 17/06/25.
//

import SwiftUI

@main
struct IOL_App_BasketApp: App {
    
    init() {
        let tabBarColor = UIColor(red: 234/255, green: 4/255, blue: 90/255, alpha: 1.0)
        let tabBarTintColorSelected = UIColor(red: 255/255, green: 221/255, blue: 0/255, alpha: 1.0)
        let tabBarTintColorNotSelected = UIColor.black.withAlphaComponent(0.5)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = tabBarColor

        appearance.compactInlineLayoutAppearance.normal.iconColor = tabBarTintColorNotSelected
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: tabBarTintColorNotSelected,
            .paragraphStyle: NSParagraphStyle.default
        ]

        appearance.inlineLayoutAppearance.normal.iconColor = tabBarTintColorNotSelected
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: tabBarTintColorNotSelected,
            .paragraphStyle: NSParagraphStyle.default
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = tabBarTintColorNotSelected
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: tabBarTintColorNotSelected,
            .paragraphStyle: NSParagraphStyle.default
        ]
        
        
        appearance.compactInlineLayoutAppearance.selected.iconColor = tabBarTintColorSelected
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: tabBarTintColorSelected,
            .paragraphStyle: NSParagraphStyle.default
        ]

        appearance.inlineLayoutAppearance.selected.iconColor = tabBarTintColorSelected
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: tabBarTintColorSelected,
            .paragraphStyle: NSParagraphStyle.default
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = tabBarTintColorSelected
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: tabBarTintColorSelected,
            .paragraphStyle: NSParagraphStyle.default
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        
        let navBarColor: UIColor = UIColor(red: 47/255, green: 26/255, blue: 82/255, alpha: 1.0)

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = navBarColor
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Titolo
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Titolo grande

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance

        UINavigationBar.appearance().tintColor = .white
    }

    
    var body: some Scene {
        WindowGroup {
            TabView {
                PartitaListView()
                    .tabItem {
                        Label("Partite", systemImage: "basketball")
                    }
                StatisticheView(viewModel: PartiteViewModel())
                    .tabItem {
                        Label("Statistiche", systemImage: "chart.bar.fill")
                    }
            }
        }
    }
}
