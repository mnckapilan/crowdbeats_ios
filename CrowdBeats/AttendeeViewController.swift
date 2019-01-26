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
    
    let alertController = UIAlertController(title: "Sorry", message: "Please, enter a valid key", preferredStyle: UIAlertController.Style.alert)
    
    @IBOutlet weak var textfield: UITextField!
   
    
    @IBAction func TextButton(_ sender: UIButton) {
        
        if textfield.text!.isEmpty {
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
           let contr = UIViewController( self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
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
