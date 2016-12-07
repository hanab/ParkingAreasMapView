//
//  Extentions.swift
//  ParkingAreasMapView
//
//  Created by Hana  Demas on 12/4/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import Foundation
import MapKit

//String extention to change to Bool
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

// PArkZone class extention to create ParkZone object from Json
extension ParkZone: JSONDecodable {
    public init?(JSON: Any) {
        //get properties from json object
        guard let JSON1 = JSON as? [String: AnyObject] else { return nil }
        guard let zoneId = JSON1["id"] as? String else { return nil }
        guard let name = JSON1["name"] as? String else { return nil }
        guard let paymentIsAllowed = JSON1["payment_is_allowed"] as? String else { return nil }
        guard let  maximumAllowedDuration = JSON1["max_duration"] as? String else { return nil }
        guard let servicePrice = JSON1["service_price"] as? String else { return nil }
        guard let depth = JSON1["depth"] as? String else { return nil }
        guard let draw = JSON1["draw"] as? String else { return nil }
        guard let stickerRequired = JSON1["sticker_required"] as? String else { return nil }
        guard let currency = JSON1["currency"] as? String else { return nil }
        guard let contactEmail = JSON1["contact_email"] as? String else { return nil }
        guard let centerPoint = JSON1["point"] as? String else { return nil }
        guard let country = JSON1["country"] as? String else { return nil }
        guard let providerID = JSON1["provider_id"] as? String else { return nil }
        guard let providerName = JSON1["provider_name"] as? String else { return nil }
        guard let boundary = JSON1["polygon"] as? String else { return nil }
        
        //construct object from the json data
        self.zoneId = Int(zoneId)!
        self.name = name
        self.paymentIsAllowed = paymentIsAllowed.toBool()!
        self.maximumAllowedDuration = Double(maximumAllowedDuration)!
        self.servicePrice = Double(servicePrice)!
        self.depth = Int(depth)!
        self.draw = Int(draw)!
        self.stickerRequired = stickerRequired.toBool()!
        self.currency = Character(currency)
        self.contactEmail = contactEmail
        self.country = country
        self.providerID = Int(providerID)!
        self.providerName = providerName
        //change location string to CLLocationCoordinate2D
        let coordinateFromString = centerPoint.components(separatedBy: " ")
        self.centerPoint = CLLocationCoordinate2DMake(CLLocationDegrees(Double(coordinateFromString[0])!), CLLocationDegrees(Double(coordinateFromString[1])!))
        var coordinateArray = boundary.components(separatedBy: ", ")
        var zoneCoordinateArray = [CLLocationCoordinate2D]()
        for i in 0...coordinateArray.count - 1 {
            let coordinateFromString = coordinateArray[i].components(separatedBy: " ")
            zoneCoordinateArray.append(CLLocationCoordinate2DMake(CLLocationDegrees(Double(coordinateFromString[0])!), CLLocationDegrees(Double(coordinateFromString[1])!)))
        }
        self.boundary = zoneCoordinateArray
        self.boundaryPointsCount = self.boundary.count
    }
}

//MapRegion extention to get MapRegion object from json
extension MapRegion: JSONDecodable  {
    init?(JSON: Any) {
        //get properties from json
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        guard let mapCenterString  = JSON["current_location"] as? String else { return nil }
        guard let mapBoundries = JSON["location_data"]?["bounds"] as? NSDictionary else{ return nil }
        guard let north = mapBoundries["north"] as? Double else {return nil}
        guard let south = mapBoundries["south"]  as? Double else {return nil}
        guard let east = mapBoundries["east"] as? Double else {return nil}
        guard let west = mapBoundries["west"]  as? Double else {return nil}
        guard let zones = JSON["location_data"]?["zones"] as? [[String: AnyObject]] else{ return nil }
        //get mapregion coordinates from string
        let coordinateFromString = mapCenterString.components(separatedBy: ", ")
        self.midCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(Double(coordinateFromString[0])!), CLLocationDegrees(Double(coordinateFromString[1])!))
        self.northBoundry = CLLocationDegrees(north)
        self.southBoundary = CLLocationDegrees(south)
        self.eastBoundary = CLLocationDegrees(east)
        self.westBoundary = CLLocationDegrees(west)
        //construct the ParkZone array object recersively using its constructure
        var temp = [ParkZone]()
        for zone in zones {
            if let parkZone = ParkZone(JSON: zone) {
                temp.append(parkZone)
            }
        }
        self.zones = temp
    }
}
