//
//  ParkingAreasMapViewTests.swift
//  ParkingAreasMapViewTests
//
//  Created by Hana  Demas on 12/3/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import XCTest
@testable import ParkingAreasMapView

let url = Bundle.main.url(forResource: "response", withExtension: "json")!
let data = try! Data(contentsOf: url)
let JSON = try! JSONSerialization.jsonObject(with: data, options: [])

class ParkingAreasMapViewTests: XCTestCase {
    
    let mapRegion = MapRegion(JSON: JSON)
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //test zone data
    func testNumberOfZones() {
        let numberOfParkingZones = mapRegion?.zones.count
        XCTAssert(numberOfParkingZones == 6, "more or less zones than expected \(numberOfParkingZones)")
        
        let zoneOne = mapRegion?.zones.filter { zone in zone.zoneId == 157 }.first
        guard let zoneOneFiltered = zoneOne else {
            XCTAssert(false)
            return
        }
        XCTAssert(zoneOneFiltered.name == "Tampere Rautatientori")
        XCTAssert(zoneOneFiltered.providerName == "AutoPark", "not the right provider")
        XCTAssert(zoneOneFiltered.maximumAllowedDuration == 720.00)
        XCTAssert(zoneOneFiltered.stickerRequired == true)
    }
    
    func testViewControllerMethod() {
        //check if all the center coordinates are inside the zones
        let vc = ParkingViewController()
        for i in 0...(mapRegion?.zones.count)! - 1 {
            let checkPoint = vc.pointInsidePolygon(point: (mapRegion?.zones[i].centerPoint)!, zones: (mapRegion?.zones)!)
            XCTAssert(checkPoint == i, "Wrong data for center coordinate")
        }
    }
    
    
    
}
