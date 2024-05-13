//
//  ViewController.swift
//  ToDo
//
//  Created by vallekal's on 12/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List by Uzair..."
        view.addSubview(tableView)
        getAllItem()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounds = view.bounds
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    
    @objc private func didTapAdd(){
        
        let alert = UIAlertController(title: "New Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty
            else{
                return}
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "MODIFY", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
        
        let alert = UIAlertController(title: "Edit Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = item.name
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let newname = field.text, !newname.isEmpty
            else{
                return}
            self?.updateItem(item: item, newName: newname)
        }))
            self.present(alert, animated: true)
        
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self]_ in
            self?.deleteitem(item: item)
        }))

        
        self.present(sheet, animated: true)
        
        
        
    }
    
    
    //core data
    
    func getAllItem(){
        do{
            models = try context.fetch(ToDoListItem.fetchRequest())
            tableView.reloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            //error
        }
    }
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItem()
        }
        catch{
            //error
        }
        
    }
    func deleteitem(item: ToDoListItem){
        context.delete(item)
        
        do{
            try context.save()
            getAllItem()
        }
        catch {
            //error handeling
        }
        
    }
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        do {
            try context.save()
            getAllItem()
        }
        catch{
            //error handeling
        }
    }
}
extension ViewController: UITableViewDelegate{
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let model = models[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }
    
    
}
