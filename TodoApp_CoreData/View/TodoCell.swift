//
//  TodoCell.swift
//  TodoApp_CoreData
//
//  Created by leewonseok on 2022/12/17.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var priorityLevel: UIView! {
        didSet {
            priorityLevel.layer.cornerRadius = 30 / 2
        }
    }
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var bottomDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
