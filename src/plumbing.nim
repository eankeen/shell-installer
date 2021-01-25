import os
import strformat
import strutils
import "./util"

# TODO: loop refactoring
proc plumbingReshim*() =
  # 'prune' before reshiming
  for i, subfolder in ["bin", "completions", "libexec", "man"]:
    removeDir(joinPath(xdgDataDir(), subfolder))
    createDir(joinPath(xdgDataDir(), subfolder))

  for i, fullProject in walkDir(joinPath(xdgDataDir(), "dls")):
    let project = lastPathPart(fullProject)
    let repo = encodeAuthorRepo(lastPathPart(project))[1]

    # project.sh symlink to bin
    let mainFile = joinPath(xdgDataDir(), "dls", project,  fmt"{repo}.sh")
    if fileExists(mainFile):
      let dest = joinPath(xdgDataDir(), "bin", repo)
      if fileExists(dest):
        removeFile(dest)
      createSymlink(mainFile, dest)

    # bin
    for j, file in walkDir(joinPath(xdgDataDir(), "dls", project, "bin")):
      let dest = joinPath(xdgDataDir(), "bin", lastPathPart(file))

      if fileExists(dest):
        removeFile(dest)
      createSymlink(file, dest)

    # completion
    for j, file in walkDir(joinPath(xdgDataDir(), "dls", project, "completions")):
      let dest = joinPath(xdgDataDir(), "completions", lastPathPart(file))

      if fileExists(dest):
        removeFile(dest)
      createSymlink(file, dest)

    # libexec
    for j, file in walkDir(joinPath(xdgDataDir(), "dls", project, "libexec")):
      let dest = joinPath(xdgDataDir(), "libexec", lastPathPart(file))

      if fileExists(dest):
        removeFile(dest)
      createSymlink(file, dest)

    # man
    for j, file in walkDir(joinPath(xdgDataDir(), "dls", project, "man")):
      let (dir, name, ext) = splitFile(file)

      # continue only if ending is .1, .7, etc.
      try:
        if ext == "": continue

        parseInt(ext[1..^1])
      except ValueError as err:
        continue

      let num = ext[1..^1]
      createDir(joinPath(xdgDataDir(), "man", "man" & num))
      let dest = joinPath(xdgDataDir(), "man", "man" & num, lastPathPart(file))

      if fileExists(dest):
        removeFile(dest)
      createSymlink(file, dest)
