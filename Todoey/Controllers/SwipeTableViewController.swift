//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Fırat AKBULUT on 4.10.2023.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            // handle action by updating model with deletion
            //            if let categoryForDeletion = self.categories?[indexPath.row]{
            //                do{
            //                    try self.realm.write {
            //                        self.realm.delete(categoryForDeletion)
            //                    }
            //                }catch{
            //                    print(error)
            //                }
            //            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath){
        
    }
    
}
