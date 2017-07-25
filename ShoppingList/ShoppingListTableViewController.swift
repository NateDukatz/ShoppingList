//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Nate Dukatz on 7/25/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ListItemTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        ListItemController.shared.fetchedResultsController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Item To Shopping List?", message: "Type your item here.", preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Item Name"
        }
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Category"
        }
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_: UIAlertAction) in
                if let nameTextField = alertController.textFields?.first, let categoryTextField = alertController.textFields?.last {
                    let itemName = nameTextField.text ?? ""
                    let category = categoryTextField.text ?? ""
                    
                    ListItemController.shared.add(listItemWith: itemName, category: category, dueDate: nil)
                    
                    DispatchQueue.main.async( execute: {
                        self.tableView.reloadData()
                    })
                }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func itemCellButtonTapped(_ sender: ListItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let listItem = ListItemController.shared.fetchedResultsController.object(at: indexPath)
        
        ListItemController.shared.toggleIsCompleteFor(listItem: listItem)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let frc = ListItemController.shared.fetchedResultsController
        if let sections = frc.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = ListItemController.shared.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController") }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ListItemTableViewCell else { return ListItemTableViewCell() }
        
        let listItem = ListItemController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.update(withItem: listItem)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = ListItemController.shared.fetchedResultsController.sections else { return nil }
        let name = sectionInfo[section].name
        
        return name
    }
    
    // MARK: - Fetch Results Delegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
 

    // MARK: - Editing Cell
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listItem = ListItemController.shared.fetchedResultsController.object(at: indexPath)
            ListItemController.shared.remove(listItem: listItem)
        }
    }

}
