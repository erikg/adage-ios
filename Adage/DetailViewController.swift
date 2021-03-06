//
//  DetailViewController.swift
//  Adage
//
// Created by Erik Greenwald on 7/8/15.
//
// Adage-iOS - iOS interface to the adage api at http://elfga.com/adage
// Copyright (c) 2015-2017 ElfGA Software Solutions, LLC
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
// import Foundation


import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    var detailItem: Fortune? {didSet {self.configureView()}}

    func configureView() {
        if let detail = self.detailItem {
            detail.fetch() { _, _, _ in
                DispatchQueue.main.async {
                    self.detailDescriptionLabel?.text = detail.getBody()
                }
            }
            self.title = detail.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.handleLeftSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.handleRightSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }

    @IBAction func handleRightSwipe(_ recognizer:UISwipeGestureRecognizer) {
        detailItem = Fortunes.sharedInstance.previous()
    }

    @IBAction func handleLeftSwipe(_ recognizer:UISwipeGestureRecognizer) {
        detailItem = Fortunes.sharedInstance.next()
    }
}
