//
//  DetailTodoViewController.swift
//  TodoApp_CoreData
//
//  Created by leewonseok on 2022/12/17.
//

import UIKit
import CoreData

enum PriorityLevel: Int16 {
    case level1 = 1
    case level2 = 2
    case level3 = 3
}

extension PriorityLevel {
    var color: UIColor {
        switch self {
        case .level1:
            return UIColor.green
        case .level2:
            return UIColor.orange
        case .level3:
            return UIColor.red
        }
    }
    var title: String {
        switch self {
        case .level1:
            return "Low"
        case .level2:
            return "Normal"
        case .level3:
            return "High"
        }
    }
}

protocol DetailTodoViewControllerProtocol {
    func didFinishSave()
}

class DetailTodoViewController: UIViewController {
    var delegate: DetailTodoViewControllerProtocol?
    var appdelegate = (UIApplication.shared.delegate as! AppDelegate)
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let halfButtonHeight: CGFloat = 20
    var isPickerOpen = true
    var priorityLevel = PriorityLevel.level1
    var todoItem: TodoList?
    
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var openCloseButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var priorityLevel1: UIButton! {
        didSet {
            priorityLevel1.layer.cornerRadius = halfButtonHeight
            priorityLevel1.setTitle(PriorityLevel.level1.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel2: UIButton! {
        didSet {
            priorityLevel2.layer.cornerRadius = halfButtonHeight
            priorityLevel2.setTitle(PriorityLevel.level2.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel3: UIButton! {
        didSet {
            priorityLevel3.layer.cornerRadius = halfButtonHeight
            priorityLevel3.setTitle(PriorityLevel.level3.title, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openCloseButton.setTitle("close", for: .normal)
        if let todoItem {
            saveButton.setTitle("Update", for: .normal)
            
            titleTextField.text = todoItem.title
            datePicker.date = todoItem.date ?? Date()
            let level = PriorityLevel(rawValue: todoItem.priorityLevel)
            priorityLevel = level ?? .level1
            
            updateLevelDesign(level: priorityLevel)
        } else {
            deleteButton.isHidden = true
        }
    }
    func updateLevelDesign(level: PriorityLevel) {
        priorityLevel1.backgroundColor = .clear
        priorityLevel2.backgroundColor = .clear
        priorityLevel3.backgroundColor = .clear
        
        switch level {
        case .level1:
            priorityLevel1.backgroundColor = level.color
        case .level2:
            priorityLevel2.backgroundColor = level.color
        case .level3:
            priorityLevel3.backgroundColor = level.color
        }
    }
    
    @IBAction func pickererOpenOrClose(_ sender: Any) {
        isPickerOpen.toggle()
        
        UIView.animate(withDuration: 0.25, delay: 0) {
            if self.isPickerOpen {
                self.datePickerHeight.priority = UILayoutPriority(240)
                self.openCloseButton.setTitle("close", for: .normal)
            }
            else {
                self.datePickerHeight.priority = UILayoutPriority(900)
                self.openCloseButton.setTitle("open", for: .normal)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selecteLevel(_ sender: UIButton) {
        
        switch sender.currentTitle {
        case PriorityLevel.level1.title:
            priorityLevel = .level1
        case PriorityLevel.level2.title:
            priorityLevel = .level2
        case PriorityLevel.level3.title:
            priorityLevel = .level3
        default:
            break
        }
        
        updateLevelDesign(level: priorityLevel)
    }
    
    @IBAction func save(_ sender: Any) {
        if let todoItem {
            //update
            CoreDataManager.shared.update(entity: todoItem) { entity in
                entity.title = titleTextField.text
                entity.priorityLevel = priorityLevel.rawValue
                entity.date = datePicker.date
            }
            
            delegate?.didFinishSave()
            dismiss(animated: true)
            return
        }
        
        CoreDataManager.shared.create(entity: TodoList.self) { entity in
            entity.title = titleTextField.text
            entity.priorityLevel = priorityLevel.rawValue
            entity.date = datePicker.date
            entity.id = UUID()
        }
        
        delegate?.didFinishSave()
        dismiss(animated: true)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        if let todoItem {
            CoreDataManager.shared.delete(entity: todoItem)
        
            delegate?.didFinishSave()
            dismiss(animated: true)
        }
    }
}

