//
//  ViewController.swift
//  Memorable Places
//
//  Created by William Peregoy on 2015/9/6.
//  Copyright © 2015年 William Peregoy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var manager: CLLocationManager!

        override func viewDidLoad() {
            super.viewDidLoad()
        
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            
            if activePlace == -1 {
                
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
                
            } else {
                
                let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
                
                let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
                
                let latDelta: CLLocationDegrees = 0.15
                
                let longDelta: CLLocationDegrees = 0.15
                
                let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                
                let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                
                let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
                
                map.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = center
                
                annotation.title = places[activePlace]["name"]
                
                self.map.addAnnotation(annotation)
                
            }

            let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
            
            uilpgr.minimumPressDuration = 2
            
            map.addGestureRecognizer(uilpgr)

    }

    func action(gestureRecognizer: UIGestureRecognizer) {

        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            
            var newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
               
                var title = ""
                
                if error == nil {
                    
                    if let p = placemarks?[0] {
                        
                        var subThoroughfare = ""
                        var thoroughfare = ""
                        
                        if p.subThoroughfare != nil {
                            
                            subThoroughfare = p.subThoroughfare!
                        
                        }
                        
                        if p.thoroughfare != nil {
                            
                            thoroughfare = p.thoroughfare!
                            
                        }
                        
                        title = subThoroughfare + " " + thoroughfare
                        
                    }
                    
                }
                
                if title == " " {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                NSUserDefaults.standardUserDefaults().setValue(places, forKey: "listData")
                
                let annotation = MKPointAnnotation()

                annotation.coordinate = newCoordinate
            
                annotation.title = title
            
                self.map.addAnnotation(annotation)
                            
        })
    }
        
}
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        var userLocation: CLLocation = locations[0]
        
        var latitude = userLocation.coordinate.latitude
        
        var longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.15
        
        let longDelta: CLLocationDegrees = 0.15
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        map.setRegion(region, animated: true)
        
    }
    
}


       /* print(rowCounter)
        

        
        let latDelta: CLLocationDegrees = 0.3
        
        let longDelta: CLLocationDegrees = 0.3
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(center, span)
        
        map.setRegion(region, animated: false)
        


        
    }
    
    var newCoordinate: CLLocationCoordinate2D!
    


        
    }
   
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
*/
