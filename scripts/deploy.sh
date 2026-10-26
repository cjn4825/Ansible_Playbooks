#!/usr/bin/env bash
set -e

# script for deploying infra with different branches of logic
# this is specifically for day-0 and day-1 bootstrapping
# additional configuration should be done via ansible directly

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

CONF="$REPO_ROOT/ansible/ansible.cfg"
INVENTORY="$REPO_ROOT/ansible/inventory/hosts.ini"
IPA_PLAYBOOK="$REPO_ROOT/ansible/playbooks/ipa_configure.yml"
VAULT_PLAYBOOK="$REPO_ROOT/ansible/playbooks/vault_configure.yml"
TIER_ZERO="$REPO_ROOT/terraform/tier-0-infra"
TIER_ONE="$REPO_ROOT/terraform/tier-1-infra"

print_help() {
    echo "Usage: $0 [--ipa | --vault] [--init | --conf | --destroy]"
    echo ""
    echo "Components:"
    echo "  --ipa       Target Tier 0 (FreeIPA Infrastructure)"
    echo "  --vault     Target Tier 1 (HashiCorp Vault Infrastructure)"
    echo ""
    echo "Actions:"
    echo "  --init      Provision infrastructure via Terraform and wait for SSH daemon"
    echo "  --conf      Configure infrastructure via Ansible playbook"
    echo "  --destroy   Teardown infrastructure via Terraform destroy"
    echo ""
    echo "Examples:"
    echo "  $0 --ipa --init"
    echo "  $0 --vault --conf"
    echo "  $0 --vault --destroy"
    exit 0
}

if [ $# -eq 0 ]; then
    print_help
fi

COMPONENT=""
ACTION=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --ipa) COMPONENT="ipa"; shift ;;
        --vault) COMPONENT="vault"; shift ;;
        --init) ACTION="init"; shift ;;
        --conf) ACTION="conf"; shift ;;
        --destroy) ACTION="destroy"; shift ;;
        --help|-h) print_help ;;
        *) echo "Unknown parameter: $1"; print_help ;;
    esac
done

if [ -z "$COMPONENT" ] || [ -z "$ACTION" ]; then
    echo "Error: You must specify both a component (--ipa or --vault) and an action (--init, --conf, --destroy)."
    echo "Run '$0 --help' for usage details."
    exit 1
fi

if [ "$COMPONENT" == "ipa" ]; then
    TF_DIR="$TIER_ZERO"
    TARGET_IP="10.10.20.5"
    ANSIBLE_PLAYBOOK="$IPA_PLAYBOOK"
    HOST_DESC="IPA host"
elif [ "$COMPONENT" == "vault" ]; then
    TF_DIR="$TIER_ONE"
    TARGET_IP="10.10.20.6"
    ANSIBLE_PLAYBOOK="$VAULT_PLAYBOOK"
    HOST_DESC="Vault host"
fi

case $ACTION in
    init)
        echo "Provisioning $COMPONENT HomeLab Infra..."
        terraform -chdir="$TF_DIR" apply -auto-approve

        echo "Waiting for SSH Daemon on $HOST_DESC ($TARGET_IP)..."
        while ! nc -zv "$TARGET_IP" 22 2>/dev/null; do
            sleep 3
        done
        echo "$HOST_DESC is online and reachable via SSH."
        ;;
    conf)
        echo "Remoting into $HOST_DESC for configuration..."
        ANSIBLE_CONFIG="$CONF" ansible-playbook \
            -i "$INVENTORY" \
            "$ANSIBLE_PLAYBOOK" \
            --ask-vault-pass
        echo "Configuration Complete."
        ;;
    destroy)
        echo "Tearing down $COMPONENT HomeLab Infra..."
        terraform -chdir="$TF_DIR" destroy -auto-approve
        echo "Teardown Complete."
        ;;
esac
