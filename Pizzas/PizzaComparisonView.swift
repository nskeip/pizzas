//
//  PizzaComparisonView.swift
//  Pizzas
//
//  Created by Nikita Hismatov on 28.09.25.
//


import SwiftUI

struct PizzaComparisonView: View {
    let pizzas: [Pizza]
    private let localizationService = LocalizationService()
    var body: some View {
        if pizzas.isEmpty {
            Text("Nothing to compare")
        } else if pizzas.count == 1 {
            Text("You have only one pizza to compare. That's odd!")
        }
        
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 300), spacing: 20)
        ], spacing: 20) {
            // col 1
            VStack(spacing: 15) {
                Text("Comparison Results")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                // Winner announcement
                VStack(spacing: 8) {
                    if pizzas.allSatisfy({ $0 == pizzas.first }) {
                        Text("Pizzas are equal!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    } else {
                        let bestPizzaIdx = pizzas.enumerated().min(by: { $0.element < $1.element })!.offset
                        Text("Pizza \(bestPizzaIdx + 1) is the better deal!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        if pizzas.count == 2 {
                            let secondBestPizzaIdx = 1 - bestPizzaIdx
                            let p1 = pizzas[bestPizzaIdx]
                            let p2 = pizzas[secondBestPizzaIdx]
                            let savings = (p2.pricePerAreaUnit - p1.pricePerAreaUnit) / p2.pricePerAreaUnit * 100
                            Text("You save \(String(format: "%.2f", savings))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.green.opacity(0.1))
                )
            }
            
            // col 2
            VStack(alignment: .leading, spacing: 12) {
                Text("Detailed Breakdown:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(pizzas.enumerated()), id: \.offset) { index, pizza in
                        HStack {
                            Circle().fill(Color.red).frame(width: 8, height: 8)
                            Text("Pizza \(index + 1):")
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(localizationService.formatArea(pizza.area))
                                Text("\(localizationService.formatPricePerArea(pizza.pricePerAreaUnit))/\(localizationService.getAreaUnitSymbol())")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
}


struct PizzaComparisonView_Pireviews: PreviewProvider {
    static var previews: some View {
        PizzaComparisonView(pizzas: [
            Pizza(diameter: 20, price: 20),
            Pizza(diameter: 28, price: 30),
        ])
    }
}
