//
//  ViewController.swift
//  Todoey
//
//  Created by Fırat AKBULUT on 28.09.2023.
//

import UIKit
import RealmSwift
import Chameleon

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.colour{
            
            title = selectedCategory?.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            if let navBarColour = UIColor(hexString: colourHex){
                navBar.barTintColor = navBarColour
                navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)

               
                searchBar.barTintColor = navBarColour
            }
            
            
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(hexString: colourHex)
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat:true)
            }
            
            // Using Swift Ternary Operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
        
    }
    
    //MARK: - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item.."
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            print("OK button tapped")
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print(error)
            }
        }
    }
    
}

//MARK: - SearchBar Delegate Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

