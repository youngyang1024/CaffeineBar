# ☕ CaffeineBar

| 中文 | **[English](README_EN.md)**

一款轻量级 macOS 菜单栏工具，一键阻止系统自动休眠。

---

## 为什么需要它？

macOS 在空闲一段时间后会自动进入休眠状态，这在以下场景中会导致任务中断：

- 🤖 AI Agent 长时间运行（Claude、ChatGPT 等）
- 📦 数据跑批、ETL 任务
- ⬇️ 大文件下载 / 系统更新
- 🧪 长时间运行的测试套件
- 🖥️ SSH 远程连接保持

**CaffeineBar** 让你在菜单栏一键开关防休眠，简单高效。

## 功能特性

- ☕ **菜单栏控制** — 点击图标即可开关，开启时图标高亮（橙色），关闭时置灰
- 🌐 **中英文切换** — 右键菜单栏图标，切换界面语言（默认中文）
- 📖 **关于窗口** — 查看项目简介和 GitHub 开源地址
- 🪶 **极致轻量** — 原生 Swift 开发，无第三方依赖，安装包仅约 30KB
- 🚫 **不占 Dock** — 仅在菜单栏显示，不干扰你的工作区

## 安装

### 方式一：直接下载安装包（推荐）

无需任何开发环境，下载即用。

> ⚠️ 首次打开前需执行一次命令移除系统隔离标记（因未经 Apple 签名），详见下方说明。

#### 选择适合你 Mac 的版本

| 芯片类型 | 适用机型 | 下载链接 |
|:---|:---|:---|
| **Apple Silicon (ARM64)** | MacBook Air/Pro M1/M2/M3/M4 等 | [📥 下载 CaffeineBar-arm64.zip](https://github.com/youngyang1024/CaffeineBar/CaffeineBar/releases/latest/download/CaffeineBar-arm64.zip) |
| **Intel (x86_64)** | 2020 年及之前的 Mac | [📥 下载 CaffeineBar-x86_64.zip](https://github.com/youngyang1024/CaffeineBar/CaffeineBar/releases/latest/download/CaffeineBar-x86_64.zip) |

> 💡 **不知道你的 Mac 是什么芯片？** 点击左上角  → "关于本机"，查看"芯片"一栏。显示 "Apple M1/M2/M3/M4" 选 ARM64，显示 "Intel" 选 x86_64。

#### 安装步骤

1. 下载上方对应版本的 `.zip` 文件
2. 双击解压得到 `CaffeineBar.app`
3. 将 `CaffeineBar.app` 拖入 `/Applications`（应用程序）文件夹
4. 打开 **终端**（在"启动台"搜索"终端"），粘贴以下命令并回车：

```bash
xattr -cr /Applications/CaffeineBar.app
```

5. 双击打开 `CaffeineBar.app`，菜单栏出现 ☕ 图标即安装成功

### 方式二：源码编译

**环境要求：**
- macOS 13.0 (Ventura) 或更高版本
- 已安装 Xcode Command Line Tools（终端运行 `xcode-select --install`）

```bash
# 克隆仓库
git clone https://github.com/youngyang1024/CaffeineBar/CaffeineBar.git
cd CaffeineBar

# 编译（以 ARM64 为例，Intel 请改为 x86_64-apple-macosx13.0）
swiftc -o CaffeineBar \
  -framework AppKit -framework IOKit \
  -target arm64-apple-macosx13.0 \
  CaffeineBar/main.swift \
  CaffeineBar/SleepManager.swift \
  CaffeineBar/StatusBarController.swift \
  CaffeineBar/LanguageManager.swift \
  CaffeineBar/AppDelegate.swift

# 或用 Xcode 打开项目直接运行
open CaffeineBar.xcodeproj
```

## 使用方法

| 操作 | 说明 |
|:---|:---|
| **左键点击** 菜单栏图标 | 打开菜单，开关防休眠、查看关于、退出 |
| **右键点击** 菜单栏图标 | 切换界面语言（中文 / English） |

### 图标状态说明

| 状态 | 图标 | 颜色 |
|:---|:---|:---|
| 防休眠已开启 | ☕ 实心咖啡杯 | 🟠 橙色高亮 |
| 防休眠已关闭 | ☕ 空心咖啡杯 | ⚪ 灰色 |

### 验证是否生效

开启防休眠后，打开终端运行：

```bash
pmset -g assertions
```

看到类似以下输出即表示生效：

```
pid xxx(CaffeineBar): [0x000x...] ...PreventUserIdleSystemSleep named: "CaffeineBar is keeping your Mac awake"
```

## 技术原理

CaffeineBar 使用 macOS IOKit 框架的 `IOPMAssertionCreateWithName` API 创建电源断言（Power Assertion），阻止系统空闲休眠。这是 macOS 官方推荐的防休眠方式，也是系统自带 `caffeinate` 命令的底层实现。

- **开启**：创建 `PreventUserIdleSystemSleep` 断言
- **关闭**：释放断言，恢复正常休眠行为
- **退出**：自动释放所有断言

## 项目结构

```
CaffeineBar/
├── CaffeineBar.xcodeproj/          # Xcode 项目文件
├── CaffeineBar/
│   ├── main.swift                   # 应用入口
│   ├── AppDelegate.swift            # 应用生命周期
│   ├── StatusBarController.swift    # 菜单栏 UI 与交互
│   ├── SleepManager.swift           # IOKit 电源断言管理
│   ├── LanguageManager.swift        # 中英文语言管理
│   ├── Assets.xcassets/             # 图标资源
│   └── Info.plist                   # 应用配置
├── README.md                        # 中文说明
├── README_EN.md                     # English README
└── LICENSE                          # MIT 许可证
```

## 系统要求

| 项目 | 最低要求 |
|:---|:---|
| macOS | 13.0 (Ventura) |
| 架构 | Apple Silicon (ARM64) / Intel (x86_64) |

## 参与贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 提交 Pull Request

## 许可证

本项目基于 MIT 许可证开源 — 详见 [LICENSE](LICENSE) 文件。

## 致谢

- 灵感来自经典的 [Caffeine](https://intelliscapesolutions.com/apps/caffeine) 应用
- 基于 Apple [IOKit Power Management](https://developer.apple.com/documentation/iokit/iopmlib_h) 框架
- 菜单栏图标使用 [SF Symbols](https://developer.apple.com/sf-symbols/)

---

⭐ **如果这个工具对你有帮助，请给个 Star 支持一下！**
