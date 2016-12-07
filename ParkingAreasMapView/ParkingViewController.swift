//
//  ViewController.swift
//  ParkingAreasMapView
//
//  Created by Hana  Demas on 12/3/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//

import UIKit
import MapKit

class ParkingViewController: UIViewController, MKMapViewDelegate {
    //MARK: Properties
    @IBOutlet var startParkingButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    var mapRegion:MapRegion!
    var point:MKMapPoint!
    var selectedZone:ParkZone?
    
    //MARK: viewcontroller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // button styling
        startParkingButton.layer.cornerRadius = 5
        //set delegate of the mapview to this viewcontroller
        mapView.delegate = self
        //get MapREgion object from local json file
        let url = Bundle.main.url(forResource: "response", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let JSON = try! JSONSerialization.jsonObject(with: data, options: [])
        mapRegion = MapRegion(JSON: JSON)
        //set region
        let latDelta = mapRegion.eastBoundary - mapRegion.westBoundary
        let longDelta = mapRegion.northBoundry - mapRegion.southBoundary
        print(mapRegion.eastBoundary)
        print(latDelta)
        let span = MKCoordinateSpanMake(fabs(latDelta), fabs(longDelta))
        let region = MKCoordinateRegionMake(mapRegion.midCoordinate, span)
        mapView.region = region
        //add overrelys
        addBoundary(mapRe:mapRegion)
        //add annotation to the map center
        let pinPoint = CustomPointAnnotation()
        pinPoint.coordinate = mapRegion.midCoordinate
        pinPoint.title = "Map Center"
        pinPoint.subtitle = "Helsinki"
        pinPoint.serviePrice = "?"
        self.mapView.addAnnotation(pinPoint)
    }
    
    //MARK: IBActions
    @IBAction func startParkingPressed(_ sender: UIButton) {
        if selectedZone != nil {
            let alertController = UIAlertController(title: "You just parked", message:"Zone: " + (selectedZone?.name)!, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            selectedZone = nil
        }
    }
    //MARK: custom functions
    
    //function to add overrely
    func addBoundary(mapRe:MapRegion) {
        var polygons = [MKPolygon]()
        for  i in 0...mapRegion.zones.count - 1 {
            var currentZone  = mapRegion.zones[i]
            let polygon = MKPolygon(coordinates: &currentZone.boundary, count: mapRegion.zones[i].boundaryPointsCount)
            //decide zone color
            if(currentZone.paymentIsAllowed == true) {
                polygon.title = "Green"
            }else {
                polygon.title = "Red"
            }
            polygons.append(polygon)
        }
        self.mapView.addOverlays(polygons)
    }
    
    //function to check if a point is inside a polygon
    func pointInsidePolygon(point:CLLocationCoordinate2D, zones:[ParkZone])->Int{
        for i in 0...zones.count - 1 {
            var currentZone = zones[i]
            let polygon = MKPolygon(coordinates: &currentZone.boundary, count:currentZone.boundaryPointsCount)
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            let currentMapPoint = MKMapPointForCoordinate(point)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)
            if polygonRenderer.path.contains(polygonViewPoint) {
                return i
            }
        }
        return  -1
    }
    
    //MARK: MKMapViewDelegate implementations
    
    //render polygon
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            if overlay.title! == "Green" {
                polygonView.fillColor = UIColor.green
            } else {
                polygonView.fillColor = UIColor.red
            }
            return polygonView
        }
        return MKPolygonRenderer()
    }
    
    //move the annotation when the region changes with the map being dragged
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Remove all annotations
        self.mapView.removeAnnotations(mapView.annotations)
        // Add new annotation
        if(self.pointInsidePolygon(point: mapView.centerCoordinate, zones: self.mapRegion.zones)) == -1 {
            //annotation when the region is not a parking zone
            let annotation = CustomPointAnnotation()
            annotation.serviePrice = "?"
            annotation.coordinate = mapView.centerCoordinate
            annotation.title = "no parking place"
            annotation.subtitle = "no parking here"
            self.mapView.addAnnotation(annotation)
        } else {
            //annotation when the region is a parking zone
            let index = self.pointInsidePolygon(point: mapView.centerCoordinate, zones: self.mapRegion.zones)
            let currentZone = self.mapRegion.zones[index]
            selectedZone = currentZone
            let annotation = CustomPointAnnotation()
            annotation.serviePrice = String(currentZone.servicePrice) + String(currentZone.currency)
            annotation.coordinate = currentZone.centerPoint
            annotation.title = currentZone.name
            annotation.subtitle =  currentZone.country
            annotation.email = currentZone.contactEmail
            annotation.duration = String(currentZone.maximumAllowedDuration) + " mins"
            annotation.provider = currentZone.providerName
            if currentZone.stickerRequired == true {
                annotation.stickerReqired = "Sticker is required"
            } else {
                annotation.stickerReqired = "Sticker is Not required"
            }
            self.mapView.addAnnotation(annotation)
            //change the background color of the region when it is selected
            let polygon = self.mapView.overlays[index]
            if let renderer = self.mapView.renderer(for: polygon) as? MKPolygonRenderer {
                renderer.fillColor = UIColor.gray
                renderer.invalidatePath()
            }
        }
    }
    //render custom anottationview
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "test"
        var anViewNew = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        //make a costum annotation with an imageview and a lable to desplay price
        
        //container view
        let annView = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 70, height: 212)))
        annView.backgroundColor = UIColor.clear
        //view dequed
        anViewNew = MKAnnotationView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 70, height: 212)))
        //map pin image view
        let annImageView =  UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 100)))
        annImageView.image = UIImage(named:"locationIcon.png")
        annImageView.backgroundColor = UIColor.clear
        // label to display service price
        let priceLabel: UILabel! = UILabel(frame: CGRect(origin: CGPoint(x: 20 ,y :25), size: CGSize(width: 60, height: 10)) )
        priceLabel.tag = 7
        priceLabel.backgroundColor = UIColor.clear
        priceLabel.textColor = UIColor.black
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        priceLabel.textAlignment = NSTextAlignment.center
        //add views to the container view
        annView.addSubview(annImageView)
        annView.addSubview(priceLabel)
        anViewNew?.addSubview(annView)
        //add callouts
        anViewNew?.canShowCallout = true
        anViewNew?.isEnabled = true
        let btn = UIButton(type: .detailDisclosure)
        anViewNew?.rightCalloutAccessoryView = btn
        
        let customAnnotation = annotation as! CustomPointAnnotation
        if let priceLabel = anViewNew?.viewWithTag(7) as? UILabel {
            anViewNew!.canShowCallout = true
            priceLabel.text = customAnnotation.serviePrice
        }
        return anViewNew
    }
    
    //action when the right callout button is pressed
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        var title = "No parking spot"
        var message = "There is no parking zone here!"
        let selectedZone = view.annotation as! CustomPointAnnotation
        if  selectedZone.duration != nil {
            title = (selectedZone.title!) + " ," + (selectedZone.subtitle!)
            let  message1 = "Maximum duration: " + (selectedZone.duration!) + "\n" + (selectedZone.stickerReqired!)
            let message2 =  "\n" + "Contact: " + selectedZone.email! + " ," + selectedZone.provider!
            message = message1 + message2
        }
        //show alert view for the detail of the zone
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

