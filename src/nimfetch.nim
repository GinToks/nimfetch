# src/nimfetch.nim
# ============================================
# nimfetch - Fast system information tool
# Written in Nim with love ❤️
# ============================================

# ----------------- IMPORTS -----------------
import std/strformat
import std/os
import std/parseopt
import std/strutils
import std/math
import std/unicode

# Import our modules
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
import nimfetch/modules/config_gen
import nimfetch/modules/network_test
import nimfetch/modules/power
import nimfetch/modules/security
import nimfetch/modules/health
import nimfetch/modules/score
import nimfetch/modules/game_compat
import nimfetch/modules/live

# ----------------- CONSTANTS -----------------
const Version = "0.2.0"
const AppName = "nimfetch"

# Unicode symbols for progress bars
const
  # Progress bar
  barFilled = "■"
  barEmpty = "□"
  
  # Icons (emoji fallback)
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

# ----------------- FUNCTIONS -----------------

proc showHelp() =
  echo colorize("""
nimfetch - Fast system information tool

Usage:
  nimfetch [OPTIONS]

Options:
   -h, --help        Show this help
   -v, --version     Show version
   -c, --config      Show config path
   --init-config     Create default configuration file
   --generate-config Interactive configuration generator
   --no-config       Ignore configuration file
   --no-logo         Don't show logo
   --json            Output in JSON format
   --themes          Show available themes
   --theme=NAME      Use theme (temporary)
   --set-theme=NAME  Set theme permanently (save to config)

Diagnostics:
   --score           System performance score
   --health          System health check
   --security        Security audit
   --power           Power and battery analysis
   --network-test    Network diagnostics
   --can-run=GAME    Check game compatibility
   --games           Show game database
   --live            Real-time monitoring

Examples:
  nimfetch              Show system information
  nimfetch --health     Check system health
  nimfetch --can-run "Cyberpunk 2077"
  nimfetch --live       Real-time monitoring
  nimfetch --set-theme=dracula  Set dracula as default theme
""", Cyan)

proc showVersion() =
  echo colorize(fmt"{AppName} ", BrightBlue) & bold(fmt"v{Version}")

proc showConfigPath() =
  let configPath = getConfigPath()
  echo colorize("Config path: ", Yellow) & configPath

proc initConfig() =
  let path = getConfigPath()
  if saveDefaultConfig(path):
    echo colorize("✓ Config created: ", Green) & path
  else:
    echo colorize("✗ Failed to create config", BrightRed)

# ----------------- PROGRESS BAR -----------------

proc progressBar(percent: float, width: int = 10): string =
  ## Create text progress bar
  let filled = int(percent / 100.0 * width.float)
  let empty = width - filled
  
  # Determine color based on percentage
  let barColor = if percent < 50: Green
                 elif percent < 75: Yellow
                 else: Red
  
  result = colorize(barFilled.repeat(filled), barColor) & 
           colorize(barEmpty.repeat(empty), BrightBlack)

# ----------------- COLORED LABELS -----------------

proc label(text: string, icon: string, col: RgbColor): string =
  ## Create colored label with icon (true-color version)
  colorize(icon & " " & text, col)

# ----------------- CPU INFO -----------------

proc getCpuInfo(): string =
  ## Get CPU information
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
  ## Get CPU core count
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

# ----------------- SCREEN RESOLUTION -----------------

proc getResolution(): string =
  ## Get screen resolution
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

# ----------------- TERMINAL COLORS -----------------

proc getTerminalColors(): string =
  ## Return terminal colors string
  result = ""
  let colors = [Black, Red, Green, Yellow, Blue, Magenta, Cyan, White]
  for c in colors:
    result &= colorize("●", c)
  result &= " "
  for c in [BrightBlack, BrightRed, BrightGreen, BrightYellow, BrightBlue, BrightMagenta, BrightCyan, BrightWhite]:
    result &= colorize("●", c)

# ----------------- INFO OUTPUT -----------------

proc showSystemInfo(cfg: Config, showLogo: bool, theme: Theme) =
  ## Shows system information
  
  # Get logo
  let logoLines = getAutoLogo()
  let logoColor = getLogoColor()
  
  # Get user and host info
  let username = getEnv("USER")
  let hostname = getEnv("HOSTNAME")
  
  # Get all info
  let osInfo = getOsInfo()
  let shellInfo = shell.getShellInfo()
  let cpuName = getCpuInfo()
  let cpuCores = getCpuCores()
  let resolution = getResolution()
  
  # Build info lines
  var infoLines: seq[string] = @[]
  
  # Header with user and host
  let userHost = bold(colorize(username, theme.primary)) & 
                 colorize("@", theme.secondary) & 
                 bold(colorize(hostname, theme.primary))
  infoLines.add(userHost)
  
  # Separator
  infoLines.add(colorize("─".repeat(28), BrightBlack))
  
  # Main info (with config check)
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
    # Add temperature if available
    let cpuTemp = cpu_temp.getInfo()
    if cpuTemp != "N/A":
      cpuLine &= " " & colorize(cpuTemp, theme.warning)
    infoLines.add(cpuLine)
  
  # GPU
  if isModuleEnabled(cfg, "gpu"):
    let gpuInfo = gpu.getInfo()
    if gpuInfo != "N/A":
      infoLines.add(label("GPU", IconGPU, theme.success) & " " & colorize(gpuInfo, theme.secondary))
  
  # Memory with progress bar
  if isModuleEnabled(cfg, "memory"):
    let memPercent = memory.getMemoryPercent()
    let memBar = progressBar(memPercent, 8)
    let memStr = fmt"{memory.getInfo()}"
    infoLines.add(label("Memory", IconMemory, theme.accent) & " " & colorize(memStr, theme.secondary) & " " & memBar)
  
  # Disk with progress bar
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
  
  # Battery (for laptops)
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
  
  # Terminal colors
  infoLines.add("")
  infoLines.add(colorize("  Colors: ", theme.secondary) & getTerminalColors())
  
  # Output information
  if showLogo:
    # Show logo and info side by side
    let maxLogoLines = logoLines.len
    let maxInfoLines = infoLines.len
    let totalLines = max(maxLogoLines, maxInfoLines)
    
    for i in 0..<totalLines:
      var line = ""
      
      # Logo
      if i < logoLines.len:
        line &= colorize(logoLines[i], parseColorName(logoColor))
      else:
        line &= " ".repeat(40)
      
      # Info
      line &= "   "
      if i < infoLines.len:
        line &= infoLines[i]
      
      echo line
  else:
    # Show info only
    for line in infoLines:
      echo line

# ----------------- ENTRY POINT -----------------
when isMainModule:
  var p = initOptParser(commandLineParams())
  var showInfo = true
  var showLogo = true
  var useConfig = true
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
      of "generate-config":
        discard config_gen.generateConfig()
        showInfo = false
      of "no-config":
        useConfig = false
      of "no-logo":
        showLogo = false
      of "json":
        useJson = true
        showLogo = false
      of "themes":
        echo colorize("Available themes: ", Cyan) & getAvailableThemes().join(", ")
        showInfo = false
      of "theme":
        themeName = val
      of "set-theme":
        setTheme = val
      of "score":
        score.printPerformanceScore()
        showInfo = false
      of "health":
        health.printHealthReport()
        showInfo = false
      of "security":
        security.printSecurityAudit()
        showInfo = false
      of "power":
        power.printPowerAnalysis()
        showInfo = false
      of "network-test":
        network_test.printNetworkTest()
        showInfo = false
      of "can-run":
        game_compat.printCompatibility(val)
        showInfo = false
      of "games":
        game_compat.listGames()
        showInfo = false
      of "live":
        live.runLiveMode()
        showInfo = false
      else:
        echo colorize("❌ Unknown option: ", BrightRed) & key
        echo "Use --help for usage"
        quit(1)
    of cmdArgument:
      discard
    of cmdEnd:
      discard

  # Handle --set-theme
  if setTheme.len > 0:
    if saveTheme(setTheme):
      echo colorize("✓ Theme '", Green) & setTheme & colorize("' saved as default theme", Green)
    else:
      echo colorize("✗ Failed to save theme", BrightRed)
    showInfo = false

  if showInfo:
    if useJson:
      printJsonOutput()
    else:
      # Load configuration
      let cfg = if useConfig: loadConfig() else: defaultConfig()
      # Use theme from parameter, or from config, or default
      let effectiveTheme = if themeName.len > 0: themeName else: cfg.theme.name
      let theme = getTheme(effectiveTheme)
      showSystemInfo(cfg, showLogo, theme)
