//
//  SongSearchTableViewController.swift
//  CrowdBeats
//
//  Created by Lloyd Clowes on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class SongSearchTableViewController: UITableViewController, SongSearchCellDelegate {
    
    
    
    var idSongToAdd:String = ""
    
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
        let id = idSongToAdd
        let navVC = segue.destination as! UINavigationController
        if segue.identifier == "segueSearchCancel" {
            let tableVC = navVC.viewControllers.first as! PlaylistViewController
            tableVC.party_id = data
            tableVC.idSongToAdd = id
        }
        
    }

    func didPressAddButton(_ sender: SongSearchCell) {
        self.idSongToAdd = sender.id
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueSearchCancel", sender: nil)
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongSearchCell", for: indexPath) as! SongSearchCell
        
        cell.TitleSong.text = results[indexPath.row].song
        cell.artistSong.text = results[indexPath.row].artist
        cell.cellDelegate = self
        cell.id = results[indexPath.row].id
        
        return cell
    }

    
    
}

protocol SongSearchCellDelegate : class {
    func didPressAddButton(_ sender: SongSearchCell)
}

class SongSearchCell : UITableViewCell
{
    var cellDelegate: SongSearchCellDelegate?
    var id: String = ""
    @IBOutlet weak var AddButton: UIView!
    
    @IBOutlet weak var artistSong: UILabel!
    @IBOutlet weak var TitleSong: UILabel!
    
   
    @IBAction func AddPressed(_ sender: UIButton) {
        cellDelegate?.didPressAddButton(self)
    }
    
}
