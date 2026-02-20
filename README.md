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

# Show help
nimfetch --help
```

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

# Показать справку
nimfetch --help
```

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
