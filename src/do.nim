import os
import osproc
import strformat
import strutils
import "./plumbing.nim"
import "./util"

# todo: async etc.
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

    # do status
    var status = "status: N/A"
    let repoChanges = execCmdEx(
      command = "git status --short --porcelain",
      workingDir = path
    )
    if repoChanges.output != "":
      status = "status: untracked changes and/or dirty index"
    else:
      discard execCmdEx("git remote update origin")
      let localHead = execCmdEx(
        command = "git rev-parse HEAD",
        workingDir = path
      )
      let remoteHead = execCmdEx(
        command = "git rev-parse origin/HEAD",
        workingDir = path
      )

      if localHead.exitCode != 0 or remoteHead.exitCode != 0:
        status = "status: error during check"
      elif localHead != remoteHead:
        status = "status: NOT UP TO DATE"
      else:
        status = "status: up to date"

    echo &"{ar[0]}/{ar[1]}\n  {version}\n  {path}\n  {status}\n"

proc doAdd*(repo: string) =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  if dirExists(path):
    quit("Error: Project already added. Please remove the project first. Exiting")

  let str = "git clone https://github.com/$#/$# $#"
  discard execCmd str % [ar[0], ar[1], path]

  plumbingReshim()

proc doRemove*(repo: string): void =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  # todo: move to removeDir etc.
  if not dirExists(path):
    quit("Error: Folder not found. Exiting", QuitFailure)

  removeDir(path)

proc doReset*(repo: string): void =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  if not dirExists(path):
    quit("Error: Folder not found. Exiting", QuitFailure)

  let cmd1 = execCmdEx(
    command = "git clean -f",
    options = { poStdErrToStdout },
    workingDir = path
  )
  echo cmd1.output

  let cmd = execCmdEx(
    command = "git reset --hard HEAD",
    options = { poStdErrToStdout },
    workingDir = path
  )
  echo cmd.output

proc doUpdate*(repo: string): void =
  let ar = inputToAuthorRepo(repo)
  let path = joinPath(xdgDataDir(), "dls", decodeAuthorRepo(ar))

  if not dirExists(path):
    quit("Error: Folder not found. Exiting", QuitFailure)

  let output = execCmdEx(
    command = "git pull origin",
    options = { poStdErrToStdout },
    workingDir = path
  )
  echo output.output.strip()

  plumbingReshim()

proc doReshim*(): void =
  plumbingReshim()
