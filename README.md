# 🖥️ Nimfetch

<div align="center">

![Nim](https://img.shields.io/badge/Nim-2.2.6+-yellow.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Version](https://img.shields.io/badge/Version-0.2.0-green.svg)

**Fast and beautiful system information tool**

</div>

---

### 📋 Description

**Nimfetch** is a modern, fast and customizable system information tool written in Nim. It displays your system information in a beautiful format with support for themes, icons and distribution logos.

### ✨ Features

- 🚀 **Fast** — compiles to native code, runs instantly
- 🎨 **10 color themes** — dracula, nord, gruvbox, catppuccin, tokyonight and more
- 📦 **Many modules** — OS, CPU, GPU, memory, disk, network, packages and more
- 🖼️ **Distro logos** — Arch, Ubuntu, Fedora, Debian, Gentoo, NixOS, openSUSE
- 📊 **JSON output** — for integration with other tools
- ⚙️ **Configuration** — TOML config with module settings
- 🎯 **True-color** — 24-bit color support
- 🔧 **Diagnostic tools** — performance score, health check, security audit, and more

### 📸 Screenshot

```
                    -`                 gintoks@archlinux
                   .o+`                ────────────────────
                  `ooo/                📦 OS: Arch Linux amd64
                 `+oooo:               🔧 Kernel: 6.18.9-zen1-2-zen
                `+oooooo:              ⏱️ Uptime: 2 hours, 15 mins
               -+oooooo+:              📥 Packages: pacman: 1167, aur: 10
             `/:-:++oooo+:             🐚 Shell: zsh
            `/++++/+++++++:            🎨 DE: KDE Plasma
           `/++++++++++++++:           💻 Terminal: konsole
          `/+++ooooooooooooo/`         ⚡ CPU: AMD Ryzen 5 3550H (8 cores)
         ./ooosssso++osssssso+`        🎮 GPU: NVIDIA TU106M
        .oossssso-````/ossssss+`       🧠 Memory: 10.5G / 30.8G ■■□□□□□□
       -osssssso.      :ssssssso.      💾 Disk: 69.0G / 475.9G ■□□□□□□□
      :osssssss/        osssso+++.     
     /ossssssss/        +ssssooo/-      Colors: ●●●●●●●● ●●●●●●●●
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/`
 .`                                 `./
```

### 🚀 Installation

#### Method 1: From source (recommended)

```bash
# Clone the repository
git clone https://github.com/GinToks/nimfetch.git
cd nimfetch

# Build and install
nimble install

# Or manually to ~/.local/bin
nimble buildRelease
cp nimfetch ~/.local/bin/
```

#### Method 2: Using nimble

```bash
nimble install https://github.com/GinToks/nimfetch
```

#### Requirements

- Nim 2.2.6 or higher
- parsetoml (installed automatically via nimble)

### 📖 Usage

```bash
# Basic run
nimfetch

# Use a theme
nimfetch --theme=dracula

# Set default theme (saved to config)
nimfetch --set-theme=nord

# Output in JSON format
nimfetch --json

# Show available themes
nimfetch --themes

# Don't show logo
nimfetch --no-logo

# Create configuration file
nimfetch --init-config

# Interactive config generator
nimfetch --generate-config

# Show help
nimfetch --help
```

### 🔧 Diagnostic Tools

Nimfetch includes powerful diagnostic tools for system analysis:

#### Performance Score
```bash
nimfetch --score
```
Evaluates your system's performance based on CPU, RAM, and disk. Shows scores from 0-1000 and percentile rankings.

#### Health Check
```bash
nimfetch --health
```
Checks system health: CPU temperature, memory usage, disk space, system load, and zombie processes. Provides recommendations for issues found.

#### Security Audit
```bash
nimfetch --security
```
Audits system security: firewall status, SSH configuration, open ports, SELinux/AppArmor, disk encryption, and automatic updates. Provides security score and recommendations.

#### Power Analysis
```bash
nimfetch --power
```
Analyzes power profile and battery status. Shows power draw estimates, battery percentage, and provides recommendations for laptop users.

#### Network Diagnostics
```bash
nimfetch --network-test
```
Tests network connectivity: internet connection, DNS resolution, gateway reachability, external IP, and IPv6 availability.

#### Game Compatibility
```bash
# Check if your system can run a specific game
nimfetch --can-run "Cyberpunk 2077"

# List all games in database
nimfetch --games
```
Checks if your system meets the requirements for popular games. Database includes: Cyberpunk 2077, Elden Ring, Baldur's Gate 3, GTA V, Minecraft, Fortnite, Valorant, CS2, and more.

#### Live Monitoring
```bash
nimfetch --live
```
Real-time system monitoring with live CPU, memory, and disk usage updates. Press Ctrl+C to exit.

### 🎨 Themes

Available themes: `default`, `dracula`, `nord`, `gruvbox`, `catppuccin`, `tokyonight`, `onedark`, `solarized`, `monokai`, `github`

### ⚙️ Configuration

Config file is located at `~/.config/nimfetch/config.toml`

```toml
[display]
enabled_modules = ["os", "kernel", "uptime", "packages", "cpu", "memory", "disk", "shell"]

[logo]
type = "auto"

[icons]
enabled = true
nerd_font = true

[theme]
name = "dracula"
```

### 📦 Modules

| Module | Description |
|--------|-------------|
| `os` | Operating system |
| `kernel` | Kernel version |
| `uptime` | System uptime |
| `packages` | Package count |
| `shell` | Current shell |
| `cpu` | CPU information |
| `gpu` | GPU information |
| `memory` | Memory usage |
| `disk` | Disk usage |
| `network` | Network interfaces |
| `battery` | Battery status |
| `media` | Current track |
| `motherboard` | Motherboard info |
| `bluetooth` | Bluetooth status |
| `locale` | Locale settings |
| `timezone` | Timezone |

### 🔧 Build

```bash
# Debug build
nimble build

# Release build with optimizations
nimble buildRelease

# Install to system
nimble install
```

### 📝 License

MIT License - see [LICENSE](LICENSE) file

---

<div align="center">

**Made with ❤️ by GinToks**

</div>
