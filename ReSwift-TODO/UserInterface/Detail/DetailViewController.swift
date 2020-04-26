//
//  DetailViewController.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet private weak var detailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "DetailItemCell", bundle: nil), forCellReuseIdentifier: "DetailItemCell")
    }

    var detailItem: TODO? {
        didSet {
            title = detailItem?.title
            tableView.reloadData()
        }
    }
}

extension DetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailItemCell", for: indexPath) as! DetailItemCell
        cell.messageLabel.text = detailItem?.message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        detailItem?.date.description
    }
}

