# src/nimfetch.nim
# ============================================
# nimfetch - Быстрый инструмент системной информации
# Написан на Nim с любовью ❤️
# ============================================

# ----------------- ИМПОРТЫ -----------------
import std/strformat
import std/os
import std/parseopt
import std/strutils
import std/math
import std/unicode

# Импортируем наши модули
import nimfetch/colors
import nimfetch/config
import nimfetch/themes
import nimfetch/modules/memory
import nimfetch/modules/os_info
import nimfetch/modules/packages
import nimfetch/modules/uptime
import nimfetch/modules/disk
import nimfetch/modules/shell
import nimfetch/modules/gpu
import nimfetch/modules/network
import nimfetch/modules/battery
import nimfetch/modules/media
import nimfetch/modules/cpu_temp
import nimfetch/modules/motherboard
import nimfetch/modules/bluetooth
import nimfetch/modules/locale
import nimfetch/json_output
import nimfetch/logos/auto

# ----------------- КОНСТАНТЫ -----------------
const Version = "0.2.0"
const AppName = "nimfetch"

# Unicode символы для рамки и прогресс-баров
const
  # Рамка
  tl = "╭"      # top-left
  tr = "╮"      # top-right
  bl = "╰"      # bottom-left
  br = "╯"      # bottom-right
  h  = "─"      # horizontal
  v  = "│"      # vertical
  
  # Прогресс-бар
  barFilled = "■"
  barEmpty = "□"
  
  # Иконки (emoji fallback)
  IconOS = "📦"
  IconKernel = "🔧"
  IconUptime = "⏱️"
  IconPackages = "📥"
  IconShell = "🐚"
  IconDE = "🎨"
  IconWM = "🪟"
  IconMemory = "🧠"
  IconDisk = "💾"
  IconCPU = "⚡"
  IconRes = "🖥️"
  IconTerm = "💻"
  IconGPU = "🎮"
  IconNet = "🌐"
  IconIP = "🔗"

# ----------------- ФУНКЦИИ -----------------

proc showHelp() =
  echo colorize("""
nimfetch - Быстрый инструмент системной информации

Использование:
  nimfetch [ОПЦИИ]

Опции:
  -h, --help        Показать эту справку
  -v, --version     Показать версию
  -c, --config      Показать путь к конфигу
  --init-config     Создать конфигурационный файл по умолчанию
  --no-config       Игнорировать конфигурационный файл
  --no-logo         Не показывать логотип
  --box             Показать информацию в рамке
  --json            Вывести информацию в JSON формате
  --themes          Показать доступные темы
  --theme=NAME      Использовать тему (временно)
  --set-theme=NAME  Установить тему постоянно (сохранить в конфиг)

Примеры:
  nimfetch              Показать системную информацию
  nimfetch --help       Показать справку
  nimfetch --init-config   Создать конфиг
  nimfetch --box        Показать в рамке
  nimfetch --theme=nord Использовать тему nord
  nimfetch --set-theme=dracula  Установить dracula как тему по умолчанию
""", Cyan)

proc showVersion() =
  echo colorize(fmt"{AppName} ", BrightBlue) & bold(fmt"v{Version}")

proc showConfigPath() =
  let configPath = getConfigPath()
  echo colorize("Путь к конфигу: ", Yellow) & configPath

proc initConfig() =
  let path = getConfigPath()
  if saveDefaultConfig(path):
    echo colorize("✓ Конфигурация создана: ", Green) & path
  else:
    echo colorize("✗ Ошибка создания конфигурации", BrightRed)

# ----------------- ПРОГРЕСС-БАР -----------------

proc progressBar(percent: float, width: int = 10): string =
  ## Создаёт текстовый прогресс-бар
  let filled = int(percent / 100.0 * width.float)
  let empty = width - filled
  
  # Определяем цвет на основе процента
  let barColor = if percent < 50: Green
                 elif percent < 75: Yellow
                 else: Red
  
  result = colorize(barFilled.repeat(filled), barColor) & 
           colorize(barEmpty.repeat(empty), BrightBlack)

# ----------------- ЦВЕТНЫЕ МЕТКИ -----------------

proc label(text: string, icon: string, col: RgbColor): string =
  ## Создаёт цветную метку с иконкой (true-color версия)
  colorize(icon & " " & text, col)

# ----------------- ИНФОРМАЦИЯ О CPU -----------------

proc getCpuInfo(): string =
  ## Получает информацию о CPU
  when hostOS == "linux":
    try:
      if fileExists("/proc/cpuinfo"):
        let content = readFile("/proc/cpuinfo")
        for line in content.splitLines():
          if line.startsWith("model name"):
            let parts = line.split(':')
            if parts.len >= 2:
              return parts[1].strip()
    except CatchableError:
      discard
  return "N/A"

proc getCpuCores(): int =
  ## Получает количество ядер CPU
  when hostOS == "linux":
    try:
      if fileExists("/proc/cpuinfo"):
        let content = readFile("/proc/cpuinfo")
        var count = 0
        for line in content.splitLines():
          if line.startsWith("processor"):
            inc(count)
        return count
    except CatchableError:
      discard
  return 0

# ----------------- РАЗРЕШЕНИЕ ЭКРАНА -----------------

proc getResolution(): string =
  ## Получает разрешение экрана
  when hostOS == "linux":
    try:
      when declared(execCmdEx):
        let (output, code) = execCmdEx("xrandr --current 2>/dev/null | grep '*' | head -1")
        if code == 0 and output.len > 0:
          let parts = output.strip().split()
          if parts.len > 0:
            return parts[0]
    except CatchableError:
      discard
  return "N/A"

# ----------------- ЦВЕТА ТЕРМИНАЛА -----------------

proc getTerminalColors(): string =
  ## Возвращает строку с цветами терминала
  result = ""
  let colors = [Black, Red, Green, Yellow, Blue, Magenta, Cyan, White]
  for c in colors:
    result &= colorize("●", c)
  result &= " "
  for c in [BrightBlack, BrightRed, BrightGreen, BrightYellow, BrightBlue, BrightMagenta, BrightCyan, BrightWhite]:
    result &= colorize("●", c)

# ----------------- ВЫВОД ИНФОРМАЦИИ -----------------

proc stripAnsi(s: string): string =
  ## Убирает ANSI коды из строки для подсчёта видимой длины
  result = ""
  var i = 0
  while i < s.len:
    if s[i] == '\x1b':
      # Пропускаем ANSI последовательность
      inc(i)
      if i < s.len and s[i] == '[':
        inc(i)
        while i < s.len and s[i] notin {'A'..'Z', 'a'..'z', '0'..'9'}:
          inc(i)
        if i < s.len:
          inc(i)
    else:
      result.add(s[i])
      inc(i)

proc visibleLen(s: string): int =
  ## Возвращает видимую длину строки без ANSI кодов
  ## Учитывает, что emoji занимают 2 колонки
  let stripped = stripAnsi(s)
  result = 0
  for c in stripped.runes:
    # Emoji и другие широкие символы имеют категорию "So" (Symbol, other)
    # Простая эвристика: символы вне BMP (code point > 0xFFFF) обычно широкие
    if c.ord > 0xFFFF:
      result += 2  # Emoji и другие широкие символы
    else:
      result += 1

proc showSystemInfo(cfg: Config, showLogo: bool, useBox: bool, theme: Theme) =
  ## Показывает системную информацию
  
  # Получаем логотип
  let logoLines = getAutoLogo()
  let logoColor = getLogoColor()
  
  # Получаем информацию о пользователе и хосте
  let username = getEnv("USER")
  let hostname = getEnv("HOSTNAME")
  
  # Получаем всю информацию
  let osInfo = getOsInfo()
  let shellInfo = shell.getShellInfo()
  let cpuName = getCpuInfo()
  let cpuCores = getCpuCores()
  let resolution = getResolution()
  
  # Собираем строки информации
  var infoLines: seq[string] = @[]
  
  # Заголовок с пользователем и хостом
  let userHost = bold(colorize(username, theme.primary)) & 
                 colorize("@", theme.secondary) & 
                 bold(colorize(hostname, theme.primary))
  infoLines.add(userHost)
  
  # Разделитель
  infoLines.add(colorize("─".repeat(28), BrightBlack))
  
  # Основная информация (с проверкой конфигурации)
  if isModuleEnabled(cfg, "os"):
    infoLines.add(label("OS", IconOS, theme.accent) & " " & colorize(osInfo.name & " " & osInfo.arch, theme.secondary))
  
  if isModuleEnabled(cfg, "kernel"):
    infoLines.add(label("Kernel", IconKernel, theme.success) & " " & colorize(getKernelString(), theme.secondary))
  
  if isModuleEnabled(cfg, "uptime"):
    infoLines.add(label("Uptime", IconUptime, theme.warning) & " " & colorize(uptime.getInfo(), theme.secondary))
  
  if isModuleEnabled(cfg, "packages"):
    infoLines.add(label("Packages", IconPackages, theme.accent) & " " & colorize(packages.getDetailedInfo(), theme.secondary))
  
  # Shell и DE/WM
  if isModuleEnabled(cfg, "shell"):
    infoLines.add(label("Shell", IconShell, theme.primary) & " " & colorize(shellInfo.shell, theme.secondary))
    if shellInfo.de.len > 0:
      infoLines.add(label("DE", IconDE, theme.accent) & " " & colorize(shellInfo.de, theme.secondary))
    elif shellInfo.wm.len > 0:
      infoLines.add(label("WM", IconWM, theme.accent) & " " & colorize(shellInfo.wm, theme.secondary))
    
    # Terminal
    if shellInfo.terminal.len > 0:
      infoLines.add(label("Terminal", IconTerm, theme.success) & " " & colorize(shellInfo.terminal, theme.secondary))
  
  # Resolution
  if isModuleEnabled(cfg, "resolution") and resolution != "N/A":
    infoLines.add(label("Resolution", IconRes, theme.warning) & " " & colorize(resolution, theme.secondary))
  
  # CPU
  if isModuleEnabled(cfg, "cpu") and cpuName != "N/A":
    let cpuStr = if cpuCores > 0: fmt"{cpuName} ({cpuCores} cores)" else: cpuName
    var cpuLine = label("CPU", IconCPU, theme.error) & " " & colorize(cpuStr, theme.secondary)
    # Добавляем температуру если доступна
    let cpuTemp = cpu_temp.getInfo()
    if cpuTemp != "N/A":
      cpuLine &= " " & colorize(cpuTemp, theme.warning)
    infoLines.add(cpuLine)
  
  # GPU
  if isModuleEnabled(cfg, "gpu"):
    let gpuInfo = gpu.getInfo()
    if gpuInfo != "N/A":
      infoLines.add(label("GPU", IconGPU, theme.success) & " " & colorize(gpuInfo, theme.secondary))
  
  # Memory с прогресс-баром
  if isModuleEnabled(cfg, "memory"):
    let memPercent = memory.getMemoryPercent()
    let memBar = progressBar(memPercent, 8)
    let memStr = fmt"{memory.getInfo()}"
    infoLines.add(label("Memory", IconMemory, theme.accent) & " " & colorize(memStr, theme.secondary) & " " & memBar)
  
  # Disk с прогресс-баром
  if isModuleEnabled(cfg, "disk"):
    let diskPercent = disk.getDiskPercent()
    let diskBar = progressBar(diskPercent, 8)
    let diskStr = disk.getInfo()
    infoLines.add(label("Disk", IconDisk, theme.primary) & " " & colorize(diskStr, theme.secondary) & " " & diskBar)
  
  # Network
  if isModuleEnabled(cfg, "network"):
    let netInfo = network.getInfo()
    if netInfo != "N/A":
      infoLines.add(label("Network", IconNet, theme.accent) & " " & colorize(netInfo, theme.secondary))
    
    # Local IP
    let localIp = network.getLocalIpInfo()
    if localIp != "N/A":
      infoLines.add(label("Local IP", IconIP, theme.warning) & " " & colorize(localIp, theme.secondary))
  
  # Battery (для ноутбуков)
  if isModuleEnabled(cfg, "battery"):
    let batteryInfo = battery.getInfo()
    if batteryInfo != "N/A":
      infoLines.add(label("Battery", "🔋", theme.success) & " " & colorize(batteryInfo, theme.secondary))
  
  # Media player
  if isModuleEnabled(cfg, "media"):
    let mediaInfo = media.getInfo()
    if mediaInfo != "N/A":
      infoLines.add(label("Media", "🎵", theme.accent) & " " & colorize(mediaInfo, theme.secondary))
  
  # Motherboard
  if isModuleEnabled(cfg, "motherboard"):
    let mbInfo = motherboard.getInfo()
    if mbInfo != "N/A":
      infoLines.add(label("Board", "🔌", theme.accent) & " " & colorize(mbInfo, theme.secondary))
  
  # BIOS
  if isModuleEnabled(cfg, "bios"):
    let biosInfo = motherboard.getBiosInfoString()
    if biosInfo != "N/A":
      infoLines.add(label("BIOS", "⚙️", theme.warning) & " " & colorize(biosInfo, theme.secondary))
  
  # Bluetooth
  if isModuleEnabled(cfg, "bluetooth"):
    let btInfo = bluetooth.getInfo()
    if btInfo != "N/A":
      infoLines.add(label("Bluetooth", "📶", theme.accent) & " " & colorize(btInfo, theme.secondary))
  
  # Locale
  if isModuleEnabled(cfg, "locale"):
    let locInfo = locale.getInfo()
    if locInfo != "N/A":
      infoLines.add(label("Locale", "🌐", theme.success) & " " & colorize(locInfo, theme.secondary))
  
  # Timezone
  if isModuleEnabled(cfg, "timezone"):
    let tzInfo = locale.getTimezoneInfo()
    if tzInfo != "N/A":
      infoLines.add(label("Timezone", "🕐", theme.warning) & " " & colorize(tzInfo, theme.secondary))
  
  # Цвета терминала
  infoLines.add("")
  infoLines.add(colorize("  Colors: ", theme.secondary) & getTerminalColors())
  
  # Выводим информацию
  if useBox:
    # Вычисляем максимальную видимую длину строки
    var maxLen = 0
    for line in infoLines:
      let vlen = visibleLen(line)
      if vlen > maxLen:
        maxLen = vlen
    
    # Добавляем отступ для emoji (они занимают 2 колонки, но считаются как 1)
    let boxWidth = maxLen + 6
    
    # Верхняя рамка
    echo colorize(tl & h.repeat(boxWidth) & tr, theme.primary)
    
    for line in infoLines:
      let padding = boxWidth - visibleLen(line) - 4
      echo colorize(v, theme.primary) & "  " & line & " ".repeat(max(0, padding)) & "  " & colorize(v, theme.primary)
    
    # Нижняя рамка
    echo colorize(bl & h.repeat(boxWidth) & br, theme.primary)
    
  elif showLogo:
    # Выводим логотип и информацию рядом
    let maxLogoLines = logoLines.len
    let maxInfoLines = infoLines.len
    let totalLines = max(maxLogoLines, maxInfoLines)
    
    for i in 0..<totalLines:
      var line = ""
      
      # Логотип
      if i < logoLines.len:
        line &= colorize(logoLines[i], parseColorName(logoColor))
      else:
        line &= " ".repeat(40)
      
      # Информация
      line &= "   "
      if i < infoLines.len:
        line &= infoLines[i]
      
      echo line
  else:
    # Выводим только информацию
    for line in infoLines:
      echo line

# ----------------- ТОЧКА ВХОДА -----------------
when isMainModule:
  var p = initOptParser(commandLineParams())
  var showInfo = true
  var showLogo = true
  var useConfig = true
  var useBox = false
  var useJson = false
  var themeName = ""
  var setTheme = ""

  for kind, key, val in p.getopt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        showHelp()
        showInfo = false
      of "version", "v":
        showVersion()
        showInfo = false
      of "config", "c":
        showConfigPath()
        showInfo = false
      of "init-config":
        initConfig()
        showInfo = false
      of "no-config":
        useConfig = false
      of "no-logo":
        showLogo = false
      of "box":
        useBox = true
        showLogo = false
      of "json":
        useJson = true
        showLogo = false
      of "themes":
        echo colorize("Доступные темы: ", Cyan) & getAvailableThemes().join(", ")
        showInfo = false
      of "theme":
        themeName = val
      of "set-theme":
        setTheme = val
      else:
        echo colorize("❌ Неизвестная опция: ", BrightRed) & key
        echo "Используйте --help для справки"
        quit(1)
    of cmdArgument:
      discard
    of cmdEnd:
      discard

  # Обработка --set-theme
  if setTheme.len > 0:
    if saveTheme(setTheme):
      echo colorize("✓ Тема '", Green) & setTheme & colorize("' сохранена как тема по умолчанию", Green)
    else:
      echo colorize("✗ Ошибка сохранения темы", BrightRed)
    showInfo = false

  if showInfo:
    if useJson:
      printJsonOutput()
    else:
      # Загружаем конфигурацию
      let cfg = if useConfig: loadConfig() else: defaultConfig()
      # Используем тему из параметра, или из конфига, или default
      let effectiveTheme = if themeName.len > 0: themeName else: cfg.theme.name
      let theme = getTheme(effectiveTheme)
      showSystemInfo(cfg, showLogo, useBox, theme)
