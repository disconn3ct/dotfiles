#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
BACKBLAZE_VER="v4.7.1"
BITWARDEN_VER="2026.6.0"
CILIUM_VER="v0.19.5"
CODER_VER=2.34.5
FLUX_VER=2.9.0
FLUX_ENVSUBST_VER=4.0.32
GO_VER=1.26.4
GOTIFY_VER=v2.3.2
HELM_VER=4.2.2
HCLOUD_VER=v1.66.0
HETZNER_K3S_VER=v2.6.0
KREW_VER=latest
KREW_PLUGINS="cert-manager cnpg ctx fuzzy graph konfig node-resource ns outdated pvu roll stern view-cert view-secret who-can"
KUBECOLOR_VER=0.6.0 # Note: moved to kubecolor/kubecolor, a fork
KUBECTL_VER=stable
KUSTOMIZE_VER=5.8.1
SEALEDSECRETS_VER=0.38.1
STEP_VER="0.24.4"
TALOSCTL_VER="v1.13.5"
TERRAFORM_VER=1.4.6
TERRAGRUNT_VER=latest
VELERO_VER="v1.17.0"
WEAVE_VER=0.38.0
YADM_VER=3.5.0
YQ_VER="v4.53.3"

# Housekeeping:
BINDIR="${HOME}/bin"
COMPLETIONDIR="${HOME}/.config/fish/completions"
LARCH=$(dpkg --print-architecture || echo amd64)
if [ "${LARCH}" == "amd64" ]; then
  ALTARCH="$(uname -m)"
  OPTARCH=""
else
  ALTARCH="${LARCH}"
  OPTARCH="-${LARCH}"
fi

# Helpers

function fetch-url() {
  # fetch-url https://git.io/binary-latest
  printmsg "$1"
  curl -fsSL "${1}"
}

function untar() {
  # untar $HOME/bin ./file-here
  tar xC "${1}" "${2}"
}

function fetch-script() {
  # fetch-script https://raw.bin.io/binary/main/raw/binary-linux $HOME/bin/binary
  fetch-url "${1}" >"${2}"
  chmod +x "${2}"
}

function fetch-ungz() {
  # fetch-ungz https://bin.io/binary-linux.gz > $HOME/bin/binary
  fetch-url "${1}" | gunzip -
}

function fetch-untgz() {
  # fetch-untgz https://git.io/binary.tgz $HOME/bin ./binary
  fetch-ungz "${1}" | untar "${2}" "${3}"
}

function fetch-untar() {
  # fetch-untar https://git.io/binary.tgz $HOME/bin ./binary
  fetch-url "${1}" | untar "${2}" "${3}"
}

function fetch-unzip() {
  # fetch-unzip https://git.me/binary.zip ${BINDIR}/binary
  fetch-url "${1}" | gunzip - >"${2}" && chmod +x "${2}"
}

function printmsg() {
  echo "$*" >/dev/stderr
}

mkdir -p "${BINDIR}" "${COMPLETIONDIR}" || true

if [ ${FORCE:-no} == "yes" ] || [ ! -x "${BINDIR}/yadm" -a -z "$(which yadm)" ]; then
  printmsg "======================="
  printmsg "YADM ${YADM_VER}"
  fetch-script https://github.com/TheLocehiliosan/yadm/raw/${YADM_VER}/yadm "${BINDIR}/yadm"
  #exec yadm bootstrap
fi

if [ ${FORCE:-no} == "yes" ] || [ ! -x "${BINDIR}/b2" -a -z "$(which b2)" ]; then
  printmsg "======================="
  printmsg "BackBlaze ${BACKBLAZE_VER}"
  fetch-script "https://github.com/backblaze/b2_command_line_tool/releases/download/${BACKBLAZE_VER}/b2-linux" "${BINDIR}/b2"
fi
if [ ${FORCE:-no} == "yes" ] || [ ! -x "${BINDIR}/bw" -a -z "$(which bw)" ]; then
  printmsg "======================="
  printmsg "Bitwarden ${BITWARDEN_VER}"
  fetch-unzip "https://github.com/bitwarden/clients/releases/download/cli-v2026.6.0/bw-oss-linux${OPTARCH}-2026.6.0.zip" "${BINDIR}/bw" && chmod +x "${BINDIR}/bw"
fi
if [ ${FORCE:-no} == "yes" ] || [ ! -x "${BINDIR}/cilium" -a -z "$(which cilium)" ]; then
  printmsg "======================="
  printmsg "Cilium ${CILIUM_VER}"
  fetch-untgz "https://github.com/cilium/cilium-cli/releases/download/${CILIUM_VER}/cilium-linux-${LARCH}.tar.gz" "${BINDIR}" "cilium" && chmod +x "${BINDIR}/cilium"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/coder" ]; then
  printmsg "======================="
  printmsg "Coder ${CODER_VER}"
  if [ -x "/tmp/coder.??????/coder" ]; then
    printmsg "Coder detected in /tmp instead."
    cp /tmp/coder.??????/coder "${BINDIR}"
  else
    fetch-untgz "https://github.com/coder/coder/releases/download/v${CODER_VER}/coder_${CODER_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" ./coder
    "${BINDIR}/coder" completion fish >"${COMPLETIONDIR}/coder.fish"
  fi
fi
if [ ${FORCE:-no} == "yes" -o ! -d "${HOME}/go" ]; then
  printmsg "======================="
  printmsg "Go ${GO_VER}"
  rm -rf "${HOME}/go" || true
  fetch-untgz https://go.dev/dl/go${GO_VER}.linux-${LARCH}.tar.gz "${HOME}" "go/"
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/kubectl" ]; then
  printmsg "======================="
  printmsg "Kubectl ${KUBECTL_VER}"
  fetch-script "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/${KUBECTL_VER}.txt)/bin/linux/${LARCH}/kubectl" "${BINDIR}/kubectl"
  "${BINDIR}/kubectl" completion fish >"${COMPLETIONDIR}/kubectl.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/kubecolor" ]; then
  printmsg "======================="
  printmsg "Kubecolor ${KUBECOLOR_VER}"
  fetch-untgz "https://github.com/kubecolor/kubecolor/releases/download/v${KUBECOLOR_VER}/kubecolor_${KUBECOLOR_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" kubecolor
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/flux" ]; then
  printmsg "======================="
  printmsg "Flux v${FLUX_VER}"
  fetch-untgz "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VER}/flux_${FLUX_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" flux
  "${BINDIR}/flux" completion fish >"${COMPLETIONDIR}/flux.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/flux-envsubst" ]; then
  printmsg "======================="
  printmsg "Flux-envsubst v${FLUX_VER}"
  fetch-untgz "https://github.com/jaconi-io/flux-envsubst/releases/download/v${FLUX_ENVSUBST_VER}/flux-envsubst_${FLUX_ENVSUBST_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" flux-envsubst
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/kubeseal" ]; then
    printmsg "======================="
      printmsg "Kubeseal ${SEALEDSECRETS_VER}"
        fetch-untgz "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${SEALEDSECRETS_VER}/kubeseal-${SEALEDSECRETS_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" kubeseal
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/step" ]; then
  printmsg "======================="
  printmsg "Step ${STEP_VER}"
  # NOGIT: fix this mess later
  fetch-untgz "https://dl.smallstep.com/gh-release/cli/gh-release-header/v${STEP_VER}/step_linux_${STEP_VER}_${LARCH}.tar.gz" "${BINDIR}" step_${STEP_VER}/bin/step && \
    mv -f "${BINDIR}/step_${STEP_VER}/bin/step" "${BINDIR}/step" && rmdir "${BINDIR}/step_${STEP_VER}/bin" "${BINDIR}/step_${STEP_VER}"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/kustomize" ]; then
  printmsg "======================="
  printmsg "Kustomize ${KUSTOMIZE_VER}"
  fetch-untgz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" kustomize
  "${BINDIR}/kustomize" completion fish >"${COMPLETIONDIR}/kustomize.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/velero" ]; then
  printmsg "======================="
  printmsg "Velero ${VELERO_VER}"
  fetch-untgz "https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VER}/velero-${VELERO_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" "velero-${VELERO_VER}-linux-amd64/velero" && \
    command mv -f "${BINDIR}/velero-${VELERO_VER}-linux-${LARCH}/velero" "${BINDIR}" && rmdir "${BINDIR}/velero-${VELERO_VER}-linux-${LARCH}"
  "${BINDIR}/velero" completion fish >"${COMPLETIONDIR}/velero.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/gitops" ]; then
  printmsg "======================="
  printmsg "Gitops ${WEAVE_VER}"
  fetch-untgz "https://github.com/weaveworks/weave-gitops/releases/download/v${WEAVE_VER}/gitops-Linux-${ALTARCH}.tar.gz" "${BINDIR}" gitops
  echo "Disabling telemetry."
  "${BINDIR}/gitops" set config analytics false
  "${BINDIR}/gitops" completion fish >"${COMPLETIONDIR}/gitops.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/gotify-cli" ]; then
  printmsg "======================="
  printmsg "Gotify ${GOTIFY_VER}"
  fetch-script "https://github.com/gotify/cli/releases/download/${GOTIFY_VER}/gotify-cli-linux-${LARCH}" "${BINDIR}/gotify-cli"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/talosctl" ]; then
  printmsg "======================="
  printmsg "Talosctl ${TALOSCTL_VER}"
  fetch-script "https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VER}/talosctl-linux-${LARCH}" "${BINDIR}/talosctl"
  "${BINDIR}/talosctl" completion fish >"${COMPLETIONDIR}/talosctl.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/terraform" ]; then
  printmsg "======================="
  printmsg "Terraform ${TERRAFORM_VER}"
  fetch-unzip "https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_${LARCH}.zip" "${BINDIR}/terraform"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/terragrunt" ]; then
  printmsg "======================="
  printmsg "Terragrunt ${TERRAGRUNT_VER}"
  fetch-script "https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${LARCH}" "${BINDIR}/terragrunt"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/helm" ]; then
  printmsg "======================="
  # Helm is kinda special. Files are in a subdir.
  printmsg "Helm ${HELM_VER}"
  fetch-untgz "https://get.helm.sh/helm-v${HELM_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" "linux-${LARCH}/helm" &&
    command mv -f "${BINDIR}/linux-${LARCH}/helm" "${BINDIR}/helm" && rmdir "${BINDIR}/linux-${LARCH}"
  "${BINDIR}/helm" completion fish >"${COMPLETIONDIR}/helm.fish"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/yq" ]; then
  printmsg "======================="
  printmsg "yq ${YQ_VER}"
  fetch-script "https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_${LARCH}" "${BINDIR}/yq"
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/hcloud" ]; then
  printmsg "======================="
  printmsg "Hetzner cloud CLI ${HCLOUD_VER}"
  fetch-untgz "https://github.com/hetznercloud/cli/releases/download/${HCLOUD_VER}/hcloud-linux-${LARCH}.tar.gz" "${BINDIR}" "hcloud"
  "${BINDIR}/hcloud" completion fish >"${COMPLETIONDIR}/hcloud.fish"
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/hetzner-k3s" ]; then
  printmsg "======================="
  printmsg "Hetzner K3s ${HETZNER_K3S_VER}"
  fetch-script "https://github.com/vitobotta/hetzner-k3s/releases/download/${HETZNER_K3S_VER}/hetzner-k3s-linux-amd64" "${BINDIR}/hetzner-k3s"
fi

# If kubectl-$PLUGIN is listed, it counts as installed.
if [ ${FORCE:-no} == "yes" -o $("${BINDIR}/kubectl" plugin list 2>/dev/null | grep 'kubectl-krew$')x == "x" ]; then
  printmsg "======================="
  printmsg "Kubectl Krew: ${KREW_VER}"
  cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/${KREW_VER}/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
fi

for plug in $KREW_PLUGINS; do
  # This could be run as a single install, but where is the fun in that?
  if [ ${FORCE:-no} == "yes" -o $("${BINDIR}/kubectl" plugin list 2>/dev/null | grep kubectl-$(echo "${plug}" | sed -e 's/-/_/g')\$)x == "x" ]; then
    printmsg "======================="
    printmsg "Kubectl Plugin: ${plug}"
    "${BINDIR}/kubectl" krew install "${plug}"
  fi
done

${BINDIR}/kubectl krew upgrade

