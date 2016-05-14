//
//  ViewController.swift
//  mapwithannotations
//
//  Created by Johnny' mac on 2016/5/11.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class tripMap: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
       var monitoredRegions: Dictionary<String, NSDate> = [:]
   
    // Build LocationManager
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set locationManager
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //Set mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        // set data
        setupData()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // not detemined
        if CLLocationManager.authorizationStatus() == .NotDetermined{
            locationManager.requestAlwaysAuthorization()
            
        }
            // authorizztion were denie
        else if CLLocationManager.authorizationStatus() == .Denied{
            showAlert(" We need your authorize to process,Please enable location services for this app in Settings.")
        }
        else if CLLocationManager.authorizationStatus() == .AuthorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData(){
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self) {
            
            let tripspotRegion = [
                tripSpot( title: "一中商圈", coordinate: CLLocationCoordinate2DMake(24.149062, 120.684891), regionRadius: 300.0, location: "台中一中", type: "food"),
                tripSpot( title: "逢甲夜市", coordinate: CLLocationCoordinate2DMake(24.180407, 120.645086), regionRadius: 300.0, location:"台中逢甲", type: "food"),
                tripSpot( title: "東海商圈", coordinate: CLLocationCoordinate2DMake(24.181143, 120.593158), regionRadius: 300.0, location: "東海商圈", type: "food")]
            
            for aSpot in tripspotRegion {
                //set annotation
                let coordinate = aSpot.coordinate
                let regionRadius = aSpot.regionRadius
                let title = aSpot.title
                let type = aSpot.type
                let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: title!)
                //set annotation
                let tripSpotAnnotation = MKPointAnnotation()
                
                tripSpotAnnotation.coordinate = coordinate
                tripSpotAnnotation.title = title
                tripSpotAnnotation.subtitle = type
                mapView.addAnnotations([tripSpotAnnotation])
                locationManager.startMonitoringForRegion(region)
                // draw a circle
                let circle = MKCircle(centerCoordinate: coordinate, radius: regionRadius)
                mapView.addOverlay(circle)
            }
        } else{
            print("system can't track regions")
        }
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.greenColor().colorWithAlphaComponent(0.4)
        circleRenderer.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        circleRenderer.lineWidth = 3.0
        
        return circleRenderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        
        if view == nil
        {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        
        view?.canShowCallout = true
        
        return view
    }

    
    
    //when user enter a region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert("\(region.identifier) is near, why just take a look?")
        //recording enter time
        monitoredRegions[region.identifier] = NSDate()
    }
    //when user exit a region
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("you are leaving \(region.identifier)!")
        // remove recoding time
        monitoredRegions.removeValueForKey(region.identifier)
    }
    //renew region
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegionsWithLocation(locations[0])
    }
    
    
    func updateRegionsWithLocation(location: CLLocation) {
        
        let regionMaxVisiting = 300.0
        var regionsToDelete:[String]=[]
        for regionIdentifier in monitoredRegions.keys{
            if NSDate().timeIntervalSinceDate(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                regionsToDelete.append(regionIdentifier)
                showAlert("Congruation you have finish the misson visiting \(location)")
                
            }
            for regionIdentifier in regionsToDelete{
                monitoredRegions.removeValueForKey(regionIdentifier)
                
            }
            
        }
        
    }
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}