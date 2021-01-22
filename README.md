# shell-installer

Installs shell scripts, symlinking their primary executables to the PATH and completion scripts to a common folder

## Usage

```sh
git clone https://github.com/eankeen/shell-installer
cd shell-installer
nimble install

shell_installer --help

# clones https://github.com/eankeen/bm to ${XDG_DATA_HOME:-$HOME/.local/share}/shell-installer/dls/eankeen--bm
shell_installer add eankeen/bm
```

Setup shell things

```bash
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/shell-installer/bin:$PATH"
for file in "${XDG_DATA_HOME:-$HOME/.local/share}"/shell-installer/completions/*.{bash,sh}; do
	if [ -r "$file" ]; then
		source "$file"
	fi
done
```
