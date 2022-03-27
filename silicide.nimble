# Package

version       = "0.1.0"
author        = "idakandrew"
description   = "silicide: silicon-level circuits"
license       = "GPL-3.0-or-later"
srcDir        = "src"
binDir        = "bin"
bin           = @["silicide"]

# Dependencies

requires "nim >= 1.6.4"
requires "boxy"
requires "staticglfw"
requires "pixie"
requires "opengl"

task dbg, "debugs":
    exec "cd /src"
    exec "c --outdir:bin silicide.nim"
    exec "cd .."
    exec "cd /bin"
    exec "silicide.exe"