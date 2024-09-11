//
//  ContentView.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import SwiftUI

struct ContentView: View {
    @State private var setting1 = ""
    @State private var setting2 = ""
    @State private var setting3 = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Settings")
                .font(.title)
                .padding(.bottom)

            SettingRow(label: "Setting 1", value: $setting1)
            SettingRow(label: "Setting 2", value: $setting2)
            SettingRow(label: "Setting 3", value: $setting3)
        }
        .padding()
        .frame(width: 300)
    }
}

struct SettingRow: View {
    let label: String
    @Binding var value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150)
        }
    }
}

#Preview {
    ContentView()
}
