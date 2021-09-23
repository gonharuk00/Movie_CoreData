//
//  Movie+CoreDataProperties.swift
//  Movie
//
//  Created by Alex Honcharuk on 21.09.2021.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var format: String
    @NSManaged public var rating: Int16
    @NSManaged public var image: Data?

}

extension Movie : Identifiable {

}
