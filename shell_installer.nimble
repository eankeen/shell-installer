version       = "0.2.1"
author        = "Edwin Kofler"
description   = "Installs shell scripts, symlinking their primary executables to the PATH and completion scripts to a common folder"
license       = "GPL-2.0"
srcDir        = "src"
bin           = @["shell_installer"]

requires "nim >= 1.4.2"
