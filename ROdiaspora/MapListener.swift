//
//  MapListener.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 05/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import Foundation

protocol MapListenerDelegate: class {
  func didPressOnLocation(locationObject: LocationObject)
}

class MapListener: NTMapEventListener {
  
  var mapView: NTMapView?
  
  weak var delegate: MapListenerDelegate?
  
  convenience init(mapView_: NTMapView){
    self.init()
    self.mapView = mapView_
  }
  
  
  // Map is moved, called also during move, with every small (single pixel) movement
  override func onMapMoved() {
    NTLog.debug("map moved")
  }
  
  // Map element is clicked. Can have many elements under same point
  override func onVectorElementClicked(_ vectorElementsClickInfo: NTVectorElementsClickInfo){
    NTLog.debug("clicked " + vectorElementsClickInfo.getVectorElementClickInfos().get(0).getVectorElement().description)
    if let metadata = vectorElementsClickInfo.getVectorElementClickInfos().get(0).getVectorElement().getMetaData() {
      NTLog.debug("capital " + metadata.get("capital") + " and country " + metadata.get("country"))
      
      if let capital = metadata.get("capital"), let country = metadata.get("country"), let latitude = Double(metadata.get("latitude")), let longitude = Double(metadata.get("longitude")) {
       let locationObject = LocationObject(name: capital, country: country, latitude: NSNumber(value: latitude), longitude: NSNumber(value: longitude))
        delegate?.didPressOnLocation(locationObject: locationObject)
      }
    }
  }
  
  // Map is clicked outside any vector element.
  override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
    
    if (mapClickInfo.getClickType() == NTClickType.CLICK_TYPE_DOUBLE)
    {
      NTLog.debug("Double map click!")
      self.mapView?.zoom(1.5, durationSeconds: 0.3)
    }
    
  }
  
}
