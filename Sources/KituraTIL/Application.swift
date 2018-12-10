//
//  Application.swift
//  KituraTIL
//
//  Created by Pavlos Nicolaou on 10/12/2018.
//

// 1 You first import CouchDB in order to set up your persistence layer
import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {
    
    // 2 You add properties for client for CouchDB and database to keep track of changes.
    var client: CouchDBClient?
    var database: Database?
    
    //1 The Router will handle incoming requests by routing them to the appropriate endpoint.
    let router = Router()
    
    private func postInit() {
        // 3 You’ll add code here after you’ve created your instance of App to connect to your database
        // 1 You created a ConnectionProperties object that you use to specify configuration values and a new CouchDBClient.
        let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
        client = CouchDBClient(connectionProperties: connectionProperties)
        // 2 You check to see if a matching database already exists, so you don’t overwrite existing data.
        client!.dbExists("acronyms") { exists, _ in
            guard exists else {
                // 3 If a new database does not exist, then you call createNewDatabase() to create a new database.
                self.createNewDatabase()
                return
            }
            // 4 If a new database does exist, you call finalizeRoutes(with:) to configure your routes.
            Log.info("Acronyms database located - loading...")
            self.finalizeRoutes(with: Database(connProperties: connectionProperties, dbName: "acronyms"))
        }
    }
    
    private func createNewDatabase() {
        // 4 This organizes your code stemming from the previous function.
        
        Log.info("Database does not exist - creating new database")
        // 1 You create your database with a given name. You can choose anything, but it’s best to keep it simple.
        client?.createDB("acronyms") { database, error in
            // 2 You ensure the database exists, or else, you abort and log an error.
            guard let database = database else {
                let errorReason = String(describing: error?.localizedDescription)
                Log.error("Could not create new database: (\(errorReason)) - acronym routes not created")
                return
            }
            // 3 Just like before, you call finalizeRoutes(with:) to configure your routes
            self.finalizeRoutes(with: database)
        }
    }
    
    private func finalizeRoutes(with database: Database) {
        // 5 Once you’ve set up your database, you’ll list all available routes for your API to match against here.
        self.database = database
        initializeAcronymRoutes(app: self)
        Log.info("Acronym routes created")
    }
    
    
    public func run() {
        
        // 6 You call postInit() from within run() to make this part of your API setup
        postInit()
        
        //2 Here, you register router to run on port 8080
        Kitura.addHTTPServer(onPort: 8080, with: router)
        //3 Kitura will run infinitely on the main run loop after you call run()
        Kitura.run()
    }
}
