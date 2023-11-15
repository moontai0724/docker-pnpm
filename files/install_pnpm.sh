#!/bin/sh

TEMP_SCRIPT_CONFIG_PATH="$HOME/.temp-shrc"
TARGET_PATH="/usr/local/bin"

set_pnpm_variable_and_path() {
  CURRENT_PNPM_HOME=$(readlink -f "$TARGET_PATH/pnpm")

  # if $PNPM_HOME is set or $CURRENT_PNPM_HOME does not exists, skip
  if [ -n "$PNPM_HOME" ] || [ ! -f "$CURRENT_PNPM_HOME" ]; then
    return
  fi

  echo "Detected existing pnpm installation: $CURRENT_PNPM_HOME"
  export PNPM_HOME="$CURRENT_PNPM_HOME"

  case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
  esac

  . /dev/null
}

install() {
  echo "Installing pnpm version: $PNPM_VERSION"

  # if PNPM_VERSION = latest, then unset it. the script will install the latest
  # version.
  if [ "$PNPM_VERSION" = "latest" ]; then
    unset PNPM_VERSION
  fi

  rm -f "$TEMP_SCRIPT_CONFIG_PATH" # remove the temp config file if it exists
  wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.temp-shrc" SHELL="$(which sh)" sh -
  unset PNPM_VERSION # delete the version env after it installed

  PNPM_INSTALLED_PATH=$(cat "$TEMP_SCRIPT_CONFIG_PATH" | grep -o 'PNPM_HOME="[^"]*"' | sed 's/PNPM_HOME="//;s/"$//')
  echo "Detected pnpm installation path: $PNPM_INSTALLED_PATH"
  rm "$TEMP_SCRIPT_CONFIG_PATH" # remove the temp config file after we got the installation path

  if [ -z "$PNPM_INSTALLED_PATH" ]; then
    return
  fi

  # if the symlink does not exist, create it
  if [ ! -f "$TARGET_PATH/pnpm" ]; then
    echo "Creating symlink for pnpm: $TARGET_PATH/pnpm -> $PNPM_INSTALLED_PATH/pnpm"
    ln -s $PNPM_INSTALLED_PATH/pnpm $TARGET_PATH/pnpm
  fi

  echo "Installed pnpm version: $(pnpm --version)"
}

# if PNPM_VERSION is set, install it
if [ -n "$PNPM_VERSION" ]; then
  install
else
  echo "PNPM_VERSION is not set, skipping installation"
fi

set_pnpm_variable_and_path

exec "$@"
