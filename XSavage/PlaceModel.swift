//
//  PlaceModel.swift
//  XSavage
//
//  Created by  Даниил on 03.01.2022.
//
    import RealmSwift

class Place: Object {
   static let RestorantName = ["Badar","Gyros", "Gordan", "4pho", "soupculture"]
    @objc dynamic  var imageData: Data?
    @objc dynamic var name = ""
    @objc dynamic  var type: String?
    @objc dynamic  var avCheck: String?
    @objc dynamic  var location: String?
    @objc dynamic var date = Date()
    
    convenience init (name:String, location:String?, type:String?, avCheck:String?, imageData:Data?){
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.avCheck = avCheck
        self.imageData = imageData
        
    }
    
}
