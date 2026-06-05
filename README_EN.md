# ☕ CaffeineBar

English | **[中文](README.md)**

A lightweight macOS menu bar utility that prevents your Mac from automatically sleeping.

---

## Why Do You Need It?

macOS automatically sleeps after a period of inactivity, which can interrupt tasks like:

- 🤖 Long-running AI agent sessions (Claude, ChatGPT, etc.)
- 📦 Batch processing, ETL jobs
- ⬇️ Large file downloads / system updates
- 🧪 Long-running test suites
- 🖥️ Maintaining SSH or remote desktop connections

**CaffeineBar** gives you a simple toggle in the menu bar to keep your Mac awake.

## Features

- ☕ **Menu Bar Control** — Click to toggle; icon lights up orange when active, gray when off
- 🌐 **Language Switching** — Right-click the menu bar icon to switch between Chinese and English
- 📖 **About Window** — View project info and GitHub repository link
- 🪶 **Ultra Lightweight** — Native Swift, zero dependencies, ~30KB install size
- 🚫 **No Dock Icon** — Runs exclusively in the menu bar

## Installation

### Option 1: Download Pre-built Binary (Recommended)

No development environment needed — download and run.

> ⚠️ Before first launch, you need to run a command to remove the macOS quarantine flag (since the app is not signed by Apple). See instructions below.

#### Choose Your Mac's Architecture

| Chip | Compatible Macs | Download |
|:---|:---|:---|
| **Apple Silicon (ARM64)** | MacBook Air/Pro M1/M2/M3/M4 etc. | [📥 Download CaffeineBar-arm64.zip](/CaffeineBar-x86_64.zip) |
| **Intel (x86_64)** | Macs from 2020 and earlier | [📥 Download CaffeineBar-x86_64.zip](/CaffeineBar-x86_64.zip) |

> 💡 **Not sure which chip your Mac has?** Click  → "About This Mac" and check the "Chip" field. If it says "Apple M1/M2/M3/M4", choose ARM64. If it says "Intel", choose x86_64.

#### Installation Steps

1. Download the `.zip` file for your architecture above
2. Double-click to extract `CaffeineBar.app`
3. Drag `CaffeineBar.app` to your `/Applications` folder
4. Open **Terminal** (search "Terminal" in Launchpad) and paste:

```bash
xattr -cr /Applications/CaffeineBar.app
```

5. Double-click `CaffeineBar.app` — a ☕ icon appears in the menu bar

### Option 2: Build from Source

**Requirements:**
- macOS 13.0 (Ventura) or later
- Xcode Command Line Tools (`xcode-select --install`)

```bash
# Clone the repository
git clone https://github.com/youngyang1024/CaffeineBar/CaffeineBar.git
cd CaffeineBar

# Build (ARM64 example; change target to x86_64-apple-macosx13.0 for Intel)
swiftc -o CaffeineBar \
  -framework AppKit -framework IOKit \
  -target arm64-apple-macosx13.0 \
  CaffeineBar/main.swift \
  CaffeineBar/SleepManager.swift \
  CaffeineBar/StatusBarController.swift \
  CaffeineBar/LanguageManager.swift \
  CaffeineBar/AppDelegate.swift

# Or open in Xcode and press ⌘R
open CaffeineBar.xcodeproj
```

## Usage

| Action | Description |
|:---|:---|
| **Left-click** the menu bar icon | Open menu: toggle sleep prevention, about, quit |
| **Right-click** the menu bar icon | Switch language (中文 / English) |

### Icon States

| State | Icon | Color |
|:---|:---|:---|
| Awake ON | ☕ Filled cup | 🟠 Orange |
| Awake OFF | ☕ Empty cup | ⚪ Gray |

### Verify It's Working

With sleep prevention enabled, open Terminal and run:

```bash
pmset -g assertions
```

You should see output like:

```
pid xxx(CaffeineBar): [0x000x...] ...PreventUserIdleSystemSleep named: "CaffeineBar is keeping your Mac awake"
```

## How It Works

CaffeineBar uses the `IOPMAssertionCreateWithName` API from macOS IOKit framework to create a power assertion that prevents idle system sleep. This is the officially recommended approach — the same mechanism behind Apple's built-in `caffeinate` command.

- **Enable**: Creates a `PreventUserIdleSystemSleep` assertion
- **Disable**: Releases the assertion, restoring normal sleep behavior
- **Quit**: Automatically releases all assertions

## Project Structure

```
CaffeineBar/
├── CaffeineBar.xcodeproj/          # Xcode project
├── CaffeineBar/
│   ├── main.swift                   # App entry point
│   ├── AppDelegate.swift            # App lifecycle
│   ├── StatusBarController.swift    # Menu bar UI & interactions
│   ├── SleepManager.swift           # IOKit power assertion management
│   ├── LanguageManager.swift        # Chinese/English language manager
│   ├── Assets.xcassets/             # Icon assets
│   └── Info.plist                   # App configuration
├── README.md                        # 中文说明
├── README_EN.md                     # English README
└── LICENSE                          # MIT License
```

## System Requirements

| Requirement | Minimum |
|:---|:---|
| macOS | 13.0 (Ventura) |
| Architecture | Apple Silicon (ARM64) / Intel (x86_64) |

## Contributing

Contributions are welcome!

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the classic [Caffeine](https://intelliscapesolutions.com/apps/caffeine) app
- Built with Apple's [IOKit Power Management](https://developer.apple.com/documentation/iokit/iopmlib_h) framework
- Menu bar icons powered by [SF Symbols](https://developer.apple.com/sf-symbols/)

---

⭐ **If you find this tool helpful, please give it a Star!**
