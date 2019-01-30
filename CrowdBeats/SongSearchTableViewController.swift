//
//  SongSearchTableViewController.swift
//  CrowdBeats
//
//  Created by Lloyd Clowes on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class SongSearchTableViewController: UITableViewController {
    
    var party_id:String = ""
    var array:NSMutableArray = []
    
    var results : [(song : String, artist : String, id : String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<array.count {
            
            // Create Blog Object
            guard let ID: String = (array[i] as AnyObject).object(forKey: "id") as? String,
                let Name: String = (array[i] as AnyObject).object(forKey: "name") as? String,
                let Artist: String = (array[i] as AnyObject).object(forKey: "artist") as? String
                else {
                    print("Error")
                    return
                }
            
            
            // Add Blog Objects to mainArray
            results.append((song: Name, artist: Artist, id: ID ))
        }
    tableView.reloadData()
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = party_id
        let navVC = segue.destination as! UINavigationController
        if segue.identifier != "segueSearchCancel" {
            let tableVC = navVC.viewControllers.first as! SongSearchTableViewController
            tableVC.party_id = data
        }
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if  (resultSearchController.isActive) {
//            return results.count
//        } else {
//            return 0
//        }
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongSearchCell", for: indexPath) as! SongSearchCell
        
        cell.TitleSong.text = results[indexPath.row].song
        cell.artistSong.text = results[indexPath.row].artist
        cell.cellDelegate = self as? SongSearchCellDelegate
        
        return cell
    }

    
    
    @IBAction func addButon(_ sender: SongSearchCell) {
        print("UPVOTE BUTTON PRESSED IN CELL: \(sender.artistSong.text!)")
        
            sender.AddButton.isUserInteractionEnabled = false
    }
    
    
}

protocol SongSearchCellDelegate : class {
    func didPressAddButton(_ sender: SongSearchCell)
}

class SongSearchCell : UITableViewCell
{
    var cellDelegate: SongSearchCellDelegate?
    
    @IBOutlet weak var AddButton: UIView!
    
    @IBOutlet weak var artistSong: UILabel!
    @IBOutlet weak var TitleSong: UILabel!
    
   
    @IBAction func AddPressed(_ sender: Any) {
        cellDelegate?.didPressAddButton(self)
    }
    
}
