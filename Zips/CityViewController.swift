//
//  CityViewController.swift
//  Zips
//
//  Created by Lonnie Pierce on 6/25/17.
//  Copyright © 2017 Lonnie Pierce. All rights reserved.
//

import UIKit

class CityViewController: UITableViewController ,UISearchBarDelegate{
    private let sectionTableId = "SectionsTableId"
    var cities = [String: [String]]()
    var keys = [String]()
    
    let city = City()
    var State = ""
    var test = ""
    
    var filteredCities = [String]()
    var isSearchActive = false
    
    private let cityNameCell = "CityName"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Cities"
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
       

        
        let city = City()
        cities =  [String: [String]]()
        city.setStateCityList(state: State)
        cities = city.getSectionedCities()
        keys = cities.keys.sorted()
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
       if(isSearchActive)
       {
           return 1
       }
       else{
        return keys.count
    
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(isSearchActive)
        {
            return filteredCities.count
        }
        else
        {
            let key = keys[section]
            let citySection = cities[key]!
            return citySection.count
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keys
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(isSearchActive)
        {
            if(filteredCities.count > 0)
            {
                let firstString = filteredCities[0]
                let firstCharIndex = firstString.index(firstString.startIndex, offsetBy: 1)
                let firstChar = firstString.substring(to: firstCharIndex)
                
                return firstChar
            }
            else{
                return ""
            }
        }
        else{
            return keys[section]
    
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionTableId, for: indexPath as IndexPath)
        
        if(isSearchActive)
        {
            cell.textLabel?.text = filteredCities[indexPath.row]
        }
        else {
            
            let key = keys[indexPath.section]
            let nameSection = cities[key]!
        
            cell.textLabel?.text = nameSection[indexPath.row]
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cityNameCell)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cityNameCell)
        }
        
        if(isSearchActive)
        {
           cell?.textLabel?.text = filteredCities[indexPath.row]
        }
        else
        {
            let key = keys[indexPath.section]
            let citySection = cities[key]!
            
            cell?.textLabel?.text = citySection[indexPath.row]
        }

        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let zipVC = segue.destination as! ZipCodeTableViewController
        let cell = sender as! UITableViewCell
        city.CityName = (cell.textLabel?.text)!
        city.State = State
        city.setZipCodeList()
        
        zipVC.ZipCodeList = city.ZipList
        
 
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText
        filteredCities.removeAll(keepingCapacity: true)
        
        if (!(searchText.isEmpty) && filteredCities.count == 0) {
            
            isSearchActive = true
            let startIndex = searchText.startIndex
            let firstCharIndex = searchText.index(startIndex, offsetBy: 1)
            let firstChar = searchText.substring(to: firstCharIndex)
            
            //states[key] = states[key]
            
            for key in keys {
                if(key == firstChar){
                    let city = cities[key]!
                    let matches = city.filter{ $0.contains(searchText)} as [String]
                    filteredCities += matches
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
