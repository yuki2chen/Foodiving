//
//  MapViewController.swift
//  Foodaholic
//
//  Created by onechun🌾 on 2016/10/4.
//  Copyright © 2016年 onechun. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(25.04, longitude: 121.56, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(25.04, 121.56)
        marker.title = "appWorks"
        marker.snippet = "Taipei"
        marker.map = mapView
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
