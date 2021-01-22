import os
import strformat
import "./util"

proc plumbingReshim*() =
  # 'prune' before reshiming
  removeDir(joinPath(xdgDataDir(), "bin"))
  removeDir(joinPath(xdgDataDir(), "completions"))
  createDir(joinPath(xdgDataDir(), "bin"))
  createDir(joinPath(xdgDataDir(), "completions"))

  for i, fullProject in walkDir(joinPath(xdgDataDir(), "dls")):
    let project = lastPathPart(fullProject)
    let repo = encodeAuthorRepo(lastPathPart(project))[1]

    # symlink main file to bin
    let mainFile = joinPath(xdgDataDir(), "dls", project,  fmt"{repo}.sh")
    if fileExists(mainFile):
      let dest = joinPath(xdgDataDir(), "bin", repo)
      if fileExists(dest):
        removeFile(dest)
      createSymlink(mainFile, dest)

    # symlink any completion files
    for j, file in walkDir(joinPath(xdgDataDir(), "dls", project, "completions")):
      let dest = joinPath(xdgDataDir(), "completions", lastPathPart(file))

      if fileExists(dest):
        removeFile(dest)
      createSymlink(file, dest)
