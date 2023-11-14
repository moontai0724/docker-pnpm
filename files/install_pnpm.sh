#!/bin/sh

install() {
  TEMP_SCRIPT_CONFIG_PATH="$HOME/.temp-shrc"
  TARGET_PATH="/usr/local/bin"

  wget -qO- https://get.pnpm.io/install.sh | ENV="$TEMP_SCRIPT_CONFIG_PATH" SHELL="$(which sh)" sh -

  PNPM_INSTALLED_PATH=$(cat "$TEMP_SCRIPT_CONFIG_PATH" | grep -o 'PNPM_HOME="[^"]*"' | sed 's/PNPM_HOME="//;s/"$//')

  echo "Detected pnpm installation path: $PNPM_INSTALLED_PATH, moving to $TARGET_PATH..."
  rm "$TEMP_SCRIPT_CONFIG_PATH"

  if [ -z "$PNPM_INSTALLED_PATH" ]; then
    return
  fi

  # Move pnpm executable to $TARGET_PATH
  mv $PNPM_INSTALLED_PATH/pnpm $TARGET_PATH

  echo "$(ls -la $TARGET_PATH | grep pnpm)"
  echo "Installed pnpm version: $(pnpm --version)"
}

# If SKIP_PRE_INSTALL is set, skip pre-installation
if [ -z "$SKIP_PRE_INSTALL" ]; then
  install
fi

exec "$@"
