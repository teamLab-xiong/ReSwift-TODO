//
//  ShowDetailCoordinator.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

final class ShowDetailCoordinator: Coordinator {
    
    private lazy var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    private lazy var master = storyboard.instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController
    
    private lazy var detail = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    
    private lazy var masterNavi = UINavigationController(rootViewController: self.master)
    private lazy var detailNavi = UINavigationController(rootViewController: self.detail)
    
    let split: UISplitViewController
    
    init(split: UISplitViewController) {
        self.split = split
        split.delegate = self
        
        split.viewControllers = [masterNavi, detailNavi]
        split.preferredDisplayMode = .allVisible
        detail.navigationItem.leftBarButtonItem = split.displayModeButtonItem
        detail.navigationItem.leftItemsSupplementBackButton = true
        
        master.coordinatorDelegate = self
    }
    
    func start() {
        
    }
}

extension ShowDetailCoordinator: MasterCoordinatorDelegate {
    func showDetail(with todo: TODO, from master: MasterViewController) {
        detail.detailItem = todo
        master.showDetailViewController(detailNavi, sender: nil)
    }
    
    func delete(_ todo: TODO, from master: MasterViewController) {
        guard let detailItem = detail.detailItem, todo == detailItem else { return }
        detail.detailItem = nil
    }
    
    func showCreateViewController(from master: MasterViewController) {
        let storyboard = UIStoryboard(name: "Create", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
        viewController.coordinatorDeletate = self
        let navi = UINavigationController(rootViewController: viewController)
        navi.modalPresentationStyle = .fullScreen
        master.present(navi, animated: true)
    }
}

extension ShowDetailCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            return true
        }
        return false
    }
}

extension ShowDetailCoordinator: CreateCoordinatorDelegate {
    func createTODO(_ todo: TODO, from source: CreateViewController) {
        master.injectTODO(todo)
        source.dismiss(animated: true)
    }
}
