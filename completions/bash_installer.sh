# shellcheck shell=bash

# based on https://tylerthrailkill.com/2019-01-19/writing-bash-completion-script-with-subcommands/

_log() {
	local -r file=".salamis-debug"
	[[ -v DEBUG ]] && {
		"$@" >> "$file"
	} 1>&2 2>/dev/null
}

_bash_installer_remove() {
	local cur="${COMP_WORDS[COMP_CWORD]}"

	local -a dirs
	for dir in "${XDG_DATA_HOME:-$HOME/.local/share}/bash-installer/dls"/*; do
		dir="$(basename "$dir")"
		dirs+=${dir/--//}
	done

	# shellcheck disable=SC2207
	COMPREPLY=($(compgen -W "${dirs[*]}" -- "$cur"))
}

_bash_installer_update() {
	_bash_installer_remove
}

_salamis_launch() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local dirs

	# TODO
	dirs="$(\ls --color=never -c1 ~/.cache/salamis/workspaces)"
	# shellcheck disable=SC2207
	COMPREPLY=($(compgen -W "one two three" -- "$cur"))
}

_bash_installer() {
	local i=1 cmd

	# iterate over COMP_WORDS (ending at currently completed word)
	# this ensures we get command completion even after passing flags
	while [[ "$i" -lt "$COMP_CWORD" ]]; do
		local s="${COMP_WORDS[i]}"
		case "$s" in
		# if our current word starts with a '-', it is not a subcommand
		-*) ;;
		# we are completing a subcommand, set cmd
		*)
			cmd="$s"
			break
			;;
		esac
		(( i++ ))
	done

	# check if we're completing 'salamis'
	if [[ "$i" -eq "$COMP_CWORD" ]]; then
		local cur="${COMP_WORDS[COMP_CWORD]}"
		# shellcheck disable=SC2207
		COMPREPLY=($(compgen -W "list add remove update reshim --help --version" -- "$cur"))
		return
	fi

	# if we're not completing 'salamis', then we're completing a subcommand
	case "$cmd" in
		list)
			COMPREPLY=() ;;
		add)
			COMPREPLY=() ;;
		remove)
			_bash_installer_remove ;;
		update)
			_bash_installer_update ;;
		reshim)
			COMPREPLY=() ;;
		*)
			;;
	esac

} && complete -F _bash_installer bash_installer