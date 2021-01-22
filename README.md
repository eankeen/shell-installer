# bash-installer

Automatically installs and manages bash programs

## Summary

Installs a Bash Program from GitHub, symlinks the main executable to a single path folder, and symlinks completion files to a separate folder as well

## Usage

```sh
git clone https://github.com/eankeen/bash-installer
cd bash-installer
nimble install

shell_installer add eankeen/bm
```

Setup shell things

```sh
export PATH="$XDG_DATA_HOME/bash-installer/bin:$PATH"
        for file in "$XDG_DATA_HOME"/bash-installer/completions/*.{bash,sh}; do
	if [ -r "$file" ]; then
		source "$file"
	fi
done
```
