//
//  ListItem+Convenience.swift
//  ShoppingList
//
//  Created by Nate Dukatz on 7/25/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

extension ListItem {
    
    convenience init(name: String, category: String, dueDate: Date? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.name = name
        self.category = category
        self.dueDate = dueDate as NSDate?
        self.isComplete = false
    }
}
