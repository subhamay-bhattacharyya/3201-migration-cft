#!/usr/bin/env bash
set -euo pipefail

TOOLS_ARG="${1:-"--tools=all"}"
LOG_FILE="/var/log/devcontainer-tools.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "🔧 Tool installation started: $TOOLS_ARG" | tee -a "$LOG_FILE"

# Extract tool list
TOOLS=$(echo "$TOOLS_ARG" | sed -n 's/--tools=//p')

install_cfn_lint() {
  echo "📦 Installing cfn-lint..." | tee -a "$LOG_FILE"
  pip3 install --no-cache-dir --upgrade cfn-lint==0.85.1 >> "$LOG_FILE" 2>&1
  echo "✅ cfn-lint installed." | tee -a "$LOG_FILE"
}

install_taskcat() {
  echo "📦 Installing taskcat..." | tee -a "$LOG_FILE"
  pip3 install --no-cache-dir --upgrade taskcat==0.9.26 >> "$LOG_FILE" 2>&1
  echo "✅ taskcat installed." | tee -a "$LOG_FILE"
}

install_cfn_guard() {
  echo "📦 Installing cfn-guard..." | tee -a "$LOG_FILE"
  CFN_GUARD_VERSION="3.0.0"
  curl -sSL -o /tmp/cfn-guard.tar.gz "https://github.com/aws-cloudformation/cloudformation-guard/releases/download/v${CFN_GUARD_VERSION}/cfn-guard-linux.tar.gz"
  tar -xzf /tmp/cfn-guard.tar.gz -C /usr/local/bin
  chmod +x /usr/local/bin/cfn-guard*
  rm /tmp/cfn-guard.tar.gz
  echo "✅ cfn-guard installed." | tee -a "$LOG_FILE"
}

install_samcli() {
  echo "📦 Installing AWS SAM CLI..." | tee -a "$LOG_FILE"
  pip3 install --no-cache-dir --upgrade aws-sam-cli==1.116.0 >> "$LOG_FILE" 2>&1
  echo "✅ AWS SAM CLI installed." | tee -a "$LOG_FILE"
}

# Install tools based on user selection
if [[ "$TOOLS" == "all" || "$TOOLS" == *"cfn-lint"* ]]; then install_cfn_lint; fi
if [[ "$TOOLS" == "all" || "$TOOLS" == *"taskcat"* ]]; then install_taskcat; fi
if [[ "$TOOLS" == "all" || "$TOOLS" == *"cfn-guard"* ]]; then install_cfn_guard; fi
if [[ "$TOOLS" == "all" || "$TOOLS" == *"samcli"* || "$TOOLS" == *"aws-sam-cli"* ]]; then install_samcli; fi

echo "🎉 Tool installation complete." | tee -a "$LOG_FILE"
