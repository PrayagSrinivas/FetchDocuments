//
//  ViewModel.swift
//  KekaDemo
//
//  Created by Webappclouds on 26/09/24.
//

import CoreData

class ViewModel: ObservableObject {
    @Published var result: [DocumentEntity] = []
    private var networkManager: NetworkService
    private var coreDataManager: CoreDataManager
    
    init(networkManager: NetworkService = NetworkManager.shared, coreDataManager: CoreDataManager = .shared) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.result = coreDataManager.fetchDocuments()
    }
    
    // Now an async function
    func getDocument() async {
        do {
            let document: DocumentModel = try await networkManager.fetchDocument()
            coreDataManager.saveDocument(document)
            
            // Update the result on the main thread
            await MainActor.run {
                self.result = self.coreDataManager.fetchDocuments()
            }
        } catch {
            print("Error fetching document: \(error.localizedDescription)")
        }
    }
}
