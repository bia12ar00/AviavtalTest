//
//  CoreDataAppoiment+CoreDataProperties.swift
//  
//
//  Created by Bhavin Kevadia on 15/09/22.
//
//

import Foundation
import CoreData


extension CoreDataAppoiment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataAppoiment> {
        return NSFetchRequest<CoreDataAppoiment>(entityName: "CoreDataAppoiment")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var dateTime: String?
    @NSManaged public var id: String?

}
