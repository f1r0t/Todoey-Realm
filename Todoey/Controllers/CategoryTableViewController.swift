//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Fırat AKBULUT on 1.10.2023.
//

import UIKit
import RealmSwift
import Chameleon

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       NavigationColour()

        loadCategories()
    }
    
    func NavigationColour(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = .systemBlue
        scrollEdgeAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationColour()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        if let category = categories?[indexPath.row]{
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColour, isFlat:true)
        }
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print(error)
            }
        }
    }
    
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            print("OK button tapped")
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories?[indexpath.row]
        }
    }
    
}


