//
//  Mobile+CoreDataProperties.swift
//  Exitek iOS Developer Tech Task
//
//  Created by Сергей Веретенников on 04/09/2022.
//
//

import Foundation
import CoreData


extension Mobile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mobile> {
        return NSFetchRequest<Mobile>(entityName: "Mobile")
    }

    @NSManaged public var imei: String?
    @NSManaged public var model: String?

}

extension Mobile : Identifiable {

}
