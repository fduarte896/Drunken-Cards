//
//  CardSearchView.swift
//  Drunken Cards
//
//  Created by Felipe Duarte on 9/04/25.
//

import SwiftUI
import SwiftData

struct CardSearchView: View {
    @State private var viewModel = CardSearchViewModel()
    @State private var setViewModel = SetSearchViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var searchMode: SearchMode = .cards

    
    var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        TextField("Nombre de la carta", text: $viewModel.query)
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.search)
                            .onSubmit {
                                Task {
                                    await viewModel.searchCards()
                                }
                            }

                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.leading, 5)
                        }
                    }
                    .padding()

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                    }

                    List(viewModel.searchResults, id: \.id) { card in
                        NavigationLink(destination: CardDetailView(card: card)){
                            HStack(alignment: .top) {
                                AsyncImage(url: URL(string: card.images.small)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 90)
                                .cornerRadius(8)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(card.name)
                                        .font(.headline)

                                    if let rarity = card.rarity {
                                        Text("Rareza: \(rarity)")
                                            .font(.subheadline)
                                    }

                                    if let price = card.tcgplayer?.prices?["normal"]?.market {
                                        Text(String(format: "Precio: $%.2f", price))
                                            .font(.footnote)
                                            .foregroundStyle(.green)
                                    }
                                }

                                Spacer()

                                Button {
                                    viewModel.saveCardIfNeeded(card, context: modelContext)
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.blue)
                                        .font(.title2)
                                }
                                .buttonStyle(.borderless)

                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("Buscar Cartas")
            }
        }
}

#Preview {
    CardSearchView()
}
