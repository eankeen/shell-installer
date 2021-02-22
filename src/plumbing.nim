import os
import strformat
import strutils
import sequtils
import "./util"

# TODO: loop refactoring
proc plumbingReshim*() =
  let dataDir = xdgDataDir()

  # 'prune' before reshiming
  for i, subfolder in ["bin", "completions", "man"]:
    removeDir(joinPath(dataDir, subfolder))
    # createDir in later loop

  for i, fullProjectDir in walkDir(joinPath(dataDir, "dls")):
    let projectDir = lastPathPart(fullProjectDir)
    let ar = encodeAuthorRepo(lastPathPart(projectDir))

    # projectDir.sh symlink to bin
    let mainFile = joinPath(fullProjectDir,  fmt"{ar[1]}.sh")

    if fileExists(mainFile):
      createDir(joinPath(dataDir, "bin"))
      let dest = joinPath(dataDir, "bin", ar[1])
      if fileExists(dest):
        removeFile(dest)
      createSymlink(mainFile, dest)

    # projectDir symlink to bin (ex. fix nitefood/asm)
    let mainShLessFile = joinPath(fullProjectDir, ar[1])
    if fileExists(mainShLessFile):
       echo mainShLessFile
       createDir(joinPath(dataDir, "bin"))
       let dest = joinPath(dataDir, "bin", ar[1])
       if fileExists(dest):
          removeFile(dest)
       createSymlink(mainShLessFile, dest)

    # generic
    var mans = @["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    mans.apply(proc(i: string): string = joinPath("man, man" & i))
    for i, subfolder in @["bin", "completions"].concat(mans):
      # only create the necessary files based on what's in the current project
      if dirExists(joinPath(fullProjectDir, subfolder)):
        createDir(joinPath(dataDir, subfolder))

      for j, subfolderFile in walkDir(joinPath(fullProjectDir, subfolder)):
        let dest = joinPath(dataDir, subfolder, lastPathPart(subfolderFile))

        # generic case
        if fileExists(dest):
          removeFile(dest)
        elif dirExists(dest):
          removeDir(dest)
        createSymlink(subfolderFile, dest)

    # special case (if man files are in "man" dir (not in any subdir man1, man2, etc.))
    for j, file in walkDir(joinPath(fullProjectDir, "man")):
      let (dir, name, ext) = splitFile(file)

      # continue only if ending is .1, .7, etc.
      try:
        if ext == "": continue

        parseInt(ext[1..^1])
      except ValueError as err:
        continue

      let num = ext[1..^1]
      createDir(joinPath(dataDir, "man", "man" & num))
      let dest = joinPath(dataDir, "man", "man" & num, lastPathPart(file))

      if fileExists(dest):
        removeFile(dest)
      createSymlink(file, dest)

  echo "Reshim Done."
