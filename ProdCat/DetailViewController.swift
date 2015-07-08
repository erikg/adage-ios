//
//  DetailViewController.swift
//  ProdCat
//
//  Created by Erik Greenwald on 7/7/15.
//  Copyright (c) 2015 ElfGA. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UITextView!


    var detailItem: Fortune? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Fortune = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.getBody()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

