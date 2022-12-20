//
//  CoreDataManager.swift
//  TodoApp_CoreData
//
//  Created by leewonseok on 2022/12/19.
//

import Foundation
import CoreData

// singleton
class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init () { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        // 모델의 정보를 가져오는 것
        let container = NSPersistentContainer(name: "TodoApp_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

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
    
    // 범용적인 타입을 위해 generic
    // T타입을 파라미터로 받아서 사용해야함. - entity
    // fetchRequest는 class func이기 떄문에 T타입 자체를 받기 위해 T.Type
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T]? {
        
//        아래와 같은 타입으로는 사용이 불가능함. 모호하다
//        -> NSMangedObject의 fetchRequest와 TodoList.fetchRequest를 확인해보면 알 수 있듯이 51번 라인과 같이 사용해야함
//        let fetchRequest = entity.fetchRequest()
        
        let fetchRequest = NSFetchRequest<T>(entityName: T.self.description())
        
        let context = self.persistentContainer.viewContext
        
        do{
            return try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return nil
    }
    
    func create<T: NSManagedObject>(entity: T.Type, completion: (T) -> Void) {
        let context = self.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: T.self.description(), in: context) else { return }

        guard let managedObject = NSManagedObject(entity: entityDescription, insertInto: context) as? T else { return }
        
        completion(managedObject)

        self.saveContext()
    }
    
    func update<T: NSManagedObject>(entity: T, completion: (T) -> Void){
        completion(entity)
        self.saveContext()
    }
    
    func delete(entity: NSManagedObject) {
        let context = self.persistentContainer.viewContext
        context.delete(entity)
        self.saveContext()
    }
}
