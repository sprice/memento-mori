//
//  Memento_MoriApp.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import AppKit
import SwiftUI

class StatusBarController: ObservableObject {
    @Published var daysLeft = "0"
    @AppStorage("deathDate") private var storedDeathDate: Double = Date().timeIntervalSince1970
    private var statusItem: NSStatusItem?
    // private var popover: NSPopover? // Removed popover

    private var settingsWindow: NSWindow? // Added settings window property

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateDaysLeft()
        statusItem?.button?.title = "💀 \(daysLeft)"

        setupMenus() // Set up the new menu

        NotificationCenter.default.addObserver(self, selector: #selector(deathDateChanged), name: Notification.Name("DeathDateChanged"), object: nil)
    }

    private func setupMenus() {
        let menu = NSMenu()

        // Settings menu item
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "") // Removed keyboard shortcut
        settingsItem.target = self
        menu.addItem(settingsItem)

        // Separator
        menu.addItem(NSMenuItem.separator())

        // Quit menu item
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "") // Removed keyboard shortcut
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu // Assign the menu to the status item
    }

    @objc func openSettings() {
        if settingsWindow == nil {
            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 250, height: 150), // Reduced width to 250 and height to 150
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false
            )
            settingsWindow?.center()
            settingsWindow?.setFrameAutosaveName("Settings")
            settingsWindow?.contentView = NSHostingView(rootView: ContentView())
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true) // Bring the window to the front
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil) // Terminate the app
    }

    @objc func deathDateChanged() {
        updateDaysLeft()
    }

    func updateDaysLeft() {
        let deathDate = Date(timeIntervalSince1970: storedDeathDate)
        let calendar = Calendar.current
        // Calculate the number of days between today and the deathDate
        if let daysRemaining = calendar.dateComponents([.day], from: Date(), to: deathDate).day {
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
