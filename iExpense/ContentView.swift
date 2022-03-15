//
//  ContentView.swift
//  iExpense
//
//  Created by Alexander Katzfey on 3/8/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var selection = "Personal"
    
    fileprivate func ListItemView(_ item: ExpenseItem) -> some View {
        HStack {
            VStack {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            
            Spacer()
            
            let text = Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
            if item.amount < 10 {
                text.foregroundColor(.green)
            }
            else if item.amount < 100 {
                text.foregroundColor(.orange)
            }
            else {
                text.foregroundColor(.red)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select expense type", selection: $selection) {
                    Text("Personal").tag("Personal")
                    Text("Buisness").tag("Buisness")
                }
                .pickerStyle(SegmentedPickerStyle())
                List {
                    ForEach(expenses.items) { item in
                        if item.type == selection {
                            ListItemView(item)
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationTitle("iExpense")
                .toolbar {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses)
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
