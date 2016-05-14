//
//  tripSpot.swift
//  mapwithannotations
//
//  Created by Johnny' mac on 2016/5/11.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import MapKit

class tripSpot: NSObject, MKAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var regionRadius: Double
    var location: String?
    var type: String?
    
    
    init(title:String , coordinate: CLLocationCoordinate2D , regionRadius: Double, location: String, type: String ){
    self.title = title
    self.coordinate = coordinate
    self.regionRadius = regionRadius
    self.location = location
    self.type = type
    
    
    
    }

}
