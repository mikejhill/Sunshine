#!/bin/sh

PORT=47990
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/sunshine/sunshine.conf"

should_launch_browser() {
  if [ ! -f "$CONFIG_FILE" ]; then
    return 0
  fi

  if grep -Eq '^[[:space:]]*launch_browser_on_startup[[:space:]]*=[[:space:]]*false([[:space:]]*(#.*)?)?$' "$CONFIG_FILE"; then
    return 1
  fi

  return 0
}

if ! curl -k https://localhost:$PORT > /dev/null 2>&1; then
  if should_launch_browser; then
    (sleep 3 && xdg-open https://localhost:$PORT) &
  fi
  exec sunshine "$@"
else
  if should_launch_browser; then
    echo "Sunshine is already running, opening the web interface..."
    xdg-open https://localhost:$PORT
  fi
fi
