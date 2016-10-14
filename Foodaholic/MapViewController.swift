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
import Firebase

class MapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate{
    
    var jsonData: NSData!
    
    var searchRestaurant: [[String: AnyObject]] = []
    
    var selectedIndexPath: NSIndexPath?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addTableView: UITableView!
    
//    var restaurantAutoID = []
    var restId: [String] = []
    
    override func viewDidLoad() {
        
        addTableView.delegate = self
        addTableView.dataSource = self
        
        
        
        
        if CLLocationManager.locationServicesEnabled(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        }
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
            // print(datajson)
            
            self.transformData()
            
            // print(NSString(data: data!, encoding: NSUTF8StringEncoding))


            
            
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
                    
                    let restaurant = searchRestaurantModel()
                    restaurant.restaurantHelper(restaurants)
                    
                    searchRestaurant.append(restaurant.restaurantDict)
                    
                    
                    
                    
                    self.addTableView.reloadData()
                    
                    
                }
                saveToFirebase()
            }
            
        }catch let error as NSError{
            
            print(error.localizedDescription)
        }
        
        myLocation()
        

//        print(searchRestaurant)
        
    }
    
    
    
    
    //Mark: TableView Data Source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return searchRestaurant.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchRestaurantsTableViewCell", forIndexPath: indexPath) as! searchRestaurantsTableViewCell
        
        let restaurant = searchRestaurant[indexPath.row]
        cell.restaurantName.text = restaurant["name"] as? String ?? ""
        return cell
    }
    
    
    
    //Mark: save to firebase
    
    
    func saveToFirebase(){
        
        for restPerInfo in searchRestaurant{
            var restaurantInfo: [String: AnyObject] = [:]
            let id = restPerInfo["id"] as? String ?? ""
            restaurantInfo["name"] = restPerInfo["name"]
            restaurantInfo["restLat"] = restPerInfo["restLat"]
            restaurantInfo["restLng"] = restPerInfo["restLng"]
        
            let restReference = FIRDatabase.database().reference()
            restReference.child("restaurants").child(id).setValue(restaurantInfo)
            
            restId.append(id)

        }
        
    }
    
    
    
    
    
    
    //Mark: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showInfo"{
        
            guard let selectIndexPath = selectedIndexPath else{
                return
            }
            
            
            let destController = segue.destinationViewController as? ResaturantMealTableViewController

            destController!.restDic = searchRestaurant[selectIndexPath.row]
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    //Mark: location
    
    let locationManager = CLLocationManager()
    
    
    func locationManager(manager: CLLocationManager,didUpdateLocations locations:[CLLocation]){
        var locationValue: CLLocationCoordinate2D = manager.location!.coordinate
        manager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
        
    }
    
    
    
    
    func myLocation(){
        
//        print("searchRest array: \(searchRestaurant.first)")
        
        for mylocate in searchRestaurant{
            
            guard let myLat = mylocate["restLat"] as? Double else{
                return}
            guard let myLng = mylocate["restLng"] as? Double else{
                return}
           
            let mylocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: myLat, longitude: myLng), addressDictionary: nil)
            
            //print("MYLOCATION IS \(mylocation)")
        
            mapView.addAnnotation(mylocation)
        
           
            let lookLocation = CLLocation.init(latitude: 25.042349, longitude: 121.565022)
            centerMapOnLocation(lookLocation)
        
        
        }
    }
    
    
    
    func centerMapOnLocation(location:CLLocation){
        let regionRadius: CLLocationDistance = 700
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 1.0, regionRadius * 1.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

