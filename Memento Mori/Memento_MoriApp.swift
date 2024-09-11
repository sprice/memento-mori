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
    @Published var daysLeft = "15589.0"
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "💀 \(daysLeft)"

        setupMenus()
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
