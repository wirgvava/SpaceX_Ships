//
//  ShipModelTests.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 29/03/2026.
//

import Testing
import ShipsModels

@Suite("Ship Model Tests")
struct ShipModelTests {
    
    @Test("Display year formats correctly")
    func displayYearFormat() {
        let ship = TestDataFactory.makeShip()
        #expect(ship.displayYear == "2020")
    }
    
    @Test("Display weight formats with kg suffix")
    func displayWeightFormat() {
        let ship = Ship(
            id: "TEST",
            name: "Test",
            type: "Cargo",
            isActive: true,
            image: "",
            homePort: "Port",
            yearBuilt: 2020,
            weightLbs: 100000,
            weightKg: 1000,
            missions: [],
            url: ""
        )
        #expect(ship.displayWeightKg.contains("kg"))
        #expect(ship.displayWeightKg.contains("1"))
    }
    
    @Test("API query parameters contains all coding keys")
    func apiQueryParameters() {
        let params = Ship.apiQueryParametersFilter()
        
        #expect(params.contains("ship_id"))
        #expect(params.contains("ship_name"))
        #expect(params.contains("ship_type"))
        #expect(params.contains("active"))
        #expect(params.contains("image"))
        #expect(params.contains("home_port"))
        #expect(params.contains("year_built"))
        #expect(params.contains("weight_lbs"))
        #expect(params.contains("weight_kg"))
        #expect(params.contains("missions"))
        #expect(params.contains("url"))
    }
    
    @Test("ShipDisplayItem preserves ship data")
    func shipDisplayItemPreservesData() {
        let ship = TestDataFactory.makeShip(id: "TEST123", name: "Test Ship")
        let displayItem = ShipDisplayItem(ship: ship, isFavorite: true)
        
        #expect(displayItem.id == "TEST123")
        #expect(displayItem.ship.name == "Test Ship")
        #expect(displayItem.isFavorite)
    }
}
