## modules.sh
## Module retrieval functions

retrieve-modules() {
  for module in "${@}"; do
    retrieve-module "${module}"
  done
}

retrieve-module() {
  ## Check if module was already retrieved
  if [[ -d "${ROOT_DIR}/build/${1}" ]]; then
    log-info "Found module '${1}'"
    return 0
  fi
  log-action "Retrieving module '${1}'"
  ## Check if module retrieving function is defined
  if ! is-defined "retrieve-module-${1}"; then
    log-error "Function 'retrieve-module-${1}' is not defined, exiting..."
    exit 1
  fi
  ## Retrieve the module
  mkdir -p "${ROOT_DIR}/build"
  enter-dir "${ROOT_DIR}/build"
  "retrieve-module-${1}"
  leave-dir
}

retrieve-module-qfusion() {
  git clone https://github.com/Warsow/qfusion.git --recursive --jobs 8
}

retrieve-module-bspc() {
  git clone https://github.com/Warsow/bspc.git
}

retrieve-module-warsow-assets() {
  git clone https://github.com/Warsow/warsow-assets.git
}

retrieve-module-warsow-assets-asprogs() {
  git clone https://github.com/Warsow/asprogs.git warsow-assets-asprogs
}

retrieve-module-warsow-assets-glsl() {
  git clone https://github.com/Warsow/glsl.git warsow-assets-glsl
}

retrieve-module-warsow-assets-huds() {
  git clone https://github.com/Warsow/huds.git warsow-assets-huds
}

retrieve-module-warsow-assets-rocketui() {
  git clone https://github.com/Warsow/rocketui.git warsow-assets-rocketui
}
