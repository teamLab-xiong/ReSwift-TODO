//
//  DataSource.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/26.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewDataSourceType {
    associatedtype Entity
    
    func accept(_ entities: [Entity])
}

class TableViewDataSource<Entity>
    : NSObject
    , UITableViewDataSource
    , UITableViewDelegate
    , TableViewDataSourceType
{
    func accept(_ entities: [Entity]) {
        _entities = entities
        tableView.reloadData()
    }
    
    typealias ConfigCell = (TableViewDataSource<Entity>, UITableView, IndexPath, Entity) -> UITableViewCell
    typealias CanEditRowAtIndexPath = (TableViewDataSource<Entity>, IndexPath) -> Bool
    typealias CommitEditingStyle = (UITableView, UITableViewCell.EditingStyle, Entity) -> Void
    typealias DidSelectRowAtIndexPath = (UITableView, Entity) -> Void
    
    private var configCell: ConfigCell
    private var canEditRowAtIndexPath: CanEditRowAtIndexPath
    private var commitEditingStyle: CommitEditingStyle
    private var didSelectRowAtIndexPath: DidSelectRowAtIndexPath
    
    unowned var tableView: UITableView
    
    init(tableView: UITableView,
        configCell: @escaping ConfigCell,
        didSelectRowAtIndexPath: @escaping DidSelectRowAtIndexPath,
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath,
        commitEditingStyle: @escaping CommitEditingStyle
    ) {
        self.tableView = tableView
        self.configCell = configCell
        self.canEditRowAtIndexPath = canEditRowAtIndexPath
        self.didSelectRowAtIndexPath = didSelectRowAtIndexPath
        self.commitEditingStyle = commitEditingStyle
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private var _entities: [Entity] = []
    
    subscript(indexPath: IndexPath) -> Entity {
        get { _entities[indexPath.row] }
        set { _entities[indexPath.row] = newValue }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configCell(self, tableView, indexPath, self[indexPath])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRowAtIndexPath(self, indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commitEditingStyle(tableView, editingStyle, self[indexPath])
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath(tableView, self[indexPath])
    }
}

