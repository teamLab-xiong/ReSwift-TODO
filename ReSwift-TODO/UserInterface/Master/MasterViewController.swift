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
    func showCreateViewController(from master: MasterViewController)
    func delete(_ todo: TODO, from master: MasterViewController)
}

class MasterViewController: UITableViewController, StoreSubscriber {
    
    // MARK: -  StoreSubscriber
    typealias StoreSubscriberStateType = State
    
    func newState(state: State) {
        tableView.reloadData()
    }
    
    // MARK: - Properties
    
    weak var coordinatorDelegate: MasterCoordinatorDelegate?
    
    let store = Store<State>(reducer: State.reducer,
                             state: .init(),
                             middleware: [cacheMiddleware])


    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    private func configView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
     
        tableView.register(UINib(nibName: "MasterItemCell", bundle: nil), forCellReuseIdentifier: "MasterItemCell")
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
        coordinatorDelegate?.showCreateViewController(from: self)
    }
    
    func injectTODO(_ todo: TODO) {
        self.store.dispatch(AddTODO(todo: todo));
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.state.todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterItemCell", for: indexPath) as! MasterItemCell
        let todo = store.state.todos[indexPath.row]
        cell.config(with: todo)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = store.state.todos[indexPath.row]
        if editingStyle == .delete {
            store.dispatch(RemoveTODO(todo: todo))
            coordinatorDelegate?.delete(todo, from: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = store.state.todos[indexPath.row]
        coordinatorDelegate?.showDetail(with: todo, from: self)
    }
}

