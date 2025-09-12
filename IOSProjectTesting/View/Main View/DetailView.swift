//
//  DetailView.swift
//  IOSProjectTesting
//
//  Created by prashanth on 18/09/25.
//

import SwiftUI

struct DetailView: View {
    
    let dog: DogModel
    
    var body: some View {
        VStack {
            Text("Breed: \(dog.breed)")
                .font(.largeTitle)
            Text("ID: \(dog.id)")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}


