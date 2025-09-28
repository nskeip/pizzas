//
//  PizzasTests.swift
//  PizzasTests
//
//  Created by Nikita Hismatov on 28.09.25.
//

import Testing
@testable import Pizzas

struct PizzasTests {

    @Test func testPizzaEqualityBasedOnFields() async throws {
        let p1 = Pizza(diameter: 10.0, price: 10.0)
        let p2 = Pizza(diameter: 10.0, price: 10.0)
        #expect(p1 == p2)
    }

    @Test func testPizzaUnequalBydiameter() async throws {
        let p1 = Pizza(diameter: 10.0, price: 10.0)
        let p2 = Pizza(diameter: 11.0, price: 10.0)
        #expect(p1 != p2)
    }
    
    @Test func testPizzaUnequalByPrice() async throws {
        let p1 = Pizza(diameter: 10.0, price: 10.0)
        let p2 = Pizza(diameter: 10.0, price: 11.0)
        #expect(p1 != p2)
    }
    
    @Test func testMakeFromGoodStrings() async throws {
        let p = Pizza.makeFrom(stringDiameter: "40.0", stringPrice: "25.0")
        #expect(p != nil)
        #expect(p!.diameter == 40)
        #expect(p!.price == 25)
    }
    
    @Test func testMakeFromBadStringsReturnNil() async throws {
        let p = Pizza.makeFrom(stringDiameter: "foo", stringPrice: "bar")
        #expect(p == nil)
    }
    
    @Test func testIrreflexibility() async throws {
        let p = Pizza(diameter: 10, price: 10)
        #expect(!(p < p))
    }
    
    @Test func testAsymmetry() async throws {
        let p1 = Pizza(diameter: 10, price: 10)
        let p2 = Pizza(diameter: 10, price: 20)
        #expect(p1 < p2)
        #expect(!(p2 < p1))
    }
    
    @Test func testTransitivity() async throws {
        let p1 = Pizza(diameter: 10, price: 10)
        let p2 = Pizza(diameter: 10, price: 20)
        let p3 = Pizza(diameter: 10, price: 30)
        #expect((p1 < p2) && (p2 < p3) && (p1 < p3))
    }
}
