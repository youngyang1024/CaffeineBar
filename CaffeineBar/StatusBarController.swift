import AppKit

final class StatusBarController {

    private let statusItem: NSStatusItem
    private let sleepManager = SleepManager.shared
    private let lang = LanguageManager.shared

    private var aboutWindowController: NSWindowController?

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        setupButton()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageDidChange),
            name: LanguageManager.changedNotification,
            object: nil
        )
    }

    // MARK: - Button Setup

    private func setupButton() {
        guard let button = statusItem.button else { return }
        updateIcon(button: button)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        button.action = #selector(handleClick(_:))
        button.target = self
    }

    // MARK: - Click Handling

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            showLanguageMenu()
        } else {
            showMainMenu()
        }
    }

    private func showMainMenu() {
        let menu = NSMenu()

        let isOn = sleepManager.isAwake

        let statusTitle = isOn
            ? lang.text("☕ 状态：已开启 — 防止休眠中", "☕ Status: On — Keeping Awake")
            : lang.text("状态：已关闭", "Status: Off")
        let statusItem = NSMenuItem(title: statusTitle, action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)

        menu.addItem(NSMenuItem.separator())

        let toggleTitle = isOn
            ? lang.text("关闭防休眠", "Disable Awake")
            : lang.text("开启防休眠", "Enable Awake")
        let toggleItem = NSMenuItem(title: toggleTitle, action: #selector(toggleAwake), keyEquivalent: "t")
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(NSMenuItem.separator())

        let aboutItem = NSMenuItem(title: lang.text("关于 CaffeineBar", "About CaffeineBar"), action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: lang.text("退出", "Quit"), action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        self.statusItem.menu = menu
        self.statusItem.button?.performClick(nil)
        self.statusItem.menu = nil
    }

    private func showLanguageMenu() {
        let menu = NSMenu()

        let titleItem = NSMenuItem(title: lang.text("切换语言", "Language"), action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)

        menu.addItem(NSMenuItem.separator())

        let isChinese = lang.current == .chinese

        let zhItem = NSMenuItem(title: "中文", action: #selector(switchToChinese), keyEquivalent: "")
        zhItem.target = self
        zhItem.state = isChinese ? .on : .off
        menu.addItem(zhItem)

        let enItem = NSMenuItem(title: "English", action: #selector(switchToEnglish), keyEquivalent: "")
        enItem.target = self
        enItem.state = isChinese ? .off : .on
        menu.addItem(enItem)

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    // MARK: - Icon

    private func updateIcon(button: NSStatusBarButton? = nil) {
        let btn = button ?? statusItem.button
        guard let btn = btn else { return }

        let isOn = sleepManager.isAwake
        let symbolName = isOn ? "cup.and.saucer.fill" : "cup.and.saucer"

        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "CaffeineBar") {
            image.isTemplate = false
            let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .medium)
            let configured = image.withSymbolConfiguration(config) ?? image
            btn.image = configured
            btn.contentTintColor = isOn ? NSColor.systemOrange : NSColor.systemGray
        }
    }

    // MARK: - Actions

    @objc private func toggleAwake() {
        sleepManager.toggle()
        updateIcon()
    }

    @objc private func switchToChinese() {
        lang.current = .chinese
    }

    @objc private func switchToEnglish() {
        lang.current = .english
    }

    @objc private func languageDidChange() {
        // 菜单每次都动态生成，无需额外刷新
    }

    @objc private func showAbout() {
        if let wc = aboutWindowController {
            wc.window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 340),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = lang.text("关于 CaffeineBar", "About CaffeineBar")
        window.center()
        window.isReleasedWhenClosed = false

        let contentView = NSView(frame: window.contentView!.bounds)
        contentView.autoresizingMask = [.width, .height]

        let iconLabel = NSTextField(labelWithString: "☕")
        iconLabel.font = NSFont.systemFont(ofSize: 48)
        iconLabel.alignment = .center
        iconLabel.frame = NSRect(x: 0, y: 260, width: 420, height: 60)
        contentView.addSubview(iconLabel)

        let titleLabel = NSTextField(labelWithString: "CaffeineBar")
        titleLabel.font = NSFont.boldSystemFont(ofSize: 20)
        titleLabel.alignment = .center
        titleLabel.frame = NSRect(x: 0, y: 230, width: 420, height: 30)
        contentView.addSubview(titleLabel)

        let versionLabel = NSTextField(labelWithString: "v1.0.0")
        versionLabel.font = NSFont.systemFont(ofSize: 12)
        versionLabel.textColor = .secondaryLabelColor
        versionLabel.alignment = .center
        versionLabel.frame = NSRect(x: 0, y: 210, width: 420, height: 20)
        contentView.addSubview(versionLabel)

        let descText = lang.text(
            "一款轻量级 macOS 菜单栏工具，一键阻止系统自动休眠。\n\n适用于跑批任务、AI Agent 长时间运行、大文件下载等场景，\n让你的 Mac 在需要时保持清醒。\n\n原生 Swift 开发，无第三方依赖，体积仅约 30KB。",
            "A lightweight macOS menu bar utility to prevent your Mac\nfrom automatically sleeping.\n\nPerfect for batch jobs, AI agent sessions, large downloads,\nand other long-running tasks.\n\nBuilt with native Swift, zero dependencies, ~30KB."
        )
        let descLabel = NSTextField(labelWithString: descText)
        descLabel.font = NSFont.systemFont(ofSize: 12)
        descLabel.alignment = .center
        descLabel.frame = NSRect(x: 20, y: 80, width: 380, height: 130)
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.maximumNumberOfLines = 0
        contentView.addSubview(descLabel)

        let linkButton = NSButton(title: "GitHub: github.com/youngyang1024/CaffeineBar", target: self, action: #selector(openGitHub))
        linkButton.bezelStyle = .inline
        linkButton.frame = NSRect(x: 90, y: 48, width: 240, height: 24)
        contentView.addSubview(linkButton)

        let thanksLabel = NSTextField(labelWithString: lang.text(
            "⭐ 如果觉得好用，欢迎 Star 支持！",
            "⭐ If you like it, please give us a Star!"
        ))
        thanksLabel.font = NSFont.systemFont(ofSize: 11)
        thanksLabel.textColor = .secondaryLabelColor
        thanksLabel.alignment = .center
        thanksLabel.frame = NSRect(x: 0, y: 20, width: 420, height: 20)
        contentView.addSubview(thanksLabel)

        window.contentView = contentView

        let wc = NSWindowController(window: window)
        aboutWindowController = wc
        wc.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func openGitHub() {
        if let url = URL(string: "https://github.com/youngyang1024/CaffeineBar") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func quit() {
        sleepManager.disable()
        NSApp.terminate(nil)
    }
}
