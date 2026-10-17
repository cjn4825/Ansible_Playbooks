#!/usr/bin/env bash
set -e

CONF="../ansible/ansible.cfg"

echo "Provisioning Tier 0 HomeLab Infra..."
terraform -chdir=../terraform/tier-0-infra \
    apply -auto-approve

while ! nc -zv 10.10.20.5 22 2>/dev/null; do
    echo "Waiting for SSH Daemon on IPA host..."
    sleep 5
done

echo "Remoting into IPA host for configuration..."
echo "Configuring IPA Server..."

ANSIBLE_CONFIG="$CONF" ansible-playbook \
    -i "../ansible/inventory/hosts.ini" \
    "../ansible/playbooks/ipa_configure.yml" \
    --ask-vault-pass

# echo "Provisioning Tier 1 HomeLab Infra..."
# terraform -chdir=../terraform/tier-1-infra apply -auto-approve

# echo "Configuring Vault Server..."
# ANSIBLE_CONFIG="$CONF" ansible-playbook \
#     "../ansible/playbooks/vault_configure.yml" \
    # --ask-vault-pass

# echo "Deployment Complete"
