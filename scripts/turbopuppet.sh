#!/usr/bin/env bash
# TurboPuppet entrypoint for macOS/Linux (stub until apply flow is ported from TurboPuppet.ps1).

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
TurboPuppet (Unix stub)

Usage: turbopuppet.sh [--branch NAME] [--role ROLES_WHATEVER] [--debug] [--noop]
         [--cached] [--skip-gems] [--skip-modules] [--quick] [--tags TAGS]

Orchestration is not implemented on this platform yet.

  --branch         Puppet environment / git branch ($BRANCH).
  --role           include() target ($ROLE).
  --debug          pass --debug to puppet apply (future).
  --noop           pass --noop to puppet apply (future).
  --cached         skip re-download (future).
  --skip-gems      skip gem install step (future).
  --skip-modules   skip r10k (future).
  --quick          skip gems and modules (future).
  --tags           puppet --tags value (future).
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

main() {
  parse_args "$@"

  local env_dir="${TURBOPUPPET_ENVIRONMENT_DIR:-}"
  if [[ -z "$env_dir" ]]; then
    env_dir="${PUPPET_CODE_DIR}/environments/${BRANCH}"
  fi

  mkdir -p "$LOG_DIR" 2>/dev/null || true
  log "turbopuppet.sh is not implemented on Unix yet."
  log "Collected options: branch=$BRANCH role=$ROLE debug=${DEBUG:-0} noop=${NOOP:-0} cached=${CACHED:-0} skip_gems=${SKIP_GEMS:-0} skip_modules=${SKIP_MODULES:-0} quick=${QUICK:-0} tags=${TAGS:-<none>}"
  log "Paths (reference): ROOT_DIR=$ROOT_DIR PUPPET_BIN_DIR=$PUPPET_BIN_DIR PUPPET_SSL_DIR=$PUPPET_SSL_DIR PUPPET_CODE_DIR=$PUPPET_CODE_DIR ENVIRONMENT_DIR=$env_dir CODE_REPO_URL=$CODE_REPO_URL"
  log "Implement Git archive, puppet config set environment, r10k, and puppet apply similarly to TurboPuppet.ps1 when ready."

  exit 0
}

main "$@"
