## main.sh

##  Globals
## --------------------------------------------------------

ROOT_DIR="$(pwd)"
WARSOW_DIR="${ROOT_DIR}/build/warsow"
WARSOW_HOME_DIR="${ROOT_DIR}/build/warsow-home-data"
MODULE_DIR="${ROOT_DIR}/build"
THREADS="$(nproc)"
export MAKEFLAGS="${MAKEFLAGS} -j ${THREADS}"


##  Tasks
## --------------------------------------------------------

setup-warsow-folder() {
  retrieve-modules warsow-assets
  retrieve-modules warsow-assets-{asprogs,glsl,huds,rocketui}
  ## Create warsow folders
  log-action "Creating warsow folder"
  mkdir -p "${WARSOW_DIR}"/{basewsw,libs}
  mkdir -p "${WARSOW_HOME_DIR}"
  log-action "Copying assets"
  rsync -a "${MODULE_DIR}"/warsow-assets/ "${WARSOW_DIR}"/basewsw
  rsync -a "${MODULE_DIR}"/warsow-assets-asprogs/ "${WARSOW_DIR}"/basewsw/progs
  rsync -a "${MODULE_DIR}"/warsow-assets-glsl/ "${WARSOW_DIR}"/basewsw/glsl
  rsync -a "${MODULE_DIR}"/warsow-assets-huds/ "${WARSOW_DIR}"/basewsw/huds
  rsync -a "${MODULE_DIR}"/warsow-assets-rocketui/ "${WARSOW_DIR}"/basewsw/ui
}

clean-warsow-folder() {
  log-action "Cleaning warsow folder"
  rm -rf "${WARSOW_DIR}"
  log-action "Cleaning qfusion folder"
  enter-dir "${MODULE_DIR}/qfusion"
  git clean -dxf
  leave-dir
}

# copy-warsow-binaries() {
#   retrieve-modules src/warsow-binaries
#   echo "Copying warsow binaries"
#   cd "${ROOT_DIR}"
#   ## TODO: Detect the target OS
#   rsync -a src/warsow-binaries/linux/ "${WARSOW_DIR}"
# }

build-qfusion() {
  retrieve-modules qfusion
  log-action "Building qfusion"
  enter-dir "${MODULE_DIR}/qfusion/source"
  if has-args "--public-build"; then
    cmake . -DQFUSION_GAME=Warsow -DCMAKE_C_FLAGS="-DPUBLIC_BUILD"
  else
    cmake . -DQFUSION_GAME=Warsow
  fi
  make
  leave-dir
  log-action "Copying qfusion binaries"
  rsync -a "${MODULE_DIR}/qfusion/source/build/" "${WARSOW_DIR}"
}

# build-openal-soft() {
#   retrieve-modules src/openal-soft
#   echo "Building openal-soft"
#   cd "${ROOT_DIR}/src/openal-soft"
#   cmake .
#   make
# }

# build-bspc() {
#   retrieve-modules src/bspc
#   echo "Building bspc"
#   cd "${ROOT_DIR}/src/bspc"
#   make
# }

# generate-aas() {
#   echo "Generating AAS files"
#   cd "${ROOT_DIR}"
#   mkdir -p "${WARSOW_DIR}/basewsw/maps"
#   local pak
#   local pak_basename
#   local map_name
#   local -a pid
#   local -i exits=0
#   for pak in $(find "${WARSOW_DIR}/basewsw" -name 'map_*.pk3' | sort); do
#     pak_basename="$(basename "${pak}")"
#     map_name="${pak_basename:4:-4}"
#     if [[ -f "${WARSOW_DIR}/basewsw/maps/${map_name}.aas" ]]; then
#       echo "Skipping '${pak_basename}'"
#       continue;
#     fi
#     echo "Generating AAS for '${pak_basename}'"
#     modules/bspc/bspc -noverbose -threads 2 \
#       -bsp2aas "${pak}/maps/${map_name}.bsp" \
#       -output "${WARSOW_DIR}/basewsw/maps" \
#       -forcesidesvisible & pid+=(${!})
#   done
#   for pid in "${pid[@]}"; do
#     wait "${pid}" || exits+=1
#   done
#   rm -f bspc.log
#   [[ ${exits} -eq 0 ]] && return 0 || exit 1
# }

run-warsow() {
  log-action "Launching warsow"
  cd "${WARSOW_DIR}"
  ## Determine the correct executable
  local arch="$(get-arch)"
  local executable="./warsow.${arch}"
  if [[ ! -e "${executable}" ]]; then
    log-error "Executable '${executable}' not found!"
    exit 1
  fi
  ## Remove temporary modules
  local tempmodule
  for tempmodule in $(find "${WARSOW_HOME_DIR}" -name 'tempmodules_*' -type d); do
    log-info "Deleting $(basename ${tempmodule})"
    rm -r "${tempmodule}"
  done
  ## Run Warsow
  log-info "Executable: ${executable}"
  exec "${executable}" \
    +set fs_basepath "${WARSOW_HOME_DIR}" \
    +set fs_cdpath "${WARSOW_DIR}" \
    +set fs_usehomedir 0 \
    +set sv_cheats 1 \
    "${@}"
}
