#!/bin/bash
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
tor_status=$(brew services list | grep -w "tor.*stopped")

if [ -n "$tor_status" ]; then
  echo ""
  echo "Starting tor services..."
  brew services start tor
fi

tor_status=$(brew services list | grep -w "tor.*started")
net_status=$(networksetup -getsocksfirewallproxy wi-fi | grep "No")

if [[ -n "$net_status" && -n "$tor_status" ]]; then
  echo ""
  echo "Setting up SOCKS proxy tunnel..."
  # workflow requiring privileges
  # https://www.alfredforum.com/topic/686-workflows-requiring-privileges/?tab=comments#comment-3360
  osascript -e  "do shell script \"sudo networksetup -setsocksfirewallproxy wi-fi 127.0.0.1 9050 >/dev/null;\" with administrator privileges"
  echo "Starting proxy tunnel..."
  networksetup -setsocksfirewallproxystate wi-fi on
else
  echo ""
  echo "Stopping proxy tunnel..."
  networksetup -setsocksfirewallproxystate wi-fi off
fi
