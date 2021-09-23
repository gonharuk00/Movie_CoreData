//
//  Persistense Manager.swift
//  Movie
//
//  Created by Alex Honcharuk on 21.09.2021.
//

import Foundation
import CoreData

struct PersistenseManager {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores { (store, error) in
            if let error = error as NSError? {
                fatalError("Error load \(store) : \(error.localizedDescription)")
            }
        }
        checkData()
    }
    
    private func checkData(){
        let context = container.viewContext
        let request : NSFetchRequest<Movie> = Movie.fetchRequest()
        
        if let movieCount = try? context.count(for: request), movieCount > 0 {
            return
        }
        uploadSampleData()
    }
    
    private func uploadSampleData(){
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let codingUserKeyContext = CodingUserInfoKey.codingUserInfoKeyContext
        else { return }
        
        do {
            let context = container.viewContext
            let decoder = JSONDecoder()
            
            decoder.userInfo[codingUserKeyContext] = context
            _ = try decoder.decode([Movie].self, from: data)
            
            try context.save()
            
        }
            catch let error{
            print(error)
        }
    }
}
