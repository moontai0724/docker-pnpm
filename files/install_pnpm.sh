#!/bin/sh

install() {
  TEMP_SCRIPT_CONFIG_PATH="$HOME/.temp-shrc"
  TARGET_PATH="/usr/local/bin"

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

  export PNPM_HOME="$PNPM_INSTALLED_PATH"
  case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
  esac

  echo "Installed pnpm version: $(pnpm --version)"
}

# If SKIP_PRE_INSTALL is set, skip pre-installation
if [ -z "$SKIP_PRE_INSTALL" ]; then
  install
fi

exec "$@"
