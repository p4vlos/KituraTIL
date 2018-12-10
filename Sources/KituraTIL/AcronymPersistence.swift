//
//  AcronymPersistence.swift
//  KituraTIL
//
//  Created by Pavlos Nicolaou on 10/12/2018.
//

import Foundation
import CouchDB
// 1 Kitura’s CouchDB wrapper has yet to be updated to use Codable, unfortunately. Instead, it utilizes SwiftyJSON to serialize objects into JSON.
import SwiftyJSON

extension Acronym {
    // 2 You create Persistence as a nested class within Acronym. This results in Persistence-namespaced methods for retrieving, saving and deleting Acronyms from CouchDB. This prevents name collisions in the event you have more than one model class, as more real-world apps do.
    class Persistence {
        
        static func getAll(from database: Database,
                           callback: @escaping (_ acronyms: [Acronym]?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                var acronyms: [Acronym] = []
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let short = document["doc"]["short"].stringValue
                    let long = document["doc"]["long"].stringValue
                    if let acronym = Acronym(id: id, short: short, long: long) {
                        acronyms.append(acronym)
                    }
                }
                callback(acronyms, nil)
            }
        }
        
        static func save(_ acronym: Acronym, to database: Database,
                         callback: @escaping (_ id: String?, _ error: NSError?) -> Void) {
            getAll(from: database) { acronyms, error in
                guard let acronyms = acronyms else {
                    return callback(nil, error)
                }
                // 3 Remember how you made Acronym conform to Equatable? This is where it comes in handy. You use it here to ensure you aren’t saving duplicate entries in the database.
                guard !acronyms.contains(acronym) else {
                    return callback(nil, NSError(domain: "Kitura-TIL",
                                                 code: 400,
                                                 userInfo: ["localizedDescription": "Duplicate entry"]))
                }
                database.create(JSON(["short": acronym.short, "long": acronym.long])) { id, _, _, error in
                    callback(id, error)
                }
            }
        }
        
        // 4 In addition to fetching all available acronyms, you also provide a method to find a single Acronym by matching its id.
        static func get(from database: Database, with id: String,
                        callback: @escaping (_ acronym: Acronym?, _ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(nil, error)
                }
                guard let acronym = Acronym(id: document["_id"].stringValue,
                                            short: document["short"].stringValue,
                                            long: document["long"].stringValue) else {
                                                return callback(nil, error)
                }
                callback(acronym, nil)
            }
        }
        
        static func delete(with id: String, from database: Database,
                           callback: @escaping (_ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(error)
                }
                let id = document["_id"].stringValue
                // 5 Here is where CouchDB differs from other NoSQL databases: each record has a revision stored as _rev, which you can use to check that you are making a proper update.
                let revision = document["_rev"].stringValue
                database.delete(id, rev: revision) { error in
                    callback(error)
                }
            }
        }
    }
}
