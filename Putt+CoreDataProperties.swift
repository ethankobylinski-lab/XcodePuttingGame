// File: Putt+CoreDataProperties.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/7/25.
//

import Foundation
import CoreData

extension CDPutt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPutt> {
        return NSFetchRequest<CDPutt>(entityName: "Putt")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var user: String?
    @NSManaged public var distance: Int16
    @NSManaged public var breakType: String?
    @NSManaged public var putterType: String?
    @NSManaged public var gripStyle: String?
    @NSManaged public var result: String?
    @NSManaged public var xp: Int16

}

extension CDPutt : Identifiable { }
