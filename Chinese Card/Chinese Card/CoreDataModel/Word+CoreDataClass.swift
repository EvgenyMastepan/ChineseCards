//
//  Word+CoreDataClass.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//
//

import Foundation
import CoreData

public typealias WordCoreDataClassSet = NSSet

@objc(Word)
public class Word: NSManagedObject {

}

public typealias WordCoreDataPropertiesSet = NSSet

extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var character: String?
    @NSManaged public var pinyin: String?
    @NSManaged public var translationRu: String?
    @NSManaged public var translationEn: String?
    @NSManaged public var hskLevel: Int16
    @NSManaged public var id: UUID?

}

extension Word : Identifiable {

}
