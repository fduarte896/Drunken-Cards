//
//  MainView.swift
//  Drunken Cards
//
//  Created by Felipe Duarte on 9/04/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CardSearchView()
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }

            InventoryView()
                .tabItem {
                    Label("Inventario", systemImage: "tray.full")
                }
        }
    }
}
#Preview {
    MainView()
}
