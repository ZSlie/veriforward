//
//  ContentView.swift
//  VeriForward
//
//  Created by Zachary Sliefert on 9/1/23.
//

import SwiftUI
import Contacts


let contactStore = CNContactStore()

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

func requestAccessToContacts() {
    // Check authorization status
    let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    // Handle various authorization states
    switch authorizationStatus {
    case .authorized:
        // Already authorized
        fetchContacts()
    case .notDetermined:
        // Request access
        contactStore.requestAccess(for: .contacts) { granted, error in
            if granted {
                fetchContacts()
            } else {
                // Handle error
                print("Permission denied: \(String(describing: error?.localizedDescription))")
            }
        }
    case .restricted, .denied:
        // Handle restricted or denied states
        print("Permission restricted or denied")
    @unknown default:
        // Handle unknown cases (though this should rarely happen)
        print("Unknown authorization status")
    }
}

func fetchContacts() {
    // Your code to fetch contacts here
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
        }.onAppear(
            perform: requestAccessToContacts
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
