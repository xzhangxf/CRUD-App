//
//  Visit.swift
//  CRUD App
//
//  Created by Xufeng Zhang on 10/10/25.
//

import Foundation


import Foundation




class Visit{
    var title: String
    var mode: TransportMode
    var date: Date
    var distanceMeters : Int
    var note: String?
    
    enum TransportMode:Int, CaseIterable{
        case walk, bike, bus, train, car

        var description: String {
            switch self {
            case .walk:  return "Walk"
            case .bike:  return "Bike"
            case .bus:   return "Bus"
            case .train: return "Train"
            case .car:   return "Car"
            }
        }
    }
    
    init(title: String, mode: TransportMode, date: Date = Date(), distanceMeters: Int, note: String? = nil)
    {
        self.title = title
        self.mode = mode
        self.date = date
        self.distanceMeters = distanceMeters
        self.note = note
    }
}


