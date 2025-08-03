//
//  CoreDataService.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import CoreData

final class CoreDataService {
    static let shared = CoreDataService()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "reza") // ganti sesuai nama model kamu
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveFavoriteUser(id: String, username: String) {
        let favorite = FavoriteUser(context: context)
        favorite.id = id
        favorite.username = username
        saveContext()
    }
    
    func deleteFavoriteUser(id: String) {
        let request = NSFetchRequest<FavoriteUser>(entityName: "FavoriteUser")
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("❌ Failed to delete favorite: \(error)")
        }
    }


    func isUserFavorite(id: String) -> Bool {
        let request = NSFetchRequest<FavoriteUser>(entityName: "FavoriteUser")
        request.predicate = NSPredicate(format: "id == %@", id)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func fetchFavorites() -> [FavoriteUser] {
        let request = NSFetchRequest<FavoriteUser>(entityName: "FavoriteUser")
        return (try? context.fetch(request)) ?? []
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data save error: \(error)")
            }
        }
    }
}
