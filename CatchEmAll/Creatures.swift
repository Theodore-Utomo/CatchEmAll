//
//  Creatures.swift
//  CatchEmAll
//
//  Created by Theodore Utomo on 10/18/24.
//

import Foundation

@MainActor
@Observable // Will watch objects for changes so that SwiftUI will redraw the interface when needed
class Creatures {
    private struct Returned: Codable {
        var count: Int
        var next: String? //TODO: We want to change this to an optional
        var results: [Creature]
    }
    
    
    var urlString = "https://pokeapi.co/api/v2/pokemon"
    var count = 0
    var creaturesArray: [Creature] = []
    var isLoading = false
    
    func getData() async {
        print("We are accessing the url \(urlString)")
        isLoading = true
        guard let url = URL(string: urlString) else {
            print("Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //Try to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("Could not decode JSON data from \(urlString)")
                return
            }
            Task { @MainActor in
                self.count = returned.count
                self.urlString = returned.next ?? ""
                self.creaturesArray = self.creaturesArray + returned.results // Async function takes some time and updating values impact user interface, so updating values is put on main thread
                isLoading = false
            }
        } catch {
            print("Could not get data from \(urlString)")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(creature: Creature) async {
        guard let lastCreature = creaturesArray.last else { return }
        if creature.name == lastCreature.name && urlString.hasPrefix("http") {
            await getData()
        }
    }
    func loadAll() async {
        Task { @MainActor in
            guard urlString.hasPrefix("http") else { return }
            
            await getData()
            await loadAll() // calls loadAll recursively to load all pokemon
        }
    }
}
