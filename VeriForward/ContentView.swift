//
//  ContentView.swift
//  VeriForward
//
//  Created by Zachary Sliefert on 9/1/23.
//

import SwiftUI
import Contacts

struct SimpleContact: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
}


struct Fruit: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String
}

enum ForwardType: String, Codable, CaseIterable {
    case Text, Email
}

func fetchSystemContacts() -> [SimpleContact] {
    // Fetch contacts from CNContactStore and return an array of SimpleContact
    // You'll need to handle permissions and errors appropriately.
    // This is just a placeholder function.
    return []
}


struct ForwardingRule: Identifiable, Codable {
    let id: Int
    let name: String
    let forwardType: ForwardType
    let contacts: [SimpleContact]
}


struct ContentView: View {
    @State private var searchText = ""
    let allItems: [Fruit] = [
        Fruit(id: 1, name: "Apple", description: "A sweet, red fruit."),
        Fruit(id: 2, name: "Banana", description: "A long, yellow fruit."),
        // Add more fruits
    ]
    
    var filteredItems: [Fruit] {
        if searchText.isEmpty {
            return allItems
        } else {
            return allItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredItems) { item in
                    NavigationLink(destination: RuleDetailView(item: item)) {
                        Text(item.name)
                    }
                }
            }
            .navigationTitle("➡️ Forwarding Rules")
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                // Perform actions based on changes to the search text
                print("Search term: \(newValue)")
            }
        }
    }
}

struct RuleDetailView: View {
    let item: Fruit
    
    var body: some View {
        VStack {
            Text(item.name)
                .font(.largeTitle)
                .padding()
            
            Text(item.description)
                .padding()
            
            // Add more details about the item here
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
