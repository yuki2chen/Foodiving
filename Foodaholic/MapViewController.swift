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
    
    //Mark: Properties
    var jsonData: NSData!
    var searchRestaurant: [[String: AnyObject]] = []
    var selectedIndexPath: NSIndexPath?
    var restId: [String] = []
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addTableView: UITableView!
    let locationManager = CLLocationManager()
    var locationLat: Double = 0.0
    var locationLng: Double = 0.0
    
    
    //Mark: View Life Cycle
    override func viewDidLoad() {
        
        addTableView.delegate = self
        addTableView.dataSource = self
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        guard
            let lat = locationManager.location?.coordinate.latitude,
            let lng = locationManager.location?.coordinate.longitude
            else{return}
        self.locationLat = lat
        self.locationLng = lng
        fetchData(locationLat, longitude: locationLng)
        
        centerMapOnLocation(locationManager.location!)
        locationManager.stopUpdatingLocation()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        return
    }
    
    // Mark: fetch data from foursquare
    
    func fetchData(latitude: Double, longitude: Double){
        let client = FoursquareAPIClient(clientId: "QI0IEIXIM255IVYTP1MIM0IWQZWC0LON5PFTRKCVO51OD5TL", clientSecret: "DUWMECG3XTFZGMHO2XZNNHGCLJBWZ5TMW3X30R530F5OR3KZ")
        
        let parameter: [String: String] = [
            "ll": "\(latitude),\(longitude)",
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
            print("get data")
            
            self.transformData()
            
            // print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            }
        
    }
    
    
    //Mark: transform data from fetchdata function
    
    func transformData(){
        do{
            if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                
                guard let response = jsonResult["response"] as? NSDictionary else{
                    return
                }
                
                guard let venues = response["venues"] as? NSArray else{return
                }
                for restaurants in venues{
                    
                    let restaurant = searchRestaurantModel()
                    
                    restaurant.restaurantHelper(restaurants)
                    
                    searchRestaurant.append(restaurant.restaurantDict)
                    
                    self.addTableView.reloadData()
                }
                print("put data")
                saveToFirebase()
            }
            
        }catch let error as NSError{
            
            print(error.localizedDescription)
        }
        
        restLocation()
        
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
            restaurantInfo["restCity"] = restPerInfo["restCity"]
            restaurantInfo["restCountry"] = restPerInfo["restCountry"]
            
            let restReference = FIRDatabase.database().reference()
            restReference.child("restaurants").child(id).setValue(restaurantInfo)
            
            restId.append(id)
        }
    }
    
    
    
    //Mark: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showInfo"{
            
            //            print(searchRestaurant)
            
            
            let destController = segue.destinationViewController as! ResaturantMealTableViewController
            
            if let selectedCell = sender as? searchRestaurantsTableViewCell{
                let indexPath = addTableView.indexPathForCell(selectedCell)
                
                destController.restDic = searchRestaurant[indexPath!.row]
            }
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    
    
    
    //Mark: rest annotation place
    
    func restLocation(){
        
        //print("searchRest array: \(searchRestaurant.first)")
        
        for restInfo in searchRestaurant{
            
            guard let restLat = restInfo["restLat"] as? Double else{
                return}
            guard let restLng = restInfo["restLng"] as? Double else{
                return}
            guard let restCountry = restInfo["restCity"] as? String else{
                return}
            guard let restCity = restInfo["restCountry"] as? String else{
                return}
            guard let restName = restInfo["name"] as? String else{
                return}
            
            
            let mylocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: restLat, longitude: restLng), addressDictionary: nil)
            

            
            
           
            
//            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = mylocation.coordinate
            annotation.title = restName
//            if let city = mylocation.locality,
//                let state = mylocation.administrativeArea {
//                annotation.subtitle = "\(city) \(state)"
//            }
            mapView.addAnnotation(annotation)
//            let span = MKCoordinateSpanMake(0.05, 0.05)
//            let region = MKCoordinateRegionMake(mylocation.coordinate, span)
//            mapView.setRegion(region, animated: true)
            
      
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 1.0, regionRadius * 1.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
}

