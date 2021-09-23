//
//  MovieManager.swift
//  Movie
//
//  Created by Alex Honcharuk on 21.09.2021.
//

import Foundation
import CoreData

class MovieManager :NSObject, ObservableObject {
    @Published var movies = [Movie]()
    @Published var sections = [String: [Movie]]()
    
    private let _context: NSManagedObjectContext
    private let _fetchedResultController: NSFetchedResultsController<Movie>
    
    init(context: NSManagedObjectContext) {
        self._context = context
        
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Movie.format, ascending: false),
            NSSortDescriptor(keyPath: \Movie.name, ascending: true)
        ]
        
        self._fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                                   managedObjectContext: self._context,
                                                                   sectionNameKeyPath: #keyPath(Movie.format),
                                                                   cacheName: nil)
        super.init()
        
        self._fetchedResultController.delegate = self
        loadMovies()
    }
    
    private func loadMovies(){
        do{
            try self._fetchedResultController.performFetch()
            
            if let sections = _fetchedResultController.sections, !sections.isEmpty {
                for section in sections{
                    if let movies = section.objects as? [Movie] {
                        self.sections[section.name] = movies
                    }
                }
            }
            movies = self._fetchedResultController.fetchedObjects ?? []
        }
        catch{
            print("Error fetching movies : \(error.localizedDescription)")
        }
    }
    
    func save(){
        if self._context.hasChanges{
            do{
                try self._context.save()
            }
            catch{
                fatalError("Error saving Data \(error.localizedDescription)")
            }
        }
    }
    
    func update(_ movie: Movie){
        save()
    }
    
    func resetRating(){
        for movie in movies{
            movie.rating = 0
        }
        save()
    }
    
    func batchReset(){
        let request = NSBatchUpdateRequest(entityName: "Movie")
        request.propertiesToUpdate = [#keyPath(Movie.rating) : 0]
        request.affectedStores = _context.persistentStoreCoordinator?.persistentStores
        request.resultType = .updatedObjectsCountResultType
        
        do{
            let bacthResult = try _context.execute(request) as? NSBatchUpdateResult
            print("Batch update: \(bacthResult!.result)")
            
            _context.reset()
            loadMovies()
        }
        catch{
            print("Error update : \(error.localizedDescription)")
        }
    }
}

extension MovieManager : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let updateMovies = controller.fetchedObjects as? [Movie] else { return }
        movies = updateMovies
    }
}
