# 🖥️ Nimfetch

<div align="center">

![Nim](https://img.shields.io/badge/Nim-2.2.6+-yellow.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Version](https://img.shields.io/badge/Version-0.2.0-green.svg)

**Fast and beautiful system information tool**

[English](#english) | [Русский](#русский)

</div>

---

## English

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

## Русский

### 📋 Описание

**Nimfetch** — это современный, быстрый и настраиваемый инструмент для отображения системной информации, написанный на Nim. Он показывает информацию о вашей системе в красивом формате с поддержкой тем, иконок и логотипов дистрибутивов.

### ✨ Возможности

- 🚀 **Быстрый** — компилируется в нативный код, запускается мгновенно
- 🎨 **10 цветовых тем** — dracula, nord, gruvbox, catppuccin, tokyonight и другие
- 📦 **Много модулей** — OS, CPU, GPU, память, диск, сеть, пакеты и многое другое
- 🖼️ **Логотипы дистрибутивов** — Arch, Ubuntu, Fedora, Debian, Gentoo, NixOS, openSUSE
- 📊 **JSON вывод** — для интеграции с другими инструментами
- ⚙️ **Конфигурация** — TOML конфиг с настройкой модулей
- 🎯 **True-color** — поддержка 24-битных цветов
- 🔧 **Диагностика** — оценка производительности, проверка здоровья, аудит безопасности

### 🚀 Установка

#### Способ 1: Из исходников (рекомендуется)

```bash
# Клонируйте репозиторий
git clone https://github.com/GinToks/nimfetch.git
cd nimfetch

# Соберите и установите
nimble install

# Или вручную в ~/.local/bin
nimble buildRelease
cp nimfetch ~/.local/bin/
```

#### Способ 2: Использование nimble

```bash
nimble install https://github.com/GinToks/nimfetch
```

#### Требования

- Nim 2.2.6 или выше
- parsetoml (устанавливается автоматически через nimble)

### 📖 Использование

```bash
# Базовый запуск
nimfetch

# Использовать тему
nimfetch --theme=dracula

# Установить тему по умолчанию (сохраняется в конфиг)
nimfetch --set-theme=nord

# Вывести в JSON формате
nimfetch --json

# Показать доступные темы
nimfetch --themes

# Не показывать логотип
nimfetch --no-logo

# Создать конфигурационный файл
nimfetch --init-config

# Интерактивный генератор конфигурации
nimfetch --generate-config

# Показать справку
nimfetch --help
```

### 🔧 Диагностика

Nimfetch включает мощные инструменты диагностики системы:

#### Оценка производительности
```bash
nimfetch --score
```
Оценивает производительность системы на основе CPU, RAM и диска. Показывает оценку от 0-1000 и процентиль.

#### Проверка здоровья
```bash
nimfetch --health
```
Проверяет здоровье системы: температуру CPU, использование памяти, место на диске, нагрузку системы и зомби-процессы. Даёт рекомендации при обнаружении проблем.

#### Аудит безопасности
```bash
nimfetch --security
```
Проверяет безопасность: статус файрвола, конфигурацию SSH, открытые порты, SELinux/AppArmor, шифрование диска и автоматические обновления. Показывает оценку безопасности и рекомендации.

#### Анализ питания
```bash
nimfetch --power
```
Анализирует профиль питания и статус батареи. Показывает примерное потребление энергии, процент заряда и рекомендации для ноутбуков.

#### Диагностика сети
```bash
nimfetch --network-test
```
Проверяет сетевое подключение: интернет, DNS, доступность шлюза, внешний IP и доступность IPv6.

#### Совместимость с играми
```bash
# Проверить, потянет ли система конкретную игру
nimfetch --can-run "Cyberpunk 2077"

# Показать все игры в базе
nimfetch --games
```
Проверяет, соответствует ли ваша система требованиям популярных игр. База включает: Cyberpunk 2077, Elden Ring, Baldur's Gate 3, GTA V, Minecraft, Fortnite, Valorant, CS2 и другие.

#### Мониторинг в реальном времени
```bash
nimfetch --live
```
Мониторинг системы в реальном времени с обновлением CPU, памяти и диска. Выход по Ctrl+C.

### 🎨 Темы

Доступные темы: `default`, `dracula`, `nord`, `gruvbox`, `catppuccin`, `tokyonight`, `onedark`, `solarized`, `monokai`, `github`

### ⚙️ Конфигурация

Конфигурационный файл находится в `~/.config/nimfetch/config.toml`

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

### 📦 Модули

| Модуль | Описание |
|--------|----------|
| `os` | Операционная система |
| `kernel` | Версия ядра |
| `uptime` | Время работы |
| `packages` | Количество пакетов |
| `shell` | Текущая оболочка |
| `cpu` | Информация о процессоре |
| `gpu` | Информация о видеокарте |
| `memory` | Использование памяти |
| `disk` | Использование диска |
| `network` | Сетевые интерфейсы |
| `battery` | Статус батареи |
| `media` | Текущий трек |
| `motherboard` | Материнская плата |
| `bluetooth` | Статус Bluetooth |
| `locale` | Языковые настройки |
| `timezone` | Часовой пояс |

### 📝 Лицензия

MIT License - см. файл [LICENSE](LICENSE)

---

<div align="center">

**Made with ❤️ by GinToks**

</div>
