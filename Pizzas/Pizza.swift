//
//  Pizza.swift
//  Pizzas
//
//  Created by Nikita Hismatov on 28.09.25.
//
import Foundation

struct Pizza: Equatable, Comparable {
    
    let diameter: Double
    let price: Double
    
    var radius: Double {
        diameter / 2
    }
    
    var area: Double {
        return .pi * pow(radius, 2)
    }
    
    var pricePerAreaUnit: Double {
        price / area
    }

    static func makeFrom(stringDiameter sd: String, stringPrice sp: String) -> Pizza? {
        guard let diameter = Double(sd), let price = Double(sp) else {
            return nil
        }
        return Pizza(diameter: diameter, price: price)
    }
    
    static func == (lhs: Pizza, rhs: Pizza) -> Bool {
        lhs.diameter == rhs.diameter &&
        lhs.price == rhs.price
    }
    
    static func < (lhs: Pizza, rhs: Pizza) -> Bool {
        lhs.pricePerAreaUnit < rhs.pricePerAreaUnit
    }
}
