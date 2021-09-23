//
//  MovieApp.swift
//  Movie
//
//  Created by Alex Honcharuk on 21.09.2021.
//

import SwiftUI

@main
struct MovieApp: App {
    let movieManager = MovieManager(context: PersistenseManager().container.viewContext)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieManager)
        }
    }
}
