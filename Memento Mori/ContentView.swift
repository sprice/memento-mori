//
//  ContentView.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("deathDate") private var storedDeathDate: Double = Date().timeIntervalSince1970

    private var deathDateBinding: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: storedDeathDate) },
            set: { newValue in
                storedDeathDate = newValue.timeIntervalSince1970
                NotificationCenter.default.post(name: Notification.Name("DeathDateChanged"), object: nil)
            }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Settings")
                .font(.title2)
                .padding(.bottom, 3)

            DatePicker("Death Date", selection: deathDateBinding, in: Date()..., displayedComponents: .date)
                .datePickerStyle(FieldDatePickerStyle())
                .onChange(of: deathDateBinding.wrappedValue) { _, _ in
                    // Binding handles updates
                }
        }
        .padding([.leading, .top], 8)
        .frame(width: 250, height: 130)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
