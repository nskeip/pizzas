//
//  LocalizationServiceTests.swift
//  PizzasTests
//
//  Created by Nikita Hismatov on 29.09.25.
//

import Testing
import Foundation
@testable import Pizzas

struct LocalizationServiceTests {

    @Test func testUSLocaleFormatting() async throws {
        // Given
        let service = LocalizationService(locale: Locale(identifier: "en_US"))

        // When
        let formattedPrice = service.formatPricePerArea(1.234)
        let unitSymbol = service.getAreaUnitSymbol()

        // Then
        #expect(formattedPrice == "$1.234")
        #expect(unitSymbol == "in²")
    }

    @Test func testGermanLocaleFormatting() async throws {
        // Given
        let service = LocalizationService(locale: Locale(identifier: "de_DE"))

        // When
        let formattedPrice = service.formatPricePerArea(1.234)
        let unitSymbol = service.getAreaUnitSymbol()

        // Then
        #expect(formattedPrice.contains("€"))
        #expect(formattedPrice.contains("1,234"))
        #expect(unitSymbol == "cm²")
    }

    @Test func testAreaFormatting() async throws {
        // Given
        let usService = LocalizationService(locale: Locale(identifier: "en_US"))
        let deService = LocalizationService(locale: Locale(identifier: "de_DE"))

        // When
        let usArea = usService.formatArea(100.0)
        let deArea = deService.formatArea(100.0)

        // Then
        #expect(usArea.contains("100"))
        #expect(usArea.contains("in²") || usArea.contains("sq in"))

        #expect(deArea.contains("645") || deArea.contains("cm²")) // 100 sq in ≈ 645 sq cm
    }

    @Test func testPriceFormattingEdgeCases() async throws {
        // Given
        let service = LocalizationService(locale: Locale(identifier: "en_US"))

        // When
        let zeroPrice = service.formatPricePerArea(0.0)
        let smallPrice = service.formatPricePerArea(0.001)
        let largePrice = service.formatPricePerArea(999.999)

        // Then
        #expect(zeroPrice == "$0.000")
        #expect(smallPrice == "$0.001")
        #expect(largePrice == "$999.999")
    }
}
