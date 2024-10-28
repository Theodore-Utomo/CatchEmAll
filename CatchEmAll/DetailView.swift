//
//  DetailView.swift
//  CatchEmAll
//
//  Created by Theodore Utomo on 10/19/24.
//

import SwiftUI

struct DetailView: View {
    let creature: Creature
    
    @State private var creatureDetail = CreatureDetail()
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 3){
            Text(creature.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
                .padding(.bottom)
            HStack {
                
                creatureImage
                
                VStack (alignment: .leading){
                    HStack (alignment: .top){
                        Text("Height: ")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(String(format: "%.1f", creatureDetail.height))
                            .font(.largeTitle)
                            .bold()
                    }
                    HStack (alignment: .top){
                        Text("Weight: ")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        
                        Text(String(format: "%.1f", creatureDetail.weight))
                            .font(.largeTitle)
                            .bold()
                    }
                    
                }
            }
            Spacer()
        }
        .padding()
        .task {
            creatureDetail.urlString = creature.url
            await creatureDetail.getData()
        }
    }
    
}

extension DetailView {
    var creatureImage: some View {
        AsyncImage(url: URL(string: creatureDetail.imageURL)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
                    .padding(.trailing)
            } else if phase.error != nil { // Error
                Image(systemName: "questionmark.square.dashed")
                    .resizable()
                    .scaledToFit()
                    .background(.white)
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
                    .padding(.trailing)
            } else { // Use placeholder - image loading
                //                        RoundedRectangle(cornerRadius: 10)
                //                            .foregroundStyle(.clear)
                //                            .frame(width: 96, height: 96)
                //                            .padding(.trailing)
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4.0)
                    .frame(width: 96, height: 96)
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    DetailView(creature: Creature(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
