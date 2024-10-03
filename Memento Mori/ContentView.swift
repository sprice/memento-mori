//
//  ContentView.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import SwiftUI

struct ContentView: View {
    @State private var deathDate = Date()
    @AppStorage("deathDate") private var storedDeathDate: Double = Date().timeIntervalSince1970

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Settings")
                .font(.title)
                .padding(.bottom)

            DatePicker("Death Date", selection: $deathDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: deathDate) { newValue in
                    storedDeathDate = newValue.timeIntervalSince1970
                    NotificationCenter.default.post(name: Notification.Name("DeathDateChanged"), object: nil)
                }

            Spacer()

            Button("Quick Action") {
                // Add your quick action functionality here
                print("Quick action button tapped")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .frame(width: 300, height: 400)
        .onAppear {
            deathDate = Date(timeIntervalSince1970: storedDeathDate)
        }
    }
}

#Preview {
    ContentView()
}
