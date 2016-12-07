//
//  CustomAnnotationWithLabel.swift
//  ParkingAreasMapView
//
//  Created by Hana  Demas on 12/6/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import Foundation

import UIKit
import MapKit

//make custom annotation
class CustomPointAnnotation: MKPointAnnotation {
    //MARK: Properties
    var serviePrice: String!
    //optional Properties
    var duration:String?
    var email:String?
    var provider:String?
    var stickerReqired:String?
}
