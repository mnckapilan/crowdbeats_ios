//
//  PlaylistViewController.swift
//  CrowdBeats
//
//  Created by Blanca Tebar on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class PlaylistViewController: UITableViewController, PlaylistCellDelegate {
    
    var party_id:String = ""
    var array: [String: Any] = [:]
    
    var songs = [(song: "Despacito", artist: "Luis Fonsi", id: "obcowbdeub", votes: 0)]

    
    var jsonArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songs = []
        
        print(party_id)
        let myurl = "https://crowdbeats-host.herokuapp.com/playlist"
        
        
        let url: NSURL = NSURL(string: myurl)!
        
        do {
            
            let data: Data = try Data(contentsOf: url as URL)
            
            jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableArray
            
            
            // Looping through jsonArray
            for i in 0..<jsonArray.count {
                
                // Create Blog Object
                guard let ID: String = (jsonArray[i] as AnyObject).object(forKey: "id") as? String,
                    let Name: String = (jsonArray[i] as AnyObject).object(forKey: "name") as? String,
                    let votes: Int = (jsonArray[i] as AnyObject).object(forKey: "votes") as? Int
                    else {
                        print("Error")
                        return
                    }
                
                // Add Blog Objects to mainArray
                songs.append((song: Name, artist: "", id: ID, votes: votes))
            }
        }
        catch {
            print("Error: (Retrieving Data)")
        }
        songs = songs.sorted(by: {$0.votes > $1.votes})
        tableView.reloadData()
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    private func search(search: String) {
        
        var comp = URLComponents(string: "https://crowdbeats-host.herokuapp.com/search")

        comp!.queryItems = [URLQueryItem(name: "party_id", value: party_id), URLQueryItem(name: "search", value: search)]

        let url : URL = comp!.url!

        print(url)
        print("test")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print(1)
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            print(2)
            do {
                print(3)
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(4)
                print(jsonResponse) //Response result
                //                print(jsonResponse)
                var array = jsonResponse as? [String: Any]
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toSearch", sender: nil)
                }
                
            } catch let parsingError {
//                print(30)
                print("Error", parsingError)
            }
//            print(20)
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toSearch", sender: nil)
            }
        }
        task.resume()
//        print(array)
    }
    
    func didPressButton(_ sender: PlaylistCell) {
        print("UPVOTE BUTTON PRESSED IN CELL: \(sender.index.text!)")
        
        sender.upvoteButton.isSelected = true
        sender.upvoteButton.isUserInteractionEnabled = false
        
        var comp = URLComponents(string: "https://crowdbeats-host.herokuapp.com/vote")
        comp!.queryItems = [URLQueryItem(name: "id", value: songs[Int(sender.index.text!)! - 1].id)]
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
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        return songs.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = party_id
        let navVC = segue.destination as! UINavigationController
        if segue.identifier != "Exit" {
            let tableVC = navVC.viewControllers.first as! SongSearchTableViewController
            tableVC.party_id = data
            tableVC.array = array
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistCell
        
        cell.index.text = String(indexPath.row + 1)
        cell.songTitle.text = songs[indexPath.row].song
        cell.artistLabel.text = songs[indexPath.row].artist
        cell.cellDelegate = self

        return cell
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alertController: UIAlertController = UIAlertController(title: "Search", message: "Search for your song below", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Search", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.search(search: firstTextField.text!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Song"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

protocol PlaylistCellDelegate : class {
    func didPressButton(_ sender: PlaylistCell)
}

class PlaylistCell : UITableViewCell
{
    var cellDelegate: PlaylistCellDelegate?
    
    @IBOutlet weak var upvoteButton: UIButton!
    
    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBAction func upvoteButtonPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(self)
    }
    
}
