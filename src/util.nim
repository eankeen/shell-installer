import os
import strutils

# [eankeen, bm] --> eankeen--bm
proc decodeAuthorRepo*(author: string, repo: string): string =
  return author & "--" & repo

proc decodeAuthorRepo*(arr: array[2, string]): string =
  return decodeAuthorRepo(arr[0], arr[1])

# "eankeen--bm" --> [eankeen, bm]
proc encodeAuthorRepo*(authorRepo: string): array[2, string] =
  if authorRepo.count("--") != 1:
    raise newException(CatchableError, "Could not deconstruct folder to an author or repo. Does not have a double hyphen or has more than one")

  let author = authorRepo.split("--")[0]
  let repo = authorRepo.split("--")[1]
  return [author, repo]

# "eankeen/bm" --> [eankeen, bm]
proc inputToAuthorRepo*(input: string): array[2, string] =
  if input.count('/') == 0:
    echo "Error: does not look like a valid repository name. Exiting"
    quit 1

  if input.startsWith("https://") or input.startsWith("git@"):
    echo "Error: Please remove the protocol and website name. Exiting"
    quit 1

  let author = input.split('/')[0]
  let repo = input.split('/')[1]

  return [author, repo]

proc getDirNum(dir: string): int =
  var i = 0
  for _ in walkDir(dir):
    i = i + 1
  return i

proc xdgDataDir*(): string =
  if getEnv("SHELL_INSTALLER_HOME") != "":
    return getEnv("SHELL_INSTALLER_HOME")

  var dir = joinPath(getHomeDir(), ".local", "share")
  if getEnv("XDG_DATA_HOME") != "":
    dir = getEnv("XDG_DATA_HOME")

  return joinPath(dir, "shell-installer")
