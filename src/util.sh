## util.sh
## Utility functions

get-arch() {
  uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc/ -e s/sparc64/sparc/ -e s/arm.*/arm/ -e s/sa110/arm/ -e s/alpha/axp/
}

is-defined() {
  hash "${@}" 2>/dev/null
}

enter-dir() {
  pushd "${1}" >/dev/null
}

leave-dir() {
  popd >/dev/null
}

log-action() {
  echo "$(colorize-bold light-green "=>") $(colorize-bold white "${@}")"
}

log-error() {
  echo "$(colorize-bold light-red "!!") $(colorize-bold white "${@}")"
}

log-info() {
  echo "$(colorize-bold light-blue "::") $(colorize-bold white "${@}")"
}

## Color definitions and colorize function
## NOTE: Associative arrays only work on Bash 4
if ((BASH_VERSINFO[0] >= 4)); then
  declare -A colors=(
    [black]="$(echo -e '\e[30m')"
    [red]="$(echo -e '\e[31m')"
    [green]="$(echo -e '\e[32m')"
    [yellow]="$(echo -e '\e[33m')"
    [blue]="$(echo -e '\e[34m')"
    [purple]="$(echo -e '\e[35m')"
    [cyan]="$(echo -e '\e[36m')"
    [light-grey]="$(echo -e '\e[37m')"
    [grey]="$(echo -e '\e[90m')"
    [light-red]="$(echo -e '\e[91m')"
    [light-green]="$(echo -e '\e[92m')"
    [light-yellow]="$(echo -e '\e[93m')"
    [light-blue]="$(echo -e '\e[94m')"
    [light-purple]="$(echo -e '\e[95m')"
    [light-cyan]="$(echo -e '\e[96m')"
    [white]="$(echo -e '\e[97m')"
    [bold]="$(echo -e '\e[1m')"
    [reset]="$(echo -e '\e[0m')"
  )

  colorize() {
    echo "${colors[$1]}${*:2}${colors[reset]}"
  }

  colorize-bold() {
    echo "${colors[bold]}${colors[$1]}${*:2}${colors[reset]}"
  }
else
  colorize() {
    echo "${*:2}"
  }

  colorize-bold() {
    echo "${*:2}"
  }
fi
