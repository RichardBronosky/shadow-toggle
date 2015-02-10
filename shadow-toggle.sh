#!/usr/bin/env bash

## No bash script should be considered releasable until it has this!
## origin: https://gist.github.com/RichardBronosky/5222338
## usage (vim): :r !curl -sL http://j.mp/safebash
# Exit if any statement returns a non-true return value (non-zero).
set -o errexit
# Exit on use of an uninitialized variable
set -o nounset

{
  type=$(defaults read-type com.apple.screencapture disable-shadow || true)
  value=$(defaults read com.apple.screencapture disable-shadow || true)
} 2>/dev/null

shopt -s nocasematch

disabled=0;
if [[ $type =~ 'bool' ]]; then
  if [[ $value == 1 ]]; then
    disabled=1;
  fi
fi

if [[ $disabled == 1 ]]; then
  read -p "Dropshadow capturing is disabled. Would you like to ENABLE it? [Y/n]"
  if [[ ! $REPLY =~ 'n' ]]; then
    echo "enabling"
    defaults delete com.apple.screencapture disable-shadow
    killall SystemUIServer;
  fi
else
  read -p "Dropshadow capturing is enabled. Would you like to DISABLE it? [Y/n]"
  if [[ ! $REPLY =~ 'n' ]]; then
    echo "disabling"
    defaults write com.apple.screencapture disable-shadow -bool TRUE;
    killall SystemUIServer;
  fi
fi
