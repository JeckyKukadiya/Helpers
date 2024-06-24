//
//  LocationManager.swift
//  TagCollectionView
//
//  Created by Jecky on 04/02/16.
//  Copyright © 2016 Openxcell. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
  
typealias LocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

class LocationManager : NSObject, CLLocationManagerDelegate{
    
    private var completionHandler:LocationCompletionHandler!
   
    private var locationStatus : NSString = "Calibrating"
    private var verboseMessage = "Calibrating"
    
    var locationManager : CLLocationManager!
    
    internal var latitude : Double = 0
    internal var longitude : Double = 0
    
    private let verboseMessageDictionary = [
    CLAuthorizationStatus.notDetermined:"You have not yet made a choice with regards to this application.",
    CLAuthorizationStatus.restricted:"This application is not authorized to use location services. You must turn on 'Always' in the Location Services Settings.",
    CLAuthorizationStatus.denied:"This application is denied to use location services. You must turn on 'Always' in the Location Services Settings.",
    CLAuthorizationStatus.authorizedAlways:"App is Authorized to use location services.",
    CLAuthorizationStatus.authorizedWhenInUse:"You have granted authorization to use your location only when the app is visible to you."]
    
    
    class var shared : LocationManager {
        struct Static {
            static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    private override init(){
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func beginLocationUpdating(completionHandler:((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())? = nil){
        
        self.completionHandler = completionHandler
        locationManager.delegate = self
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        checkLocationManagerAuthorizationStatus()
        
    }
    func startLocationUpdating(){
        locationManager.delegate = self
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)){
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    func endLocationUpdating(){
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    func clearLocation(){
        latitude = 0
        longitude = 0
    }
    func checkLocationManagerAuthorizationStatus(){
        var strStatus : String? = nil
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted{
            strStatus = "Location services are restricted!"
        } else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied){
            strStatus = "Location services are denied!"
        } else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
            strStatus = "Location services are notdetermined!"
        }
        
        if strStatus != nil{
            completionHandler?(latitude, longitude, strStatus! ,verboseMessageDictionary[CLLocationManager.authorizationStatus()]!, "YES")
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations.last!
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
        completionHandler?(latitude, longitude, locationStatus as String,verboseMessage, nil)
        self.completionHandler = nil
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            var hasAuthorised = false
            let verboseKey = status
            switch status {
            case CLAuthorizationStatus.restricted:
                locationStatus = "Location services are restricted!"
            case CLAuthorizationStatus.denied:
                locationStatus = "Location services are denied!"
            case CLAuthorizationStatus.notDetermined:
                locationStatus = "Location services are notdetermined!"
            default:
                locationStatus = "Allowed access"
                hasAuthorised = true
            }
            
            let verboseMessage = verboseMessageDictionary[verboseKey]!
            
            if (hasAuthorised == true) {
                startLocationUpdating()
            }else{
                
                clearLocation()
                if (!locationStatus.isEqual(to: "Denied access")){
                    if(completionHandler != nil){
                        completionHandler?(latitude, longitude, locationStatus as String, verboseMessage,"YES")
                    }
                }
            }
    }
}
