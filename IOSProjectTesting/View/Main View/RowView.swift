//
//  RowView.swift
//  IOSProjectTesting
//
//  Created by prashanth on 18/09/25.
//

import SwiftUI

struct RowView: View {
    
    let dogModel: DogModel
    
    var body: some View {
        NavigationLink(destination: DetailView(dog: dogModel)) {
            Text(dogModel.breed)
        }
    }
}

