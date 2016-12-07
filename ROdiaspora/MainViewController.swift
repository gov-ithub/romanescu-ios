//
//  MainViewController.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 07/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import UIKit
import GLKit
import SwiftyJSON

// NOTE: NTMapView is imported through 'bridging header' (hellomap3swift-Bridging-Header.h)
class MainViewController: GLKViewController {
  
  override func loadView()
  {
    NTMapView.registerLicense("XTUMwQ0ZCeFVjZHFjdlpZdjZOL0pNaEV1blgzZWVSclFBaFVBbnI3YjlDWmNCV2dJRHQ4MTZLcDZIbjNFTldjPQoKcHJvZHVjdHM9c2RrLWlvcy0zLioKYnVuZGxlSWRlbnRpZmllcj1yby53aXAuUk9kaWFzcG9yYQp3YXRlcm1hcms9bnV0aXRlcQpvbmxpbmVMaWNlbnNlPTEKdXNlcktleT02NmVjY2M1ZDY2MGQ4NTU4YTYwY2U3ZWM3ZTk1YjU4MQo=")
    
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // GLKViewController-specific parameters for smoother animations
    resumeOnDidBecomeActive = false
    preferredFramesPerSecond = 60
    
    let mapView = view as! NTMapView
    
    // Set the base projection, that will be used for most MapView, MapEventListener and Options methods
    guard let proj = NTEPSG3857() else {
      return
    }
    mapView.getOptions().setBaseProjection(proj) // EPSG3857 is actually the default base projection, so this is actually not needed
    
    // General options
    mapView.getOptions().setRotatable(true) // make map rotatable (this is actually the default)
    mapView.getOptions().setTileThreadPoolSize(2) // use 2 threads to download tiles
    
    // Set initial location and other parameters, don't animate
    mapView.setFocus(proj.fromWgs84(NTMapPos(x:24.9730954, y:45.8416402)), durationSeconds:0)
    mapView.setZoom(5, durationSeconds:0)
    mapView.setRotation(0, durationSeconds:0)
    
    // Create online vector tile layer, use style asset embedded in the project
    let vectorTileLayer = NTNutiteqOnlineVectorTileLayer(styleAssetName:"nutibright-v3.zip")
    
    // Add vector tile layer
    mapView.getLayers().add(vectorTileLayer)
    
    // Load bitmaps for custom markers
    let markerImage = UIImage(named:"marker")
    let markerBitmap = NTBitmapUtils.createBitmap(from: markerImage)
    
    // Create a marker style, use it for both markers, because they should look the same
    guard let markerStyleBuilder = NTMarkerStyleBuilder() else {
      return
    }
    markerStyleBuilder.setBitmap(markerBitmap)
    markerStyleBuilder.setSize(30)
    guard let sharedMarkerStyle = markerStyleBuilder.buildStyle()else  {
      return
    }
    
    // Initialize a local vector data source
    guard let vectorDataSource = NTLocalVectorDataSource(projection:proj) else {
      return
    }
    
    // generate points from JSON
    DataProvider.readGeoJson(proj: proj, name: "capitals_3857", forMap: mapView, intoDataSource: vectorDataSource, sharedMarkerStyle: sharedMarkerStyle)
    
    // Initialize a vector layer with the previous data source
    let vectorLayer = NTVectorLayer(dataSource:vectorDataSource)
    
    // Add the previous vector layer to the map
    mapView.getLayers().add(vectorLayer)
    
    let listener = MapListener(mapView_:mapView)
    listener.delegate = self
    mapView.setMapEventListener(listener)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // GLKViewController-specific, do on-demand rendering instead of constant redrawing
    // This is VERY IMPORTANT as it stops battery drain when nothing changes on the screen!
    isPaused = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

extension MainViewController : MapListenerDelegate  {
  
  func didPressOnLocation(locationObject: LocationObject) {
    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVCid") as? DetailViewController {
      viewController.locationObject = locationObject
      self.present(viewController, animated: true, completion: {
      })
    }
  }
  
}

