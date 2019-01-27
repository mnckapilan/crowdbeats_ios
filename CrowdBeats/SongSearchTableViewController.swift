//
//  SongSearchTableViewController.swift
//  CrowdBeats
//
//  Created by Lloyd Clowes on 26/01/2019.
//  Copyright © 2019 kapilan. All rights reserved.
//

import UIKit

class SongSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var party_id:String = ""
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var results = [String]()
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search songs"
        navigationItem.searchController = resultSearchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        results.removeAll(keepingCapacity: false)
        
        var comp = URLComponents(string: "https://crowdbeats-host.herokuapp.com/search")
        
        comp!.queryItems = [URLQueryItem(name: "party_id", value: party_id), URLQueryItem(name: "search", value: searchController.searchBar.text!)]
        
        let url : URL = comp!.url!
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                
                print("HELO")
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                //                print(jsonResponse)
                let array = jsonResponse as? [String: Any]
//                guard let num = min(array?["tracks"]["limit"], array?["tracks"]["total"]) as? Int else { return }

            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        //task.resume()
        
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
    
