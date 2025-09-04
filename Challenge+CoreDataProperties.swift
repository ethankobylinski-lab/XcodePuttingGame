// File: Challenge+CoreDataProperties.swift
//  PuttingGameV1
//

import Foundation
import CoreData

extension CDChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDChallenge> {
        return NSFetchRequest<CDChallenge>(entityName: "Challenge")
    }

    @NSManaged public var date: Date?
    @NSManaged public var type: String?
    @NSManaged public var makes: Int16
    @NSManaged public var attempts: Int16
    @NSManaged public var xp: Int16
    @NSManaged public var makePct: Double
    @NSManaged public var result: String?

}

extension CDChallenge : Identifiable { }
