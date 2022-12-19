//
//  ViewController.swift
//  TodoApp_CoreData
//
//  Created by leewonseok on 2022/12/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        }
    }
    var todoList = [TodoList]()
    let appdelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    func fetchData() {
        let fetchRequest = TodoList.fetchRequest()
        let context = appdelegate.persistentContainer.viewContext
        
        do{
            todoList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "To Do List"
        self.addRightBarButtonItem()
        self.fetchData()
        self.tableView.reloadData()
    }
    
    private func addRightBarButtonItem() {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTodo))
        item.tintColor = .orange
        
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func createTodo() {
        let detailVC = DetailTodoViewController(nibName: "DetailTodoViewController", bundle: nil)
        detailVC.delegate = self
        self.present(detailVC, animated: true)
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell

        cell.topTitle.text = todoList[indexPath.row].title
        let formatter = DateFormatter()
        formatter.dateFormat = " MM-dd hh:mm:ss"
        if let todoDate = todoList[indexPath.row].date {
            cell.bottomDate.text = formatter.string(from: todoDate)
        }
        
        let savedLevel = todoList[indexPath.row].priorityLevel
        let level = PriorityLevel(rawValue: savedLevel)
        cell.priorityLevel.backgroundColor = level?.color
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTodoViewController(nibName: "DetailTodoViewController", bundle: nil)
        detailVC.delegate = self
        
        detailVC.todoItem = todoList[indexPath.row]
        
        self.present(detailVC, animated: true)
    }
}

extension ViewController: DetailTodoViewControllerProtocol {
    func didFinishSave() {
        self.fetchData()
        self.tableView.reloadData()
    }
}
