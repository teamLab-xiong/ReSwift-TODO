//
//  CreateViewController.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/20.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit

protocol CreateCoordinatorDelegate: AnyObject {
    func createTODO(_ todo: TODO, from source: CreateViewController)
}

class CreateViewController: UITableViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var textView: UITextView!
    
    weak var coordinatorDeletate: CreateCoordinatorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        defer { dismiss(animated: true) }
        
        guard !textView.text.isEmpty else { return }
        
        let todo = TODO(title: textView.text, message: textView.text, date: Date())
        coordinatorDeletate?.createTODO(todo, from: self)
    }
}
