#!/usr/bin/env bash
# TurboPuppet entrypoint for macOS/Linux.

set -euo pipefail

# Defaults mirror scripts/TurboPuppet.ps1
BRANCH="${TURBOPUPPET_BRANCH:-production}"
ROLE="${TURBOPUPPET_ROLE:-roles::camper::generic}"
DEBUG=""
NOOP=""
CACHED=""
SKIP_GEMS=""
SKIP_MODULES=""
QUICK=""
TAGS=""

ROOT_DIR="${TURBOPUPPET_ROOT:-/opt/CampFitch}"
LOG_DIR="$ROOT_DIR/logs"

# Typical Puppet Agent paths (nix); bin is /opt/puppetlabs/bin on Darwin and Linux agents.
readonly PUPPET_BIN_DIR="${PUPPET_BIN_DIR_OVERRIDE:-/opt/puppetlabs/bin}"
readonly PUPPET_SSL_DIR="${PUPPET_SSL_DIR_OVERRIDE:-/etc/puppetlabs/puppet/ssl}"
readonly PUPPET_CODE_DIR="${PUPPET_CODE_DIR_OVERRIDE:-/etc/puppetlabs/code}"

readonly CODE_REPO_URL="${TURBOPUPPET_REPO_URL:-https://github.com/CFCC/TurboPuppet}"

log() {
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$ts] $*"
}

usage() {
  cat <<EOF
TurboPuppet

Usage: turbopuppet.sh [--branch NAME] [--role ROLE] [--debug] [--noop]
         [--cached] [--skip-gems] [--skip-modules] [--quick] [--tags TAGS]

  --branch         Puppet environment / git branch (default: $BRANCH).
  --role           Puppet include() target (default: $ROLE).
  --debug          Pass --debug to puppet apply.
  --noop           Pass --noop to puppet apply.
  --cached         Skip re-downloading the branch archive.
  --skip-gems      Skip gem install step (r10k).
  --skip-modules   Skip r10k puppetfile install.
  --quick          Skip both gems and modules.
  --tags           Pass --tags value to puppet apply.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch)
        BRANCH="${2:?}"
        shift 2
        ;;
      --role)
        ROLE="${2:?}"
        shift 2
        ;;
      --tags)
        TAGS="${2:?}"
        shift 2
        ;;
      --debug) DEBUG="1"; shift ;;
      --noop) NOOP="1"; shift ;;
      --cached) CACHED="1"; shift ;;
      --skip-gems) SKIP_GEMS="1"; shift ;;
      --skip-modules) SKIP_MODULES="1"; shift ;;
      --quick) QUICK="1"; shift ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage
        exit 1
        ;;
    esac
  done
}

get_git_branch_archive() {
  local env_dir="$1"
  if [[ -n "$CACHED" || -n "$QUICK" ]]; then
    log "Using cached branch $BRANCH"
    return 0
  fi

  local tarball="/tmp/TurboPuppet-${BRANCH}.tar.gz"
  local url="${CODE_REPO_URL}/archive/refs/heads/${BRANCH}.tar.gz"

  rm -rf "$env_dir"
  mkdir -p "$env_dir"

  log "Downloading branch $BRANCH from $url"
  curl -fSL "$url" -o "$tarball"

  log "Extracting archive to $env_dir"
  tar xzf "$tarball" -C "$env_dir" --strip-components=1

  rm -f "$tarball"
  log "Successfully downloaded and extracted branch $BRANCH"
}

set_puppet_environment() {
  local current
  current="$("${PUPPET_BIN_DIR}/puppet" config print environment)"
  if [[ "$current" != "$BRANCH" ]]; then
    log "Changing Puppet environment from $current to $BRANCH"
    "${PUPPET_BIN_DIR}/puppet" config set environment "$BRANCH"
  else
    log "Puppet environment already set to $BRANCH"
  fi
}

install_gems() {
  log "Installing r10k..."
  "${PUPPET_BIN_DIR}/gem" install r10k --version '~> 3.15.4'
  log "Successfully installed all gems"
}

install_puppet_modules() {
  local env_dir="$1"
  local puppetfile="${env_dir}/Puppetfile"
  if [[ ! -f "$puppetfile" ]]; then
    log "ERROR: Puppetfile not found at $puppetfile"
    exit 1
  fi

  log "Installing modules from Puppetfile..."
  "${PUPPET_BIN_DIR}/r10k" puppetfile install \
    --puppetfile "$puppetfile" \
    --moduledir "${env_dir}/modules"
  log "Successfully installed modules from Puppetfile"
}

run_puppet() {
  local -a apply_args=("-e" "include $ROLE")
  [[ -n "$DEBUG" ]] && apply_args+=("--debug")
  [[ -n "$NOOP" ]]  && apply_args+=("--noop")
  if [[ -n "$TAGS" ]]; then
    apply_args+=("--tags" "$TAGS")
  fi

  log "Executing puppet apply with arguments: puppet apply ${apply_args[*]}"
  "${PUPPET_BIN_DIR}/puppet" apply "${apply_args[@]}"
}

main() {
  parse_args "$@"

  local env_dir="${TURBOPUPPET_ENVIRONMENT_DIR:-${PUPPET_CODE_DIR}/environments/${BRANCH}}"
  mkdir -p "$LOG_DIR" 2>/dev/null || true

  get_git_branch_archive "$env_dir"
  set_puppet_environment
  if [[ -z "$SKIP_GEMS" && -z "$QUICK" ]]; then
    install_gems
  fi
  if [[ -z "$SKIP_MODULES" && -z "$QUICK" ]]; then
    install_puppet_modules "$env_dir"
  fi
  run_puppet
}

main "$@"
