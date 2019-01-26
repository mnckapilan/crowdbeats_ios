//
//  AttendeeViewController.swift
//  CrowdBeats
//
//  Created by Blanca Tebar on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit
import Alamofire

class AttendeeViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var textfield: UITextField!
   
    @IBAction func keyEnter(_ sender: Any) {
        textfield.becomeFirstResponder()
        if textfield.text!.isEmpty {
            print("Empty key")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
