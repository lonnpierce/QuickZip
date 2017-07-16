//
//  RootViewControllerTableViewController.swift
//  Zips
//
//  Created by Lonnie Pierce on 6/25/17.
//  Copyright © 2017 Lonnie Pierce. All rights reserved.
//

import UIKit

class RootViewControllerTableViewController: UITableViewController, UISearchBarDelegate {

    
    private let sectionTableId = "SectionsTableId"
    var states = [String: [String]]()
    var keys = [String]()
    let state = State()
    var filteredState = [String]()
    var isSearchActive = false
    
    private let stateCell = "StateName"
    @IBOutlet weak var filterStateSearchBar: UISearchBar!
    
    //Delegates
    //var searchController: UISearchController!
    @IBOutlet var statesTableView: UITableView!
    //@IBOutlet weak var stateSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        
        //Init State Data
        state.findFile()
        state.setStateList()
        states = state.getSectionedStates()
        keys = states.keys.sorted()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        self.filterStateSearchBar.delegate = self

    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         //Dispose of any resources that can be recreated.
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true;
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       return true
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if(isSearchActive)
        {
            return 1
        }
        else
        {
            return keys.count
        }
    }

    /**/override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearchActive)
        {
            return filteredState.count
        }
        else {
            let key = keys[section]
            let stateSection = states[key]!
            return stateSection.count
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return keys
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (isSearchActive)
        {
           if(filteredState.count > 0)
           {
                let firstString = filteredState[0]
                let firstCharIndex = firstString.index(firstString.startIndex, offsetBy: 1)
                let firstChar = firstString.substring(to: firstCharIndex)
                 
                return firstChar
            }
           else{
                return ""
            }
            
        }
        else
        {
             return keys[section]
        }
       
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
       
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionTableId, for: indexPath as IndexPath)
        
        if(isSearchActive)
        {
            cell.textLabel?.text = filteredState[indexPath.row]
            
            return cell
        }
        else
        {
            let key = keys[indexPath.section]
            let nameSection = states[key]!
            
            cell.textLabel?.text = nameSection[indexPath.row]
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: stateCell)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: stateCell)
        }
        
        if(isSearchActive)
        {
           cell?.textLabel?.text = filteredState[indexPath.row]
        }
        else
        {
            let key = keys[indexPath.section]
            let stateSection = states[key]!
        
            cell?.textLabel?.text = stateSection[indexPath.row]
        }
    
        return cell!
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

   
        let state = (sender as! UITableViewCell).textLabel?.text as! String
        let cityVC = segue.destination as! CityViewController
        cityVC.State = state;
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText
        filteredState.removeAll(keepingCapacity: true)
        
        if (!(searchText.isEmpty) && filteredState.count == 0) {
            
            isSearchActive = true
            let startIndex = searchText.startIndex
            let firstCharIndex = searchText.index(startIndex, offsetBy: 1)
            let firstChar = searchText.substring(to: firstCharIndex)
            
            //states[key] = states[key]
            
            for key in keys {
                if(key == firstChar){
                    let stateForKey = states[key]!
                    let matches = stateForKey.filter{ $0.contains(searchText)} as [String]
                    filteredState += matches
                }
                //if key == initalIndex {
                //  break
                //}
            }
           
        }
        else {
            isSearchActive = false
        
        }
         tableView.reloadData()
    }
 

   
   

}
