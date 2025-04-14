//
//  InventoryView.swift
//  Drunken Cards
//
//  Created by Felipe Duarte on 9/04/25.
//

import SwiftUI
import SwiftData

struct InventoryView: View {
    @Query var inventory: [PokemonCard]

    var body: some View {
        NavigationStack {
            List {
                ForEach(inventory, id: \.id) { card in
                    HStack(alignment: .top) {
                        AsyncImage(url: URL(string: card.imageURL)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 90)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 90)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(card.name)
                                .font(.headline)

                            if !card.types.isEmpty {
                                Text("Tipo: \(card.types.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            if let price = card.price {
                                Text(String(format: "💰 $%.2f", price))
                                    .font(.footnote)
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Mi Inventario")
        }
    }
}
#Preview {
    InventoryView()
}
