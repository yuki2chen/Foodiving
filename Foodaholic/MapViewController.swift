//
//  MapViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/6.
//  Copyright © 2016年 onechun. All rights reserved.
//

import FoursquareAPIClient
import UIKit
import MapKit

class MapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var jsonData: NSData!
    var searchRestaurants = [searchRestaurant]()
    
    @IBOutlet weak var addTableView: UITableView!
    override func viewDidLoad() {

        addTableView.delegate = self
        addTableView.dataSource = self
        
        fetchData()
        
    }
    
    
    
    
    func fetchData(){
        let client = FoursquareAPIClient(clientId: "QI0IEIXIM255IVYTP1MIM0IWQZWC0LON5PFTRKCVO51OD5TL", clientSecret: "DUWMECG3XTFZGMHO2XZNNHGCLJBWZ5TMW3X30R530F5OR3KZ")
        
        let parameter: [String: String] = [
            "ll": "25.0445735,121.5548777",
            "categoryId": "4d4b7105d754a06374d81259",
            "limit": "10"
        ]
        
        client.requestWithPath("venues/search", method: .GET, parameter: parameter) {
            (data, error) in
            
            if let error = error{
                print("Errrrrror: \(error.localizedDescription)")
                return
            }
            
            
            let datajson = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let data = datajson!.dataUsingEncoding(NSUTF8StringEncoding)
            self.jsonData = data
//            print(datajson)
            
            self.transformData()
            
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
        }
        
    }
    
    
    
    func transformData(){
        
        
        
        do{
            
            if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                
                guard let response = jsonResult["response"] as? NSDictionary else{
                    return
                }
                
                guard let venues = response["venues"] as? NSArray else{
                    return
                }
                for restaurants in venues{
                    guard let restaurants = restaurants as? NSDictionary else{
                        return
                    }

                    let id = restaurants.valueForKey("id") as? String ?? ""
                    let name = restaurants.valueForKey("name") as? String ?? ""
                    let location = restaurants.valueForKey("location") as? String ?? ""
                    self.searchRestaurants.append(searchRestaurant(id: id, name: name, location: location))
                    
                    print(restaurants["location"]!)
                }
                
                
                
                self.addTableView.reloadData()

                
            }
        }catch let error as NSError{
            print(error)
        }
       

        
    }
    
    
  
    
    //Mark: TableView Data Source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchRestaurants.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchRestaurantsTableViewCell", forIndexPath: indexPath) as! searchRestaurantsTableViewCell
        
        let restaurant = searchRestaurants[indexPath.row]
        cell.restaurantName.text = restaurant.name
        
        return cell
    }



    
    
    
}


