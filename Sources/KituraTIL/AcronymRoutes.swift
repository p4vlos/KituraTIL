//
//  AcronymRoutes.swift
//  KituraTIL
//
//  Created by Pavlos Nicolaou on 10/12/2018.
//

import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializeAcronymRoutes(app: App) {
    database = app.database
    // 1 Here you declare handlers for each route, which associate API endpoints with methods to be called.
    app.router.get("/acronyms", handler: getAcronyms)
    app.router.post("/acronyms", handler: addAcronym)
    app.router.delete("/acronyms", handler: deleteAcronym)
}

// 2 getAcronyms will be called to fetch Acronyms whenever a GET /acronyms request is made.
private func getAcronyms(completion: @escaping ([Acronym]?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Acronym.Persistence.getAll(from: database) { acronyms, error in
        return completion(acronyms, error as? RequestError)
    }
}

// 3 addAcronym will insert a new Acronym into the database whenever a POST /acronyms request is made.
private func addAcronym(acronym: Acronym, completion: @escaping (Acronym?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Acronym.Persistence.save(acronym, to: database) { id, error in
        guard let id = id else {
            return completion(nil, .notAcceptable)
        }
        Acronym.Persistence.get(from: database, with: id) { newAcronym, error in
            return completion(newAcronym, error as? RequestError)
        }
    }
}

// 4 deleteAcronym will remove an Acronym from the database whenever a DELETE /acronyms request is made.
private func deleteAcronym(id: String, completion: @escaping (RequestError?) -> Void) {
    guard let database = database else {
        return completion(.internalServerError)
    }
    Acronym.Persistence.delete(with: id, from: database) { error in
        return completion(error as? RequestError)
    }
}
