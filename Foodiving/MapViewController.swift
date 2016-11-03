//
//  MapViewController.swift
//  Foodiving
//
//  Created by onechun🌾 on 2016/10/6.
//  Copyright © 2016年 onechun. All rights reserved.
//

import FoursquareAPIClient
import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate{
    
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
    
      //Mark: Action
    
    @IBAction func reloadButton(sender: AnyObject) {
        self.viewDidLoad()

    }
    
   
    //Mark: View Life Cycle
    override func viewDidLoad() {
        
        addTableView.delegate = self
        addTableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 0)
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 255/255, green: 226/255, blue: 82/255, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
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
    
    
    
    // Mark: fetch data from foursquare
    
    func fetchData(latitude: Double, longitude: Double){
        let client = FoursquareAPIClient(clientId: "QI0IEIXIM255IVYTP1MIM0IWQZWC0LON5PFTRKCVO51OD5TL", clientSecret: "DUWMECG3XTFZGMHO2XZNNHGCLJBWZ5TMW3X30R530F5OR3KZ")
        
        let parameter: [String: String] = [
            "ll": "\(latitude),\(longitude)",
            "categoryId": "4d4b7105d754a06374d81259",
            "radius": "300",
            "limit": "1000"
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
                searchRestaurant = []
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
        mapView.removeAnnotations(mapView.annotations)

        
        for restInfo in searchRestaurant{
            
            guard let restLat = restInfo["restLat"] as? Double else{
                return}
            guard let restLng = restInfo["restLng"] as? Double else{
                return}
//            guard let restCountry = restInfo["restCity"] as? String else{
//                return}
//            guard let restCity = restInfo["restCountry"] as? String else{
//                return}
            guard let restName = restInfo["name"] as? String else{
                return}
            
            
            let mylocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: restLat, longitude: restLng), addressDictionary: nil)
        
            

            let annotation = MKPointAnnotation()
            
            annotation.coordinate = mylocation.coordinate
            annotation.title = restName

            mapView.addAnnotation(annotation)
      
        }
    }
    
    func centerMapOnLocation(location: CLLocation){
        let regionRadius: CLLocationDistance = 400
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 1.0, regionRadius * 1.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
}


