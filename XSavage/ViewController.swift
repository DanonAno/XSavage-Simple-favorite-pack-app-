//
//  ViewController.swift
//  XSavage
//
//  Created by  Даниил on 19.12.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var Places: Results<Place>!
    private var filtredPlaces: Results<Place>!
    private var ascendingSorting = true
    
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var ReversedSortingbuttonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Places = realm.objects(Place.self)
        
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return Places.isEmpty ? 0: Places.count //Places может быть пустым, т.е если в массиве Places нет никаких данных, то мы возвращаем кол-во ячеек равное 0, если больше ноля, то возвращаем кол-во данных
        
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        let place = Places[indexPath.row]
        
        
        cell.NameLabel?.text = place.name
        cell.AvCheckLabel.text = place.avCheck
        cell.LocationLabel.text = place.location
        cell.TypeLabel.text = place.type
        cell.ImageOfPlace.image = UIImage(data: place.imageData!)
        cell.ImageOfPlace?.layer.cornerRadius = cell.ImageOfPlace.frame.size.height / 2
        cell.ImageOfPlace?.clipsToBounds = true
        
        return cell
    }
    
    //MARK: TableViewDelegateDelete
    //Функция удаления ячеек
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = Places[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue ) {
        guard let newPlaceVc = segue.source as? AddRestViewController else {return}
        
        newPlaceVc.savePlace()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = Places[indexPath.row]
            let AddPlaceVc = segue.destination as! AddRestViewController
            AddPlaceVc.currentPlace = place
        }
        
    }

    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        if ascendingSorting {
            ReversedSortingbuttonItem.image = #imageLiteral(resourceName: "AZ")
        } else {
            ReversedSortingbuttonItem.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    private func sorting(){
        
        if SegmentedControl.selectedSegmentIndex == 0 {
            Places = Places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            Places = Places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

