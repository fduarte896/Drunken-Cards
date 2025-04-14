//
//  CardDetailView.swift
//  Drunken Cards
//
//  Created by Felipe Duarte on 9/04/25.
//

import SwiftUI

struct CardDetailView: View {
    let card: PokemonCardDTO

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Imagen
                AsyncImage(url: URL(string: card.images.large)) { image in
                    image.resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .shadow(radius: 6)
                } placeholder: {
                    ProgressView()
                }
                .padding(.top)

                // Precio
                if let price = card.tcgplayer?.prices?["normal"]?.market {
                    Text(String(format: "💰 Precio de mercado: $%.2f", price))
                        .font(.title3)
                        .foregroundStyle(.green)
                }

                // Historial de precios (Cardmarket)
                if let avg30 = card.cardmarket?.prices.avg30 {
                    Text(String(format: "📈 Promedio últimos 30 días: $%.2f", avg30))
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }

                // Flavor text
                if let flavor = card.flavorText {
                    VStack(alignment: .leading) {
                        Text("Texto de ambientación")
                            .font(.headline)
                        Text("“\(flavor)”")
                            .italic()
                    }
                    .padding(.horizontal)
                }

                // Enlaces externos
                if let tcgURL = card.tcgplayer?.url {
                    Link("Ver en TCGPlayer", destination: URL(string: tcgURL)!)
                        .font(.callout)
                        .padding(.top)
                }

                // Agregar al inventario
                Button(action: {
                    // Lógica aquí para guardar la carta
                }) {
                    Label("Agregar a mi colección", systemImage: "plus.circle.fill")
                        .font(.title3)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
        }

        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
//    CardDetailView()
}
