//
//  RatingView.swift
//  Movie
//
//  Created by Alex Honcharuk on 21.09.2021.
//

import SwiftUI

struct RatingView: View {
    @EnvironmentObject private var manager: MovieManager
    var movie: Movie
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { idx in
                Image(idx < movie.rating ? "yellowstar" : "blackstar")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .onTapGesture {
                        movie.rating = Int16(idx + 1)
                        manager.update(movie)
                    }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(movie: Movie())
    }
}
