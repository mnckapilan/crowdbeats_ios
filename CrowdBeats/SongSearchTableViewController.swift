//
//  SongSearchTableViewController.swift
//  CrowdBeats
//
//  Created by Lloyd Clowes on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class SongSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var results = [String]()
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        results.removeAll(keepingCapacity: false)

        var comp = URLComponents(string: "https://crowdbeats-host.herokuapp.com/newguest")
        
        comp!.queryItems = [URLQueryItem(name: "party_id", value: "ElP91"), URLQueryItem(name: "search", value: searchController.searchBar.text!)]
        
        let url : URL = comp!.url!
        
        let task = URLSession.shared.dataTask(with: url) { (data,  response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //                print(jsonResponse)
                let array = jsonResponse as? [[[String: Any]]]
                guard let name = array?["tracks"]["items"][0]["name"] as? String else { return }
            }
        }
        
//        results =
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return results.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (resultSearchController.isActive) {
            cell.textLabel?.text = results[indexPath.row]
        }
        return cell
    }

}
