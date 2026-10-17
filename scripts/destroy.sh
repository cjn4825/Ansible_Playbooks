#!/usr/bin/env bash
set -e

echo "Destroying Tier 0 HomeLab Infra..."
terraform -chdir=../terraform/tier-0-infra \
    apply -destroy -auto-approve

# echo "Destroying Tier 1 HomeLab Infra..."
# terraform -chdir=../terraform/tier-1-infra \
#   apply -destroy -auto-approve

# echo "Infra Destroyed"
