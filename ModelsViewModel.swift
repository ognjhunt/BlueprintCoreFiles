//
//  ModelsViewModel.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 10/13/21.
//  Copyright © 2021 Placenote. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ModelsViewModel : ObservableObject {
    @Published var models: [Model] = []
    
    private let db = Firestore.firestore()
    
    func fetchData() {
//        db.collection("models").addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("Firestore: No docs")
//                return
//            }
//            
//            self.models = documents.map { (queryDocumentSnapshot) -> Model in
//                let data = queryDocumentSnapshot.data()
//                
//                let name = data["name"] as? String ?? ""
//                let categoryText = data["category"] as? String ?? ""
//                let category = ModelCategory(rawValue: categoryText) ?? .furniture
//                let scale = data["scale"] as? Double ?? 1.0
//                
//                return Model(name: name, category: category, scale: Float(scale))
//            }
//        }
    }
}
