//
//  ParkZone.swift
//  ParkingAreasMapView
//
//  Created by Hana  Demas on 12/3/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import Foundation
import MapKit

public struct ParkZone {
    //MARK: Properties
    var zoneId:Int
    var name:String
    var paymentIsAllowed:Bool
    var maximumAllowedDuration:Double
    var servicePrice:Double
    var depth:Int
    var draw:Int
    var stickerRequired:Bool
    var currency:Character
    var contactEmail:String
    var centerPoint:CLLocationCoordinate2D
    var country:String
    var providerID:Int
    var providerName:String
    var boundary: [CLLocationCoordinate2D]
    var boundaryPointsCount: NSInteger
    
    //MARK: Init
    init(  zoneId:Int,name:String,paymentIsAllowed:Bool, maximumAllowedDuration:Double, servicePrice:Double, depth:Int, draw:Int, stickerRequired:Bool, currency:Character, contactEmail:String, centerPoint:CLLocationCoordinate2D, country:String, providerID:Int,providerName:String, boundary: [CLLocationCoordinate2D], boundaryPointsCount: NSInteger){
        self.zoneId = zoneId
        self.name = name
        self.paymentIsAllowed = paymentIsAllowed
        self.maximumAllowedDuration = maximumAllowedDuration
        self.servicePrice = servicePrice
        self.depth = depth
        self.draw = draw
        self.stickerRequired = stickerRequired
        self.currency = currency
        self.contactEmail = contactEmail
        self.centerPoint = centerPoint
        self.country = country
        self.providerID = providerID
        self.providerName = providerName
        self.boundary = boundary
        self.boundaryPointsCount = boundary.count
    }
}
