//
//  ShoppingListTableViewCell.swift
//  ShoppingList
//
//  Created by Nate Dukatz on 7/25/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

protocol ListItemTableViewCellDelegate {
    func itemCellButtonTapped(_ sender: ListItemTableViewCell)
}

class ListItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: ListItemTableViewCellDelegate?
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.itemCellButtonTapped(self)
    }
    
    func updateButton(_ isComplete: Bool) {
        completeButton.setImage(isComplete ? #imageLiteral(resourceName: "complete") : #imageLiteral(resourceName: "incomplete"), for: .normal)
    }

}

extension ListItemTableViewCell {
    
    func update(withItem listItem: ListItem) {
        itemLabel.text = listItem.name
        
        updateButton(listItem.isComplete)
    }
}
