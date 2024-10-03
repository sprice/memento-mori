//
//  Memento_MoriApp.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import AppKit
import SwiftUI

class StatusBarController: ObservableObject {
    @Published var isSettingsOpen = false
    @Published var daysLeft = "0"
    @AppStorage("deathDate") private var storedDeathDate: Double = Date().timeIntervalSince1970
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateDaysLeft()
        statusItem?.button?.title = "💀 \(daysLeft)"

        setupMenus()

        NotificationCenter.default.addObserver(self, selector: #selector(deathDateChanged), name: Notification.Name("DeathDateChanged"), object: nil)
    }

    private func setupMenus() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 300)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: ContentView())

        statusItem?.button?.action = #selector(togglePopover(_:))
        statusItem?.button?.target = self
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(sender)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

    @objc func deathDateChanged() {
        updateDaysLeft()
    }

    func updateDaysLeft() {
        let deathDate = Date(timeIntervalSince1970: storedDeathDate)
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: deathDate, to: Date())
        let currentAge = ageComponents.year ?? 0
        let lifeExpectancy = 80 // You can adjust this value

        if let daysRemaining = calendar.dateComponents([.day], from: Date(), to: calendar.date(byAdding: .year, value: lifeExpectancy - currentAge, to: Date())!).day {
            daysLeft = "\(daysRemaining)"
            statusItem?.button?.title = "💀 \(daysLeft)"
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController!

    func applicationDidFinishLaunching(_: Notification) {
        statusBarController = StatusBarController()
    }
}

@main
struct Memento_MoriApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.setActivationPolicy(.accessory)
        app.run()
    }
}
