discard """
"""

import "../src/util.nim"

assert decodeAuthorRepo("eankeen", "bm") == "eankeen--bm"
assert decodeAuthorRepo("eankeen", "some-thing") == "eankeen--some-thing"
assert decodeAuthorRepo(["eankeen", "bm"]) == "eankeen--bm"

assert encodeAuthorRepo("eankeen--bm") == ["eankeen", "bm"]
try:
  discard encodeAuthorRepo("some-value")
  assert false
except CatchableError:
  assert true
try:
  discard encodeAuthorRepo("some--author--reponame")
  assert false
except CatchableError:
  assert true

echo inputToAuthorRepo("eankeen/bm")
assert inputToAuthorRepo("eankeen/bm") == ["eankeen", "bm"]
# intended
assert inputToAuthorRepo("eankeen/bm/sub") == ["eankeen", "bm"]
