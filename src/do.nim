import os
import osproc
import strformat
import strutils
import "./plumbing.nim"
import "./util"

proc doList*() =
  for i, file in walkDir(joinPath(xdgDataDir(), "dls")):
    let ar = encodeAuthorRepo(lastPathPart(file))
    let path = joinPath(xdgDataDir(), "dls", lastPathPart(file))

    var version = ""
    let result = execCmdEx(
      command = "git tag --points-at HEAD",
      options = { poStdErrToStdOut },
      workingDir = path
    )
    version = result.output.strip()

    # if no git tag, output hash
    if result.output == "":
      let result2 = execCmdEx(
        command = "git rev-parse HEAD",
        options = { poStdErrToStdOut },
        workingDir = path
      )
      version = result2.output.strip()


    echo &"{ar[0]}/{ar[1]}\n  {version}\n  {path}"

proc doAdd*(repo: string) =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  if dirExists(path):
    quit("Error: Project already added. Please remove the project first. Exiting")

  let str = "git clone https://github.com/$#/$# $#"
  discard execCmd str % [ar[0], ar[1], path]

  plumbingReshim()

proc doRemove*(repo: string) =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  removeDir(path)

proc doUpdate*(repo: string) =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  if not dirExists(path):
    quit("Error: Folder not found. Exiting", QuitFailure)

  discard execCmdEx(
    command = "git pull origin main",
    options = { poStdErrToStdout },
    workingDir = path
  )

  plumbingReshim()

proc doReshim*() =
  plumbingReshim()
