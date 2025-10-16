//
//  Visit.swift
//  CRUD App
//
//  Created by Xufeng Zhang on 10/10/25.
//

import Foundation

nonisolated struct Visit : Identifiable, Equatable, Codable, Hashable{
    let id: UUID
    var title: String
    var mode: TransportMode
    var date : Date
    var distanceMeters : Int
    var note: String?
    var createdAt: Date = Date()
    
    init(id: UUID = UUID(),
         title: String,
         mode: TransportMode,
         date: Date = Date(),
         distanceMeters: Int,
         note: String? = nil)
    {
        self.id = id
        self.title = title
        self.mode = mode
        self.date = date
        self.distanceMeters = distanceMeters
        self.note = note
    }
    
    enum TransportMode:Int, CaseIterable, Codable, Equatable, Hashable{
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
    
}


enum sortMode {case name, date}

class VisitDataStore {
    static let shared = VisitDataStore() // 1. singleton

    private init() {
        cache = loadVisits()
    }

    private var fileURL: URL {
        let documentsPath = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        return documentsPath.appendingPathComponent("visits.json")
    }

    func loadVisits() -> [Visit] {
        guard let data = try? Data(contentsOf: fileURL),
              let visits = try? JSONDecoder().decode([Visit].self, from: data) else {
            return []
        }
        return visits
    }

    func saveVisits(_ visits: [Visit]) {
//        do {
//            let data = try JSONEncoder().encode(visits)
//            do{
//                try data.write(to: fileURL)
//            }catch{
//                throw VisitStoreError.writingFailed(writeFailed)
//            }
//        } catch {
//            throw VisitStoreError.encodingFailed(readFailed)
//        }
        
//        in the vc need to use do catch
//            do {
//                var visits = try VisitDataStore.shared.loadVisits()
//                visits.append(newVisit)
//                try VisitDataStore.shared.saveVisits(visits)
//            } catch let e as VisitStoreError {
//                // map to nice messages if you like
//                switch e {
//                case .readFailed(let err):   print("Read failed:", err)
//                case .decodeFailed(let err): print("Decode failed:", err)
//                case .encodeFailed(let err): print("Encode failed:", err)
//                case .writeFailed(let err):  print("Write failed:", err)
//                }
//                // showAlert("Couldn’t save your visit. Please try again.")
//            } catch {
//                print("Unexpected error:", error)
//            }
        
        // 2. try? without error handling
        guard let data = try? JSONEncoder().encode(visits) else { return }
        try? data.write(to: fileURL)
    }
    
    var cache: [Visit] = []
    
    private func persist() {
        saveVisits(cache)
    }
    
    func addVisit(_ visit: Visit){
        cache.append(visit)
        persist()
    }
    
    func updateVisit(_ visit: Visit){
        if let idx = cache.firstIndex(where: {$0.id == visit.id}){
            cache[idx] = visit
            persist()
        }
        
    }
    
    func deleteVisit(_ visit: Visit) {
        if let idx = cache.firstIndex(where: { $0.id == visit.id }) {
            cache.remove(at: idx)
            persist()
        }
    }

    func deleteVisit(at index: Int) {
        guard cache.indices.contains(index) else { return }
        cache.remove(at: index)
        persist()
    }
    
    
    
}

//class Visit{
//    var title: String
//    var mode: TransportMode
//    var date: Date
//    var distanceMeters : Int
//    var note: String?
//    
//    enum TransportMode:Int, CaseIterable{
//        case walk, bike, bus, train, car
//
//        var description: String {
//            switch self {
//            case .walk:  return "Walk"
//            case .bike:  return "Bike"
//            case .bus:   return "Bus"
//            case .train: return "Train"
//            case .car:   return "Car"
//            }
//        }
//    }
//    
//    init(title: String, mode: TransportMode, date: Date = Date(), distanceMeters: Int, note: String? = nil)
//    {
//        self.title = title
//        self.mode = mode
//        self.date = date
//        self.distanceMeters = distanceMeters
//        self.note = note
//    }
//}



//You do not need to do the following! Because once you have an id: UUID in your properties, Swift will synthesise Equatable and Hashable for you.
//// NO NEED FOR THIS! It's automatically done if your id is a UUID
//extension Item: Hashable {
//    static func == (lhs: Item, rhs: Item) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) { // hash based on ID only
//        hasher.combine(id)
//    }
//}
