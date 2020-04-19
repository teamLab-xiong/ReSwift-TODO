//
//  MasterViewController.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit
import ReSwift

protocol MasterCoordinatorDelegate: AnyObject {
    func showDetail(with todo: TODO, from master: MasterViewController)
}

class MasterViewController: UITableViewController, StoreSubscriber {
    
    // MARK: -  StoreSubscriber
    typealias StoreSubscriberStateType = State
    
    func newState(state: State) {
        tableView.reloadData()
    }
    
    // MARK: - Properties
    
    weak var coordinatorDelegate: MasterCoordinatorDelegate?
    
    var store = Store<State>(reducer: State.reducer,
                             state: .init(),
                             middleware: [cacheMiddleware])


    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "TODO", message: nil, preferredStyle: .alert)
        alert.addTextField {
            $0.placeholder = "Input TODO"
        }
        alert.addAction(.init(title: "Add", style: .default) { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self.store.dispatch(AddTODO(todo: .init(title: text, date: Date())));
        })
        present(alert, animated: true)
    }

    // MARK: - Table View Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.state.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = store.state.todos[indexPath.row]
        cell.textLabel!.text = todo.title
        cell.detailTextLabel?.text = todo.date.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = store.state.todos[indexPath.row]
        if editingStyle == .delete {
            store.dispatch(RemoveTODO(todo: todo))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = store.state.todos[indexPath.row]
        coordinatorDelegate?.showDetail(with: todo, from: self)
    }
}

