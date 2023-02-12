//
//  FoodVC.swift
//  CalorieFriend
//
//  Created by Brandon on 2/11/23.
//

import UIKit

class FoodVC: UITableViewController {
    
    let reuseIdentifier = "ToDoCell"
    var data: [ToDo]? {
        didSet {
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        let toDoManager = ToDoManager()
        
        toDoManager.fetchToDos() { result in
            self.data = result
            DispatchQueue.main.async { [self] in
                navigationItem.title = "Menu"
            }
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .lightGray
        tableView.tableFooterView = UIView()
    }
    
}

extension FoodVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        guard let toDo = data?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "\(toDo.userId): \(toDo.title) - \(toDo.completed)"
        
        return cell
    }
}
