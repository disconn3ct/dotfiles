#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

ARGOCD_VER=latest # 2.4.14
ARGOWF_VER=latest # 3.4.1
CODER_VER=2.2.0
FLUX_VER=2.0.0
FLUX_ENVSUBST_VER=2.0.13
GO_VER=1.19.5
GOTIFY_VER=v2.2.3
HELM_VER=3.12.0
ISTIO_VER=1.14.6
KREW_VER=latest
KREW_PLUGINS="cert-manager ctx fuzzy graph konfig ns outdated roll stern view-cert who-can"
KUBECOLOR_VER=0.0.21 # Note: moved to kubecolor/kubecolor, a fork
KUBECTL_VER=stable
KUSTOMIZE_VER=5.0.3
STEP_VER="0.24.4"
TERRAFORM_VER=1.4.6
TERRAGRUNT_VER=latest
WEAVE_VER=latest # 0.9.6
YADM_VER=3.2.2

# Housekeeping:
BINDIR="${HOME}/bin"
COMPLETIONDIR="${HOME}/.config/fish/completions"
LARCH=$(dpkg --print-architecture)
if [ "${LARCH}" == "amd64" ]; then
  ALTARCH="$(uname -m)"
else
  ALTARCH="${LARCH}"
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

if [ ${FORCE:-no} == "yes" -o ! -d "${HOME}/go" ]; then
  printmsg "======================="
  printmsg "Go ${GO_VER}"
  fetch-untgz https://go.dev/dl/go${GO_VER}.linux-${LARCH}.tar.gz "${HOME}" "go/"
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/kubectl" ]; then
  printmsg "======================="
  printmsg "Kubectl ${KUBECTL_VER}"
  fetch-script "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/${KUBECTL_VER}.txt)/bin/linux/${LARCH}/kubectl" "${BINDIR}/kubectl"
  if [ ! -f "${COMPLETIONDIR}/kubectl.fish" ]; then
    "${BINDIR}/kubectl" completion fish >"${COMPLETIONDIR}/kubectl.fish"
  fi
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/kubecolor" ]; then
  printmsg "======================="
  printmsg "Kubecolor ${KUBECOLOR_VER}"
  fetch-untgz "https://github.com/kubecolor/kubecolor/releases/download/v${KUBECOLOR_VER}/kubecolor_${KUBECOLOR_VER}_Linux_${ALTARCH}.tar.gz" "${BINDIR}" kubecolor
fi

if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/argocd" ]; then
  printmsg "======================="
  printmsg "ArgoCD ${ARGOCD_VER}"
  fetch-script "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-${LARCH}" "${BINDIR}/argocd"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/argo" ]; then
  printmsg "Argo Workflows ${ARGOWF_VER}"
  fetch-unzip "https://github.com/argoproj/argo-workflows/releases/latest/download/argo-linux-${LARCH}.gz" "${BINDIR}/argo"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/flux" ]; then
  printmsg "======================="
  printmsg "Flux v${FLUX_VER}"
  fetch-untgz "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VER}/flux_${FLUX_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" flux
  if [ ! -f "${COMPLETIONDIR}/flux" ]; then
    "${BINDIR}/flux" completion fish >"${COMPLETIONDIR}/flux.fish"
  fi
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/flux-envsubst" ]; then
  printmsg "======================="
  printmsg "Flux-envsubst v${FLUX_VER}"
  fetch-untgz "https://github.com/jaconi-io/flux-envsubst/releases/download/v${FLUX_ENVSUBST_VER}/flux-envsubst_${FLUX_ENVSUBST_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" flux-envsubst
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/coder" ]; then
  printmsg "======================="
  printmsg "Coder ${CODER_VER}"
  if [ -x "/tmp/coder.??????/coder" ]; then
    printmsg "Coder detected in /tmp instead."
    cp /tmp/coder.??????/coder "${BINDIR}"
  else
    fetch-untgz "https://github.com/coder/coder/releases/download/v${CODER_VER}/coder_${CODER_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" ./coder
    if [ ! -f "${COMPLETIONDIR}/coder" ]; then
      "${BINDIR}/coder" completion fish >"${COMPLETIONDIR}/coder.fish"
    fi
  fi
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/step" ]; then
  printmsg "======================="
  printmsg "Step ${STEP_VER}"
  # NOGIT: fix this mess later
  fetch-untgz "https://dl.smallstep.com/gh-release/cli/gh-release-header/v${STEP_VER}/step_linux_${STEP_VER}_${LARCH}.tar.gz" "${BINDIR}" step_${STEP_VER}/bin/step && \
    mv -f "${BINDIR}/step_${STEP_VER}/bin/step" "${BINDIR}/step" && rmdir "${BINDIR}/step_${STEP_VER}/bin" "${BINDIR}/step_${STEP_VER}"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/istioctl" ]; then
  printmsg "======================="
  printmsg "Istio ${ISTIO_VER}"
  fetch-untgz "https://github.com/istio/istio/releases/download/${ISTIO_VER}/istioctl-${ISTIO_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" istioctl
  if [ ! -f "${COMPLETIONDIR}/istioctl" ]; then
    "${BINDIR}/istioctl" completion fish >"${COMPLETIONDIR}/istioctl.fish"
  fi
fi
if [ ! -x "${BINDIR}/kustomize" ]; then
  printmsg "======================="
  printmsg "Kustomize ${KUSTOMIZE_VER}"
  fetch-untgz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_${LARCH}.tar.gz" "${BINDIR}" kustomize
  if [ ${FORCE:-no} == "yes" -o ! -f "${COMPLETIONDIR}/kustomize" ]; then
    "${BINDIR}/kustomize" completion fish >"${COMPLETIONDIR}/kustomize.fish"
  fi
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/gitops" ]; then
  printmsg "======================="
  printmsg "Gitops ${WEAVE_VER}"
  fetch-untgz "https://github.com/weaveworks/weave-gitops/releases/latest/download/gitops-linux-${ALTARCH}.tar.gz" "${BINDIR}" gitops
  if [ ${FORCE:-no} == "yes" -o ! -f "${COMPLETIONDIR}/gitops" ]; then
    "${BINDIR}/gitops" set config analytics false
    "${BINDIR}/gitops" completion fish >"${COMPLETIONDIR}/gitops.fish"
  fi
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/gotify-cli" ]; then
  printmsg "======================="
  printmsg "Gotify ${GOTIFY_VER}"
  fetch-url "https://github.com/gotify/cli/releases/download/${GOTIFY_VER}/gotify-cli-linux-${LARCH}" >"${BINDIR}/gotify-cli" && chmod +x "${BINDIR}/gotify-cli"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/terraform" ]; then
  printmsg "======================="
  printmsg "Terraform ${TERRAFORM_VER}"
  fetch-unzip "https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_${LARCH}.zip" "${BINDIR}/terraform"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/terragrunt" ]; then
  printmsg "======================="
  printmsg "Terragrunt ${TERRAGRUNT_VER}"
  fetch-url "https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${LARCH}" >"${BINDIR}/terragrunt" && chmod +x "${BINDIR}/terragrunt"
fi
if [ ${FORCE:-no} == "yes" -o ! -x "${BINDIR}/helm" ]; then
  printmsg "======================="
  # Helm is kinda special. Files are in a subdir.
  printmsg "Helm ${HELM_VER}"
  fetch-untgz "https://get.helm.sh/helm-v${HELM_VER}-linux-${LARCH}.tar.gz" "${BINDIR}" "linux-${LARCH}/helm" &&
    command mv -f "${BINDIR}/linux-${LARCH}/helm" "${BINDIR}/helm" && rmdir "${BINDIR}/linux-${LARCH}"
  if [ ${FORCE:-no} == "yes" -o ! -f "${COMPLETIONDIR}/helm" ]; then
    "${BINDIR}/helm" completion fish >"${COMPLETIONDIR}/helm.fish"
  fi
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
