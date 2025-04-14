//
//  ViewModel.swift
//  Drunken Cards
//
//  Created by Felipe Duarte on 9/04/25.
//

import Foundation
import SwiftData

@Observable
class CardSearchViewModel {
    
    enum SearchMode: String, CaseIterable, Identifiable {
        case cards = "Cartas"
        case sets = "Sets"
        
        var id: String { rawValue }
    }
    
    var query: String = ""
    var searchResults: [PokemonCardDTO] = []
    var isLoading: Bool = false
    var errorMessage: String?

    func searchCards() async {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {
            let urlQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let url = URL(string: "https://api.pokemontcg.io/v2/cards?q=name:\(urlQuery)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            

            let (data, _) = try await URLSession.shared.data(for: request)
            let jsonString = String(data: data, encoding: .utf8)
//            print("JSON string: \(jsonString ?? "No se pudo decodificar")")
            let decoded = try JSONDecoder().decode(CardSearchResponse.self, from: data)
            searchResults = decoded.data
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted:", context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch for type \(type):", context.debugDescription)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value \(value) not found:", context.debugDescription)
        } catch {
            print("Error decoding JSON:", error.localizedDescription)
        }
//        catch {
//            errorMessage = "Error buscando cartas: \(error.localizedDescription)"
//            searchResults = []
//        }

        isLoading = false
    }


    func saveCardIfNeeded(_ dto: PokemonCardDTO, context: ModelContext) {
        let cardID = dto.id  // ✅ extraemos el valor fuera del #Predicate

        let descriptor = FetchDescriptor<PokemonCard>(
            predicate: #Predicate { $0.id == cardID }
        )

        do {
            let existing = try context.fetch(descriptor)
            if existing.isEmpty {
                let newCard = convertToPokemonCard(from: dto)
                context.insert(newCard)
                try context.save()
                print("✅ Carta guardada en el inventario: \(newCard.name)")
            } else {
                print("ℹ️ Carta ya existente en el inventario")
            }
        } catch {
            print("❌ Error guardando carta: \(error.localizedDescription)")
        }
    }
    
    func convertToPokemonCard(from dto: PokemonCardDTO) -> PokemonCard {
        let marketPrice = dto.tcgplayer?.prices?["normal"]?.market

        return PokemonCard(
            id: dto.id,
            name: dto.name,
            hp: dto.hp ?? "N/A",
            types: dto.types ?? [],
            rarity: dto.rarity,
            imageURL: dto.images.small,
            price: marketPrice
        )
    }
    
    
    var setSearchQuery: String = ""
    var isLoadingSet = false
    var errorMessageSet: String?
    var setSearchResults: [PokemonSetDTO] = []

    func searchSets() async {
        guard !setSearchQuery.isEmpty else { return }

        isLoadingSet = true
        errorMessageSet = nil

        do {
            let encoded = setSearchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? setSearchQuery
            let url = URL(string: "https://api.pokemontcg.io/v2/sets?q=name:\(encoded)")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(SetSearchResponse.self, from: data)

            setSearchResults = decoded.data
        } catch {
            errorMessage = "No se pudieron cargar los sets. \(error.localizedDescription)"
            setSearchResults = []
        }

        isLoadingSet = false
    }

}
