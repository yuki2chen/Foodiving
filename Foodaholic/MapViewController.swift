//
//  MapViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/4.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire


class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    
    //Mark: properties
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
//        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)){
//            UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?center=25.04,121.56&zoom=15&views=traffic&mapmode=standard&q=Restaurant")!)
//            UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps-x-callback://?center=25.04,121.56&zoom=15&x-success=sourceapp://?resume=true&x-source=Nom+Nom")!)
//            
//        }else{
//            print("can't use comgooglemaps://")
//        }
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(25.04, longitude: 121.56, zoom: 15)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(25.04, 121.56)
        marker.title = "appWorks"
        marker.snippet = "Taipei"
        marker.map = mapView
        
        
        mapView.accessibilityElementsHidden = false
        mapView.myLocationEnabled = true
        if let mylocation = mapView.myLocation{
            print("User's Location:\(mylocation)")
        }else{
            print("User's location is unknown")
        }
        
        //      地圖邊框間距
        //        let mapInsets = UIEdgeInsetsMake(100.0, -300.0, 0.0, 300.0)
        //        mapView.padding = mapInsets
        
        
        
        //Mark: location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        
        
        //指南針
        mapView.settings.compassButton = true
        
        fetchJson()
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:\(error.localizedDescription)")
    }
    
    
    
    
    
    
    //Mark: reserch nearby restaurant
    
    func fetchJson(){
    
        let requestURL:NSURL = NSURL(string:
            "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants&key=AIzaSyCZWxo8dAqLLxguD92c3zjFd6ypBQFLJ7g")!
    
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            print(error?.localizedDescription)
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200){
                print("finding restaurant place downloaded")
                
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                    if let findingPlace = json["results"] as? [[String: AnyObject]]{
                        
                        
                        
                        print("finding place ok")
                    }
                }catch{
                    print("Error with Json:\(error)")
                }
            }
        }
        task.resume()
        
    }
    

    func pickPlace(){
        //        let center = CLLocation
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //?????
//    override func loadView() {
//        var camera = GMSCameraPosition.cameraWithLatitude(1.285, longitude: 103.848, zoom: 12)
//        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//        mapView.delegate = self
//        self.view = mapView
//    }
    
    
//    func reverseGeocodeCoordinate(coordinate:CLLocationCoordinate2D){
//        let geocoder = GMSGeocoder()
//        
//        geocoder.reverseGeocodeCoordinate(coordinate){response,error in
//            if let address = response?.firstResult(){
//                let lines = address.lines as [String]!
//                self.addressLabel.text = lines.joinWithSeparator("\n")
//                
//                UIView.animateWithDuration(0.25){
//                    self.view.layoutIfNeeded()
//                }
//            }
//        }
//        
    
        
//    }
    
}


//extension MapViewController: GMSMapViewDelegate{
//    func mapView(mapView: GMSMapView!,willmove gesture:Bool) {
//        mapView.clear()
//    }
//    func mapView(mapView: GMSMapView!, idleAtCameraPosition cameraPosition: GMSCameraPosition!){
//        let handler = {(response: GMSReverseGeocodeResponse! ,error: NSError!) -> Void in
//            if let result = response.firstResult(){
//                let marker = GMSMarker()
//                marker.position = cameraPosition.target
//                marker.title = result.lines[0] as! String
//                marker.snippet = result.lines[1] as! String
//                marker.map = mapView
//            }
//        }
//        geocoder?.reverseGeocodeCoordinate(cameraPosition.target,completionhandler: handler)
//    }
//}





//extension MapViewController: GMSMapViewDelegate{
//    func mapView(mapView: GMSMapView, idleAtCameraPosition position:GMSCameraPosition) {
//        reverseGeocodeCoordinate(position.target)
//    
//    }
//}
//
//
