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
