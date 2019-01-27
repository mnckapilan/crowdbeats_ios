//
//  PlaylistViewController.swift
//  CrowdBeats
//
//  Created by Blanca Tebar on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class PlaylistViewController: UITableViewController, PlaylistCellDelegate {
    
//    var songs = [Song]()
    let songs = [Song(title: "Despacito", artist: "Luis Fonsi", ID: "123"),
                 Song(title: "Can't Hold Us", artist: "Macklemore and Ryan Lewis", ID: "124")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    func didPressButton(_ sender: PlaylistCell) {
        sender.upvoteButton.isSelected = true
        sender.upvoteButton.isUserInteractionEnabled = false
        print("UPVOTE BUTTON PRESSED IN CELL: \(sender.index.text!)")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistCell

        cell.index.text = String(indexPath.row)
        cell.songTitle.text = songs[indexPath.row].title
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
