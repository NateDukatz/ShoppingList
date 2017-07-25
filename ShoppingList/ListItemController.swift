//
//  ListItemController.swift
//  ShoppingList
//
//  Created by Nate Dukatz on 7/25/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

class ListItemController {
    
    static let shared  = ListItemController()
    
    let fetchedResultsController: NSFetchedResultsController<ListItem>
    
    // MARK: - Controller Initializer / Fetch Request
    init() {
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        let categorySortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        let completedSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        let dueDateSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [categorySortDescriptor, completedSortDescriptor, dueDateSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "category", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Could not perform fetch \(error)")
        }
    }
    
    // MARK: - CRUD Stuff
    
    func toggleIsCompleteFor(listItem: ListItem) {
        listItem.isComplete = !listItem.isComplete
        saveToPersistentStorage()
    }
    
    func add(listItemWith name: String, category: String, dueDate: Date?) {
        let _ = ListItem(name: name, category: category, dueDate: dueDate)
        
        saveToPersistentStorage()
    }
    
    func update(listItem: ListItem, name: String, category: String, dueDate: Date?) {
        listItem.name = name
        listItem.category = category
        listItem.dueDate = dueDate as NSDate?
        
        saveToPersistentStorage()
    }
    
    func remove(listItem: ListItem) {
        let moc = CoreDataStack.context
        moc.delete(listItem)
        do {
            try moc.save()
        } catch {
            NSLog("Couldn't save to persistent storage \(error)")
        }
        
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        
        let moc = CoreDataStack.context
        
        do {
            try moc.save()
        } catch {
            NSLog("Couldn't save to persistent storage \(error)")
        }
    }
}
