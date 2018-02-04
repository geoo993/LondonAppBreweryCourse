
import CoreData

public class CoreDataStack {
  
    public static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Runner")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
  
    public static var context: NSManagedObjectContext { return persistentContainer.viewContext 
    }
  
    public class func saveContext () {
        let context = persistentContainer.viewContext
    
        guard context.hasChanges else {
            return
        }
    
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
