## argparse.sh
## Argument parsing

## A copy of arguments
declare -a root_args=()

## A map of arguments (key -> value)
declare -A root_args_map=()

## Parse arguments
for arg in "${@}"; do
  ## Long flag
  if [[ ${arg} == --* ]]; then
    root_args+="${arg}"
    root_args_map[${arg}]=1
  ## Short flag
  elif [[ ${arg} == -* ]]; then
    ## Iterate over all short flags
    for (( i = 1; i < ${#arg}; i++ )); do
      root_args+="-${arg:$i:1}"
      root_args_map[-${arg:$i:1}]=1
    done
  ## Rest
  else
    root_args+="${arg}"
    root_args_map[${arg}]=1
  fi
done

## Check if argument was passed to this program
has-args() {
  for arg in "${@}"; do
    [[ ${root_args_map[$arg]} ]] && return 0
  done
  return 1
}
