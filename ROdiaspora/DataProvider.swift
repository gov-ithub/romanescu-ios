//
//  DataProvider+Locations.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 07/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import Foundation
import SwiftyJSON

public class LocationObject {
  
  var country : String
  var name : String
  var latitude : NSNumber
  var longitude : NSNumber
  
  init(name: String, country: String, latitude: NSNumber, longitude: NSNumber) {
    self.name = name
    self.country = country
    self.latitude = latitude
    self.longitude = longitude
  }
}

public class DataProvider {
  
  static func readGeoJson(proj: NTProjection, name: String, forMap map: NTMapView, intoDataSource dataSource: NTLocalVectorDataSource, sharedMarkerStyle: NTMarkerStyle) {
    let fullPath = Bundle.main.path(forResource: name, ofType: "json")
    
    guard let path = fullPath else {
      return
    }
    
    guard let data = NSData(contentsOfFile: path) else {
      return
    }
    
    //    let geoJsonReader = NTGeoJSONGeometryReader()
    //    let balloonPopupStyleBuilder = NTBalloonPopupStyleBuilder()
    
    var parsingError: NSError?
    let json = JSON(data: data as Data, error: &parsingError)
    
    DLog(object: parsingError)
    
    var i = 0
    
    if let features = json["features"].array {
      
      for feature in features {
        i += 1
        guard let geometry = feature["geometry"].dictionary else {
          return
        }
        
        guard let coordinates = geometry["coordinates"],
              let properties = feature["properties"].dictionary else {
          return
        }
        
        let capital = properties["Capital"]?.string
        let country = properties["Country"]?.string
        
        if coordinates.count == 2 {
          let pos = proj.fromWgs84(NTMapPos(x: coordinates[1].double!, y: coordinates[0].double!))
          let marker = NTMarker(pos:pos, style:sharedMarkerStyle)
          
          marker?.setMetaData("capital", element: capital)
          marker?.setMetaData("country", element: country)
          marker?.setMetaData("latitude", element: "\(coordinates[0].double!)")
          marker?.setMetaData("longitude", element: "\(coordinates[1].double!)")
          dataSource.add(marker)
        }
        
      }
      DLog(object: "Added \(i) features")
    }
    else {
      DLog(object: "Failed. File not found")
    }
  }
}
