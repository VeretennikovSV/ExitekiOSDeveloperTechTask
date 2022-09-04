//
//  CoreDataManager.swift
//  Exitek iOS Developer Tech Task
//
//  Created by Сергей Веретенников on 04/09/2022.
//

import Foundation
import CoreData

enum DataFetchErrors: Error {
    case duplicate
    case nothingToDelete
}

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

final class CoreDataManager: MobileStorage {
    
    lazy var viewContext = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Exitek_iOS_Developer_Tech_Task")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    // MARK: - Core Data Saving support

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addNewDeviceWith(name: String, imei: String, completion: @escaping (Mobile) -> Void) throws {
        let device = Mobile(context: viewContext)
        
        device.model = name
        device.imei = imei
        do {
            completion(try save(device))
        } catch let error {
            throw error
        }
    }
    
    func deleteDeviceWith(model: String, imei: String, completion: @escaping () -> Void) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mobile")
        request.predicate = NSPredicate(format: "imei = %@ && model = %@", imei, model)
        
        let result = try? viewContext.fetch(request) as? [NSManagedObject]
        
        result?.forEach { viewContext.delete($0) }
        completion()
        
    }
    
    func getAll() -> Set<Mobile> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mobile")
        let devices = try? viewContext.fetch(request) as? [Mobile]
        
        
        let set: Set<Mobile> = Set(devices ?? [])
        return set
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mobile")
        
        request.predicate = NSPredicate(format: "imei = %@", imei)
        
        let devices = try? viewContext.fetch(request) as? [Mobile]
        
        
        if devices?.count == 0 {
            return nil
        } else {
            let exactDevice = devices?.first
            
            saveContext()
            return exactDevice
        }
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        
        if exists(mobile) {
            throw DataFetchErrors.duplicate
        } else {
            viewContext.insert(mobile)
            saveContext()
            return mobile
        }
    }
    
    func delete(_ product: Mobile) throws {
        
        if exists(product) {
            viewContext.delete(product)
            saveContext()
        } else {
            throw DataFetchErrors.nothingToDelete
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mobile")
        request.predicate = NSPredicate(format: "imei = %@", product.imei ?? "")
        
        do {
            if try viewContext.fetch(request).count > 1 {
                viewContext.delete(product)
                saveContext()
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
}
