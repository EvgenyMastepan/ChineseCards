//
//  Word+CoreDataProperties.swift
//  Chinese Card
//
//  Created by Evgeny Mastepan on 26.10.2025.
//
//

import Foundation
import CoreData

class CoreManager {
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ChineseCard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



