//
//  DetailViewController.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var detailTextView: UITextView!
    
    func configureView() {
        guard let detailTextView = detailTextView, let dateLabel = dateLabel else { return }
        detailTextView.text = detailItem?.title
        dateLabel.text = detailItem?.date.description
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var detailItem: TODO? {
        didSet {
            configureView()
        }
    }
}

