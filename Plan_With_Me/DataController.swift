//
//  DataController.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-03-11.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "Model")
    
    init(){
        container.loadPersistentStores{
            description, error in
            if let error = error{
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
    }
}
