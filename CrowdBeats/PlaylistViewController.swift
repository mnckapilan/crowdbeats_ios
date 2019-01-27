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
    
    var songs = [(song: "Despacito", artist: "Luis Fonsi", id: "obcowbdeub"),
                 (song: "Can't Hold Us", artist: "Macklemore and Ryan Lewis", id:"ouwebcobco")]

    
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
                    let Name: String = (jsonArray[i] as AnyObject).object(forKey: "name") as? String
                    else {
                        print("Error")
                        return
                    }
                
                // Add Blog Objects to mainArray
                songs.append((song: Name, artist: "", id: ID))
            }
        }
        catch {
            print("Error: (Retrieving Data)")
        }
        tableView.reloadData()
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    
    
    func didPressButton(_ sender: PlaylistCell) {
        print("UPVOTE BUTTON PRESSED IN CELL: \(sender.index.text!)")
        
        sender.upvoteButton.isSelected = true
        sender.upvoteButton.isUserInteractionEnabled = false
        
        var comp = URLComponents(string: "https://crowdbeats-host.herokuapp.com/vote")
        comp!.queryItems = [URLQueryItem(name: "id", value: songs[Int(sender.index.text!)!].id)]
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
        
        let tableVC = navVC.viewControllers.first as! SongSearchTableViewController
        tableVC.party_id = data
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
    
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistCell
        
        
        cell.index.text = String(indexPath.row)
        cell.songTitle.text = songs[indexPath.row].song
        cell.artistLabel.text = songs[indexPath.row].artist
        cell.cellDelegate = self

        return cell
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
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
