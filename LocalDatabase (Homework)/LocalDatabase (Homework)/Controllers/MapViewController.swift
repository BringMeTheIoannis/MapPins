//
//  ViewController.swift
//  LocalDatabase (Homework)
//
//  Created by Ivan Kuzmenkov on 9.11.22.
//

//TODO:
// Привести код в нормальный вид! сделано: доделать удаление из бд при нажатии на пин на карте
// доделать удаление из бд и с карты при удалении данных из таблицы
// доделать дизайн

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var realm = RealmManager<LocationModel>()
    var markers = [GMSMarker]()
    var countOfBadgeTapping: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setMap()
        initialPinsDrawing()
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialPinsDrawing()
        countOfBadgeTapping = 0
    }
    
    func setMap() {
        let camera = GMSCameraPosition(latitude: 53.9, longitude: 27.56, zoom: 6.0)
        mapView.camera = camera
        
        do {
              if let styleURL = Bundle.main.url(forResource: "googleMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
              } else {
                NSLog("Unable to find style.json")
              }
            } catch {
              NSLog("One or more of the map styles failed to load. \(error)")
            }
    }
    
    func drawMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .yellow)
        marker.map = mapView
        markers.append(marker)
    }
    
    func initialPinsDrawing() {
        mapView.clear()
        let data = realm.read()
        data.forEach { dataPiece in
            let position = CLLocationCoordinate2D(latitude: dataPiece.latitude, longitude: dataPiece.longtitude)
            let marker = GMSMarker(position: position)
            markers.append(marker)
            drawMarker(coordinate: position)
        }
    }
    
    func deleteMarker(marker: GMSMarker) {
        markers.forEach { markerFromMarkers in
            if markerFromMarkers == marker {
                markerFromMarkers.map = nil
            }
        }
        guard let markerIndex = markers.firstIndex(of: marker) else { return }
        markers.remove(at: markerIndex)
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let location = LocationModel()
        location.latitude = coordinate.latitude
        location.longtitude = coordinate.longitude
        location.time = Date()
        drawMarker(coordinate: coordinate)
        realm.write(object: location)
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let addedPin = tabBar.items?[1] else { return }
        countOfBadgeTapping += 1
        addedPin.badgeColor = .red
        addedPin.badgeValue = "\(countOfBadgeTapping)"
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let realmBase = try! Realm()
        let markerToDeleteFromRealm = realmBase.objects(LocationModel.self).where { $0.longtitude == marker.position.longitude && $0.latitude == marker.position.latitude
        }
        deleteMarker(marker: marker)
        realm.delete(object: markerToDeleteFromRealm)
        guard let tabBar = self.tabBarController?.tabBar else { return true}
        guard let addedPin = tabBar.items?[1] else { return true}
        countOfBadgeTapping -= 1
        if countOfBadgeTapping <= 0 {
            addedPin.badgeValue = nil
            countOfBadgeTapping = 0
        } else {
        addedPin.badgeValue = "\(countOfBadgeTapping)"
        }
        return true
    }
}

