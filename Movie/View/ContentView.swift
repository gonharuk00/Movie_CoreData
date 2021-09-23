//
//  ContentView.swift
//  Movie
//
//  Created by Alex Honcharuk on 21.09.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var _manager : MovieManager
    var body: some View {
        NavigationView{
            List{
                ForEach(Array(_manager.sections.keys.sorted(by: >)), id: \.self){ section in
                    Section(header: Text(section.uppercased())){
                        ForEach(_manager.sections[section] ?? [], id: \.id){ movie in
                            HStack(alignment: .center , spacing: 20) {
                                movie.pngImage
                                
                                VStack(alignment: .leading){
                                    Text(movie.name)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    RatingView(movie: movie)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetListStyle())
            .navigationBarItems(trailing:
                                    Button(action: {
                                        _manager.batchReset()
                                    }, label:{
                                        HStack(spacing: 2){
                                            Text("Reset")
                                            Image("yellowstar")
                                                .resizable()
                                                .frame(width: 15, height: 15, alignment: .center)
                                                .offset(y: -1)
                                        }
                                    }))
            .navigationBarTitle("Movie Library")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
