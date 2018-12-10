//
//  Acronym.swift
//  KituraTIL
//
//  Created by Pavlos Nicolaou on 10/12/2018.
//
// 1 By making Acronym conform to Codable, you’ll be able to take advantage of a new Kitura feature named Codable Routing. You’ll learn more about this shortly.
struct Acronym: Codable {
    
    var id: String?
    var short: String
    var long: String
    
    init?(id: String?, short: String, long: String) {
        // 2 Within the initializer, you validate that neither short nor long are empty strings.
        if short.isEmpty || long.isEmpty {
            return nil
        }
        self.id = id
        self.short = short
        self.long = long
    }
}

// 3 You make Acronym conform to Equatable to enable you to determine if two acronyms are the same. You’ll use this later, as another form of validation.
extension Acronym: Equatable {
    
    public static func ==(lhs: Acronym, rhs: Acronym) -> Bool {
        return lhs.short == rhs.short && lhs.long == rhs.long
    }
}
