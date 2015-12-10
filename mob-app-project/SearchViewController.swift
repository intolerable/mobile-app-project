//
//  SearchViewController.wift.swift
//  mob-app-project
//
//  Created by Harry Duce on 08/12/2015.
//  Copyright © 2015 HarryFraser. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dota 2 Match Finder"
        
        searchTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: Actions
    
    func textFieldShouldReturn(searchTextField: UITextField) -> Bool {
        // Hides the keyboard when return is pressed
        searchTextField.resignFirstResponder()
        
        return true
    }
    
    // sets up the segue to handle the requested user url
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "usernameSearchSegue" {
            if let svc = segue.destinationViewController as? UserMatchHistoryController {
                svc.requestedAccountURL = searchTextField.text
            }
        }
    }
}
