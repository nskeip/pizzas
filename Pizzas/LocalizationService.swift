//
//  LocalizationService.swift
//  Pizzas
//
//  Created by Nikita Hismatov on 29.09.25.
//

import Foundation

protocol LocalizationServiceProtocol {
    func formatArea(_ area: Double) -> String
    func formatPricePerArea(_ price: Double) -> String
    func getAreaUnitSymbol() -> String
}

class LocalizationService: LocalizationServiceProtocol {
    private let locale: Locale

    init(locale: Locale = .current) {
        self.locale = locale
    }

    func formatArea(_ area: Double) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = locale

        // Convert to preferred unit based on locale
        let preferredUnit = getPreferredAreaUnit()
        let areaMeasurement = Measurement(value: area, unit: UnitArea.squareInches)
        let convertedMeasurement = areaMeasurement.converted(to: preferredUnit)

        return measurementFormatter.string(from: convertedMeasurement)
    }

    private func getPreferredAreaUnit() -> UnitArea {
        if #available(iOS 16, *) {
            return locale.measurementSystem == .metric ? UnitArea.squareCentimeters : UnitArea.squareInches
        } else {
            return locale.usesMetricSystem ? UnitArea.squareCentimeters : UnitArea.squareInches
        }
    }

    func formatPricePerArea(_ price: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = locale
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 3
        currencyFormatter.maximumFractionDigits = 3
        return currencyFormatter.string(from: NSNumber(value: price)) ?? "0"
    }

    func getAreaUnitSymbol() -> String {
        return getPreferredAreaUnit().symbol
    }
}
