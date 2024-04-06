//
//  PickerComponent.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 06/04/24.
//

import SwiftUI

struct PickerComponent: View {
    
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @Binding var defaultPickerSelectionItem: String
    
    var body: some View {
        Picker("Picker Filter", selection: $defaultPickerSelectionItem) {
            ForEach(pickerFilters, id: \.self) {
                Text($0)
            }
        }.pickerStyle(.segmented)
    }
}

struct PickerComponent_Previews: PreviewProvider {
    static var previews: some View {
        PickerComponent(defaultPickerSelectionItem: .constant("Active"))
    }
}
