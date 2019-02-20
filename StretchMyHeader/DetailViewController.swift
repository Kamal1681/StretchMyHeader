//
//  DetailViewController.swift
//  StretchMyHeader
//
//  Created by Kamal Maged on 2019-02-19.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.headLine
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: NewsItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

