//
//  MapRegion.swift
//  ParkingAreasMapView
//
//  Created by Hana  Demas on 12/3/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import Foundation
import MapKit
//protocol which will be implemented by ParkZone class and MapRegion to construct object
//recursively
protocol JSONDecodable {
    init?(JSON: Any)
}

public struct MapRegion {
    //MARK: Properties
    var zones:[ParkZone]
    var midCoordinate: CLLocationCoordinate2D
    var northBoundry:CLLocationDegrees
    var southBoundary: CLLocationDegrees
    var eastBoundary: CLLocationDegrees
    var westBoundary: CLLocationDegrees
    
    //MARK: Init
    init( zones:[ParkZone],midCoordinate: CLLocationCoordinate2D, northBoundry:CLLocationDegrees,  southBoundary: CLLocationDegrees, eastBoundary: CLLocationDegrees, westBoundary: CLLocationDegrees ) {
        self.zones = zones
        self.midCoordinate = midCoordinate
        self.northBoundry = northBoundry
        self.southBoundary = southBoundary
        self.eastBoundary = eastBoundary
        self.westBoundary = westBoundary
    }
}
