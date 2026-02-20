# Package

version       = "0.2.0"
author        = "GinToks"
description   = "Fast system information tool written in Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["nimfetch"]


# Dependencies

requires "nim >= 2.2.6"
requires "parsetoml >= 0.7.0"

# Tasks

task test, "Run tests":
  exec "nim c -r tests/test_all.nim"

task buildRelease, "Build optimized release binary":
  exec "nim c -d:release -d:strip --opt:speed src/nimfetch.nim"

task install, "Install nimfetch to system":
  exec "nim c -d:release -d:strip --opt:speed src/nimfetch.nim"
  exec "cp nimfetch ~/.local/bin/nimfetch"
  echo "nimfetch installed to ~/.local/bin/nimfetch"
  echo "Make sure ~/.local/bin is in your PATH"
