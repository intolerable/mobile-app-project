//
//  SearchViewController.wift.swift
//  mob-app-project
//
//  Created by Harry Duce on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
//    func textFieldShouldReturn(valueTextField: UITextField) -> Bool {
//        // Hides the keyboard when return is pressed
//        valueTextField.resignFirstResponder()
//        
//        return true
//    }
}