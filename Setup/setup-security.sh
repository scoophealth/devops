#!/bin/bash
#
set -e # exit on errors
#
### 1) Don't write command history to disk
# Based on discussion at 
# http://www.cyberciti.biz/faq/clear-the-shell-history-in-ubuntu-linux/
#
# Clear bash shell history
history -c
# Remove history file
rm ~/.bash_history
# Add 'history -c' to end of ~/.bash_logout
touch ~/.bash_logout # create ~/.bash_logout if it doesn't exist
if ! grep --quiet "history -c" ~/.bash_logout; then
  echo 'history -c' >> ~/.bash_logout
fi
# Modify HISTFILE and LESSHISTFILE to prevent history file creation
if ! grep --quiet "unset HISTFILE" ~/.bashrc; then
  echo 'unset HISTFILE' >> ~/.bashrc
fi
if ! grep --quiet "export LESSHISTFILE" ~/.bashrc; then
  echo 'export LESSHISTFILE="-"' >> ~/.bashrc
fi
