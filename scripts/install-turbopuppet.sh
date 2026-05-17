#!/usr/bin/env bash
# TurboPuppet first-time bootstrap for macOS (Darwin) and Linux.
# Mirrors scripts/Install-TurboPuppet.ps1 for Unix-like hosts.

set -euo pipefail

ROOT_DIR="/opt/CampFitch"
BIN_DIR="$ROOT_DIR/bin"
ETC_DIR="$ROOT_DIR/etc/TurboPuppet"
LOG_DIR="$ROOT_DIR/logs"
INSTALLER_DIR="$ROOT_DIR/opt/Installers"

PUPPET_AGENT_VERSION="8.10.0"
PUPPET_DMG_ARM64_URL="https://downloads.puppetlabs.com/mac/puppet8/14/arm64/puppet-agent-${PUPPET_AGENT_VERSION}-1.osx14.dmg"

REPO_OWNER="CFCC"
REPO_NAME="TurboPuppet"
BRANCH="production"

usage() {
  cat <<EOF
Usage: sudo $0 [--branch NAME]

Bootstrap directories, PATH, Puppet agent (macOS only for now), and TurboPuppet
shell scripts under $ROOT_DIR.

  --branch   GitHub branch for downloaded scripts (default: production).
EOF
}

log() {
  local level="${1:?}"
  shift
  local message="$*"
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  local line="[$ts] [$level] $message"
  if [[ "$level" == "Error" ]]; then
    echo "$message" >&2
  else
    echo "$message"
  fi
  mkdir -p "$LOG_DIR"
  printf '%s\n' "$line" >>"$LOG_DIR/install-turbopuppet.log"
}

ensure_root() {
  if [[ "${EUID:-}" -ne 0 ]]; then
    log Error "Must run as root (use sudo)."
    exit 1
  fi
}

mkdir_safe() {
  mkdir -p "$1"
}

raw_github_scripts_url() {
  local branch="$1"
  local file="$2"
  echo "https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/refs/heads/${branch}/scripts/${file}"
}

download_to() {
  local url="$1"
  local dest="$2"
  log Info "Downloading $url ..."
  curl -fSL "$url" -o "$dest"
  log Info "Saved $dest"
}

ensure_xcode_clt() {
  if xcode-select -p &>/dev/null; then
    log Info "Xcode Command Line Tools already installed"
    return 0
  fi

  log Info "Installing Xcode Command Line Tools (provides git) ..."
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

  local label
  label="$(softwareupdate --list 2>&1 \
    | grep -o 'Label: Command Line Tools.*' \
    | tail -1 \
    | sed 's/^Label: //')"

  if [[ -z "$label" ]]; then
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    log Error "Could not find Command Line Tools in softwareupdate list"
    exit 1
  fi

  softwareupdate --install "$label" --agree-to-license
  rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  log Info "Xcode Command Line Tools installed"
}

install_path_hook_darwin() {
  local marker="/etc/paths.d/turbopuppet"
  if [[ ! -f "$marker" ]] || [[ "$(cat "$marker" 2>/dev/null)" != "$BIN_DIR" ]]; then
    printf '%s\n' "$BIN_DIR" >"$marker"
    chmod 644 "$marker"
    log Info "Added $BIN_DIR via $marker"
  else
    log Info "$BIN_DIR already listed in $marker"
  fi
}

install_path_hook_linux() {
  local marker="/etc/profile.d/turbopuppet.sh"
  cat >"$marker" <<EOF
# Added by TurboPuppet install-turbopuppet.sh
export PATH="$BIN_DIR:\$PATH"
EOF
  chmod 644 "$marker"
  log Info "Ensured PATH includes $BIN_DIR via $marker"
}

disable_puppet_service_darwin() {
  local plist="/Library/LaunchDaemons/com.puppetlabs.puppet.plist"
  if [[ -f "$plist" ]]; then
    launchctl unload -w "$plist" 2>/dev/null || log Info "launchctl unload returned non-zero (agent may already be unloaded)."
    log Info "Puppet agent launch daemon unloaded"
  else
    log Info "No $plist yet; skipping launchctl unload"
  fi
}

install_puppet_darwin_arm64() {
  local dmg_name="puppet-agent-${PUPPET_AGENT_VERSION}-1.osx14.dmg"
  local dmg_path="$INSTALLER_DIR/$dmg_name"
  mkdir_safe "$INSTALLER_DIR"

  if [[ -x /opt/puppetlabs/bin/puppet ]]; then
    log Info "Puppet agent appears installed at /opt/puppetlabs/bin/puppet; skipping DMG install"
    disable_puppet_service_darwin
    return 0
  fi

  if [[ ! -f "$dmg_path" ]]; then
    download_to "$PUPPET_DMG_ARM64_URL" "$dmg_path"
  else
    log Info "Using cached DMG $dmg_path"
  fi

  local mountpoint=""
  mountpoint="$(mktemp -d /tmp/turbopuppet-puppet-mount.XXXXXX)"

  cleanup_mount() {
    if [[ -n "$mountpoint" ]] && [[ -d "$mountpoint" ]]; then
      hdiutil detach "$mountpoint" -quiet >/dev/null 2>&1 || true
      rmdir "$mountpoint" >/dev/null 2>&1 || true
    fi
  }

  if ! hdiutil attach "$dmg_path" -mountpoint "$mountpoint" -nobrowse -quiet; then
    cleanup_mount
    log Error "Could not attach DMG at $dmg_path"
    exit 1
  fi

  local pkg
  pkg="$(find "$mountpoint" -maxdepth 1 -name '*.pkg' -print -quit)"
  if [[ -z "${pkg:-}" ]]; then
    cleanup_mount
    log Error "No .pkg found inside Puppet DMG at $mountpoint"
    exit 1
  fi

  log Info "Installing $pkg ..."
  if ! installer -pkg "$pkg" -target /; then
    cleanup_mount
    log Error "installer -pkg failed for $pkg"
    exit 1
  fi

  cleanup_mount

  disable_puppet_service_darwin
  log Info "Puppet agent install finished"
}

install_puppet_darwin_intel_skip() {
  log Info "Skipping bundled Puppet DMG install on Intel Mac — only ARM64 macOS 14 DMG URL is scripted. Install puppet-agent separately or extend install-turbopuppet.sh with the amd64 dmg from https://downloads.puppetlabs.com/mac/puppet8/14/"
}

install_git_linux_stub() {
  local id_like=""
  [[ -r /etc/os-release ]] && . /etc/os-release
  id_like="${ID_LIKE:-} ${ID:-}"
  log Info "Linux Puppet agent install not implemented yet."
  echo "TurboPuppet: add distro-specific Puppet agent install (apt/yum) for this host ID=$ID VERSION=$VERSION_ID ID_LIKE='$id_like'"
  echo "Example: Debian/Ubuntu — enable Puppet APT repo then install puppet-agent-${PUPPET_AGENT_VERSION}; RHEL/Fedora — Puppet yum repo + puppet-agent package."
}

install_linux_path_and_stub() {
  install_path_hook_linux
  install_git_linux_stub
}

install_turbopuppet_scripts() {
  local branch="$1"
  mkdir_safe "$BIN_DIR"
  download_to "$(raw_github_scripts_url "$branch" "turbopuppet.sh")" "$BIN_DIR/turbopuppet.sh"
  download_to "$(raw_github_scripts_url "$branch" "install-turbopuppet.sh")" "$BIN_DIR/install-turbopuppet.sh"
  chmod 755 "$BIN_DIR/turbopuppet.sh" "$BIN_DIR/install-turbopuppet.sh"
  log Info "Installed turbopuppet.sh and install-turbopuppet.sh to $BIN_DIR"
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch)
        BRANCH="${2:?}"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        usage
        exit 1
        ;;
    esac
  done

  ensure_root

  mkdir_safe "$ETC_DIR"
  mkdir_safe "$BIN_DIR"
  mkdir_safe "$LOG_DIR"
  mkdir_safe "$INSTALLER_DIR"

  local kern
  kern="$(uname -s)"

  case "$kern" in
    Darwin)
      ensure_xcode_clt
      install_path_hook_darwin
      local arch
      arch="$(uname -m)"
      if [[ "$arch" == "arm64" ]]; then
        install_puppet_darwin_arm64
      else
        install_puppet_darwin_intel_skip
      fi
      ;;
    Linux)
      install_linux_path_and_stub
      ;;
    *)
      log Error "Unsupported OS/kernel: $kern"
      exit 1
      ;;
  esac

  install_turbopuppet_scripts "$BRANCH"
  log Info "Bootstrap complete. Open a new shell or source your profile so PATH picks up $BIN_DIR."
}

main "$@"
