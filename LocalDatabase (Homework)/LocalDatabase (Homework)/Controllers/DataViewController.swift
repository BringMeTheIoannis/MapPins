//
//  DataViewController.swift
//  LocalDatabase (Homework)
//
//  Created by Ivan Kuzmenkov on 9.11.22.
//

import UIKit
import RealmSwift


class DataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var realmLocations = RealmManager<LocationModel>().read()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        realmLocations = RealmManager<LocationModel>().read()
        tableView.reloadData()
        guard let tabBar = self.tabBarController?.tabBar else { return }
        guard let addedPin = tabBar.items?[1] else { return }
        addedPin.badgeValue = nil
    }
    
    func registerCells() {
        let nib = UINib(nibName: DataCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DataCell.id)
    }
    
}

extension DataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        realmLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stringLat = String(realmLocations[indexPath
            .row].latitude)
        let stringLon = String(realmLocations[indexPath
            .row].longtitude)
        let stringTime = DateFormatter.localizedString(from: realmLocations[indexPath
            .row].time, dateStyle: .medium, timeStyle: .medium)
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.id, for: indexPath)
        guard let cell = cell as? DataCell else { return cell }
        cell.latitudeLabel.text = "latitude: \(stringLat)"
        cell.longtitudeLabel.text = "longtitude: \(stringLon)"
        cell.timeLabel.text = "date: \(stringTime)"
        return cell
    }
}

extension DataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            let locationRealm = RealmManager<LocationModel>()
            let objectToDelete = realm.objects(LocationModel.self).where { $0.longtitude == realmLocations[indexPath.row].longtitude && $0.latitude == realmLocations[indexPath.row].latitude }
            tableView.beginUpdates()
            locationRealm.delete(object: objectToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
    
