//
//  SetSearchViewModel.swift
//  Drunken Cards
//
//  Created by Felipe Duarte on 11/04/25.
//

import Foundation

@Observable
class SetSearchViewModel {
    var query: String = ""
    var isLoading = false
    var errorMessage: String?
    var searchResults: [PokemonSetDTO] = []

    func searchSets() async {
        guard !query.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let url = URL(string: "https://api.pokemontcg.io/v2/sets?q=name:\(encoded)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(SetSearchResponse.self, from: data)

            searchResults = decoded.data
        } catch {
            errorMessage = "No se pudieron cargar los sets. \(error.localizedDescription)"
            searchResults = []
        }

        isLoading = false
    }
}
