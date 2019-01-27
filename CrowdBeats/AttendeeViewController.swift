//
//  AttendeeViewController.swift
//  CrowdBeats
//
//  Created by Blanca Tebar on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class AttendeeViewController: UIViewController , UITextFieldDelegate{
    
    let alertController = UIAlertController(title: "Sorry", message: "Please, enter a valid key", preferredStyle: UIAlertController.Style.alert)
    
    @IBOutlet weak var textfield: UITextField!
   
    
    @IBAction func TextButton(_ sender: UIButton) {
        
        if textfield.text!.isEmpty {
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
            
        var comp = URLComponents(string: "https://crowdbeats-host.herokuapp.com/newguest")
        
        comp!.queryItems = [URLQueryItem(name: "party_id", value: textfield.text)]
        
        let url : URL = comp!.url!
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                //                print(jsonResponse)
                let array = jsonResponse as? [String: Any]
                guard let success = array?["success"] as? Int else { return }
                if success == 1 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Next", sender: nil)
                    }
                }
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
            }
            task.resume()
            
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
