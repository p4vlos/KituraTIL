//
//  Application.swift
//  KituraTIL
//
//  Created by Pavlos Nicolaou on 10/12/2018.
//

import Kitura
import LoggerAPI

public class App {
    //1 The Router will handle incoming requests by routing them to the appropriate endpoint.
    let router = Router()
    
    public func run() {
        //2 Here, you register router to run on port 8080
        Kitura.addHTTPServer(onPort: 8080, with: router)
        //3 Kitura will run infinitely on the main run loop after you call run()
        Kitura.run()
    }
}
