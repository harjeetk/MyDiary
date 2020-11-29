//
//  MyNotes+CoreDataProperties.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//
//

import Foundation
import CoreData


extension MyNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyNotes> {
        return NSFetchRequest<MyNotes>(entityName: "MyNotes")
    }

    @NSManaged public var cdIdentifier: String?
    @NSManaged public var cdTitle: String?
    @NSManaged public var cdContent: String?
    @NSManaged public var cdDate: String?

}

extension MyNotes : Identifiable {

}
