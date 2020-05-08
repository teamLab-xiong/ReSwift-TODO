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
        dataSource.accept(state.todos)
    }
    
    // MARK: - Properties
    
    weak var coordinatorDelegate: MasterCoordinatorDelegate?
    
    let store = Store<State>(reducer: State.reducer,
                             state: .init(),
                             middleware: [cacheMiddleware])
    
    typealias DataSource = TableViewDataSource<TODO>
    
    private lazy var dataSource = DataSource(
        tableView: tableView,
        configCell: { ds, tb, ip, todo in
            let cell = tb.dequeueReusableCell(for: ip, cellType: MasterItemCell.self)
            cell.config(with: todo)
            return cell
        },
        didSelectRowAtIndexPath: { [unowned self] tb, todo in
            self.coordinatorDelegate?.showDetail(with: todo, from: self)
        },
        canEditRowAtIndexPath: { ds, ip in
            return true
        },
        commitEditingStyle: { [unowned self] tb, style, todo in
            if case .delete = style {
                self.store.dispatch(RemoveTODO(todo: todo))
                self.coordinatorDelegate?.delete(todo, from: self)
            }
        })


    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }
    
    private func configView() {
        title = "TODOs"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
     
        tableView.register(cellType: MasterItemCell.self)
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
}

extension MasterViewController: StoryboardLoadable {}

