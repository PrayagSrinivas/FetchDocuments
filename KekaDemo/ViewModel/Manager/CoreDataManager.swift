//
//  CoreDataManager.swift
//  KekaDemo
//
//  Created by Webappclouds on 26/09/24.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "DocumentModel") // Use the name of your .xcdatamodeld file
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func saveDocument(_ document: DocumentModel) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        document.response.doc.forEach { docItem in
            let entity = DocumentEntity(context: context)
            entity.abstract = docItem.abstract
            entity.webUrl = docItem.webUrl
            entity.imageUrl = docItem.multimedia[2].url
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save document: \(error)")
        }
    }
    
    func fetchDocuments() -> [DocumentEntity] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DocumentEntity> = DocumentEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch documents: \(error)")
            return []
        }
    }

}
