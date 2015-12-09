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
        
        searchTextField.delegate = self
        
        if
            let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                retrieveJSON(NSURL(string: apiURL(dict["api key"] as! String))!) { x in
                    print(x)
                }
            }
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
}