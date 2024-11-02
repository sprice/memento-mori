//
//  Memento_MoriApp.swift
//  Memento Mori
//
//  Created by Shawn Price on 2024-09-11.
//

import AppKit
import SwiftUI

// MARK: - SettingsWindowController

/// A custom window controller to manage the Settings window.
class SettingsWindowController: NSWindowController {
    init() {
        // Initialize the window with desired size and style.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 250, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.setFrameAutosaveName("Settings")
        window.contentView = NSHostingView(rootView: ContentView())
        super.init(window: window)
        self.window?.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Conform to NSWindowDelegate to handle window lifecycle events.
extension SettingsWindowController: NSWindowDelegate {
    func windowWillClose(_: Notification) {
        // Post a notification or handle any cleanup if necessary.
        // For this use-case, no additional action is needed.
        // If you decide to use a different mechanism to manage the window's lifecycle,
        // implement the necessary cleanup here.
    }
}

// MARK: - StatusBarController

class StatusBarController: NSObject, ObservableObject {
    @Published var daysLeft = "0"
    @AppStorage("deathDate") private var storedDeathDate: Double = Date().timeIntervalSince1970
    private var statusItem: NSStatusItem?

    // Use NSWindowController to manage the Settings window.
    private var settingsWindowController: SettingsWindowController?

    // Add a Timer property
    private var timer: Timer?

    override init() {
        super.init()
        // Initialize the status bar item with variable length.
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateDaysLeft()
        statusItem?.button?.title = "💀 \(daysLeft)"

        setupMenus() // Set up the status bar menu.

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deathDateChanged),
            name: Notification.Name("DeathDateChanged"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )

        // Initialize and schedule the Timer
        startTimer()
    }

    deinit {
        // Invalidate the timer when the controller is deallocated
        timer?.invalidate()
    }

    @objc func handleWake() {
        updateDaysLeft()
    }

    private func setupMenus() {
        let menu = NSMenu()

        // Settings menu item.
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "")
        settingsItem.target = self
        menu.addItem(settingsItem)

        // Separator.
        menu.addItem(NSMenuItem.separator())

        // Quit menu item.
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu // Assign the menu to the status item.
    }

    @objc func openSettings() {
        if settingsWindowController == nil {
            // Initialize the SettingsWindowController.
            settingsWindowController = SettingsWindowController()
            print("Created a new settings window controller.")
        } else {
            print("Reusing existing settings window controller.")
        }

        // Show the settings window.
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        print("Settings Window Type: \(String(describing: settingsWindowController?.window))")
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil) // Terminate the app.
    }

    @objc func deathDateChanged() {
        updateDaysLeft()
    }

    func updateDaysLeft() {
        let deathDate = Date(timeIntervalSince1970: storedDeathDate)
        let now = Date()
        let timeInterval = deathDate.timeIntervalSince(now)
        let daysRemaining = timeInterval / 86400.0 // Total seconds in a day
        let formattedDays = String(format: "%.0f", daysRemaining)

        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.month, .day], from: now)
        let deathComponents = calendar.dateComponents([.month, .day], from: deathDate)

        let isAnniversary = todayComponents.month == deathComponents.month && todayComponents.day == deathComponents.day
        let emoji = isAnniversary ? "🎂" : "💀"

        daysLeft = formattedDays
        statusItem?.button?.title = "\(emoji) \(daysLeft)"
    }

    // MARK: - Timer Setup

    /// Starts a timer that updates the days left every 10 seconds.
    private func startTimer() {
        // Schedule the timer to fire every 10 seconds
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }

    /// Called every time the timer fires.
    @objc private func timerFired() {
        updateDaysLeft()
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController!

    func applicationDidFinishLaunching(_: Notification) {
        statusBarController = StatusBarController()
    }
}

// MARK: - Main Application

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
