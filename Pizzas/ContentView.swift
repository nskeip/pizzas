//
//  ContentView.swift
//  Pizzas
//
//  Created by Nikita Hismatov on 28.09.25.
//


import SwiftUI


struct ContentView: View {
    @State private var pizza1Diameter: String = ""
    @State private var pizza1Price: String = ""
    @State private var pizza2Diameter: String = ""
    @State private var pizza2Price: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Pizza Price Comparison")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Compare which pizza gives you more value for your money!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 300), spacing: 20),
                    ], spacing: 30) {
                        // Pizza 1 Section
                        PizzaInputSection(
                            title: "Pizza 1",
                            color: .red,
                            diameter: $pizza1Diameter,
                            price: $pizza1Price
                        )

                        // Pizza 2 Section
                        PizzaInputSection(
                            title: "Pizza 2",
                            color: .blue,
                            diameter: $pizza2Diameter,
                            price: $pizza2Price
                        )
                    }

                    // Comparison Results - moved outside the grid
                    if !pizza1Diameter.isEmpty && !pizza1Price.isEmpty &&
                       !pizza2Diameter.isEmpty && !pizza2Price.isEmpty {
                        let pizzasToCompare = [
                            Pizza.makeFrom(stringDiameter: pizza1Diameter, stringPrice: pizza1Price),
                            Pizza.makeFrom(stringDiameter: pizza2Diameter, stringPrice: pizza2Price),
                        ].compactMap { $0 }
                        if pizzasToCompare.count > 1 {
                            PizzaComparisonView(
                                pizzas: pizzasToCompare
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }.padding()
    }

    init(pizza1Diameter: String = "", pizza1Price: String = "", pizza2Diameter: String = "", pizza2Price: String = "") {
        self._pizza1Diameter = State(initialValue: pizza1Diameter)
        self._pizza1Price = State(initialValue: pizza1Price)
        self._pizza2Diameter = State(initialValue: pizza2Diameter)
        self._pizza2Price = State(initialValue: pizza2Price)
    }
}

struct PizzaInputSection: View {
    let title: String
    let color: Color
    @Binding var diameter: String
    @Binding var price: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Diameter:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 100, alignment: .leading)
                    Spacer()
                    TextField("Enter diameter", text: $diameter)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Price:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 100, alignment: .leading)
                    Spacer()
                    TextField("Enter price", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct PizzaComparisonView: View {
    let pizzas: [Pizza]
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
                                let preferredUnit = Locale.current.measurementSystem == .metric ?                                UnitArea.squareCentimeters : UnitArea.squareInches

                                let roundedArea = round(pizza.area, 2)
                                Text("\(roundedArea) \(preferredUnit.symbol)")
                                
                                let roundedPricePerAreaUnit = round(pizza.pricePerAreaUnit, 3)
                                let currencySymbol = Locale.current.currency.symbol ?? ""
                                Text("\(currencySymbol)\(roundedPricePerAreaUnit)/\(preferredUnit.symbol)")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDisplayName("iPhone Portrait - Empty")

            ContentView(pizza1Diameter: "12", pizza1Price: "15.99", pizza2Diameter: "16", pizza2Price: "22.99")
                .previewDisplayName("iPhone Portrait - Filled")

            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPhone Landscape - Empty")

            ContentView(pizza1Diameter: "12", pizza1Price: "15.99", pizza2Diameter: "16", pizza2Price: "22.99")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPad Landscape - Filled")
        }
    }
}
