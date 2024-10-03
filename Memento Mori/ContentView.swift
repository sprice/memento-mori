//
//  ContentView.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("deathDate") private var storedDeathDate: Double = Date().timeIntervalSince1970
    // @State private var deathDate: Date = .init(timeIntervalSince1970: storedDeathDate) // Removed

    // Added Binding for deathDate
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
        VStack(alignment: .leading, spacing: 5) { // Reduced spacing
            Text("Settings")
                .font(.title2) // Increased font size from .headline to .title2
                .padding(.bottom, 3) // Reduced bottom padding to shift up

            DatePicker("Death Date", selection: deathDateBinding, in: Date()..., displayedComponents: .date) // Added 'in: Date()...' to restrict dates
                .datePickerStyle(FieldDatePickerStyle())
                .onChange(of: deathDateBinding.wrappedValue) { _, _ in // Updated to include oldValue for macOS 14.0 compatibility
                    // No additional actions needed since binding handles updates
                }

            // Spacer() // Removed to eliminate empty space
        }
        .padding([.leading, .top], 8) // Reduced padding to shift elements left and up
        .frame(width: 250, height: 130) // Further reduced width and height for a smaller window
        // Removed onAppear since deathDate is now managed by the binding
    }
} // End of ContentView struct

#Preview {
    ContentView()
}
