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
    // MARK: - Переделываем в синглтон, так как у нас везде нужна одни и та же база. И других экземпляров нам не нать.
    static let shared = CoreManager()
    private init() {}
    
    // MARK: - Core Data стек
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChineseCard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data запись
    func saveContext() {
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



